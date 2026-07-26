import 'package:get/get.dart';

/// Format a raw model label into a user-friendly, translated string.
///
/// Behavior:
/// - If a translation exists for the raw key (checked via GetX .tr), return it.
/// - Otherwise replace underscores with spaces for readability.
String formatLabel(String? raw) {
  if (raw == null) return '';
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final translated = trimmed.tr;
  if (translated != trimmed) return translated;
  return trimmed.replaceAll('_', ' ');
}
