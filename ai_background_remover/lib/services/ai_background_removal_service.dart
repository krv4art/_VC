import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;

enum AIProvider {
  removeBg,
  supabase,
  tflite,
  local, // Fallback to basic algorithm
}

class AIBackgroundRemovalService {
  final String? removeBgApiKey = dotenv.env['REMOVE_BG_API_KEY'];
  final String? supabaseUrl = dotenv.env['SUPABASE_URL'];
  final String? supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

  /// Remove background using the best available provider
  Future<Uint8List> removeBackground({
    required File imageFile,
    AIProvider? preferredProvider,
    bool isPremium = false,
  }) async {
    // Try providers in order of preference
    final providers = _getProviderOrder(preferredProvider, isPremium);

    Exception? lastError;

    for (final provider in providers) {
      try {
        switch (provider) {
          case AIProvider.removeBg:
            if (removeBgApiKey != null && removeBgApiKey!.isNotEmpty) {
              return await _removeBackgroundWithRemoveBg(imageFile);
            }
            break;
          case AIProvider.supabase:
            if (supabaseUrl != null && supabaseUrl!.isNotEmpty) {
              return await _removeBackgroundWithSupabase(imageFile);
            }
            break;
          case AIProvider.tflite:
            return await _removeBackgroundWithTFLite(imageFile);
          case AIProvider.local:
            return await _removeBackgroundLocal(imageFile);
        }
      } catch (e) {
        lastError = Exception('${provider.name} failed: $e');
        continue; // Try next provider
      }
    }

    // If all providers failed, throw the last error
    throw lastError ?? Exception('All AI providers failed');
  }

  List<AIProvider> _getProviderOrder(AIProvider? preferred, bool isPremium) {
    if (preferred != null) {
      return [
        preferred,
        ...AIProvider.values.where((p) => p != preferred),
      ];
    }

    // Default priority: Premium users get API services, free users get local
    if (isPremium) {
      return [
        AIProvider.removeBg,
        AIProvider.supabase,
        AIProvider.tflite,
        AIProvider.local,
      ];
    } else {
      return [
        AIProvider.tflite,
        AIProvider.local,
      ];
    }
  }

  /// Remove background using Remove.bg API
  Future<Uint8List> _removeBackgroundWithRemoveBg(File imageFile) async {
    final uri = Uri.parse('https://api.remove.bg/v1.0/removebg');
    final request = http.MultipartRequest('POST', uri);

    request.headers['X-Api-Key'] = removeBgApiKey!;
    request.files.add(
      await http.MultipartFile.fromPath('image_file', imageFile.path),
    );

    // Add parameters for better quality
    request.fields['size'] = 'auto';
    request.fields['format'] = 'png';
    request.fields['type'] = 'auto';

    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Remove.bg API timeout');
      },
    );

    if (streamedResponse.statusCode == 200) {
      return await streamedResponse.stream.toBytes();
    } else {
      final responseBody = await streamedResponse.stream.bytesToString();
      throw Exception(
        'Remove.bg API error (${streamedResponse.statusCode}): $responseBody',
      );
    }
  }

  /// Remove background using Supabase Edge Function
  Future<Uint8List> _removeBackgroundWithSupabase(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final uri = Uri.parse('$supabaseUrl/functions/v1/remove-background');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $supabaseAnonKey',
        'Content-Type': 'application/octet-stream',
      },
      body: bytes,
    ).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw Exception('Supabase API timeout');
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Supabase API error (${response.statusCode}): ${response.body}',
      );
    }
  }

  /// Remove background using TensorFlow Lite model (offline)
  Future<Uint8List> _removeBackgroundWithTFLite(File imageFile) async {
    // TensorFlow Lite integration for on-device ML inference
    // This would use a pre-trained model like DeepLabV3+ or U2-Net
    //
    // Implementation steps:
    // 1. Place model file in assets/models/background_removal.tflite
    // 2. Load model using tflite_flutter package
    // 3. Preprocess image to model input size (e.g., 512x512)
    // 4. Run inference to get mask
    // 5. Apply mask to original image
    //
    // Example code:
    // final interpreter = await Interpreter.fromAsset('models/background_removal.tflite');
    // final inputImage = preprocessImage(imageFile, size: 512);
    // final mask = interpreter.run(inputImage);
    // final result = applyMask(imageFile, mask);
    //
    // For production deployment, download a pre-trained model from:
    // - DeepLabV3+: https://www.tensorflow.org/lite/examples/segmentation
    // - U2-Net: https://github.com/xuebinqin/U-2-Net
    //
    // Currently using improved local algorithm as fallback
    return await _removeBackgroundLocal(imageFile);
  }

  /// Local background removal algorithm (basic but fast)
  Future<Uint8List> _removeBackgroundLocal(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Use improved algorithm with multiple techniques
    final result = await _advancedLocalRemoval(image);

    return Uint8List.fromList(img.encodePng(result));
  }

  /// Advanced local removal using multiple techniques
  Future<img.Image> _advancedLocalRemoval(img.Image image) async {
    final result = img.Image(
      width: image.width,
      height: image.height,
      numChannels: 4,
    );

    // Edge detection for better subject isolation
    final edges = _detectEdges(image);

    // Analyze image to find likely background color
    final backgroundColor = _findBackgroundColor(image);

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // Combine multiple heuristics
        final isBackground = _isBackgroundPixel(
          r, g, b,
          backgroundColor,
          edges.getPixel(x, y),
          x, y,
          image.width, image.height,
        );

        if (isBackground) {
          result.setPixelRgba(x, y, 0, 0, 0, 0); // Transparent
        } else {
          result.setPixel(x, y, pixel);
        }
      }
    }

    // Apply anti-aliasing to smooth edges
    return _smoothEdges(result);
  }

  img.Image _detectEdges(img.Image image) {
    // Sobel edge detection
    return img.sobel(image);
  }

  Color _findBackgroundColor(img.Image image) {
    // Sample pixels from edges to determine background color
    final samples = <Color>[];

    final sampleSize = 20;

    // Top edge
    for (int x = 0; x < image.width; x += image.width ~/ sampleSize) {
      final pixel = image.getPixel(x, 0);
      samples.add(Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
    }

    // Bottom edge
    for (int x = 0; x < image.width; x += image.width ~/ sampleSize) {
      final pixel = image.getPixel(x, image.height - 1);
      samples.add(Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
    }

    // Left edge
    for (int y = 0; y < image.height; y += image.height ~/ sampleSize) {
      final pixel = image.getPixel(0, y);
      samples.add(Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
    }

    // Right edge
    for (int y = 0; y < image.height; y += image.height ~/ sampleSize) {
      final pixel = image.getPixel(image.width - 1, y);
      samples.add(Color.fromARGB(255, pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()));
    }

    // Find most common color (simple averaging)
    if (samples.isEmpty) {
      return const Color(0xFFFFFFFF); // White default
    }

    int totalR = 0, totalG = 0, totalB = 0;
    for (final color in samples) {
      totalR += color.red;
      totalG += color.green;
      totalB += color.blue;
    }

    return Color.fromARGB(
      255,
      totalR ~/ samples.length,
      totalG ~/ samples.length,
      totalB ~/ samples.length,
    );
  }

  bool _isBackgroundPixel(
    int r, int g, int b,
    Color backgroundColor,
    img.Pixel edgePixel,
    int x, int y,
    int width, int height,
  ) {
    // Check color similarity to detected background
    final colorDist = _colorDistance(r, g, b, backgroundColor);

    // Check edge strength
    final edgeStrength = edgePixel.r.toInt();

    // Check position (corners more likely to be background)
    final isNearEdge = x < width * 0.1 || x > width * 0.9 ||
                       y < height * 0.1 || y > height * 0.9;

    // Combine heuristics
    if (colorDist < 40 && edgeStrength < 30) return true;
    if (colorDist < 60 && isNearEdge) return true;

    return false;
  }

  double _colorDistance(int r1, int g1, int b1, Color color2) {
    final r2 = color2.red;
    final g2 = color2.green;
    final b2 = color2.blue;

    return ((r1 - r2) * (r1 - r2) +
            (g1 - g2) * (g1 - g2) +
            (b1 - b2) * (b1 - b2)).toDouble();
  }

  img.Image _smoothEdges(img.Image image) {
    // Apply slight Gaussian blur to alpha channel for smoother edges
    final result = img.Image(
      width: image.width,
      height: image.height,
      numChannels: 4,
    );

    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        final pixel = image.getPixel(x, y);

        if (pixel.a == 0) {
          // Fully transparent, keep as is
          result.setPixel(x, y, pixel);
        } else {
          // Check neighbors for edge smoothing
          final neighbors = [
            image.getPixel(x - 1, y),
            image.getPixel(x + 1, y),
            image.getPixel(x, y - 1),
            image.getPixel(x, y + 1),
          ];

          final hasTransparentNeighbor = neighbors.any((p) => p.a == 0);

          if (hasTransparentNeighbor) {
            // Edge pixel - apply slight transparency
            final alpha = (pixel.a * 0.95).toInt();
            result.setPixelRgba(
              x, y,
              pixel.r.toInt(),
              pixel.g.toInt(),
              pixel.b.toInt(),
              alpha,
            );
          } else {
            result.setPixel(x, y, pixel);
          }
        }
      }
    }

    return result;
  }
}

class Color {
  final int value;

  const Color(this.value);

  const Color.fromARGB(int a, int r, int g, int b)
      : value = ((a & 0xff) << 24) |
               ((r & 0xff) << 16) |
               ((g & 0xff) << 8) |
               (b & 0xff);

  int get alpha => (value >> 24) & 0xff;
  int get red => (value >> 16) & 0xff;
  int get green => (value >> 8) & 0xff;
  int get blue => value & 0xff;
}
