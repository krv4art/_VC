import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../models/background_preset.dart';

/// Service for applying backgrounds to images
class BackgroundService {
  /// Apply a background preset to an image
  Future<File> applyBackground(
    File foregroundFile,
    BackgroundPreset preset, {
    String? outputPath,
  }) async {
    final foregroundBytes = await foregroundFile.readAsBytes();
    final foreground = img.decodeImage(foregroundBytes);

    if (foreground == null) {
      throw Exception('Failed to decode foreground image');
    }

    img.Image result;

    switch (preset.type) {
      case BackgroundType.transparent:
        // Keep original transparency
        result = foreground;
        break;

      case BackgroundType.solid:
        if (preset.color == null) {
          throw Exception('Solid background requires a color');
        }
        result = _applySolidColor(foreground, preset.color!);
        break;

      case BackgroundType.gradient:
        if (preset.gradientColors == null || preset.gradientColors!.isEmpty) {
          throw Exception('Gradient background requires colors');
        }
        result = await _applyGradient(
          foreground,
          preset.gradientColors!,
          preset.gradientType ?? GradientType.linear,
        );
        break;

      case BackgroundType.image:
        if (preset.imageAssetPath != null) {
          result = await _applyAssetImage(foreground, preset.imageAssetPath!);
        } else if (preset.imageUrl != null) {
          result = await _applyNetworkImage(foreground, preset.imageUrl!);
        } else {
          throw Exception('Image background requires an image path or URL');
        }
        break;

      case BackgroundType.blur:
        result = _applyBlurredBackground(foreground);
        break;
    }

    return _saveImage(result, outputPath);
  }

  /// Apply solid color background
  img.Image _applySolidColor(img.Image foreground, Color color) {
    final background = img.Image(
      width: foreground.width,
      height: foreground.height,
      numChannels: 4,
    );

    // Fill with solid color
    img.fill(
      background,
      color: img.ColorRgba8(color.red, color.green, color.blue, 255),
    );

    // Composite foreground over background
    img.compositeImage(background, foreground);

    return background;
  }

  /// Apply gradient background
  Future<img.Image> _applyGradient(
    img.Image foreground,
    List<Color> colors,
    GradientType type,
  ) async {
    final width = foreground.width;
    final height = foreground.height;

    // Create gradient image
    final background = img.Image(
      width: width,
      height: height,
      numChannels: 4,
    );

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        Color pixelColor;

        switch (type) {
          case GradientType.linear:
            // Vertical gradient
            final t = y / height;
            pixelColor = _interpolateColors(colors, t);
            break;

          case GradientType.radial:
            // Radial gradient from center
            final dx = (x - width / 2) / (width / 2);
            final dy = (y - height / 2) / (height / 2);
            final distance = (dx * dx + dy * dy).clamp(0.0, 1.0);
            pixelColor = _interpolateColors(colors, distance);
            break;

          case GradientType.sweep:
            // Sweep gradient
            final dx = x - width / 2;
            final dy = y - height / 2;
            final angle = (atan2(dy, dx) + 3.14159) / (2 * 3.14159);
            pixelColor = _interpolateColors(colors, angle);
            break;
        }

        background.setPixelRgba(
          x, y,
          pixelColor.red,
          pixelColor.green,
          pixelColor.blue,
          255,
        );
      }
    }

    // Composite foreground over gradient
    img.compositeImage(background, foreground);

    return background;
  }

  /// Interpolate between multiple colors
  Color _interpolateColors(List<Color> colors, double t) {
    if (colors.length == 1) return colors[0];

    final segmentCount = colors.length - 1;
    final segment = (t * segmentCount).clamp(0, segmentCount - 0.001);
    final segmentIndex = segment.floor();
    final segmentT = segment - segmentIndex;

    final color1 = colors[segmentIndex];
    final color2 = colors[segmentIndex + 1];

    return Color.fromARGB(
      255,
      (color1.red + (color2.red - color1.red) * segmentT).round(),
      (color1.green + (color2.green - color1.green) * segmentT).round(),
      (color1.blue + (color2.blue - color1.blue) * segmentT).round(),
    );
  }

  /// Apply asset image as background
  Future<img.Image> _applyAssetImage(
    img.Image foreground,
    String assetPath,
  ) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();
    var background = img.decodeImage(bytes);

    if (background == null) {
      throw Exception('Failed to decode asset image');
    }

    // Resize background to match foreground
    background = img.copyResize(
      background,
      width: foreground.width,
      height: foreground.height,
      interpolation: img.Interpolation.cubic,
    );

    // Composite foreground over background
    img.compositeImage(background, foreground);

    return background;
  }

  /// Apply network image as background
  Future<img.Image> _applyNetworkImage(
    img.Image foreground,
    String imageUrl,
  ) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to download background image');
    }

    var background = img.decodeImage(response.bodyBytes);

    if (background == null) {
      throw Exception('Failed to decode network image');
    }

    // Resize background to match foreground
    background = img.copyResize(
      background,
      width: foreground.width,
      height: foreground.height,
      interpolation: img.Interpolation.cubic,
    );

    // Composite foreground over background
    img.compositeImage(background, foreground);

    return background;
  }

  /// Apply blurred version of original as background
  img.Image _applyBlurredBackground(img.Image foreground) {
    // Create a blurred version of the foreground
    final blurred = img.gaussianBlur(foreground, radius: 20);

    // Composite sharp foreground over blurred background
    img.compositeImage(blurred, foreground);

    return blurred;
  }

  /// Create custom gradient background
  Future<File> createCustomGradient({
    required int width,
    required int height,
    required List<Color> colors,
    required GradientType type,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
    String? outputPath,
  }) async {
    final background = img.Image(
      width: width,
      height: height,
      numChannels: 4,
    );

    // Generate gradient based on type
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        Color pixelColor;

        switch (type) {
          case GradientType.linear:
            // Custom linear gradient based on begin/end alignment
            final t = _calculateLinearGradientT(
              x, y, width, height, begin, end,
            );
            pixelColor = _interpolateColors(colors, t);
            break;

          case GradientType.radial:
            final dx = (x - width / 2) / (width / 2);
            final dy = (y - height / 2) / (height / 2);
            final distance = (dx * dx + dy * dy).clamp(0.0, 1.0);
            pixelColor = _interpolateColors(colors, distance);
            break;

          case GradientType.sweep:
            final dx = x - width / 2;
            final dy = y - height / 2;
            final angle = (atan2(dy, dx) + 3.14159) / (2 * 3.14159);
            pixelColor = _interpolateColors(colors, angle);
            break;
        }

        background.setPixelRgba(
          x, y,
          pixelColor.red,
          pixelColor.green,
          pixelColor.blue,
          255,
        );
      }
    }

    return _saveImage(background, outputPath);
  }

  double _calculateLinearGradientT(
    int x, int y, int width, int height,
    Alignment begin, Alignment end,
  ) {
    // Convert alignment to coordinates
    final beginX = (begin.x + 1) / 2 * width;
    final beginY = (begin.y + 1) / 2 * height;
    final endX = (end.x + 1) / 2 * width;
    final endY = (end.y + 1) / 2 * height;

    // Calculate progress along the gradient line
    final dx = endX - beginX;
    final dy = endY - beginY;
    final length = (dx * dx + dy * dy);

    if (length == 0) return 0;

    final dotProduct = (x - beginX) * dx + (y - beginY) * dy;
    return (dotProduct / length).clamp(0.0, 1.0);
  }

  /// Save image to file
  Future<File> _saveImage(img.Image image, String? outputPath) async {
    final path = outputPath ?? await _generateOutputPath();
    final file = File(path);

    await file.writeAsBytes(img.encodePng(image));

    return file;
  }

  Future<String> _generateOutputPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${directory.path}/background_applied_$timestamp.png';
  }

  double atan2(double y, double x) {
    // Simple atan2 implementation
    if (x > 0) {
      return _atan(y / x);
    } else if (x < 0) {
      if (y >= 0) {
        return _atan(y / x) + 3.14159;
      } else {
        return _atan(y / x) - 3.14159;
      }
    } else {
      if (y > 0) {
        return 3.14159 / 2;
      } else if (y < 0) {
        return -3.14159 / 2;
      } else {
        return 0;
      }
    }
  }

  double _atan(double x) {
    // Taylor series approximation for atan
    double result = 0;
    double term = x;
    int i = 0;

    while (term.abs() > 0.0001 && i < 20) {
      result += term;
      i++;
      term *= -x * x * (2 * i - 1) / (2 * i + 1);
    }

    return result;
  }
}
