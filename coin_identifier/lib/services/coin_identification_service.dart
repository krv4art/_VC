import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';
import '../services/gemini_service.dart';
import '../config/prompts_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service for coin and banknote identification using AI
class CoinIdentificationService {
  final GeminiService _geminiService;

  CoinIdentificationService({GeminiService? geminiService})
      : _geminiService = geminiService ??
            GeminiService(
              useProxy: true,
              supabaseClient: Supabase.instance.client,
            );

  /// Analyze coin/banknote image and return detailed analysis
  Future<AnalysisResult> analyzeCoinImage(
    Uint8List imageBytes, {
    String languageCode = 'en',
  }) async {
    try {
      debugPrint('📸 Starting coin analysis...');
      debugPrint('Image size: ${(imageBytes.length / 1024).toStringAsFixed(2)} KB');
      debugPrint('Language: $languageCode');

      // Convert image to base64
      final base64Image = base64Encode(imageBytes);
      debugPrint('Base64 encoded');

      // Build analysis prompt
      final promptBuilder = _buildAnalysisPrompt(languageCode);
      debugPrint('Prompt prepared');

      // Call Gemini Vision API via Supabase Edge Function
      final result = await _geminiService.analyzeImage(
        base64Image,
        promptBuilder,
        languageCode: languageCode,
      );

      debugPrint('✓ Analysis completed successfully');
      debugPrint('Is coin/banknote: ${result.isCoinOrBanknote}');
      if (result.isCoinOrBanknote) {
        debugPrint('Name: ${result.name}');
        debugPrint('Rarity: ${result.rarityLevel} (${result.rarityScore}/10)');
      }

      return result;
    } catch (e) {
      debugPrint('❌ Coin analysis error: $e');
      rethrow;
    }
  }

  /// Build comprehensive analysis prompt for coins
  String _buildAnalysisPrompt(String languageCode) {
    // Use prompts from configuration
    final variables = {
      'language_code': languageCode,
    };

    // Get scanning analysis prompt with variable substitution
    final promptTemplate = PromptsManager.getPrompt('chat.scanning.analysis_prompt');

    if (promptTemplate == null) {
      debugPrint('⚠️ Using default coin analysis prompt');
      return _getDefaultCoinPrompt(languageCode);
    }

    // Replace variables in template
    String prompt = promptTemplate;
    variables.forEach((key, value) {
      prompt = prompt.replaceAll('{{$key}}', value);
    });

    return prompt;
  }

  /// Default coin analysis prompt (fallback)
  String _getDefaultCoinPrompt(String languageCode) {
    return '''
You are an expert numismatist with comprehensive knowledge of coins and banknotes from around the world.

LANGUAGE: $languageCode
IMPORTANT: ALL text in your response MUST be in the language specified above.

STEP 1: DETERMINE OBJECT TYPE
Examine the image and determine if this is a coin or banknote.

If this is NOT a coin or banknote:
- Set "is_coin_or_banknote" to false
- Create a humorous message (20-40 words) in $languageCode
- Leave other fields empty/default

If this IS a coin or banknote:
- Set "is_coin_or_banknote" to true
- Set "item_type" to "coin" or "banknote"
- Proceed with full analysis

STEP 2: FULL NUMISMATIC ANALYSIS:
1. Identify name, country, year, mint mark, denomination
2. Describe obverse and reverse
3. Identify materials and composition
4. Assess rarity level and score (1-10)
5. Provide market valuation
6. Identify mint errors if any
7. Provide historical context
8. Give expert advice

REQUIRED JSON OUTPUT:
{
  "is_coin_or_banknote": true/false,
  "humorous_message": "..." (only if not coin/banknote, in $languageCode),
  "item_type": "coin" or "banknote",
  "name": "..." (in $languageCode),
  "country": "..." (in $languageCode),
  "year_of_issue": "...",
  "mint_mark": "...",
  "denomination": "..." (in $languageCode),
  "description": "..." (in $languageCode),
  "obverse_description": "..." (in $languageCode),
  "reverse_description": "..." (in $languageCode),
  "materials": [
    {
      "name": "..." (in $languageCode),
      "percentage": 0.0,
      "description": "..." (in $languageCode)
    }
  ],
  "weight": 0.0,
  "diameter": 0.0,
  "edge": "..." (in $languageCode),
  "rarity_level": "Common|Uncommon|Rare|Very Rare|Extremely Rare" (in $languageCode),
  "rarity_score": 1-10,
  "market_value": {
    "min_price": 0.0,
    "max_price": 0.0,
    "currency": "USD",
    "condition": "..." (in $languageCode),
    "confidence": "low|medium|high",
    "source": "..." (in $languageCode)
  },
  "collector_interest": "..." (in $languageCode),
  "historical_context": "..." (in $languageCode),
  "mintage_quantity": "...",
  "circulation_period": "..." (in $languageCode),
  "mint_errors": [
    {
      "error_type": "..." (in $languageCode),
      "description": "..." (in $languageCode),
      "rarity_impact": "..." (in $languageCode),
      "estimated_value_increase": "..." (in $languageCode)
    }
  ],
  "special_features": ["..." (in $languageCode)],
  "warnings": ["..." (in $languageCode)],
  "authenticity_notes": "..." (in $languageCode),
  "similar_coins": ["..." (in $languageCode)],
  "ai_summary": "..." (30-80 words, in $languageCode),
  "expert_advice": "..." (in $languageCode)
}

All text fields MUST be in $languageCode.
''';
  }
}
