import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class StorageService {
  static final _box = GetStorage();
  static const String key = "scan_history";

  /// Get history as a strongly typed list of maps
  static List<Map<String, dynamic>> getHistory() {
    final data = _box.read(key);
    if (data == null) return [];
    return List<Map<String, dynamic>>.from(data);
  }

  /// Save a new result at the top of history
  static void saveResult(Map<String, dynamic> result) {
    final history = getHistory();
    history.insert(0, result); // add on top
    _box.write(key, history);
  }

  /// Delete a single result from history
  static void deleteResult(Map<String, dynamic> item) {
    final history = getHistory();
    history.remove(item);
    _box.write(key, history);
  }

  /// Clear all history
  static void clearHistory() {
    _box.remove(key);
  }

  /// Export history to CSV string
  static String exportToCsv(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return '';
    final headers = history.first.keys.toList();
    final rows = history.map((item) =>
        headers.map((h) => item[h]?.toString().replaceAll(',', ' ') ?? '').join(','));
    return [headers.join(','), ...rows].join('\n');
  }

  /// Export history to JSON string
  static String exportToJson(List<Map<String, dynamic>> history) {
    return const JsonEncoder.withIndent('  ').convert(history);
  }
}