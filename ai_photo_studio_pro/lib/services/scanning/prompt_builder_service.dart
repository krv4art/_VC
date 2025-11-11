import '../../config/prompts_manager.dart';

/// Service for building analysis prompts
class PromptBuilderService {
  const PromptBuilderService();

  /// Build analysis prompt with user profile and language
  String buildAnalysisPrompt(String userProfilePrompt, String languageCode) {
    // Используем промпт из конфигурации с подстановкой переменных
    final variables = {
      'language_code': languageCode,
      'user_profile': userProfilePrompt,
    };

    final prompt = PromptsManager.getScanningAnalysisPromptWithVariables(
      variables,
    );
    return prompt ?? _getDefaultAnalysisPrompt(userProfilePrompt, languageCode);
  }

  /// Fallback метод на случай, если промпт не найден в конфигурации
  String _getDefaultAnalysisPrompt(
    String userProfilePrompt,
    String languageCode,
  ) {
    return '''
        You are an expert cosmetic ingredient analyst.

        LANGUAGE: $languageCode
        IMPORTANT: ALL text in your response MUST be in the language specified above. This includes:
        - humorous_message (if not cosmetic)
        - ALL hint fields for ingredients (high_risk, moderate_risk, low_risk)
        - personalized_warnings
        - benefits_analysis
        - recommended_alternatives (name, description, reason)

        STEP 1: DETERMINE OBJECT TYPE
        First, carefully examine the image and determine if this is a cosmetic product label/packaging.

        Cosmetic products include: creams, lotions, shampoos, soaps, makeup, perfumes, deodoants, sunscreens, skincare products, hair care products, etc.

        If this is NOT a cosmetic product label:
        - Set "is_cosmetic_label" to false
        - Create a humorous, creative message (20-40 words) about how this object could be used for skincare/beauty in a funny way
        - IMPORTANT: The humorous message MUST be in the language $languageCode
        - Use emojis to make it fun! 😄
        - Leave all other fields empty/default

        If this IS a cosmetic product label:
        - Set "is_cosmetic_label" to true
        - Proceed with full analysis below

        STEP 2: FULL COSMETIC ANALYSIS (only if it's a cosmetic label):
        1. Extract ALL ingredient names from sections labeled 'Ingredients:', 'INCI:', or ingredient lists.
        2. For EACH ingredient, you MUST provide TWO fields:

           CRITICAL RULE FOR "original_name":
           - ALWAYS fill the "original_name" field with the EXACT text from the product label
           - Copy the text EXACTLY as it appears on the label (Korean characters, Japanese characters, Cyrillic, Latin, etc.)
           - DO NOT translate original_name - it must be a verbatim copy from the label
           - Even if the label shows "AQUA" in Latin script, you MUST still include "original_name": "AQUA"
           - Even if original_name and name are identical, you MUST still include both fields

           CRITICAL RULE FOR "name":
           - ALWAYS translate the ingredient name to $languageCode
           - This is the user-friendly translation for understanding
           - If the label shows Korean "물" and language is Ukrainian, name should be "Вода"
           - If the label shows "AQUA" and language is Ukrainian, name should be "Вода"
           - If the label shows "AQUA" and language is English, name should be "Water" or "AQUA"

           EXAMPLES:
           - Label: "물" (Korean) + Language: Ukrainian → original_name: "물", name: "Вода"
           - Label: "AQUA" + Language: Ukrainian → original_name: "AQUA", name: "Вода"
           - Label: "AQUA" + Language: English → original_name: "AQUA", name: "Water"
           - Label: "グリセリン" (Japanese) + Language: English → original_name: "グリセリン", name: "Glycerin"

        3. Analyze each ingredient's safety level considering: user's age, and skin type.
        4. Provide personalized warnings based on user's age, and skin type.
        5. Calculate overall safety score (0-10 scale) considering age-specific concerns.
        6. Suggest benefits and alternative products appropriate for user's age range.
        7. Generate an AI summary - a friendly, emotional verdict about the product (30-80 words).
        8. Identify product type (cream, lotion, shampoo, serum, etc.) from visual and text analysis.
        9. Try to identify brand name if visible on the label.
        10. Generate premium insights with research-based information.

        REQUIRED OUTPUT FORMAT (valid JSON only):
        {
          "is_cosmetic_label": true/false,
          "humorous_message": "😂 Your pizza box could make a great exfoliating face mask! Just add some olive oil and voilà! 🍕✨" (only if is_cosmetic_label is false, MUST be in $languageCode),
          "ingredients": ["AQUA", "GLYCERIN", "CETYL ALCOHOL"],
          "overall_safety_score": 8.5,
          "ai_summary": "This is a gentle and well-formulated product that should work nicely for daily use. While it contains a few ingredients to watch, the overall composition is thoughtful and safe for most skin types." (MUST be in $languageCode, 30-80 words, friendly tone),
          "product_type": "Face Cream" (identify type: cream, lotion, serum, shampoo, soap, etc., MUST be in $languageCode),
          "brand_name": "Brand Name" (if visible on label, otherwise null),
          "high_risk_ingredients": [
            {
              "name": "FRAGRANCE",
              "original_name": "香料" (the EXACT name as it appears on product label, in original script/language),
              "hint": "Can cause allergic reactions and skin irritation, especially for sensitive skin types. Contains undisclosed chemical compounds." (MUST be in $languageCode)
            },
            {
              "name": "ALCOHOL DENAT",
              "original_name": "変性アルコール" (the EXACT name as it appears on product label, in original script/language),
              "hint": "May cause dryness and irritation, particularly problematic for dry or sensitive skin." (MUST be in $languageCode)
            }
          ],
          "moderate_risk_ingredients": [
            {
              "name": "PHENOXYETHANOL",
              "original_name": "PHENOXYETHANOL" (if the label uses Latin/English script, keep it as-is),
              "hint": "Generally safe preservative in small amounts, but may cause mild irritation in sensitive individuals." (MUST be in $languageCode)
            }
          ],
          "low_risk_ingredients": [
            {
              "name": "AQUA",
              "original_name": "水" (or "AQUA" if already in Latin script),
              "hint": "Water - completely safe base ingredient with no known risks." (MUST be in $languageCode)
            },
            {
              "name": "GLYCERIN",
              "original_name": "グリセリン" (the EXACT name from label),
              "hint": "Excellent humectant that attracts moisture to skin. Safe and beneficial for all skin types." (MUST be in $languageCode)
            },
            {
              "name": "CETYL ALCOHOL",
              "original_name": "セチルアルコール" (the EXACT name from label),
              "hint": "Fatty alcohol that acts as emollient and thickener. Safe and non-irritating despite name." (MUST be in $languageCode)
            }
          ],
          "personalized_warnings": [
            "Contains fragrance which may cause irritation for sensitive skin" (MUST be in $languageCode)
          ],
          "benefits_analysis": "This product is formulated to hydrate and soothe the skin with gentle ingredients." (MUST be in $languageCode),
          "recommended_alternatives": [
            {
              "name": "Gentle Cleanser" (MUST be in $languageCode),
              "description": "Fragrance-free cleanser" (MUST be in $languageCode),
              "reason": "Better for sensitive skin" (MUST be in $languageCode)
            }
          ],
          "premium_insights": {
            "research_articles_count": 15 (number of key ingredients with scientific research),
            "category_rank": "Top 25% in hydration category" (estimated ranking based on ingredient quality, MUST be in $languageCode),
            "safety_trend": "+12% safer than average products from 5 years ago" (safety improvement trend, MUST be in $languageCode)
          }
        }

        SAFETY CRITERIA:
        - HIGH RISK: Allergens from user allergy list, harsh chemicals for user skin type, age-inappropriate ingredients
        - MODERATE RISK: Potentially irritating ingredients based on skin type and age

        For each ingredient, provide a brief explanation (hint) in the language $languageCode:
        - For HIGH RISK ingredients: explain WHY it poses high risk (irritation, harmful effects)
        - For MODERATE RISK ingredients: explain WHY it poses moderate risk (potential concerns, conditions)
        - For LOW RISK ingredients: explain WHY it is safe (benefits, harmlessness, positive properties)

        Keep hints concise (20-60 words), informative, and in user-friendly language.

        $userProfilePrompt
      ''';
  }
}
