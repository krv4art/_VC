import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/background_settings.dart';

/// Service for AI-powered background removal and replacement
class BackgroundRemovalService {
  final SupabaseClient supabaseClient;

  // Background images repository
  static const Map<BackgroundStyle, String> _backgroundUrls = {
    BackgroundStyle.office: 'backgrounds/office_modern.jpg',
    BackgroundStyle.studio: 'backgrounds/studio_white.jpg',
    BackgroundStyle.outdoor: 'backgrounds/outdoor_park.jpg',
    BackgroundStyle.urban: 'backgrounds/urban_building.jpg',
    BackgroundStyle.library: 'backgrounds/library_bookshelf.jpg',
    BackgroundStyle.conference: 'backgrounds/conference_room.jpg',
    BackgroundStyle.modern: 'backgrounds/modern_interior.jpg',
    BackgroundStyle.classic: 'backgrounds/classic_wood.jpg',
  };

  BackgroundRemovalService({required this.supabaseClient});

  /// Remove background from image (transparent PNG)
  Future<String> removeBackground(String imagePath) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Supabase Edge Function for background removal
      final response = await supabaseClient.functions.invoke(
        'background-removal',
        body: {
          'action': 'remove',
          'image': base64Image,
        },
      );

      if (response.status != 200) {
        throw Exception('Background removal failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollBackgroundJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from background removal service');
    } catch (e) {
      debugPrint('Error removing background: $e');
      rethrow;
    }
  }

  /// Replace background with a new one
  Future<String> replaceBackground({
    required String imagePath,
    required BackgroundSettings settings,
  }) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare background data based on settings
      String? backgroundData;
      if (settings.type == BackgroundType.preset && settings.style != null) {
        backgroundData = _backgroundUrls[settings.style];
      } else if (settings.type == BackgroundType.custom && settings.customBackgroundUrl != null) {
        backgroundData = settings.customBackgroundUrl;
      }

      final response = await supabaseClient.functions.invoke(
        'background-removal',
        body: {
          'action': 'replace',
          'image': base64Image,
          'background_type': settings.type.toString().split('.').last,
          'background_data': backgroundData,
          'background_color': settings.backgroundColor?.toString().split('.').last,
          'blur_amount': settings.blurAmount,
        },
      );

      if (response.status != 200) {
        throw Exception('Background replacement failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollBackgroundJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from background replacement service');
    } catch (e) {
      debugPrint('Error replacing background: $e');
      rethrow;
    }
  }

  /// Blur background (bokeh effect)
  Future<String> blurBackground(String imagePath, {double intensity = 0.7}) async {
    return await replaceBackground(
      imagePath: imagePath,
      settings: BackgroundSettings(
        type: BackgroundType.blurred,
        blurAmount: intensity,
      ),
    );
  }

  /// Apply solid color background
  Future<String> applySolidBackground(
    String imagePath,
    BackgroundColor color,
  ) async {
    return await replaceBackground(
      imagePath: imagePath,
      settings: BackgroundSettings(
        type: BackgroundType.solidColor,
        backgroundColor: color,
      ),
    );
  }

  /// Apply preset professional background
  Future<String> applyPresetBackground(
    String imagePath,
    BackgroundStyle style,
  ) async {
    return await replaceBackground(
      imagePath: imagePath,
      settings: BackgroundSettings(
        type: BackgroundType.preset,
        style: style,
      ),
    );
  }

  /// Batch remove backgrounds from multiple images
  Future<List<String>> batchRemoveBackground(List<String> imagePaths) async {
    final results = <String>[];

    // Process in parallel (max 10 at a time)
    const batchSize = 10;
    for (int i = 0; i < imagePaths.length; i += batchSize) {
      final batch = imagePaths.skip(i).take(batchSize).toList();
      final futures = batch.map((path) => removeBackground(path));

      final batchResults = await Future.wait(futures);
      results.addAll(batchResults);
    }

    return results;
  }

  /// Poll for background job completion
  Future<String> _pollBackgroundJob(String jobId) async {
    const maxAttempts = 60; // 5 minutes max
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await supabaseClient.functions.invoke(
        'background-removal',
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
        throw Exception('Background job failed: ${data['error']}');
      }
    }

    throw Exception('Background job timed out');
  }

  /// Get list of available preset backgrounds
  static Map<BackgroundStyle, String> getAvailableBackgrounds() {
    return _backgroundUrls;
  }
}
