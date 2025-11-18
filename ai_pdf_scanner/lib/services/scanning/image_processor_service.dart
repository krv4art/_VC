import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Image processing service
/// Handles image enhancement, compression, and manipulation
class ImageProcessorService {
  static final ImageProcessorService _instance = ImageProcessorService._internal();
  factory ImageProcessorService() => _instance;
  ImageProcessorService._internal();

  /// Enhance image quality (brightness, contrast, sharpness)
  Future<String> enhanceImage(String imagePath, {
    double brightness = 1.1,
    double contrast = 1.2,
    bool sharpen = true,
  }) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Adjust brightness
      if (brightness != 1.0) {
        image = img.adjustColor(image, brightness: brightness);
      }

      // Adjust contrast
      if (contrast != 1.0) {
        image = img.adjustColor(image, contrast: contrast);
      }

      // Sharpen
      if (sharpen) {
        image = img.smooth(image, weight: 1.2);
      }

      // Convert to grayscale for better OCR
      // image = img.grayscale(image);

      // Save enhanced image
      final outputPath = await _getSavePathWithSuffix(imagePath, '_enhanced');
      final enhancedFile = File(outputPath);
      await enhancedFile.writeAsBytes(img.encodeJpg(image, quality: 95));

      debugPrint('✅ Image enhanced: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Image enhancement failed: $e');
      rethrow;
    }
  }

  /// Compress image to reduce file size
  Future<String> compressImage(String imagePath, {
    int quality = 85,
    int? targetWidth,
    int? targetHeight,
  }) async {
    try {
      final outputPath = await _getSavePathWithSuffix(imagePath, '_compressed');

      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        outputPath,
        quality: quality,
        minWidth: targetWidth ?? 1920,
        minHeight: targetHeight ?? 2560,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw Exception('Compression failed');
      }

      debugPrint('✅ Image compressed: ${result.path}');
      return result.path;
    } catch (e) {
      debugPrint('❌ Image compression failed: $e');
      rethrow;
    }
  }

  /// Crop image to specified coordinates
  Future<String> cropImage(
    String imagePath, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Crop
      final cropped = img.copyCrop(image,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Save cropped image
      final outputPath = await _getSavePathWithSuffix(imagePath, '_cropped');
      final croppedFile = File(outputPath);
      await croppedFile.writeAsBytes(img.encodeJpg(cropped, quality: 95));

      debugPrint('✅ Image cropped: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Image cropping failed: $e');
      rethrow;
    }
  }

  /// Rotate image by degrees (90, 180, 270)
  Future<String> rotateImage(String imagePath, int degrees) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Rotate
      final rotated = img.copyRotate(image, angle: degrees);

      // Save rotated image
      final outputPath = await _getSavePathWithSuffix(imagePath, '_rotated');
      final rotatedFile = File(outputPath);
      await rotatedFile.writeAsBytes(img.encodeJpg(rotated, quality: 95));

      debugPrint('✅ Image rotated: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Image rotation failed: $e');
      rethrow;
    }
  }

  /// Apply perspective correction to image
  Future<String> applyPerspectiveCorrection(
    String imagePath,
    List<ui.Offset> corners,
  ) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // TODO: Implement perspective transformation
      // This is a complex operation that requires matrix calculations
      // For now, we'll return the original image
      // In production, use opencv_dart or custom implementation

      debugPrint('⚠️ Perspective correction not yet implemented');
      return imagePath;
    } catch (e) {
      debugPrint('❌ Perspective correction failed: $e');
      rethrow;
    }
  }

  /// Convert image to grayscale
  Future<String> convertToGrayscale(String imagePath) async {
    try {
      // Load image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Convert to grayscale
      final grayscale = img.grayscale(image);

      // Save grayscale image
      final outputPath = await _getSavePathWithSuffix(imagePath, '_grayscale');
      final grayscaleFile = File(outputPath);
      await grayscaleFile.writeAsBytes(img.encodeJpg(grayscale, quality: 95));

      debugPrint('✅ Image converted to grayscale: $outputPath');
      return outputPath;
    } catch (e) {
      debugPrint('❌ Grayscale conversion failed: $e');
      rethrow;
    }
  }

  /// Generate thumbnail from image
  Future<String> generateThumbnail(
    String imagePath, {
    int width = 200,
    int height = 280,
  }) async {
    try {
      final outputPath = await _getSavePathWithSuffix(imagePath, '_thumb');

      final result = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        outputPath,
        quality: 70,
        minWidth: width,
        minHeight: height,
        format: CompressFormat.jpeg,
      );

      if (result == null) {
        throw Exception('Thumbnail generation failed');
      }

      debugPrint('✅ Thumbnail generated: ${result.path}');
      return result.path;
    } catch (e) {
      debugPrint('❌ Thumbnail generation failed: $e');
      rethrow;
    }
  }

  /// Get image dimensions
  Future<Map<String, int>> getImageDimensions(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      return {
        'width': image.width,
        'height': image.height,
      };
    } catch (e) {
      debugPrint('❌ Failed to get image dimensions: $e');
      rethrow;
    }
  }

  /// Helper method to generate output path with suffix
  Future<String> _getSavePathWithSuffix(String originalPath, String suffix) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String fileName = path.basenameWithoutExtension(originalPath);
    final String extension = path.extension(originalPath);
    final String newFileName = '$fileName$suffix$extension';
    return path.join(tempDir.path, newFileName);
  }
}
