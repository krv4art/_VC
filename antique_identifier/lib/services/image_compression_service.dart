import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

/// Сервис для сжатия изображений перед отправкой
class ImageCompressionService {
  static const int _targetWidth = 1280;
  static const int _targetHeight = 1280;
  static const int _quality = 85; // 0-100

  /// Сжимает изображение из файла
  static Future<Uint8List> compressImageFile(String filePath) async {
    try {
      debugPrint('=== Compressing image ===');
      debugPrint('Original file: $filePath');

      final File file = File(filePath);
      final int originalSize = await file.length();
      debugPrint('Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');

      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        '${filePath}_compressed.jpg',
        minWidth: _targetWidth,
        minHeight: _targetHeight,
        quality: _quality,
      );

      if (compressedFile == null) {
        debugPrint('Compression failed, using original');
        return file.readAsBytes();
      }

      final Uint8List result = await compressedFile.readAsBytes();
      final int compressedSize = result.length;
      final double ratio = 100 - ((compressedSize / originalSize) * 100);

      debugPrint('Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
      debugPrint('Compression ratio: ${ratio.toStringAsFixed(1)}%');
      debugPrint('=== Compression complete ===');

      return result;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      // Return original if compression fails
      return File(filePath).readAsBytes();
    }
  }

  /// Сжимает изображение из Uint8List
  static Future<Uint8List> compressImageBytes(
    Uint8List imageBytes, {
    int quality = _quality,
  }) async {
    try {
      debugPrint('=== Compressing image bytes ===');
      debugPrint('Original size: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB');

      final List<int>? compressed = await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: _targetWidth,
        minHeight: _targetHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressed == null) {
        debugPrint('Compression failed, using original');
        return imageBytes;
      }

      final Uint8List result = Uint8List.fromList(compressed);
      final double ratio = 100 - ((result.length / imageBytes.length) * 100);

      debugPrint('Compressed size: ${(result.length / 1024).toStringAsFixed(2)} KB');
      debugPrint('Compression ratio: ${ratio.toStringAsFixed(1)}%');
      debugPrint('=== Compression complete ===');

      return result;
    } catch (e) {
      debugPrint('Error compressing bytes: $e');
      // Return original if compression fails
      return imageBytes;
    }
  }

  /// Вычисляет размер файла в KB
  static String getFileSizeKB(int bytes) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  }

  /// Вычисляет процент сжатия
  static double getCompressionRatio(int originalSize, int compressedSize) {
    return 100 - ((compressedSize / originalSize) * 100);
  }
}
