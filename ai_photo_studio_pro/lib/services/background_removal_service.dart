import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for AI-powered background removal and photo enhancement
class BackgroundRemovalService {
  // Using Remove.bg API or similar service
  // You'll need to add API key to .env file
  static const String _removeBgApiUrl = 'https://api.remove.bg/v1.0/removebg';

  // Alternative: Use Replicate for background removal
  static const String _replicateApiUrl = 'https://api.replicate.com/v1/predictions';

  final String? _removeBgApiKey;
  final String? _replicateApiKey;

  BackgroundRemovalService({
    String? removeBgApiKey,
    String? replicateApiKey,
  })  : _removeBgApiKey = removeBgApiKey,
        _replicateApiKey = replicateApiKey;

  /// Remove background from image using Remove.bg
  Future<String?> removeBackgroundRemoveBg({
    required String imagePath,
    BackgroundRemovalSize size = BackgroundRemovalSize.auto,
    String? backgroundColor,
  }) async {
    if (_removeBgApiKey == null) {
      debugPrint('Remove.bg API key not configured');
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        debugPrint('Image file does not exist: $imagePath');
        return null;
      }

      // Prepare request
      final request = http.MultipartRequest('POST', Uri.parse(_removeBgApiUrl));
      request.headers['X-Api-Key'] = _removeBgApiKey!;

      // Add image file
      request.files.add(await http.MultipartFile.fromPath('image_file', imagePath));

      // Add parameters
      request.fields['size'] = size.name;
      if (backgroundColor != null) {
        request.fields['bg_color'] = backgroundColor;
      }

      // Send request
      final response = await request.send();

      if (response.statusCode == 200) {
        // Save result
        final bytes = await response.stream.toBytes();
        final outputPath = await _saveProcessedImage(bytes, 'bg_removed');
        debugPrint('Background removed successfully: $outputPath');
        return outputPath;
      } else {
        final errorBody = await response.stream.bytesToString();
        debugPrint('Background removal failed: ${response.statusCode} - $errorBody');
        return null;
      }
    } catch (e) {
      debugPrint('Error removing background: $e');
      return null;
    }
  }

  /// Remove background using Replicate (FLUX or other models)
  Future<String?> removeBackgroundReplicate({
    required String imagePath,
  }) async {
    if (_replicateApiKey == null) {
      debugPrint('Replicate API key not configured');
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        debugPrint('Image file does not exist: $imagePath');
        return null;
      }

      // Convert image to base64
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Create prediction
      final response = await http.post(
        Uri.parse(_replicateApiUrl),
        headers: {
          'Authorization': 'Token $_replicateApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': 'background-removal-model-version', // Replace with actual version
          'input': {
            'image': 'data:image/jpeg;base64,$base64Image',
          },
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final predictionId = data['id'];

        // Poll for result
        final resultUrl = await _pollReplicatePrediction(predictionId);
        if (resultUrl != null) {
          return await _downloadAndSaveImage(resultUrl, 'bg_removed');
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error removing background with Replicate: $e');
      return null;
    }
  }

  /// Upscale image using AI
  Future<String?> upscaleImage({
    required String imagePath,
    int scale = 2,
  }) async {
    if (_replicateApiKey == null) {
      debugPrint('Replicate API key not configured');
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_replicateApiUrl),
        headers: {
          'Authorization': 'Token $_replicateApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': 'upscaling-model-version', // e.g., Real-ESRGAN
          'input': {
            'image': 'data:image/jpeg;base64,$base64Image',
            'scale': scale,
          },
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final predictionId = data['id'];

        final resultUrl = await _pollReplicatePrediction(predictionId);
        if (resultUrl != null) {
          return await _downloadAndSaveImage(resultUrl, 'upscaled');
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error upscaling image: $e');
      return null;
    }
  }

  /// Restore old/damaged photo
  Future<String?> restorePhoto({
    required String imagePath,
  }) async {
    if (_replicateApiKey == null) {
      debugPrint('Replicate API key not configured');
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) return null;

      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_replicateApiUrl),
        headers: {
          'Authorization': 'Token $_replicateApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': 'restoration-model-version', // e.g., GFPGAN
          'input': {
            'image': 'data:image/jpeg;base64,$base64Image',
          },
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final predictionId = data['id'];

        final resultUrl = await _pollReplicatePrediction(predictionId);
        if (resultUrl != null) {
          return await _downloadAndSaveImage(resultUrl, 'restored');
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error restoring photo: $e');
      return null;
    }
  }

  /// Poll Replicate prediction until complete
  Future<String?> _pollReplicatePrediction(String predictionId) async {
    const maxAttempts = 60; // 1 minute max
    const pollInterval = Duration(seconds: 1);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await http.get(
        Uri.parse('$_replicateApiUrl/$predictionId'),
        headers: {
          'Authorization': 'Token $_replicateApiKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'];

        if (status == 'succeeded') {
          final output = data['output'];
          if (output is String) {
            return output;
          } else if (output is List && output.isNotEmpty) {
            return output[0];
          }
        } else if (status == 'failed' || status == 'canceled') {
          debugPrint('Prediction failed: ${data['error']}');
          return null;
        }
      }
    }

    debugPrint('Prediction polling timeout');
    return null;
  }

  /// Download image from URL and save
  Future<String?> _downloadAndSaveImage(String url, String prefix) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return await _saveProcessedImage(response.bodyBytes, prefix);
      }
      return null;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  /// Save processed image to temporary directory
  Future<String> _saveProcessedImage(List<int> bytes, String prefix) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = '${prefix}_$timestamp.png';
    final filePath = path.join(tempDir.path, fileName);

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  /// Estimate cost for background removal
  double estimateBackgroundRemovalCost(BackgroundRemovalSize size) {
    // Remove.bg pricing (example)
    switch (size) {
      case BackgroundRemovalSize.preview:
        return 0.0; // Free preview
      case BackgroundRemovalSize.small:
      case BackgroundRemovalSize.regular:
        return 0.09; // $0.09 per image
      case BackgroundRemovalSize.medium:
      case BackgroundRemovalSize.hd:
        return 0.18; // $0.18 per image
      case BackgroundRemovalSize.full:
      case BackgroundRemovalSize.auto:
        return 0.25; // $0.25 per image
    }
  }
}

/// Background removal size options
enum BackgroundRemovalSize {
  preview, // Low resolution preview
  small, // Up to 0.25 megapixels
  regular, // Up to 4 megapixels
  medium, // Up to 10 megapixels
  hd, // Up to 25 megapixels
  full, // Original size
  auto, // Automatic selection
}
