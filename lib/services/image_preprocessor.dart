import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class ImagePreprocessor {
  static Future<File> preprocessImage(File image) async {
    final imageBytes = await image.readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageBytes);

    // Resize to 224x224
    final resizedImage = img.copyResize(decodedImage!, width: 224, height: 224);

    // Save processed image
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/processed_image.jpg';
    final processedFile = File(tempPath);
    await processedFile.writeAsBytes(img.encodeJpg(resizedImage));

    return processedFile;
  }
}
