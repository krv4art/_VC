import 'package:flutter/foundation.dart';

/// Manager for application prompts
/// Provides system prompts and language instructions for plant identification
class PromptsManager {
  static bool _isInitialized = false;

  /// Initialize the prompts manager
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      debugPrint('PromptsManager initialized successfully');
    } catch (e) {
      debugPrint('Error initializing PromptsManager: $e');
      _isInitialized = true;
    }
  }

  /// Get chat system prompt
  static String? getChatSystemPrompt({String type = 'default'}) {
    if (type == 'default') {
      return 'You are a helpful AI assistant specializing in plant identification and care. You provide accurate information about plants, their care requirements, and can answer questions about botany and gardening.';
    }
    return null;
  }

  /// Get chat system prompt with custom prompt support
  static String? getChatSystemPromptWithCustom({
    String type = 'default',
    String? customPrompt,
    bool includeCustom = false,
  }) {
    String? basePrompt = getChatSystemPrompt(type: type);
    if (basePrompt == null) return null;

    if (includeCustom && customPrompt != null && customPrompt.isNotEmpty) {
      return '$basePrompt\n\nAdditional instructions: $customPrompt';
    }

    return basePrompt;
  }

  /// Get language instruction for responses
  static String? getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'ВАЖНО: Предоставь весь ответ на РУССКОМ языке. Все описания, советы и рекомендации должны быть на русском языке.';
      case 'uk':
        return 'ВАЖЛИВО: Надай всю відповідь УКРАЇНСЬКОЮ мовою. Усі описи, поради та рекомендації мають бути українською мовою.';
      case 'es':
        return 'IMPORTANTE: Proporciona toda la respuesta en ESPAÑOL. Todas las descripciones, consejos y recomendaciones deben estar en español.';
      case 'de':
        return 'WICHTIG: Geben Sie die gesamte Antwort auf DEUTSCH. Alle Beschreibungen, Ratschläge und Empfehlungen müssen auf Deutsch sein.';
      case 'fr':
        return 'IMPORTANT: Fournissez toute la réponse en FRANÇAIS. Toutes les descriptions, conseils et recommandations doivent être en français.';
      case 'it':
        return 'IMPORTANTE: Fornisci l\'intera risposta in ITALIANO. Tutte le descrizioni, consigli e raccomandazioni devono essere in italiano.';
      case 'en':
      default:
        return 'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, advice, and recommendations should be in English.';
    }
  }

  /// Check if initialized
  static bool get isInitialized => _isInitialized;

  /// Get context message for plant results
  static String? getPlantContextMessage(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Я вижу результат идентификации вашего растения. Задавайте любые вопросы о растении, советах по уходу или чем-то ещё!';
      case 'uk':
        return 'Я бачу результат ідентифікації вашої рослини. Ставте будь-які питання про рослину, поради з догляду або що-небудь інше!';
      case 'es':
        return 'Veo el resultado de identificación de tu planta. Puedes hacerme cualquier pregunta sobre la planta, consejos de cuidado o cualquier otra cosa!';
      case 'en':
      default:
        return 'I can see your plant identification result. Feel free to ask me any questions about the plant, care tips, or anything else!';
    }
  }

}
