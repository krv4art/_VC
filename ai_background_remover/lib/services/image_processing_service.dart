import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../models/processing_options.dart';
import 'ai_background_removal_service.dart';

class ImageProcessingService {
  final AIBackgroundRemovalService _aiService = AIBackgroundRemovalService();

  Future<File> removeBackground(File imageFile, ProcessingOptions options) async {
    try {
      // Process the image based on mode
      img.Image? processedImage;
      Uint8List? processedBytes;

      switch (options.mode) {
        case 'Remove Background':
          // Use AI service for background removal
          processedBytes = await _aiService.removeBackground(
            imageFile: imageFile,
            isPremium: options.isPremium ?? false,
          );
          processedImage = img.decodePng(processedBytes);
          break;
        case 'Remove Object':
          processedImage = await _removeObject(imageFile);
          break;
        case 'Auto Enhance':
          final bytes = await imageFile.readAsBytes();
          final image = img.decodeImage(bytes);
          if (image != null) {
            processedImage = _autoEnhance(image);
          }
          break;
        case 'Smart Erase':
          processedImage = await _smartErase(imageFile);
          break;
        default:
          final bytes = await imageFile.readAsBytes();
          processedImage = img.decodeImage(bytes);
      }

      if (processedImage == null) {
        throw Exception('Failed to process image');
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

  Future<img.Image> _removeObject(File imageFile) async {
    // Use AI service for object removal (similar to background removal)
    final bytes = await _aiService.removeBackground(
      imageFile: imageFile,
      isPremium: false,
    );
    final result = img.decodePng(bytes);
    if (result == null) {
      throw Exception('Failed to remove object');
    }
    return result;
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

  Future<img.Image> _smartErase(File imageFile) async {
    // Smart erase implementation using AI
    final bytes = await _aiService.removeBackground(
      imageFile: imageFile,
      isPremium: false,
    );
    final result = img.decodePng(bytes);
    if (result == null) {
      throw Exception('Failed to smart erase');
    }
    return result;
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

  /// Save image to device gallery
  Future<bool> saveToGallery(File imageFile, {String? name}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final fileName = name ?? 'background_removed_${DateTime.now().millisecondsSinceEpoch}';

      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: fileName,
      );

      return result['isSuccess'] ?? false;
    } catch (e) {
      throw Exception('Failed to save to gallery: $e');
    }
  }

  /// Share processed image
  Future<void> shareImage(File imageFile) async {
    try {
      // This method can be enhanced with share_plus package
      await saveToGallery(imageFile);
    } catch (e) {
      throw Exception('Failed to share image: $e');
    }
  }
}
