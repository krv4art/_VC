import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

/// Сервис для анализа антиквариата с несколькими фотографиями
class MultiPhotoAnalysisService {
  static const String _supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1OTYzNDYsImV4cCI6MjA0NzE3MjM0Nn0.ipERbuUJkhBK-SUtXWvgQXo_KrfLnpJFu_ZqsrVyxZg';

  /// Анализирует предмет по нескольким фотографиям
  /// Позволяет более точно оценить состояние, детали, клейма
  Future<AnalysisResult?> analyzeMultiplePhotos({
    required List<String> imagePaths,
    String language = 'en',
  }) async {
    if (imagePaths.isEmpty) {
      developer.log('No images provided', name: 'MultiPhotoAnalysisService');
      return null;
    }

    try {
      developer.log(
        'Analyzing ${imagePaths.length} photos',
        name: 'MultiPhotoAnalysisService',
      );

      // Кодируем все изображения в Base64
      final List<String> base64Images = [];
      for (final path in imagePaths) {
        final file = File(path);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          base64Images.add(base64Encode(bytes));
        }
      }

      if (base64Images.isEmpty) {
        developer.log('No valid images found', name: 'MultiPhotoAnalysisService');
        return null;
      }

      // Создаем специальный промпт для мульти-фото анализа
      final prompt = _buildMultiPhotoPrompt(language, base64Images.length);

      // Отправляем первое изображение как основное, остальные в контексте
      final response = await http.post(
        Uri.parse('$_supabaseUrl/functions/v1/gemini-vision-proxy'),
        headers: {
          'Authorization': 'Bearer $_anonKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Images.first,
          'additionalImages': base64Images.skip(1).toList(),
          'prompt': prompt,
        }),
      ).timeout(const Duration(seconds: 90));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['text'] as String?;

        if (text == null || text.isEmpty) {
          developer.log('Empty response', name: 'MultiPhotoAnalysisService');
          return null;
        }

        // Парсим JSON ответ
        final analysisResult = _parseAnalysisResult(text);

        developer.log(
          'Multi-photo analysis completed',
          name: 'MultiPhotoAnalysisService',
        );

        return analysisResult;
      } else {
        developer.log(
          'Analysis failed: ${response.statusCode}',
          name: 'MultiPhotoAnalysisService',
        );
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error analyzing photos: $e',
        name: 'MultiPhotoAnalysisService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Создает промпт для анализа нескольких фотографий
  String _buildMultiPhotoPrompt(String language, int photoCount) {
    return '''
You are analyzing $photoCount photographs of the same antique item from different angles.

IMPORTANT: Analyze ALL provided images together to get a complete understanding of:
1. Overall condition (visible in different angles)
2. Material details (better visible in close-ups)
3. Maker's marks or signatures (visible in detail shots)
4. Construction methods (visible from different perspectives)
5. Wear patterns and authenticity indicators (multiple views)
6. Decorative elements and craftsmanship details

Use ALL images to provide a more accurate and comprehensive analysis than would be possible with a single photo.

Respond in $language language.

Return ONLY valid JSON with this structure:
{
  "is_antique": true/false,
  "humorous_message": "funny message if not antique" or null,
  "item_name": "name of the item",
  "category": "furniture/pottery/silver/etc",
  "description": "detailed description based on ALL photos",
  "materials": [
    {
      "name": "material name",
      "description": "characteristics visible in the photos",
      "era": "period if identifiable"
    }
  ],
  "historical_context": "historical background and significance",
  "estimated_period": "time period",
  "estimated_origin": "country/region of origin",
  "price_estimate": {
    "min_price": 100,
    "max_price": 500,
    "currency": "USD",
    "confidence": "low/medium/high",
    "based_on": "what the estimate is based on"
  },
  "warnings": ["disclaimer 1", "disclaimer 2"],
  "authenticity_notes": "authenticity assessment based on ALL photos - mention specific details visible in different images",
  "similar_items": ["comparable item 1", "comparable item 2"],
  "ai_summary": "comprehensive summary mentioning insights from different photos",
  "condition_assessment": "detailed condition report based on all angles",
  "visible_marks": "description of any marks, signatures, or stamps visible in detail photos"
}

Key requirements:
- Mention which details are visible in which photos (e.g., "maker's mark visible in detail shot", "wear pattern seen from side angle")
- Provide more confident assessments due to multiple perspectives
- Note any inconsistencies or confirming details across photos
- Give a comprehensive condition assessment using all views
''';
  }

  /// Парсит результат анализа из текста
  AnalysisResult? _parseAnalysisResult(String text) {
    try {
      // Извлекаем JSON из ответа
      final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
      if (jsonMatch == null) {
        developer.log('No JSON found in response', name: 'MultiPhotoAnalysisService');
        return null;
      }

      final jsonString = jsonMatch.group(0)!;
      final Map<String, dynamic> json = jsonDecode(jsonString);

      return AnalysisResult.fromJson(json);
    } catch (e) {
      developer.log('Error parsing result: $e', name: 'MultiPhotoAnalysisService');
      return null;
    }
  }

  /// Оптимальное количество фотографий для анализа
  static const int recommendedPhotoCount = 4;

  /// Рекомендации по съемке фотографий
  static List<String> getPhotoGuidelines(String language) {
    // Для простоты возвращаем на английском, можно добавить локализацию
    return [
      '1. Overall view: Full item from front',
      '2. Detail shot: Close-up of any marks, signatures, or decorative elements',
      '3. Side/back view: Construction details and condition',
      '4. Condition issues: Any damage, repairs, or wear',
      '5. (Optional) Bottom/base: Maker\'s marks often located here',
    ];
  }
}
