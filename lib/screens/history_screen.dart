import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import '../utils/label_helper.dart';
import '../models/disease_result.dart';
import 'analysis_result.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<Map<String, dynamic>> history;
  List<Map<String, dynamic>> filteredHistory = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    history = List<Map<String, dynamic>>.from(StorageService.getHistory());
    filteredHistory = List<Map<String, dynamic>>.from(history);
  }

  void _deleteItem(int index) {
    final item = filteredHistory[index];
    setState(() {
      history.remove(item);
      filteredHistory.removeAt(index);
    });
    StorageService.deleteResult(item);
    Get.snackbar('Deleted'.tr, 'History item deleted'.tr);
  }

  void _showSearchDialog() {
    TextEditingController controller = TextEditingController();
    Get.defaultDialog(
      title: 'Search'.tr,
      content: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter date or diagnosis'.tr,
            ),
          ),
        ],
      ),
      textConfirm: 'Search'.tr,
      textCancel: 'Cancel'.tr,
      onConfirm: () {
        final query = controller.text.trim().toLowerCase();
        setState(() {
          searchQuery = query;
          filteredHistory = history.where((item) {
            final diagnosis = item['label']?.toString().toLowerCase() ?? '';
            final timestamp = item['timestamp']?.toString().toLowerCase() ?? '';
            return diagnosis.contains(query) || timestamp.contains(query);
          }).toList();
        });
        Get.back(); // closes only the dialog
      },
    );
  }

  void _clearSearch() {
    setState(() {
      searchQuery = '';
      filteredHistory = List<Map<String, dynamic>>.from(history);
    });
  }

  /// Show export dialog for CSV/JSON
  void _showExportDialog() {
    if (filteredHistory.isEmpty) {
      Get.snackbar('Error'.tr, 'No history to export'.tr);
      return;
    }
    Get.defaultDialog(
      title: 'Export Data'.tr,
      content: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.table_chart, color: Colors.white),
              label: Text(
                'Export as CSV'.tr,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                final csv = StorageService.exportToCsv(filteredHistory);
                await Share.share(csv, subject: 'Smart Leaf Doctor CSV Export');
                Get.back();
              },
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.code, color: Colors.white),
              label: Text(
                'Export as JSON'.tr,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blueGrey,
              ),
              onPressed: () async {
                final json = StorageService.exportToJson(filteredHistory);
                await Share.share(json, subject: 'Smart Leaf Doctor JSON Export');
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (searchQuery.isNotEmpty) {
          _clearSearch();
          return false; // prevent leaving screen
        }
        return true; // allow normal back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('history'.tr),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (searchQuery.isNotEmpty) {
                _clearSearch();
              } else {
                Get.back();
              }
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: _showSearchDialog,
            ),
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: 'Export PDF',
              onPressed: filteredHistory.isEmpty
                  ? null
                  : () async {
                await PdfService.createAndSharePdf(filteredHistory);
              },
            ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              tooltip: 'Export Data'.tr,
              onPressed: _showExportDialog,
            ),
          ],
        ),
        body: filteredHistory.isEmpty
            ? Center(child: Text('no_history'.tr))
            : ListView.builder(
          itemCount: filteredHistory.length,
          itemBuilder: (_, i) {
            final item = filteredHistory[i];
            final hasImage = item["image_path"] != null &&
                File(item["image_path"]).existsSync();

            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                leading: hasImage
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(item["image_path"]),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image, size: 40),
                title: Text(() {
                  // --- FIX: Translate the saved crop key before display ---
                  final rawCrop = item['crop']?.toString() ?? 'crop_unknown';
                  final cropName = rawCrop.tr;

                  // Format and translate the diagnosis/label
                  final raw = item['label']?.toString() ?? '';
                  final display = formatLabel(raw).tr;

                  return "$cropName • $display";
                }()),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${'confidence'.tr}: ${(item['confidence'] * 100).toStringAsFixed(1)}%",
                    ),
                    Text(
                      item["timestamp"].toString().split('.')[0],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    if (item.containsKey('feedback'))
                      Text(
                        "Feedback: ${item['feedback']}".tr,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.blueGrey),
                      ),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'share'.tr) {
                      if (hasImage) {
                        final transformed =
                        Map<String, dynamic>.from(item);
                        final raw =
                            transformed['label']?.toString() ?? '';
                        transformed['label'] = formatLabel(raw);
                        await PdfService.createAndSharePdf([transformed]);
                      } else {
                        final raw = item['label']?.toString() ?? '';
                        final display = formatLabel(raw);
                        final text =
                            "${(item['crop']?.toString().tr ?? 'crop_unknown'.tr)} - ${display.tr}\n${'confidence'.tr}: ${(item['confidence'] * 100).toStringAsFixed(1)}%";
                        await Share.share(text);
                      }
                    } else if (value == 'delete'.tr) {
                      _deleteItem(i);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'share'.tr,
                      child: ListTile(
                        leading: const Icon(Icons.share),
                        title: Text('Share'.tr),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete'.tr,
                      child: ListTile(
                        leading:
                        const Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete'.tr),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  final imageFile = item["image_path"] != null &&
                      File(item["image_path"]).existsSync()
                      ? File(item["image_path"])
                      : null;

                  final result = DiseaseResult(
                    crop: item["crop"] ?? "crop_unknown",
                    label: item["label"] ?? "diagnosis_unknown",
                    rawLabel:
                    item["rawLabel"] ?? item["label"] ?? "Unknown",
                    confidence: item["confidence"] ?? 0.0,
                    symptoms: item["symptoms"] ?? "none",
                    treatment: item["treatment"] ?? "none",
                    message: item["message"] ?? "unknown_crop_msg",
                    status: item["status"] ?? "status_unknown",
                  );
                  Get.to(() => AnalysisResultScreen(
                      result: result,
                      imageFile: imageFile,
                      fromHistory: true));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
