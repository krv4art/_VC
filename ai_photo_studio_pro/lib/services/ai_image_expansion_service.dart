import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

/// Service for AI-powered image expansion (outpainting)
/// Expands images to different aspect ratios for various platforms
class AIImageExpansionService {
  final SupabaseClient supabaseClient;

  AIImageExpansionService({required this.supabaseClient});

  /// Expand image to target aspect ratio
  Future<String> expandImage({
    required String imagePath,
    required AspectRatio targetRatio,
    ExpansionDirection direction = ExpansionDirection.all,
  }) async {
    try {
      final imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        throw Exception('Image file not found: $imagePath');
      }

      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final response = await supabaseClient.functions.invoke(
        'image-expansion',
        body: {
          'action': 'expand',
          'image': base64Image,
          'target_ratio': targetRatio.toString().split('.').last,
          'direction': direction.toString().split('.').last,
        },
      );

      if (response.status != 200) {
        throw Exception('Image expansion failed: ${response.data}');
      }

      final data = response.data as Map<String, dynamic>;

      if (data.containsKey('url')) {
        return data['url'] as String;
      } else if (data.containsKey('job_id')) {
        return await _pollExpansionJob(data['job_id'] as String);
      }

      throw Exception('Unexpected response from expansion service');
    } catch (e) {
      debugPrint('Error expanding image: $e');
      rethrow;
    }
  }

  /// Expand vertical photo to 16:9 (YouTube, landscape)
  Future<String> expandToLandscape(String imagePath) async {
    return await expandImage(
      imagePath: imagePath,
      targetRatio: AspectRatio.ratio16x9,
      direction: ExpansionDirection.horizontal,
    );
  }

  /// Expand horizontal photo to 9:16 (Instagram Stories, TikTok)
  Future<String> expandToPortrait(String imagePath) async {
    return await expandImage(
      imagePath: imagePath,
      targetRatio: AspectRatio.ratio9x16,
      direction: ExpansionDirection.vertical,
    );
  }

  /// Expand to square (Instagram posts)
  Future<String> expandToSquare(String imagePath) async {
    return await expandImage(
      imagePath: imagePath,
      targetRatio: AspectRatio.ratio1x1,
      direction: ExpansionDirection.all,
    );
  }

  /// Expand to LinkedIn banner
  Future<String> expandToLinkedInBanner(String imagePath) async {
    return await expandImage(
      imagePath: imagePath,
      targetRatio: AspectRatio.linkedInBanner,
      direction: ExpansionDirection.horizontal,
    );
  }

  /// Poll for expansion job completion
  Future<String> _pollExpansionJob(String jobId) async {
    const maxAttempts = 60;
    const pollInterval = Duration(seconds: 5);

    for (int i = 0; i < maxAttempts; i++) {
      await Future.delayed(pollInterval);

      final response = await supabaseClient.functions.invoke(
        'image-expansion',
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
        throw Exception('Expansion job failed: ${data['error']}');
      }
    }

    throw Exception('Expansion job timed out');
  }

  /// Get available aspect ratios
  static List<AspectRatioOption> getAvailableRatios() {
    return [
      AspectRatioOption(
        ratio: AspectRatio.ratio1x1,
        name: 'Square (1:1)',
        description: 'Instagram Posts',
        width: 1080,
        height: 1080,
      ),
      AspectRatioOption(
        ratio: AspectRatio.ratio4x5,
        name: 'Portrait (4:5)',
        description: 'Instagram Portrait',
        width: 1080,
        height: 1350,
      ),
      AspectRatioOption(
        ratio: AspectRatio.ratio9x16,
        name: 'Vertical (9:16)',
        description: 'Stories, Reels, TikTok',
        width: 1080,
        height: 1920,
      ),
      AspectRatioOption(
        ratio: AspectRatio.ratio16x9,
        name: 'Landscape (16:9)',
        description: 'YouTube, LinkedIn',
        width: 1920,
        height: 1080,
      ),
      AspectRatioOption(
        ratio: AspectRatio.linkedInBanner,
        name: 'LinkedIn Banner',
        description: 'Profile Banner',
        width: 1584,
        height: 396,
      ),
    ];
  }
}

enum AspectRatio {
  ratio1x1,    // Square
  ratio4x5,    // Instagram portrait
  ratio9x16,   // Stories, TikTok
  ratio16x9,   // YouTube
  linkedInBanner, // 4:1
}

enum ExpansionDirection {
  all,
  horizontal,
  vertical,
  top,
  bottom,
  left,
  right,
}

class AspectRatioOption {
  final AspectRatio ratio;
  final String name;
  final String description;
  final int width;
  final int height;

  AspectRatioOption({
    required this.ratio,
    required this.name,
    required this.description,
    required this.width,
    required this.height,
  });

  double get aspectRatio => width / height;

  @override
  String toString() => '$name - $description (${width}x$height)';
}
