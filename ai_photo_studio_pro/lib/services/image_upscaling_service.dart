import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Service for AI-powered image upscaling to 4K resolution
class ImageUpscalingService {
  final SupabaseClient supabaseClient;

  ImageUpscalingService({required this.supabaseClient});

  /// Upscale image to higher resolution
  /// Supports 2x, 4x upscaling
  Future<String> upscaleImage({
    required String imagePath,
    int scaleFactor = 4, // 2x or 4x
    UpscaleQuality quality = UpscaleQuality.high,
  }) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Supabase Edge Function for upscaling
      final response = await supabaseClient.functions.invoke(
        'image-upscaling',
        body: {
          'action': 'upscale',
          'image': base64Image,
          'scale_factor': scaleFactor,
          'quality': quality.toString().split('.').last,
        },
      );

      if (response.status != 200) {
        throw Exception('Image upscaling failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollUpscalingJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from upscaling service');
    } catch (e) {
      debugPrint('Error upscaling image: $e');
      rethrow;
    }
  }

  /// Upscale to 4K resolution (3840x2160)
  Future<String> upscaleTo4K(String imagePath) async {
    return await upscaleImage(
      imagePath: imagePath,
      scaleFactor: 4,
      quality: UpscaleQuality.ultra,
    );
  }

  /// Upscale to 2K resolution (2048x1080)
  Future<String> upscaleTo2K(String imagePath) async {
    return await upscaleImage(
      imagePath: imagePath,
      scaleFactor: 2,
      quality: UpscaleQuality.high,
    );
  }

  /// Enhance image quality without changing resolution
  Future<String> enhanceQuality(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await supabaseClient.functions.invoke(
        'image-upscaling',
        body: {
          'action': 'enhance',
          'image': base64Image,
        },
      );

      if (response.status != 200) {
        throw Exception('Image enhancement failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollUpscalingJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from enhancement service');
    } catch (e) {
      debugPrint('Error enhancing image: $e');
      rethrow;
    }
  }

  /// Batch upscale multiple images
  Future<List<String>> batchUpscale({
    required List<String> imagePaths,
    int scaleFactor = 4,
    UpscaleQuality quality = UpscaleQuality.high,
  }) async {
    final results = <String>[];

    // Process in parallel (max 3 at a time due to computational intensity)
    const batchSize = 3;
    for (int i = 0; i < imagePaths.length; i += batchSize) {
      final batch = imagePaths.skip(i).take(batchSize).toList();
      final futures = batch.map((path) => upscaleImage(
        imagePath: path,
        scaleFactor: scaleFactor,
        quality: quality,
      ));

      final batchResults = await Future.wait(futures);
      results.addAll(batchResults);
    }

    return results;
  }

  /// Poll for upscaling job completion
  Future<String> _pollUpscalingJob(String jobId) async {
    const maxAttempts = 120; // 10 minutes max (upscaling takes longer)
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await supabaseClient.functions.invoke(
        'image-upscaling',
        body: {
          'action': 'check_status',
          'job_id': jobId,
        },
      );

      if (response.status != 200) {
        throw Exception('Failed to check job status');
      }

      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String;

      if (status == 'completed') {
        return data['url'] as String;
      } else if (status == 'failed') {
        throw Exception('Upscaling job failed: ${data['error']}');
      }
    }

    throw Exception('Upscaling job timed out');
  }

  /// Get supported resolutions for image
  static List<Resolution> getSupportedResolutions(int currentWidth, int currentHeight) {
    final resolutions = <Resolution>[];

    // 2x upscale
    resolutions.add(Resolution(
      width: currentWidth * 2,
      height: currentHeight * 2,
      name: '2K',
      scaleFactor: 2,
    ));

    // 4x upscale
    resolutions.add(Resolution(
      width: currentWidth * 4,
      height: currentHeight * 4,
      name: '4K',
      scaleFactor: 4,
    ));

    // Standard 4K
    resolutions.add(Resolution(
      width: 3840,
      height: 2160,
      name: '4K Ultra HD',
      scaleFactor: 4,
    ));

    return resolutions;
  }
}

enum UpscaleQuality {
  standard,
  high,
  ultra,
}

class Resolution {
  final int width;
  final int height;
  final String name;
  final int scaleFactor;

  Resolution({
    required this.width,
    required this.height,
    required this.name,
    required this.scaleFactor,
  });

  @override
  String toString() => '$name (${width}x$height)';
}
