import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import '../models/disease_result.dart';
import '../utils/label_helper.dart';
import 'image_preprocessor.dart';

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  Interpreter? _combinedInterpreter;
  List<String>? _combinedLabels;

  bool get _modelsLoaded =>
      _combinedInterpreter != null && _combinedLabels != null;

  Future<void> _ensureModelsLoaded() async {
    if (_modelsLoaded) return;
    try {
      _combinedInterpreter ??= await _loadModel(
        'assets/model/best_float32.tflite',
      );
      _combinedLabels ??= await _loadLabels('assets/model/labels.txt');
    } catch (e, st) {
      print('❗ Error loading models: $e\n$st');
      rethrow;
    }
  }

  Future<void> preloadModels() async {
    await _ensureModelsLoaded();
  }

  Future<Interpreter> _loadModel(String assetPath) async {
    final modelBytes = (await rootBundle.load(assetPath)).buffer.asUint8List();
    return Interpreter.fromBuffer(modelBytes);
  }

  Future<List<String>> _loadLabels(String labelPath) async {
    final labelsData = await rootBundle.loadString(labelPath);
    final labels = labelsData
        .trim()
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    print('📁 Loaded ${labels.length} labels: $labels');
    return labels;
  }

  Future<List<double>> _runClassification(
      Interpreter interpreter,
      Uint8List inputImage,
      ) async {
    final inputTensor = interpreter.getInputTensor(0);
    final inputShape = inputTensor.shape;
    final inputType = inputTensor.type;
    final outputTensor = interpreter.getOutputTensor(0);
    final outputShape = outputTensor.shape;

    final image = img.decodeImage(inputImage);
    if (image == null) throw Exception('Could not decode image bytes');

    final height = inputShape.length > 2 ? inputShape[1] : 224;
    final width = inputShape.length > 2 ? inputShape[2] : 224;
    final resized = img.copyResize(image, width: width, height: height);

    if (inputType != TensorType.float32) {
      throw Exception(
        'Only float32 input type supported by this helper. Found: $inputType',
      );
    }

    final input = List.generate(
      1,
          (_) => List.generate(height, (y) {
        return List.generate(width, (x) {
          final pixel = resized.getPixel(x, y);
          final r = pixel.r / 255.0;
          final g = pixel.g / 255.0;
          final b = pixel.b / 255.0;
          return [r, g, b];
        });
      }),
    );

    final numClasses = outputShape[1];
    final output = List.filled(numClasses, 0.0).reshape([1, numClasses]);
    interpreter.run(input, output);

    final List<dynamic> raw = output[0];
    return raw.map((e) => (e as num).toDouble()).toList();
  }

  Map<String, dynamic> _argMax(List<double> scores) {
    double maxVal = -1.0;
    int idx = 0;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxVal) {
        maxVal = scores[i];
        idx = i;
      }
    }
    return {'index': idx, 'confidence': maxVal};
  }

  Future<DiseaseResult> runInference(File imageFile) async {
    final processedFile = await ImagePreprocessor.preprocessImage(imageFile);
    final imageBytes = await processedFile.readAsBytes();

    await _ensureModelsLoaded();

    final interpreter = _combinedInterpreter!;
    final labels = _combinedLabels!;

    final output = await _runClassification(interpreter, imageBytes);
    print('🌿 Combined raw output: $output');

    final arg = _argMax(output);
    final int index = arg['index'];
    final double confidence = arg['confidence'];

    if (index < 0 || index >= labels.length) {
      return DiseaseResult(
        crop: 'crop_unknown',
        label: 'diagnosis_unknown',
        rawLabel: 'Unknown',
        confidence: confidence,
        symptoms: 'none',
        treatment: 'none',
        message: 'unknown_crop_msg',
        status: 'status_unknown',
      );
    }

    final String clsName = labels[index].trim();
    print('🧠 Predicted: $clsName (conf=${confidence.toStringAsFixed(3)})');

    // Parse class name
    // Example label formats: "Cassava_Healthy", "Cassava_Mosaic_Disease", "Maize_Leaf_Blight"
    final parts = clsName.split(RegExp(r'[_\s]')); // split on underscore or space
    final cropType = parts.isNotEmpty ? parts[0].capitalizeFirst! : 'Unknown';
    String status;
    String diagnosis;

    final lowerCls = clsName.toLowerCase();
    if (lowerCls.contains('healthy')) {
      status = 'healthy';
      diagnosis = 'healthy';
    } else {
      status = 'diseased';
      diagnosis = parts.length > 1 ? parts.sublist(1).join(' ') : 'Unknown';
    }

    // If crop is not cassava or maize → Unknown
    if (!(cropType.toLowerCase().contains('cassava') ||
        cropType.toLowerCase().contains('maize'))) {
      status = 'unknown';
      diagnosis = 'Unknown';
    }

    // Translate keys for localization (we store keys, not final translated strings)
    String translatedStatusKey = {
      'healthy': 'status_healthy',
      'diseased': 'status_diseased',
      'unknown': 'status_unknown',
    }[status.toLowerCase()] ?? 'status_unknown';

    // Ensure crop is stored as a translation key (crop_cassava / crop_maize / crop_unknown)
    String translatedCropKey = {
      'cassava': 'crop_cassava',
      'maize': 'crop_maize',
    }[cropType.toLowerCase()] ??
        'crop_unknown';

    final normalizedDiagnosis = diagnosis.toLowerCase().trim();
    String translatedDiagnosisKey = {
      'mosaic disease': 'diagnosis_mosaic',
      'leaf blight': 'diagnosis_leaf_blight',
      'gray leaf spot': 'diagnosis_gray_leaf_spot',
      'brown streak disease': 'diagnosis_brown_streak',
      'healthy': 'diagnosis_healthy',
      'unknown': 'diagnosis_unknown',
    }[normalizedDiagnosis] ?? 'diagnosis_unknown';

    // Map for symptoms/treatment/message — keep the canonical raw model key as map index (clsName)
    final Map<String, Map<String, String>> infoMap = {
      'Cassava_Healthy': {
        'symptoms': 'cassava_healthy_symptoms',
        'treatment': 'cassava_healthy_treatment',
        'message': 'cassava_healthy_msg',
      },
      'Cassava_Mosaic_Disease': {
        'symptoms': 'cmd_symptoms',
        'treatment': 'cmd_treatment',
        'message': 'cassava_mosaic',
      },
      'Cassava_Brown_Streak_Disease': {
        'symptoms': 'cbsd_symptoms',
        'treatment': 'cbsd_treatment',
        'message': 'cassava_brown_streak_msg',
      },
      'Maize_Healthy': {
        'symptoms': 'maize_healthy_symptoms',
        'treatment': 'maize_healthy_treatment',
        'message': 'maize_healthy_msg',
      },
      'Maize_Leaf_Blight': {
        'symptoms': 'mlb_symptoms',
        'treatment': 'mlb_treatment',
        'message': 'maize_blight_msg',
      },
      'Maize_Gray_Leaf_Spot': {
        'symptoms': 'mgls_symptoms',
        'treatment': 'mgls_treatment',
        'message': 'maize_gray_leaf_spot_msg',
      },
    };

    final info = infoMap[clsName] ?? {
      'symptoms': 'none',
      'treatment': 'none',
      'message': 'unknown_crop_msg',
    };

    return DiseaseResult(
      crop: translatedCropKey,
      label: translatedDiagnosisKey,
      rawLabel: clsName,
      confidence: confidence,
      symptoms: info['symptoms']!,
      treatment: info['treatment']!,
      message: info['message']!,
      status: translatedStatusKey,
    );
  }
}
