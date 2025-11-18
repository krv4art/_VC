import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for compressing images before processing
class ImageCompressionService {
  /// Compress image for API processing
  /// Returns path to compressed image
  static Future<String> compressForProcessing(String imagePath) async {
    try {
      debugPrint('Compressing image: $imagePath');

      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      // Compress image
      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 1024,
        minHeight: 1024,
        quality: 85,
        format: CompressFormat.png,
      );

      // Save compressed image
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'compressed_$timestamp.png';
      final compressedPath = path.join(directory.path, fileName);

      final compressedFile = File(compressedPath);
      await compressedFile.writeAsBytes(compressedBytes);

      final originalSize = bytes.length;
      final compressedSize = compressedBytes.length;
      final compressionRatio =
          ((1 - compressedSize / originalSize) * 100).toStringAsFixed(1);

      debugPrint(
        'Image compressed: ${_formatBytes(originalSize)} -> ${_formatBytes(compressedSize)} ($compressionRatio% reduction)',
      );

      return compressedPath;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      rethrow;
    }
  }

  /// Compress image for display/sharing
  static Future<Uint8List> compressForDisplay(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();

      final compressedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        minWidth: 800,
        minHeight: 800,
        quality: 80,
        format: CompressFormat.jpeg,
      );

      return compressedBytes;
    } catch (e) {
      debugPrint('Error compressing image for display: $e');
      rethrow;
    }
  }

  /// Format bytes to human-readable string
  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
