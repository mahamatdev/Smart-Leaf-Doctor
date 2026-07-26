import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();

  // Reactive flag so UI can update immediately when toggled.
  final RxBool isDark = false.obs;

  @override
  void onInit() {
    super.onInit();
    final stored = box.read('isDarkMode');
    isDark.value = stored == true;
  }

  ThemeMode getThemeMode() {
    return isDark.value ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme(bool dark) {
    isDark.value = dark;
    box.write('isDarkMode', dark);
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
}
