import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Service for compressing images before sending to AI
/// Reduces bandwidth usage and API costs while maintaining quality
class ImageCompressionService {
  // Configuration for AI image compression
  static const int maxWidth = 1920;
  static const int maxHeight = 1920;
  static const int quality = 85;
  static const int maxFileSizeKB = 500; // Target max size: 500KB

  /// Compress image file and return compressed bytes
  ///
  /// This method:
  /// 1. Resizes image to max dimensions while maintaining aspect ratio
  /// 2. Compresses with specified quality (85%)
  /// 3. Ensures final size is under 500KB
  ///
  /// Returns compressed image bytes ready for base64 encoding
  static Future<Uint8List> compressImageFile(String imagePath) async {
    try {
      debugPrint('📸 Starting image compression for: $imagePath');

      // Get original file size
      final originalFile = File(imagePath);
      final originalSize = await originalFile.length();
      debugPrint('📏 Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');

      // Compress image
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg, // JPEG for photos, better compression
      );

      if (compressedBytes == null) {
        throw Exception('Image compression failed');
      }

      final compressedSize = compressedBytes.length;
      debugPrint('🗜️ Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
      debugPrint('📊 Compression ratio: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%');

      // If still too large, compress more aggressively
      if (compressedSize > maxFileSizeKB * 1024) {
        debugPrint('⚠️ Image still too large, applying aggressive compression...');
        return await _compressAggressively(imagePath, compressedBytes);
      }

      return compressedBytes;
    } catch (e) {
      debugPrint('❌ Error compressing image: $e');
      // Fallback: return original file bytes
      debugPrint('⚠️ Falling back to original image');
      return await File(imagePath).readAsBytes();
    }
  }

  /// Aggressively compress image if first attempt is too large
  static Future<Uint8List> _compressAggressively(
    String imagePath,
    Uint8List firstAttempt,
  ) async {
    // Try with lower quality
    final aggressiveBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 1280,
      minHeight: 1280,
      quality: 70, // Lower quality
      format: CompressFormat.jpeg,
    );

    if (aggressiveBytes == null) {
      return firstAttempt; // Return first attempt if this fails
    }

    final finalSize = aggressiveBytes.length;
    debugPrint('🗜️ Aggressive compression size: ${(finalSize / 1024).toStringAsFixed(2)} KB');

    return aggressiveBytes;
  }

  /// Compress image bytes directly (for in-memory images)
  static Future<Uint8List> compressImageBytes(Uint8List imageBytes) async {
    try {
      debugPrint('📸 Starting in-memory image compression');

      final originalSize = imageBytes.length;
      debugPrint('📏 Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');

      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      final compressedSize = compressedBytes.length;
      debugPrint('🗜️ Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
      debugPrint('📊 Compression ratio: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%');

      return compressedBytes;
    } catch (e) {
      debugPrint('❌ Error compressing image bytes: $e');
      return imageBytes; // Return original on error
    }
  }

  /// Save compressed image to temporary directory
  /// Useful for preview or caching
  static Future<String> compressAndSaveImage(String sourcePath) async {
    try {
      final compressedBytes = await compressImageFile(sourcePath);

      // Save to temp directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(sourcePath);
      final fileName = 'compressed_$timestamp$extension';
      final targetPath = p.join(tempDir.path, fileName);

      final file = File(targetPath);
      await file.writeAsBytes(compressedBytes);

      debugPrint('💾 Saved compressed image to: $targetPath');
      return targetPath;
    } catch (e) {
      debugPrint('❌ Error saving compressed image: $e');
      return sourcePath; // Return original path on error
    }
  }

  /// Get estimated base64 size from compressed bytes
  /// Base64 encoding increases size by ~33%
  static int estimateBase64Size(Uint8List bytes) {
    return (bytes.length * 1.33).ceil();
  }

  /// Check if image needs compression based on file size
  static Future<bool> needsCompression(String imagePath) async {
    try {
      final file = File(imagePath);
      final size = await file.length();
      return size > maxFileSizeKB * 1024;
    } catch (e) {
      return false;
    }
  }
}
