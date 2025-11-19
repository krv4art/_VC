import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/retouch_settings.dart';

/// Service for AI-powered photo retouching
/// Uses multiple AI models for different retouch tasks
class AIRetouchService {
  final SupabaseClient supabaseClient;

  AIRetouchService({required this.supabaseClient});

  /// Apply AI retouch to an image
  /// Returns path to retouched image or URL
  Future<String> applyRetouch({
    required String imagePath,
    required RetouchSettings settings,
  }) async {
    try {
      // Read image file
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare request for Supabase Edge Function
      final Map<String, dynamic> requestBody = {
        'action': 'retouch',
        'image': base64Image,
        'settings': settings.toMap(),
      };

      // Call via Supabase Edge Function (ai-photo-enhance)
      final response = await supabaseClient.functions.invoke(
        'ai-photo-enhance',
        body: requestBody,
      );

      if (response.status != 200) {
        throw Exception('AI retouch failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      // Return URL or job ID for tracking
      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        // Poll for completion
        return await _pollRetouchJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from AI retouch service');
    } catch (e) {
      debugPrint('Error applying AI retouch: $e');
      rethrow;
    }
  }

  /// Remove blemishes using AI
  Future<String> removeBlemishes(String imagePath) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: const RetouchSettings(
        removeBlemishes: true,
        smoothSkin: false,
        enhanceLighting: false,
        colorCorrection: false,
        removeShine: false,
      ),
    );
  }

  /// Smooth skin while preserving texture
  Future<String> smoothSkin(String imagePath, {double intensity = 0.7}) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: RetouchSettings(
        removeBlemishes: false,
        smoothSkin: true,
        enhanceLighting: false,
        colorCorrection: false,
        removeShine: false,
        smoothnessLevel: intensity,
      ),
    );
  }

  /// Enhance lighting and shadows
  Future<String> enhanceLighting(String imagePath, {double intensity = 0.6}) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: RetouchSettings(
        removeBlemishes: false,
        smoothSkin: false,
        enhanceLighting: true,
        colorCorrection: false,
        removeShine: false,
        lightingIntensity: intensity,
      ),
    );
  }

  /// Apply complete professional retouch
  Future<String> professionalRetouch(String imagePath) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: RetouchSettings.professional(),
    );
  }

  /// Apply natural retouch (subtle)
  Future<String> naturalRetouch(String imagePath) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: RetouchSettings.natural(),
    );
  }

  /// Apply glamour retouch (intensive)
  Future<String> glamourRetouch(String imagePath) async {
    return await applyRetouch(
      imagePath: imagePath,
      settings: RetouchSettings.glamour(),
    );
  }

  /// Poll for retouch job completion
  Future<String> _pollRetouchJob(String jobId) async {
    const maxAttempts = 60; // 5 minutes max
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await supabaseClient.functions.invoke(
        'ai-photo-enhance',
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
        throw Exception('Retouch job failed: ${data['error']}');
      }

      // Continue polling if status is 'processing'
    }

    throw Exception('Retouch job timed out');
  }

  /// Batch retouch multiple images
  Future<List<String>> batchRetouch({
    required List<String> imagePaths,
    required RetouchSettings settings,
  }) async {
    final results = <String>[];

    // Process in parallel (max 5 at a time to avoid overwhelming the API)
    const batchSize = 5;
    for (int i = 0; i < imagePaths.length; i += batchSize) {
      final batch = imagePaths.skip(i).take(batchSize).toList();
      final futures = batch.map((path) => applyRetouch(
        imagePath: path,
        settings: settings,
      ));

      final batchResults = await Future.wait(futures);
      results.addAll(batchResults);
    }

    return results;
  }
}
