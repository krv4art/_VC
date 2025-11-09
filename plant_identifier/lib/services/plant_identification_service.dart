import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plant_result.dart';
import '../models/user_preferences.dart';

/// Service for identifying plants using AI (Gemini)
class PlantIdentificationService {
  final SupabaseClient _supabaseClient;

  PlantIdentificationService({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Identify plant from image
  Future<PlantResult> identifyPlant({
    required String base64Image,
    required String languageCode,
    UserPreferences? userPreferences,
  }) async {
    final functionUrl =
        'https://yerbryysrnaraqmbhqdm.supabase.co/functions/v1/gemini-vision-proxy';

    final prompt = _buildIdentificationPrompt(languageCode, userPreferences);

    final requestBody = {
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

    try {
      final httpResponse = await http.post(
        Uri.parse(functionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (httpResponse.statusCode != 200) {
        throw Exception(
          'Failed to identify plant: ${httpResponse.statusCode} ${httpResponse.body}',
        );
      }

      final responseData = jsonDecode(httpResponse.body) as Map<String, dynamic>;

      // Extract text from Gemini response
      final candidates = responseData['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw Exception('No candidates in response');
      }

      final content = candidates[0]['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List<dynamic>;
      final text = parts[0]['text'] as String;

      // Parse the response text into PlantResult
      return _parsePlantResult(text, base64Image);
    } catch (e) {
      debugPrint('Error identifying plant: $e');
      rethrow;
    }
  }

  /// Build identification prompt based on language and user preferences
  String _buildIdentificationPrompt(
    String languageCode,
    UserPreferences? preferences,
  ) {
    final languageInstruction = _getLanguageInstruction(languageCode);

    final basePrompt = '''
You are an expert botanist and mycologist. Analyze this image and provide detailed information about the plant or mushroom.

Return your analysis in the following JSON format:
{
  "plantName": "Common name",
  "scientificName": "Scientific name (genus species)",
  "description": "Detailed description",
  "type": "plant, mushroom, herb, tree, flower, succulent, fern, moss, cactus, or unknown",
  "commonNames": ["name1", "name2"],
  "family": "Plant family",
  "origin": "Geographic origin",
  "isToxic": true or false,
  "isEdible": true or false,
  "usesAndBenefits": ["use1", "use2"],
  "confidence": 0.0 to 1.0,
  "careInfo": {
    "wateringFrequency": "Description of watering needs",
    "sunlightRequirement": "Full sun / Partial shade / Shade",
    "soilType": "Soil type description",
    "temperature": "Temperature range",
    "humidity": "Humidity requirements",
    "fertilizer": "Fertilizer recommendations",
    "commonPests": ["pest1", "pest2"],
    "commonDiseases": ["disease1", "disease2"]
  }
}

$languageInstruction
''';

    // Add user preferences context if available
    if (preferences != null) {
      final preferencesContext = _buildPreferencesContext(preferences);
      return '$basePrompt\n\n$preferencesContext';
    }

    return basePrompt;
  }

  /// Build context from user preferences
  String _buildPreferencesContext(UserPreferences preferences) {
    final context = StringBuffer();

    context.writeln('User Context:');
    if (preferences.location != null) {
      context.writeln('- Location: ${preferences.location}');
    }
    if (preferences.climate != null) {
      context.writeln('- Climate: ${preferences.climate}');
    }
    if (preferences.gardenType != null) {
      context.writeln('- Garden type: ${preferences.gardenType}');
    }

    // Environmental conditions
    if (preferences.temperature != null) {
      context.writeln('- Average temperature: ${preferences.temperature}°C');
    }
    if (preferences.humidity != null) {
      context.writeln('- Average humidity: ${preferences.humidity}%');
    }

    context.writeln(
        '- Experience level: ${preferences.experience.toString().split('.').last}');

    if (preferences.interests.isNotEmpty) {
      context.writeln('- Interests: ${preferences.interests.map((i) => i.toString().split('.').last).join(', ')}');
    }

    if (preferences.showToxicWarnings) {
      context.writeln(
          '- Please highlight any toxic properties clearly for safety.');
    }

    if (preferences.lowMaintenancePreference) {
      context.writeln('- User prefers low-maintenance plants.');
    }

    // Add environmental context note
    if (preferences.temperature != null || preferences.humidity != null) {
      context.writeln(
          '\nPlease tailor care recommendations to match these environmental conditions.');
    }

    return context.toString();
  }

  /// Get language instruction
  String _getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'ВАЖНО: Предоставьте весь ответ на РУССКОМ языке. Все описания, предупреждения и рекомендации должны быть на русском.';
      case 'uk':
        return 'ВАЖЛИВО: Надайте всю відповідь УКРАЇНСЬКОЮ мовою. Всі описи, попередження та рекомендації мають бути українською.';
      case 'en':
      default:
        return 'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, warnings, and recommendations should be in English.';
    }
  }

  /// Parse Gemini response into PlantResult
  PlantResult _parsePlantResult(String responseText, String imageUrl) {
    try {
      // Extract JSON from response (it might be wrapped in markdown code blocks)
      var jsonText = responseText;
      if (jsonText.contains('```json')) {
        final startIndex = jsonText.indexOf('```json') + 7;
        final endIndex = jsonText.lastIndexOf('```');
        jsonText = jsonText.substring(startIndex, endIndex).trim();
      } else if (jsonText.contains('```')) {
        final startIndex = jsonText.indexOf('```') + 3;
        final endIndex = jsonText.lastIndexOf('```');
        jsonText = jsonText.substring(startIndex, endIndex).trim();
      }

      final json = jsonDecode(jsonText) as Map<String, dynamic>;

      return PlantResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        plantName: json['plantName'] as String,
        scientificName: json['scientificName'] as String,
        description: json['description'] as String,
        type: _parseType(json['type'] as String?),
        imageUrl: imageUrl,
        identifiedAt: DateTime.now(),
        careInfo: json['careInfo'] != null
            ? PlantCareInfo.fromJson(json['careInfo'] as Map<String, dynamic>)
            : null,
        commonNames:
            (json['commonNames'] as List<dynamic>?)?.cast<String>() ?? [],
        family: json['family'] as String?,
        origin: json['origin'] as String?,
        isToxic: json['isToxic'] as bool? ?? false,
        isEdible: json['isEdible'] as bool? ?? false,
        usesAndBenefits:
            (json['usesAndBenefits'] as List<dynamic>?)?.cast<String>() ?? [],
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      debugPrint('Error parsing plant result: $e');
      // Return a basic result with the raw response
      return PlantResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        plantName: 'Unknown Plant',
        scientificName: 'Unknown',
        description: responseText,
        type: PlantType.unknown,
        imageUrl: imageUrl,
        identifiedAt: DateTime.now(),
        confidence: 0.0,
      );
    }
  }

  /// Parse plant type from string
  PlantType _parseType(String? typeString) {
    if (typeString == null) return PlantType.unknown;

    switch (typeString.toLowerCase()) {
      case 'mushroom':
      case 'fungi':
        return PlantType.mushroom;
      case 'herb':
        return PlantType.herb;
      case 'tree':
        return PlantType.tree;
      case 'flower':
        return PlantType.flower;
      case 'succulent':
        return PlantType.succulent;
      case 'fern':
        return PlantType.fern;
      case 'moss':
        return PlantType.moss;
      case 'cactus':
        return PlantType.cactus;
      case 'plant':
        return PlantType.plant;
      default:
        return PlantType.unknown;
    }
  }
}
