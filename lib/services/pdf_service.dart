import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import '../utils/label_helper.dart';

class PdfService {
  /// history is a List<Map> as saved by StorageService
  static Future<File> createHistoryPdf(List<dynamic> history) async {
    final pdf = pw.Document();
    final dateFmt = DateFormat('yyyy-MM-dd HH:mm');

    for (final item in history) {
      final crop = item['crop'] ?? 'Unknown';
      final rawLabel = (item['label'] ?? 'Unknown').toString();
      final label = formatLabel(rawLabel);
      final confidence = item['confidence'] != null
          ? (item['confidence'] is double
                ? (item['confidence'] * 100).toStringAsFixed(1)
                : item['confidence'].toString())
          : 'N/A';
      final ts = item['timestamp'] ?? '';
      final imagePath = item['image_path'];

      pw.Widget contentRow;

      if (imagePath != null && File(imagePath).existsSync()) {
        final imageBytes = File(imagePath).readAsBytesSync();
        final pwImage = pw.MemoryImage(imageBytes);
        contentRow = pw.Row(
          children: [
            pw.Container(
              width: 120,
              height: 120,
              child: pw.Image(pwImage, fit: pw.BoxFit.cover),
            ),
            pw.SizedBox(width: 12),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Crop: $crop',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text('Diagnosis: $label'),
                  pw.Text('${'confidence'.tr}: $confidence%'),
                  pw.Text(
                    'Date: ${dateFmt.format(DateTime.tryParse(ts) ?? DateTime.now())}',
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        contentRow = pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Crop: $crop',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Diagnosis: $label'),
            pw.Text('${'confidence'.tr}: $confidence%'),
            pw.Text(
              'Date: ${dateFmt.format(DateTime.tryParse(ts) ?? DateTime.now())}',
            ),
          ],
        );
      }

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(16),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [contentRow, pw.Divider()],
              ),
            );
          },
        ),
      );
    }

    // Save to temp file
    final outputDir = await getTemporaryDirectory();
    final file = File(
      '${outputDir.path}/scan_history_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<void> createAndSharePdf(List<dynamic> history) async {
    final file = await createHistoryPdf(history);
    await Share.shareXFiles([XFile(file.path)], text: 'Scan History Report');
  }
}
