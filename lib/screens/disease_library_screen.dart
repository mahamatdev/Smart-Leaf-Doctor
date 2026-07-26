import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/disease_data.dart';
import '../utils/label_helper.dart'; // ✅ Import this

class DiseaseLibraryScreen extends StatelessWidget {
  const DiseaseLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = DiseaseData.infoMap.entries.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Disease Library".tr)),
      body: ListView.builder(
        itemCount: diseases.length,
        itemBuilder: (_, i) {
          final entry = diseases[i];
          final rawLabel = entry.key;
          final info = entry.value;

          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.local_florist, color: Colors.green),
              title: Text(formatLabel(rawLabel)), // ✅ Translated + formatted
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${'symptoms'.tr}: ${info['symptoms']!.tr}"),
                  Text("${'treatment'.tr}: ${info['treatment']!.tr}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}