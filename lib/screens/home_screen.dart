import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_theme.dart';
import 'scanner_screen.dart';
import 'best_practices_screen.dart';
import 'settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () => Get.to(() => const HistoryScreen()),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryColor, AppTheme.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/newlogo.png", height: 260),
            const SizedBox(height: 25),
            Text("app_title".tr,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 6),
            Text("Scan & diagnose crop diseases instantly".tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: Text(
                "scan_now".tr,
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // Adjust width and height as needed
                backgroundColor: Colors.green, // Optional: set button background color
                side:  BorderSide(           // ✅ Add border here
                  color: Colors.green[600]!,            // Border color
                  width: 1,
                ),
              ),
              onPressed: () => Get.to(() => const ScannerScreen()),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              icon: const Icon(Icons.info, color: Colors.white),
              label: Text(
                "best_practices".tr,
                style: const TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(200, 50), // Wider button
                backgroundColor: Colors.green, // Ripple effect color
              ),
              onPressed: () => Get.to(() => const BestPracticesScreen()),
            ),
            const SizedBox(height: 12),

          ],
        ),
      ),
    );
  }
}
