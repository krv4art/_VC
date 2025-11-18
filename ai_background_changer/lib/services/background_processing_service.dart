import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for background removal and replacement
class BackgroundProcessingService {
  final SupabaseClient _supabaseClient;

  BackgroundProcessingService(this._supabaseClient);

  /// Remove background from image using AI
  /// Returns path to the processed image with transparent background
  Future<String> removeBackground(String imagePath) async {
    try {
      debugPrint('Removing background from: $imagePath');

      // Read image file
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Call Supabase Edge Function for background removal
      // Note: This is a placeholder URL - you'll need to implement the edge function
      final functionUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/background-removal';

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (httpResponse.statusCode != 200) {
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        throw Exception('Background removal failed: $error');
      }

      final responseData = jsonDecode(httpResponse.body);
      final processedBase64 = responseData['processed_image'] as String;

      // Decode and save processed image
      final processedBytes = base64Decode(processedBase64);
      final processedPath = await _saveProcessedImage(processedBytes, 'removed_bg');

      debugPrint('Background removed successfully: $processedPath');
      return processedPath;
    } catch (e) {
      debugPrint('Error removing background: $e');
      rethrow;
    }
  }

  /// Generate new background for image
  /// Takes image with removed background and a prompt/style
  /// Returns path to the final composite image
  Future<String> generateBackground({
    required String removedBgImagePath,
    String? prompt,
    String? stylePrompt,
  }) async {
    try {
      debugPrint('Generating background with prompt: ${prompt ?? stylePrompt}');

      // Read image with removed background
      final imageFile = File(removedBgImagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      // Prepare the prompt
      final finalPrompt = prompt ?? stylePrompt ?? 'professional studio background';

      // Call Supabase Edge Function for background generation
      // Note: This is a placeholder URL - you'll need to implement the edge function
      final functionUrl =
          'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/background-generation';

      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'foreground_image': base64Image,
          'background_prompt': finalPrompt,
        }),
      );

      if (httpResponse.statusCode != 200) {
        final errorData = jsonDecode(httpResponse.body);
        final error = errorData['error'] ?? 'Unknown error';
        throw Exception('Background generation failed: $error');
      }

      final responseData = jsonDecode(httpResponse.body);
      final compositeBase64 = responseData['composite_image'] as String;

      // Decode and save composite image
      final compositeBytes = base64Decode(compositeBase64);
      final compositePath = await _saveProcessedImage(compositeBytes, 'with_bg');

      debugPrint('Background generated successfully: $compositePath');
      return compositePath;
    } catch (e) {
      debugPrint('Error generating background: $e');
      rethrow;
    }
  }

  /// Save processed image to local storage
  Future<String> _saveProcessedImage(Uint8List imageBytes, String suffix) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'processed_${suffix}_$timestamp.png';
      final filePath = path.join(directory.path, 'backgrounds', fileName);

      // Create directory if it doesn't exist
      final dir = Directory(path.join(directory.path, 'backgrounds'));
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Write file
      final file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      debugPrint('Error saving processed image: $e');
      rethrow;
    }
  }

  /// Simple composite function for local processing
  /// This is a fallback if edge functions are not available
  Future<String> simpleComposite({
    required String foregroundPath,
    required String backgroundPath,
  }) async {
    try {
      // Read both images
      final foreground = File(foregroundPath);
      final background = File(backgroundPath);

      final foregroundBytes = await foreground.readAsBytes();
      final backgroundBytes = await background.readAsBytes();

      // For now, just return the foreground
      // In a real implementation, you'd use image package to composite
      final compositePath = await _saveProcessedImage(
        foregroundBytes,
        'composite',
      );

      return compositePath;
    } catch (e) {
      debugPrint('Error creating composite: $e');
      rethrow;
    }
  }
}
