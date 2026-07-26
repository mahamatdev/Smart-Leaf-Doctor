import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> init() async {
    // Optionally set default language to current Get.locale
    final locale = Get.locale?.languageCode ?? 'en';
    try {
      await _tts.setLanguage(locale);
    } catch (e) {
      // ignore
    }
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  static Future<void> speak(String text) async {
    await init();
    await _tts.stop();
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}
