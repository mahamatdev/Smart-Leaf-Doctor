import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ai_service.dart';
import '../theme/app_theme.dart'; // Make sure this is imported
import 'analysis_result.dart';
import 'loading_screen.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final picker = ImagePicker();
  File? _image;

  Future<void> pickImage(ImageSource source) async {
    // Replace the scanner page with the analyzing/loading screen BEFORE
    // opening the camera/gallery. This ensures that when the external
    // picker returns we come back to the LoadingScreen instead of briefly
    // showing the scanner page.
    debugPrint('Scanner: replacing Scanner with Analyzing LoadingScreen');
    Get.off(() => const LoadingScreen());

    // Now open the camera/gallery picker. The LoadingScreen will remain
    // underneath the platform picker so when the picker returns the user
    // sees the loading UI rather than the scanner.
    final picked = await picker.pickImage(source: source, imageQuality: 75);

    if (picked == null) {
      debugPrint('Scanner: picker returned null, restoring ScannerScreen');
      // User cancelled — restore the scanner UI (replace LoadingScreen).
      Get.off(() => const ScannerScreen());
      return;
    }

    // Update the local image reference
    _image = File(picked.path);

    debugPrint('Scanner: image picked, starting inference');
    final result = await AIService().runInference(File(picked.path));
    debugPrint('Scanner: inference complete, navigating to AnalysisResult');

    // Replace the loading screen with the analysis result to keep the UX
    // smooth (no intermediate flash back to scanner screen).
    Get.off(() => AnalysisResultScreen(result: result));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("scan_now".tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white30,
                  child: Icon(
                    Icons.agriculture_rounded,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Empowering agriculture through smart image diagnostics".tr,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black45,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildActionButton(
                  icon: Icons.camera_alt,
                  label: "capture_image".tr,

                  onPressed: () => pickImage(ImageSource.camera),

                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  icon: Icons.photo,
                  label: "select_image".tr,
                  onPressed: () => pickImage(ImageSource.gallery),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white, size: 28),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(210, 50),
        backgroundColor: Colors.green,
        foregroundColor: Colors.green,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
    );
  }
}
