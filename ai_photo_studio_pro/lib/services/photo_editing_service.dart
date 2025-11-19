import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for photo editing operations (crop, rotate, filters, adjustments)
class PhotoEditingService {
  /// Crop an image to specified rectangle
  Future<String?> cropImage({
    required String imagePath,
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final cropped = img.copyCrop(
        image,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      return await _saveImage(cropped, 'cropped');
    } catch (e) {
      debugPrint('Error cropping image: $e');
      return null;
    }
  }

  /// Rotate image by specified angle (90, 180, 270 degrees)
  Future<String?> rotateImage({
    required String imagePath,
    required int angle,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      img.Image rotated;
      switch (angle) {
        case 90:
          rotated = img.copyRotate(image, angle: 90);
          break;
        case 180:
          rotated = img.copyRotate(image, angle: 180);
          break;
        case 270:
          rotated = img.copyRotate(image, angle: 270);
          break;
        default:
          rotated = img.copyRotate(image, angle: angle);
      }

      return await _saveImage(rotated, 'rotated');
    } catch (e) {
      debugPrint('Error rotating image: $e');
      return null;
    }
  }

  /// Flip image horizontally
  Future<String?> flipHorizontal(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final flipped = img.flipHorizontal(image);

      return await _saveImage(flipped, 'flipped_h');
    } catch (e) {
      debugPrint('Error flipping image horizontally: $e');
      return null;
    }
  }

  /// Flip image vertically
  Future<String?> flipVertical(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final flipped = img.flipVertical(image);

      return await _saveImage(flipped, 'flipped_v');
    } catch (e) {
      debugPrint('Error flipping image vertically: $e');
      return null;
    }
  }

  /// Adjust brightness (-100 to 100)
  Future<String?> adjustBrightness({
    required String imagePath,
    required int brightness,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final adjusted = img.adjustColor(
        image,
        brightness: brightness.toDouble(),
      );

      return await _saveImage(adjusted, 'brightness');
    } catch (e) {
      debugPrint('Error adjusting brightness: $e');
      return null;
    }
  }

  /// Adjust contrast (-100 to 100)
  Future<String?> adjustContrast({
    required String imagePath,
    required int contrast,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final adjusted = img.adjustColor(
        image,
        contrast: contrast.toDouble(),
      );

      return await _saveImage(adjusted, 'contrast');
    } catch (e) {
      debugPrint('Error adjusting contrast: $e');
      return null;
    }
  }

  /// Adjust saturation (-100 to 100)
  Future<String?> adjustSaturation({
    required String imagePath,
    required int saturation,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final adjusted = img.adjustColor(
        image,
        saturation: saturation.toDouble(),
      );

      return await _saveImage(adjusted, 'saturation');
    } catch (e) {
      debugPrint('Error adjusting saturation: $e');
      return null;
    }
  }

  /// Apply all adjustments at once for better performance
  Future<String?> adjustImage({
    required String imagePath,
    int brightness = 0,
    int contrast = 0,
    int saturation = 0,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final adjusted = img.adjustColor(
        image,
        brightness: brightness.toDouble(),
        contrast: contrast.toDouble(),
        saturation: saturation.toDouble(),
      );

      return await _saveImage(adjusted, 'adjusted');
    } catch (e) {
      debugPrint('Error adjusting image: $e');
      return null;
    }
  }

  /// Apply grayscale filter
  Future<String?> applyGrayscale(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final grayscale = img.grayscale(image);

      return await _saveImage(grayscale, 'grayscale');
    } catch (e) {
      debugPrint('Error applying grayscale: $e');
      return null;
    }
  }

  /// Apply sepia filter
  Future<String?> applySepia(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final sepia = img.sepia(image);

      return await _saveImage(sepia, 'sepia');
    } catch (e) {
      debugPrint('Error applying sepia: $e');
      return null;
    }
  }

  /// Apply blur effect
  Future<String?> applyBlur({
    required String imagePath,
    int radius = 5,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      final blurred = img.gaussianBlur(image, radius: radius);

      return await _saveImage(blurred, 'blurred');
    } catch (e) {
      debugPrint('Error applying blur: $e');
      return null;
    }
  }

  /// Resize image
  Future<String?> resizeImage({
    required String imagePath,
    int? width,
    int? height,
    bool maintainAspectRatio = true,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      img.Image resized;
      if (maintainAspectRatio) {
        if (width != null) {
          resized = img.copyResize(image, width: width);
        } else if (height != null) {
          resized = img.copyResize(image, height: height);
        } else {
          return imagePath;
        }
      } else {
        resized = img.copyResize(
          image,
          width: width ?? image.width,
          height: height ?? image.height,
        );
      }

      return await _saveImage(resized, 'resized');
    } catch (e) {
      debugPrint('Error resizing image: $e');
      return null;
    }
  }

  /// Add watermark to image
  Future<String?> addWatermark({
    required String imagePath,
    required String watermarkText,
    int fontSize = 24,
    Color color = Colors.white,
    double opacity = 0.5,
    WatermarkPosition position = WatermarkPosition.bottomRight,
  }) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      // Draw text watermark
      final watermarked = img.drawString(
        image,
        watermarkText,
        font: img.arial48,
        x: _getWatermarkX(image.width, position),
        y: _getWatermarkY(image.height, position),
        color: img.ColorRgb8(
          (color.red * 255).toInt(),
          (color.green * 255).toInt(),
          (color.blue * 255).toInt(),
        ),
      );

      return await _saveImage(watermarked, 'watermarked');
    } catch (e) {
      debugPrint('Error adding watermark: $e');
      return null;
    }
  }

  int _getWatermarkX(int width, WatermarkPosition position) {
    switch (position) {
      case WatermarkPosition.topLeft:
      case WatermarkPosition.bottomLeft:
        return 20;
      case WatermarkPosition.topRight:
      case WatermarkPosition.bottomRight:
        return width - 200;
      case WatermarkPosition.center:
        return width ~/ 2 - 100;
    }
  }

  int _getWatermarkY(int height, WatermarkPosition position) {
    switch (position) {
      case WatermarkPosition.topLeft:
      case WatermarkPosition.topRight:
        return 20;
      case WatermarkPosition.bottomLeft:
      case WatermarkPosition.bottomRight:
        return height - 60;
      case WatermarkPosition.center:
        return height ~/ 2;
    }
  }

  /// Save processed image to temporary directory
  Future<String> _saveImage(img.Image image, String prefix) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${prefix}_$timestamp.jpg';
    final filePath = path.join(tempDir.path, fileName);

    final file = File(filePath);
    await file.writeAsBytes(img.encodeJpg(image, quality: 95));

    return filePath;
  }

  /// Get image dimensions
  Future<Size?> getImageDimensions(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      debugPrint('Error getting image dimensions: $e');
      return null;
    }
  }
}

/// Watermark position options
enum WatermarkPosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  center,
}
