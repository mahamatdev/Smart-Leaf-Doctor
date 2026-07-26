import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('help'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'how_to_use'.tr,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 10),
            Text(
              'help_step1'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            Text(
              'help_step2'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            Text(
              'help_step3'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            Text(
              'help_step4'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            const SizedBox(height: 20),
            Text(
              'tips'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            Text(
              'tip1'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
            Text(
              'tip2'.tr,
              style: const TextStyle(fontSize: 16),
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            ),
          ],
        ),
      ),
    );
  }
}
