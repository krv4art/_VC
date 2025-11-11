import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/generation_job.dart';

/// Service for integrating with Replicate FLUX.1 API
/// Uses Supabase Edge Function as proxy for security
class ReplicateService {
  final bool useProxy;
  final SupabaseClient? supabaseClient;
  final String? directApiKey;

  ReplicateService({
    this.useProxy = true,
    this.supabaseClient,
    this.directApiKey,
  }) {
    if (useProxy && supabaseClient == null) {
      throw ArgumentError('supabaseClient is required when useProxy is true');
    }
    if (!useProxy && directApiKey == null) {
      throw ArgumentError('directApiKey is required when useProxy is false');
    }
  }

  /// Generate headshot using FLUX.1
  ///
  /// Parameters:
  /// - [imagePath]: Path to local image file
  /// - [stylePrompt]: Style prompt for generation
  /// - [quality]: Output quality (low, medium, high)
  ///
  /// Returns [GenerationJob] with job ID for tracking
  Future<GenerationJob> generateHeadshot({
    required String imagePath,
    required String stylePrompt,
    String quality = 'medium',
  }) async {
    try {
      // Read image file
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare request
      final Map<String, dynamic> requestBody = {
        'image': base64Image,
        'prompt': stylePrompt,
        'quality': quality,
        'model': 'black-forest-labs/flux-1-schnell', // FLUX.1 Schnell for fast generation
      };

      String predictionId;

      if (useProxy) {
        // Call via Supabase Edge Function
        predictionId = await _callViaProxy(requestBody);
      } else {
        // Call Replicate API directly
        predictionId = await _callDirectly(requestBody);
      }

      // Create and return generation job
      return GenerationJob(
        id: predictionId,
        photoId: 0, // Will be set by caller
        styleId: '', // Will be set by caller
        status: JobStatus.processing,
        createdAt: DateTime.now(),
        startedAt: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error generating headshot: $e');
      rethrow;
    }
  }

  /// Check status of generation job
  Future<GenerationJob> checkJobStatus(String jobId) async {
    try {
      if (useProxy) {
        return await _checkStatusViaProxy(jobId);
      } else {
        return await _checkStatusDirectly(jobId);
      }
    } catch (e) {
      debugPrint('Error checking job status: $e');
      rethrow;
    }
  }

  /// Call Replicate API via Supabase Edge Function (recommended)
  Future<String> _callViaProxy(Map<String, dynamic> requestBody) async {
    final response = await supabaseClient!.functions.invoke(
      'replicate-proxy',
      body: requestBody,
    );

    if (response.status != 200) {
      throw Exception('Supabase function error: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    return data['id'] as String;
  }

  /// Check job status via Supabase Edge Function
  Future<GenerationJob> _checkStatusViaProxy(String jobId) async {
    final response = await supabaseClient!.functions.invoke(
      'replicate-proxy',
      body: {'action': 'check_status', 'job_id': jobId},
    );

    if (response.status != 200) {
      throw Exception('Supabase function error: ${response.data}');
    }

    final data = response.data as Map<String, dynamic>;
    return _parseJobResponse(data);
  }

  /// Call Replicate API directly (not recommended - exposes API key)
  Future<String> _callDirectly(Map<String, dynamic> requestBody) async {
    final response = await http.post(
      Uri.parse('https://api.replicate.com/v1/predictions'),
      headers: {
        'Authorization': 'Token $directApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode != 201) {
      throw Exception('Replicate API error: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['id'] as String;
  }

  /// Check job status directly
  Future<GenerationJob> _checkStatusDirectly(String jobId) async {
    final response = await http.get(
      Uri.parse('https://api.replicate.com/v1/predictions/$jobId'),
      headers: {
        'Authorization': 'Token $directApiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Replicate API error: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return _parseJobResponse(data);
  }

  /// Parse Replicate API response to GenerationJob
  GenerationJob _parseJobResponse(Map<String, dynamic> data) {
    final status = _mapReplicateStatus(data['status'] as String);

    return GenerationJob(
      id: data['id'] as String,
      photoId: 0, // Will be set by caller
      styleId: '', // Will be set by caller
      status: status,
      createdAt: DateTime.parse(data['created_at'] as String),
      startedAt: data['started_at'] != null
          ? DateTime.parse(data['started_at'] as String)
          : null,
      completedAt: data['completed_at'] != null
          ? DateTime.parse(data['completed_at'] as String)
          : null,
      resultUrl: status == JobStatus.completed && data['output'] != null
          ? (data['output'] is List
              ? (data['output'] as List).first as String?
              : data['output'] as String?)
          : null,
      errorMessage: data['error'] as String?,
      metadata: data,
    );
  }

  /// Map Replicate status to JobStatus enum
  JobStatus _mapReplicateStatus(String status) {
    switch (status.toLowerCase()) {
      case 'starting':
      case 'processing':
        return JobStatus.processing;
      case 'succeeded':
        return JobStatus.completed;
      case 'failed':
        return JobStatus.failed;
      case 'canceled':
        return JobStatus.cancelled;
      default:
        return JobStatus.pending;
    }
  }

  /// Cancel a running job
  Future<void> cancelJob(String jobId) async {
    try {
      if (useProxy) {
        await supabaseClient!.functions.invoke(
          'replicate-proxy',
          body: {'action': 'cancel', 'job_id': jobId},
        );
      } else {
        await http.post(
          Uri.parse('https://api.replicate.com/v1/predictions/$jobId/cancel'),
          headers: {
            'Authorization': 'Token $directApiKey',
            'Content-Type': 'application/json',
          },
        );
      }
    } catch (e) {
      debugPrint('Error cancelling job: $e');
      rethrow;
    }
  }
}
