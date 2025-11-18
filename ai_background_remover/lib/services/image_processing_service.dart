import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../models/processing_options.dart';

class ImageProcessingService {
  Future<File> removeBackground(File imageFile, ProcessingOptions options) async {
    try {
      // Read the image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Process the image based on mode
      img.Image processedImage;

      switch (options.mode) {
        case 'Remove Background':
          processedImage = await _removeBackground(image);
          break;
        case 'Remove Object':
          processedImage = await _removeObject(image);
          break;
        case 'Auto Enhance':
          processedImage = _autoEnhance(image);
          break;
        case 'Smart Erase':
          processedImage = await _smartErase(image);
          break;
        default:
          processedImage = image;
      }

      // Apply background if specified
      if (options.backgroundColor != null) {
        processedImage = _applyBackgroundColor(processedImage, options.backgroundColor!);
      } else if (options.backgroundImagePath != null) {
        processedImage = await _applyBackgroundImage(
          processedImage,
          options.backgroundImagePath!,
        );
      }

      // Save the processed image
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final outputPath = '${directory.path}/processed_$timestamp.png';

      final outputFile = File(outputPath);

      if (options.outputFormat == 'PNG') {
        await outputFile.writeAsBytes(img.encodePng(processedImage));
      } else {
        await outputFile.writeAsBytes(
          img.encodeJpg(processedImage, quality: options.quality),
        );
      }

      return outputFile;
    } catch (e) {
      throw Exception('Failed to process image: $e');
    }
  }

  Future<img.Image> _removeBackground(img.Image image) async {
    // Create a new image with transparency
    final result = img.Image(width: image.width, height: image.height);

    // Simple background removal algorithm
    // This is a basic implementation - in production, you'd use ML models
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Simple green screen effect
        // In production, use proper background removal AI
        if (_isBackgroundPixel(r, g, b)) {
          result.setPixelRgba(x, y, 0, 0, 0, 0); // Transparent
        } else {
          result.setPixel(x, y, pixel);
        }
      }
    }

    return result;
  }

  bool _isBackgroundPixel(int r, int g, int b) {
    // Simple algorithm to detect background
    // Check if pixel is close to white or has uniform color
    final brightness = (r + g + b) / 3;
    final variance = ((r - brightness).abs() +
                     (g - brightness).abs() +
                     (b - brightness).abs()) / 3;

    // If brightness is high and variance is low, likely background
    return brightness > 200 && variance < 30;
  }

  Future<img.Image> _removeObject(img.Image image) async {
    // Similar to background removal but more selective
    return _removeBackground(image);
  }

  img.Image _autoEnhance(img.Image image) {
    // Apply auto-enhance filters
    var enhanced = img.adjustColor(
      image,
      contrast: 1.2,
      saturation: 1.1,
      brightness: 1.05,
    );

    // Apply sharpening
    enhanced = img.convolution(
      enhanced,
      filter: [
        0, -1, 0,
        -1, 5, -1,
        0, -1, 0,
      ],
    );

    return enhanced;
  }

  Future<img.Image> _smartErase(img.Image image) async {
    // Smart erase implementation
    return _removeBackground(image);
  }

  img.Image _applyBackgroundColor(img.Image foreground, Color color) {
    final result = img.Image(width: foreground.width, height: foreground.height);

    // Fill with background color
    img.fill(
      result,
      color: img.ColorRgba8(color.red, color.green, color.blue, 255),
    );

    // Composite foreground over background
    img.compositeImage(result, foreground);

    return result;
  }

  Future<img.Image> _applyBackgroundImage(
    img.Image foreground,
    String backgroundPath,
  ) async {
    final bgFile = File(backgroundPath);
    final bgBytes = await bgFile.readAsBytes();
    var background = img.decodeImage(bgBytes);

    if (background == null) {
      throw Exception('Failed to decode background image');
    }

    // Resize background to match foreground
    background = img.copyResize(
      background,
      width: foreground.width,
      height: foreground.height,
    );

    // Composite foreground over background
    img.compositeImage(background, foreground);

    return background;
  }

  Future<File> applyFilter(File imageFile, String filterName) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    img.Image filtered;

    switch (filterName) {
      case 'Grayscale':
        filtered = img.grayscale(image);
        break;
      case 'Sepia':
        filtered = img.sepia(image);
        break;
      case 'Invert':
        filtered = img.invert(image);
        break;
      case 'Blur':
        filtered = img.gaussianBlur(image, radius: 5);
        break;
      default:
        filtered = image;
    }

    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final outputPath = '${directory.path}/filtered_$timestamp.png';
    final outputFile = File(outputPath);

    await outputFile.writeAsBytes(img.encodePng(filtered));

    return outputFile;
  }
}
