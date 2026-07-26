import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/disease_result.dart';
import '../services/tts_service.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import 'scanner_screen.dart';

class AnalysisResultScreen extends StatefulWidget {
  final DiseaseResult result;
  final File? imageFile;
  final bool fromHistory;

  const AnalysisResultScreen({
    super.key,
    required this.result,
    this.imageFile,
    this.fromHistory = false,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  @override
  void dispose() {
    TtsService.stop();
    super.dispose();
  }

  Color _getStatusColor() {
    final status = widget.result.status.toLowerCase();
    if (status == 'status_healthy') return Colors.green;
    if (status == 'status_diseased') return Colors.red;
    return Colors.yellow;
  }

  IconData _getStatusIcon() {
    final status = widget.result.status.toLowerCase();
    if (status == 'status_healthy') return Icons.check_circle;
    if (status == 'status_diseased') return Icons.warning_amber_rounded;
    return Icons.help;
  }

  String _buildSpeakText() {
    final buffer = StringBuffer();
    buffer.write('${'crop_type'.tr}: ${widget.result.crop.tr}. ');
    buffer.write('${'diagnosis'.tr}: ${widget.result.label.tr}. ');
    buffer.write(
      '${'confidence'.tr}: ${(widget.result.confidence * 100).toStringAsFixed(0)} percent. ',
    );
    if (widget.result.message.isNotEmpty && widget.result.message != 'none') {
      buffer.write(widget.result.message.tr);
    }
    return buffer.toString();
  }

  void _handleBackNavigation() {
    TtsService.stop();
    if (widget.fromHistory) {
      // Pop back to the existing HistoryScreen without pushing a new one
      Get.back();
    } else {
      // Replace with ScannerScreen when coming from scan flow
      Get.off(() => const ScannerScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();

    return WillPopScope(
      onWillPop: () async {
        _handleBackNavigation();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('analysis_result'.tr),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _handleBackNavigation,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                final historyItem = {
                  "crop": widget.result.crop,
                  "label": widget.result.label,
                  "confidence": widget.result.confidence,
                  "image_path": widget.imageFile?.path,
                  "timestamp": DateTime.now().toString(),
                };
                await PdfService.createAndSharePdf([historyItem]);
              },
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                StorageService.saveResult({
                  "crop": widget.result.crop,
                  "label": widget.result.label,
                  "rawLabel": widget.result.rawLabel,
                  "confidence": widget.result.confidence,
                  "image_path": widget.imageFile?.path,
                  "timestamp": DateTime.now().toString(),
                  "status": widget.result.status,
                  "symptoms": widget.result.symptoms,
                  "treatment": widget.result.treatment,
                  "message": widget.result.message,
                });
                Get.snackbar('Saved'.tr, 'Scan result saved'.tr);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 2),
                ),
                child: Column(
                  children: [
                    Icon(statusIcon, size: 48, color: statusColor),
                    const SizedBox(height: 8),
                    Text(
                      widget.result.status.tr.capitalizeFirst!,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${'confidence'.tr}: ${(widget.result.confidence * 100).toStringAsFixed(2)}%",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (widget.imageFile != null)
                Card(child: Image.file(widget.imageFile!, fit: BoxFit.cover)),

              const SizedBox(height: 12),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_florist, color: Colors.green),
                  title: Text('crop_type'.tr),
                  subtitle: Text(widget.result.crop.tr),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.coronavirus, color: Colors.red),
                  title: Text('diagnosis'.tr),
                  subtitle: Text(widget.result.label.tr),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.biotech, color: Colors.orange),
                  title: Text('symptoms'.tr),
                  subtitle: Text(
                    widget.result.symptoms.tr == 'none'
                        ? 'none'.tr
                        : widget.result.symptoms.tr,
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.medical_information,
                    color: Colors.blue,
                  ),
                  title: Text('treatment'.tr),
                  subtitle: Text(
                    widget.result.treatment.tr == 'none'
                        ? 'none'.tr
                        : widget.result.treatment.tr,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.volume_up),
                      label: Text('Speak'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: () {
                        final text = _buildSpeakText();
                        TtsService.speak(text);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.lightbulb),
                      label: Text('recommendation'.tr),
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'recommendation'.tr,
                          content: Text(widget.result.message.tr),
                          textConfirm: 'ok'.tr,
                          onConfirm: () => Get.back(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Show retake only when coming from scanner flow
              if (!widget.fromHistory)
                OutlinedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: Text('retake_photo'.tr),
                  onPressed: () {
                    TtsService.stop();
                    Get.off(() => const ScannerScreen());
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}