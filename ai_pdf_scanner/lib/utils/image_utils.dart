import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../exceptions/app_exception.dart';
import 'file_utils.dart';

/// Utility class for image processing operations
class ImageUtils {
  ImageUtils._();

  /// Compress image to reduce file size
  static Future<Uint8List> compressImage(
    Uint8List imageBytes, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final result = await FlutterImageCompress.compressWithList(
        imageBytes,
        quality: quality,
        minWidth: maxWidth ?? 1920,
        minHeight: maxHeight ?? 1080,
      );
      return result;
    } catch (e) {
      throw StorageException(
        'Failed to compress image',
        originalError: e,
      );
    }
  }

  /// Compress image file
  static Future<File> compressImageFile(
    String filePath, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final targetPath = filePath.replaceFirst(
        path.extension(filePath),
        '_compressed${path.extension(filePath)}',
      );

      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: quality,
        minWidth: maxWidth ?? 1920,
        minHeight: maxHeight ?? 1080,
      );

      if (result == null) {
        throw StorageException('Image compression returned null');
      }

      return File(result.path);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to compress image file',
        originalError: e,
      );
    }
  }

  /// Resize image
  static Future<Uint8List> resizeImage(
    Uint8List imageBytes, {
    required int width,
    required int height,
    bool maintainAspectRatio = true,
  }) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      img.Image resized;
      if (maintainAspectRatio) {
        resized = img.copyResize(
          image,
          width: width,
          height: height,
          interpolation: img.Interpolation.linear,
        );
      } else {
        resized = img.copyResize(
          image,
          width: width,
          height: height,
          interpolation: img.Interpolation.linear,
        );
      }

      return Uint8List.fromList(img.encodeJpg(resized, quality: 90));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to resize image',
        originalError: e,
      );
    }
  }

  /// Rotate image
  static Future<Uint8List> rotateImage(
    Uint8List imageBytes,
    int degrees,
  ) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      img.Image rotated;
      switch (degrees) {
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
          rotated = img.copyRotate(image, angle: degrees);
      }

      return Uint8List.fromList(img.encodeJpg(rotated, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to rotate image',
        originalError: e,
      );
    }
  }

  /// Crop image
  static Future<Uint8List> cropImage(
    Uint8List imageBytes, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      final cropped = img.copyCrop(
        image,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      return Uint8List.fromList(img.encodeJpg(cropped, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to crop image',
        originalError: e,
      );
    }
  }

  /// Enhance image (brightness, contrast, sharpness)
  static Future<Uint8List> enhanceImage(
    Uint8List imageBytes, {
    double brightness = 1.0,
    double contrast = 1.0,
    double saturation = 1.0,
  }) async {
    try {
      var image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      // Adjust brightness
      if (brightness != 1.0) {
        image = img.adjustColor(
          image,
          brightness: brightness,
        );
      }

      // Adjust contrast
      if (contrast != 1.0) {
        image = img.adjustColor(
          image,
          contrast: contrast,
        );
      }

      // Adjust saturation
      if (saturation != 1.0) {
        image = img.adjustColor(
          image,
          saturation: saturation,
        );
      }

      return Uint8List.fromList(img.encodeJpg(image, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to enhance image',
        originalError: e,
      );
    }
  }

  /// Convert image to grayscale
  static Future<Uint8List> convertToGrayscale(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      final grayscale = img.grayscale(image);
      return Uint8List.fromList(img.encodeJpg(grayscale, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to convert to grayscale',
        originalError: e,
      );
    }
  }

  /// Apply auto-enhance to image
  static Future<Uint8List> autoEnhance(Uint8List imageBytes) async {
    try {
      var image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      // Auto-adjust contrast and brightness
      image = img.adjustColor(
        image,
        contrast: 1.2,
        brightness: 1.1,
      );

      // Sharpen slightly
      image = img.adjustColor(image, saturation: 1.1);

      return Uint8List.fromList(img.encodeJpg(image, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to auto-enhance image',
        originalError: e,
      );
    }
  }

  /// Get image dimensions
  static Future<Size> getImageDimensions(Uint8List imageBytes) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }
      return Size(image.width.toDouble(), image.height.toDouble());
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to get image dimensions',
        originalError: e,
      );
    }
  }

  /// Convert image to base64
  static String imageToBase64(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }

  /// Convert base64 to image bytes
  static Uint8List base64ToImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      throw ValidationException(
        'Invalid base64 image data',
        originalError: e,
      );
    }
  }

  /// Create thumbnail from image
  static Future<Uint8List> createThumbnail(
    Uint8List imageBytes, {
    int maxWidth = 300,
    int maxHeight = 300,
  }) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      // Calculate thumbnail size maintaining aspect ratio
      final thumbnail = img.copyResize(
        image,
        width: maxWidth,
        height: maxHeight,
        interpolation: img.Interpolation.linear,
      );

      return Uint8List.fromList(img.encodeJpg(thumbnail, quality: 80));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to create thumbnail',
        originalError: e,
      );
    }
  }

  /// Detect if image needs rotation based on EXIF
  static Future<int> detectImageRotation(String filePath) async {
    // Note: This requires additional EXIF reading library
    // For now, return 0 (no rotation needed)
    // TODO: Implement EXIF rotation detection
    return 0;
  }

  /// Apply perspective correction to image (useful for document scanning)
  static Future<Uint8List> correctPerspective(
    Uint8List imageBytes, {
    required List<Offset> corners,
  }) async {
    // This is a simplified version
    // Full perspective correction requires more complex image processing
    // TODO: Implement proper perspective transformation
    return imageBytes;
  }

  /// Convert to black and white (for documents)
  static Future<Uint8List> convertToBlackAndWhite(
    Uint8List imageBytes, {
    int threshold = 128,
  }) async {
    try {
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw StorageException('Failed to decode image');
      }

      // Convert to grayscale first
      var processed = img.grayscale(image);

      // Apply threshold
      for (int y = 0; y < processed.height; y++) {
        for (int x = 0; x < processed.width; x++) {
          final pixel = processed.getPixel(x, y);
          final gray = pixel.r.toInt();
          final newColor = gray > threshold ? 255 : 0;
          processed.setPixelRgba(x, y, newColor, newColor, newColor, 255);
        }
      }

      return Uint8List.fromList(img.encodeJpg(processed, quality: 95));
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Failed to convert to black and white',
        originalError: e,
      );
    }
  }
}

import 'dart:convert';
import 'package:path/path.dart' as path;
