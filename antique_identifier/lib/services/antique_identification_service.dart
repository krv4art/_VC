import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/analysis_result.dart';
import 'prompt_builder_service.dart';

/// Сервис для идентификации и анализа антикварных предметов
class AntiqueIdentificationService {
  static const String _supabaseUrl =
      'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

  Future<AnalysisResult> analyzeAntiqueImage(
    Uint8List imageBytes, {
    required String languageCode,
  }) async {
    try {
      final String base64Image = base64Encode(imageBytes);
      final String prompt = PromptBuilderService.buildAntiqueAnalysisPrompt(
        languageCode,
      );

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'inline_data': {'mime_type': 'image/png', 'data': base64Image},
              },
              {'text': prompt},
            ],
          },
        ],
      };

      debugPrint('Analyzing antique image with Gemini API...');

      final http.Response response = await http.post(
        Uri.parse(_supabaseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () => throw TimeoutException(
          'Antique analysis took too long. Please try again.',
        ),
      );

      if (response.statusCode != 200) {
        debugPrint(
            'API error: ${response.statusCode} - ${response.body}');
        throw Exception(
          'Failed to analyze image: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Извлекаем текст из ответа Gemini
      final String? responseText = responseData['candidates']?[0]?['content']
          ?['parts']?[0]?['text'] as String?;

      if (responseText == null) {
        throw Exception('No response text from Gemini');
      }

      debugPrint('Gemini Response: $responseText');

      // Парсим JSON из ответа
      final Map<String, dynamic> analysisData = _parseJsonFromResponse(responseText);

      return AnalysisResult.fromJson(analysisData);
    } on http.ClientException catch (e) {
      debugPrint('Network error: $e');
      throw Exception('Network error: $e');
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      rethrow;
    }
  }

  /// Парсит JSON из текстового ответа ИИ
  Map<String, dynamic> _parseJsonFromResponse(String response) {
    try {
      // Пытаемся найти JSON в ответе
      final startIndex = response.indexOf('{');
      final endIndex = response.lastIndexOf('}');

      if (startIndex != -1 && endIndex != -1) {
        final jsonString = response.substring(startIndex, endIndex + 1);
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }

      throw Exception('Could not find JSON in response');
    } catch (e) {
      debugPrint('Error parsing JSON: $e');
      // Возвращаем default структуру если парсинг не сработал
      return {
        'is_antique': false,
        'humorous_message':
            'Unable to analyze this image. Please try another antique item.',
        'item_name': '',
        'description': '',
        'materials': [],
        'historical_context': '',
        'warnings': ['Unable to perform proper analysis.'],
        'similar_items': [],
      };
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);

  @override
  String toString() => message;
}
