import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class CropClassifier {
  final Interpreter interpreter;
  final List<String> labels;
  final int inputSize;
  final double threshold;

  CropClassifier({
    required this.interpreter,
    required this.labels,
    this.inputSize = 224,
    this.threshold = 0.5,
  });

  static Future<CropClassifier> loadModel({
    required String modelPath,
    required String labelPath,
    double threshold = 0.5,
  }) async {
    final interpreter = await Interpreter.fromAsset(modelPath);
    final labelData = await rootBundle.loadString(labelPath);
    final labels = labelData
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return CropClassifier(
      interpreter: interpreter,
      labels: labels,
      threshold: threshold,
    );
  }

  Future<Map<String, dynamic>> classify(List<List<List<double>>> imageData) async {
    final output = List.filled(labels.length, 0.0).reshape([1, labels.length]);

    interpreter.run(imageData, output);

    final rawOutput = output[0];
    print('🔍 Raw model output: $rawOutput');

    final maxConfidence = rawOutput.reduce(max);
    final predictedIndex = rawOutput.indexOf(maxConfidence);

    print('🧠 Predicted index: $predictedIndex');
    print('📊 Max confidence: $maxConfidence');

    String crop = 'Unknown';
    String diagnosis = 'Unknown';
    String symptoms = 'None';
    String treatment = 'None';

    if (maxConfidence >= threshold && predictedIndex < labels.length) {
      final label = labels[predictedIndex];
      print('✅ Predicted label: $label');

      // Split label if format is "Cassava - Mosaic Disease"
      final parts = label.split(' - ');
      if (parts.length == 2) {
        crop = parts[0];
        diagnosis = parts[1];
      } else {
        diagnosis = label;
      }

      // Optional: Add symptom/treatment mapping here
    } else {
      print('⚠️ Fallback to Unknown');
    }

    return {
      'crop': crop,
      'diagnosis': diagnosis,
      'confidence': (maxConfidence * 100).toStringAsFixed(2),
      'symptoms': symptoms,
      'treatment': treatment,
    };
  }
}