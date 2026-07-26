import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../controllers/theme_controller.dart';
import 'disease_library_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(title: Text("Settings".tr)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text("language".tr),
            trailing: DropdownButton(
              value: Get.locale!.languageCode,
              onChanged: (val) {
                Get.updateLocale(Locale(val!));
              },
              items: const [
                DropdownMenuItem(value: "en", child: Text("English")),
                DropdownMenuItem(value: "fr", child: Text("Français")),
                DropdownMenuItem(value: "ar", child: Text("العربية")),
                DropdownMenuItem(value: "rw", child: Text("Kinyarwanda")),
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text("Dark Mode".tr),
            trailing: Obx(
                  () => Switch(
                value: themeController.isDark.value,
                onChanged: (val) {
                  themeController.toggleTheme(val);
                },
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: Text("Clear history".tr),
            onTap: () {
              StorageService.clearHistory();
              Get.snackbar("Success", "History cleared".tr);
            },
          ),

          // NEW: Disease Library button
          ListTile(
            leading: const Icon(Icons.menu_book, color: Colors.green),
            title: Text("Disease Library".tr),
            onTap: () {
              Get.to(() => const DiseaseLibraryScreen());
            },
          ),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text("About the App".tr),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("About Smart Leaf Doctor".tr),
                    content: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.maxFinite,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "📌 ${"App Overview".tr}\n\n${"Smart Leaf Doctor is an offline mobile app that helps farmers and agronomists quickly identify crop diseases by analyzing leaf images. It provides instant, reliable results to help protect your crops and improve yields.".tr}\n",
                              ),
                              Text(
                                "✨ ${"Key Features".tr}\n\n- 🌿 ${"Offline AI-based disease detection".tr}\n- 🌾 ${"Supports multiple crops (e.g., cassava, maize)".tr}\n- 📊 ${"Shows confidence scores for each prediction".tr}\n- 🗂 ${"Stores past scans for offline reference".tr}\n- 🧭 ${"Easy-to-use interface with multilingual support".tr}\n- 🌗 ${"Light/Dark mode toggle for accessibility".tr}\n- 🔄 ${"Works without internet or mobile data".tr}\n",
                              ),
                              Text(
                                "🎯 ${"Benefits".tr}\n\n- ⏱ ${"Save time compared to manual inspection".tr}\n- 🛡 ${"Reduce crop loss through early detection".tr}\n- 📶 ${"Works anywhere, even in remote areas".tr}\n- 🧠 ${"Helps make informed farming decisions".tr}\n- 🧑‍🌾 ${"Empowers farmers with instant, offline insights".tr}\n",
                              ),
                              Text(
                                "👤 ${"Credits & Contact".tr}\n\n${"Developed by: Mahamat Ali Abderaman".tr}\n${"For feedback or support:".tr}\n📧 mahamataliabderaman235@gmail.com\n📞 +250 790005891\n",
                              ),
                              Text(
                                "🔒 ${"Privacy & Data".tr}\n\n${"This app stores scan history locally on your device. No personal data is shared or uploaded.".tr}\n",
                              ),
                              Text(
                                "🌐 ${"Languages Supported".tr}\n\n${"English, Français, العربية, Kinyarwanda".tr}\n",
                              ),
                              Text(
                                "📅 ${"Version Info".tr}\n\n${"Version: 1.0.0".tr}\n${"Last updated: November 2025".tr}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text("Close".tr),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}