import 'constants.dart';
import 'package:get/get.dart';

class LanguageManager extends Translations {
  @override
  Map<String, Map<String, String>> get keys => AppTranslations().keys;
}
