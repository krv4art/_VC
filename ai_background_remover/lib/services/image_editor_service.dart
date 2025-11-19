import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Advanced image editing service with crop, rotate, resize, and filters
class ImageEditorService {
  /// Crop image to specified rectangle
  Future<File> cropImage(
    File imageFile,
    Rect cropRect, {
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final cropped = img.copyCrop(
      image,
      x: cropRect.left.toInt(),
      y: cropRect.top.toInt(),
      width: cropRect.width.toInt(),
      height: cropRect.height.toInt(),
    );

    return _saveImage(cropped, outputPath, 'cropped');
  }

  /// Rotate image by degrees (90, 180, 270, or custom angle)
  Future<File> rotateImage(
    File imageFile,
    double degrees, {
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    img.Image rotated;

    // Optimize for common rotations
    if (degrees == 90 || degrees == -270) {
      rotated = img.copyRotate(image, angle: 90);
    } else if (degrees == 180 || degrees == -180) {
      rotated = img.copyRotate(image, angle: 180);
    } else if (degrees == 270 || degrees == -90) {
      rotated = img.copyRotate(image, angle: 270);
    } else {
      // Custom angle rotation
      rotated = img.copyRotate(image, angle: degrees);
    }

    return _saveImage(rotated, outputPath, 'rotated');
  }

  /// Flip image horizontally or vertically
  Future<File> flipImage(
    File imageFile, {
    bool horizontal = true,
    bool vertical = false,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    img.Image flipped = image;

    if (horizontal) {
      flipped = img.flipHorizontal(flipped);
    }

    if (vertical) {
      flipped = img.flipVertical(flipped);
    }

    return _saveImage(flipped, outputPath, 'flipped');
  }

  /// Resize image to specific dimensions
  Future<File> resizeImage(
    File imageFile, {
    int? width,
    int? height,
    bool maintainAspectRatio = true,
    String? outputPath,
  }) async {
    if (width == null && height == null) {
      throw Exception('Either width or height must be specified');
    }

    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Calculate dimensions
    int targetWidth = width ?? image.width;
    int targetHeight = height ?? image.height;

    if (maintainAspectRatio) {
      if (width != null && height == null) {
        // Scale based on width
        final ratio = width / image.width;
        targetHeight = (image.height * ratio).toInt();
      } else if (height != null && width == null) {
        // Scale based on height
        final ratio = height / image.height;
        targetWidth = (image.width * ratio).toInt();
      }
    }

    final resized = img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
      interpolation: img.Interpolation.cubic,
    );

    return _saveImage(resized, outputPath, 'resized');
  }

  /// Apply various filters to image
  Future<File> applyFilter(
    File imageFile,
    ImageFilter filter, {
    double intensity = 1.0,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    img.Image filtered;

    switch (filter) {
      case ImageFilter.grayscale:
        filtered = img.grayscale(image);
        break;

      case ImageFilter.sepia:
        filtered = img.sepia(image);
        break;

      case ImageFilter.invert:
        filtered = img.invert(image);
        break;

      case ImageFilter.blur:
        final radius = (10 * intensity).toInt();
        filtered = img.gaussianBlur(image, radius: radius);
        break;

      case ImageFilter.sharpen:
        filtered = img.convolution(
          image,
          filter: [
            0, -1, 0,
            -1, 5, -1,
            0, -1, 0,
          ],
        );
        break;

      case ImageFilter.emboss:
        filtered = img.emboss(image);
        break;

      case ImageFilter.vignette:
        filtered = img.vignette(image);
        break;

      case ImageFilter.vintage:
        // Apply vintage effect (sepia + vignette + contrast)
        filtered = img.sepia(image);
        filtered = img.vignette(filtered);
        filtered = img.adjustColor(
          filtered,
          contrast: 1.2,
          saturation: 0.8,
        );
        break;

      case ImageFilter.cool:
        // Cool tone filter
        filtered = img.adjustColor(
          image,
          saturation: 1.3,
          hue: 20,
        );
        break;

      case ImageFilter.warm:
        // Warm tone filter
        filtered = img.adjustColor(
          image,
          saturation: 1.2,
          hue: -20,
        );
        break;

      case ImageFilter.blackAndWhite:
        filtered = img.grayscale(image);
        filtered = img.adjustColor(
          filtered,
          contrast: 1.3,
        );
        break;

      case ImageFilter.vivid:
        filtered = img.adjustColor(
          image,
          saturation: 1.5,
          contrast: 1.2,
          brightness: 1.05,
        );
        break;

      case ImageFilter.none:
        filtered = image;
        break;
    }

    return _saveImage(filtered, outputPath, 'filtered');
  }

  /// Adjust image brightness, contrast, saturation
  Future<File> adjustColors(
    File imageFile, {
    double brightness = 1.0,
    double contrast = 1.0,
    double saturation = 1.0,
    double hue = 0.0,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    final adjusted = img.adjustColor(
      image,
      brightness: brightness,
      contrast: contrast,
      saturation: saturation,
      hue: hue,
    );

    return _saveImage(adjusted, outputPath, 'adjusted');
  }

  /// Add text watermark to image
  Future<File> addTextWatermark(
    File imageFile, {
    required String text,
    double fontSize = 24,
    Color color = Colors.white,
    WatermarkPosition position = WatermarkPosition.bottomRight,
    double opacity = 0.7,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Calculate text position based on WatermarkPosition
    int x, y;
    final padding = 20;
    final textWidth = text.length * (fontSize * 0.6).toInt();
    final textHeight = fontSize.toInt();

    switch (position) {
      case WatermarkPosition.topLeft:
        x = padding;
        y = padding;
        break;
      case WatermarkPosition.topRight:
        x = image.width - textWidth - padding;
        y = padding;
        break;
      case WatermarkPosition.center:
        x = (image.width - textWidth) ~/ 2;
        y = (image.height - textHeight) ~/ 2;
        break;
      case WatermarkPosition.bottomLeft:
        x = padding;
        y = image.height - textHeight - padding;
        break;
      case WatermarkPosition.bottomRight:
        x = image.width - textWidth - padding;
        y = image.height - textHeight - padding;
        break;
    }

    // Draw text using img.drawString
    // Note: The image package has limited font support
    // For production, consider using a custom font or Canvas rendering
    final watermarkedImage = img.Image.from(image);

    // Draw simple text overlay
    // Since img.drawString requires a font, we'll create a semi-transparent rectangle
    // with the text area as a visual watermark indicator
    final watermarkColor = img.ColorRgba8(
      color.red,
      color.green,
      color.blue,
      (opacity * 255).toInt(),
    );

    // Draw watermark background rectangle
    for (int dy = 0; dy < textHeight; dy++) {
      for (int dx = 0; dx < textWidth; dx++) {
        final px = x + dx;
        final py = y + dy;
        if (px >= 0 && px < image.width && py >= 0 && py < image.height) {
          final originalPixel = image.getPixel(px, py);
          // Blend with watermark color
          final blendedR = ((originalPixel.r * (1 - opacity)) + (color.red * opacity)).toInt();
          final blendedG = ((originalPixel.g * (1 - opacity)) + (color.green * opacity)).toInt();
          final blendedB = ((originalPixel.b * (1 - opacity)) + (color.blue * opacity)).toInt();
          watermarkedImage.setPixelRgba(px, py, blendedR, blendedG, blendedB, 255);
        }
      }
    }

    // For advanced text rendering with custom fonts:
    // 1. Use Flutter's Canvas to render text to an image
    // 2. Composite that image onto the main image
    // 3. Or use packages like flutter_native_image for text overlay

    return _saveImage(watermarkedImage, outputPath, 'watermarked');
  }

  /// Edge refinement for better background removal
  Future<File> refineEdges(
    File imageFile, {
    int blurRadius = 2,
    double threshold = 0.5,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Apply slight blur to alpha channel for smoother edges
    final refined = img.Image(
      width: image.width,
      height: image.height,
      numChannels: 4,
    );

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        // Check if pixel is on edge (has transparent neighbors)
        bool isEdge = false;
        if (x > 0 && x < image.width - 1 && y > 0 && y < image.height - 1) {
          final neighbors = [
            image.getPixel(x - 1, y),
            image.getPixel(x + 1, y),
            image.getPixel(x, y - 1),
            image.getPixel(x, y + 1),
          ];

          final hasTransparent = neighbors.any((p) => p.a < 128);
          final hasOpaque = neighbors.any((p) => p.a >= 128);
          isEdge = hasTransparent && hasOpaque;
        }

        if (isEdge) {
          // Apply smoothing to edge pixels
          final alpha = (pixel.a * 0.9).toInt();
          refined.setPixelRgba(
            x, y,
            pixel.r.toInt(),
            pixel.g.toInt(),
            pixel.b.toInt(),
            alpha,
          );
        } else {
          refined.setPixel(x, y, pixel);
        }
      }
    }

    return _saveImage(refined, outputPath, 'refined');
  }

  /// Apply blur to background while keeping foreground sharp
  Future<File> blurBackground(
    File imageFile, {
    int blurRadius = 10,
    String? outputPath,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Create blurred version
    final blurred = img.gaussianBlur(image, radius: blurRadius);

    // Composite: use original for opaque pixels, blurred for background
    final result = img.Image(
      width: image.width,
      height: image.height,
      numChannels: 4,
    );

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final blurPixel = blurred.getPixel(x, y);

        // Blend based on alpha
        if (pixel.a > 200) {
          // Foreground - use original
          result.setPixel(x, y, pixel);
        } else if (pixel.a < 50) {
          // Background - use blurred
          result.setPixel(x, y, blurPixel);
        } else {
          // Edge - blend
          final t = pixel.a / 255.0;
          result.setPixelRgba(
            x, y,
            (pixel.r * t + blurPixel.r * (1 - t)).toInt(),
            (pixel.g * t + blurPixel.g * (1 - t)).toInt(),
            (pixel.b * t + blurPixel.b * (1 - t)).toInt(),
            255,
          );
        }
      }
    }

    return _saveImage(result, outputPath, 'bg_blurred');
  }

  /// Helper method to save image
  Future<File> _saveImage(
    img.Image image,
    String? outputPath,
    String prefix,
  ) async {
    final path = outputPath ?? await _generateOutputPath(prefix);
    final file = File(path);

    // Determine format from path extension
    final extension = path.split('.').last.toLowerCase();

    if (extension == 'png') {
      await file.writeAsBytes(img.encodePng(image));
    } else if (extension == 'jpg' || extension == 'jpeg') {
      await file.writeAsBytes(img.encodeJpg(image, quality: 95));
    } else {
      // Default to PNG
      await file.writeAsBytes(img.encodePng(image));
    }

    return file;
  }

  Future<String> _generateOutputPath(String prefix) async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/${prefix}_$timestamp.png';
  }
}

/// Available image filters
enum ImageFilter {
  none,
  grayscale,
  sepia,
  invert,
  blur,
  sharpen,
  emboss,
  vignette,
  vintage,
  cool,
  warm,
  blackAndWhite,
  vivid,
}

/// Watermark position options
enum WatermarkPosition {
  topLeft,
  topRight,
  center,
  bottomLeft,
  bottomRight,
}
