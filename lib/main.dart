import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/theme_controller.dart';
import 'services/ai_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  AIService()
      .preloadModels()
      .then((_) {
        print('Models preloaded');
      })
      .catchError((e) {
        print('Warning: model preload failed: $e');
      });
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Leaf Detector',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.getThemeMode(),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      translations: AppTranslations(),
      home: const HomeScreen(),
    );
  }
}
