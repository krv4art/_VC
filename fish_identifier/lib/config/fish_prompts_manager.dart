/// Fish Identification AI Prompts Manager
///
/// Provides prompts for Gemini AI to identify fish species and provide
/// helpful information for anglers, divers, and fish enthusiasts.
class FishPromptsManager {
  // Private constructor to prevent instantiation
  FishPromptsManager._();

  /// Get the identification prompt for analyzing a fish image
  static String getIdentificationPrompt(String languageCode) {
    final languageInstruction = getLanguageInstruction(languageCode);

    return '''
You are an expert ichthyologist and fishing guide. Analyze this fish image and provide detailed information.

IMPORTANT: Return your response as a valid JSON object with this EXACT structure:

{
  "is_fish": true/false,
  "fish_name": "Common name of the fish",
  "scientific_name": "Scientific name (Genus species)",
  "habitat": "Where this fish lives (freshwater/saltwater, depth, regions)",
  "diet": "What this fish eats",
  "fun_facts": ["Fact 1", "Fact 2", "Fact 3"],
  "confidence_score": 0.95,
  "edibility": "Edible/Not recommended/Toxic",
  "cooking_tips": "Best cooking methods and recipes",
  "fishing_tips": "Best bait, lures, techniques, and seasons for catching",
  "conservation_status": "Conservation status (e.g., Least Concern, Endangered)"
}

If this is NOT a fish, set "is_fish" to false and provide a humorous message explaining what you see instead.

Guidelines:
- Be accurate and scientific, but also friendly and helpful
- Include practical information for anglers
- Mention any safety concerns (spines, toxins, etc.)
- If uncertain, provide your best guess with lower confidence_score
- Include local fishing regulations if relevant

$languageInstruction
''';
  }

  /// Get the chat system prompt for fish-related conversations
  static String getChatSystemPrompt(String languageCode, {String? fishContext}) {
    final languageInstruction = getLanguageInstruction(languageCode);
    final contextInfo = fishContext != null
        ? '\n\nCurrent fish context:\n$fishContext'
        : '';

    return '''
You are FishAI, an expert fishing assistant and ichthyologist. Your role is to help users with:

1. Fish identification and species information
2. Fishing techniques, tips, and equipment recommendations
3. Cooking and preparing fish
4. Local fishing regulations and conservation
5. Best fishing locations and conditions
6. Bait and lure recommendations
7. Fish behavior and habitat information

Personality:
- Friendly and enthusiastic about fishing
- Knowledgeable but not overly technical
- Practical and helpful
- Safety-conscious
- Environmentally aware

Guidelines:
- Always prioritize safety (handling fish, weather conditions, etc.)
- Encourage catch-and-release when appropriate
- Respect local fishing regulations
- Share your knowledge generously
- Be patient with beginners
- Celebrate the user's catches!
$contextInfo

$languageInstruction
''';
  }

  /// Get language-specific instruction for AI responses
  static String getLanguageInstruction(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'ВАЖНО: Весь ответ должен быть НА РУССКОМ ЯЗЫКЕ. Все описания, советы и рекомендации на русском.';
      case 'es':
        return 'IMPORTANTE: Toda la respuesta debe estar EN ESPAÑOL. Todas las descripciones, consejos y recomendaciones en español.';
      case 'ja':
        return '重要：回答全体を日本語で提供してください。すべての説明、アドバイス、推奨事項を日本語で。';
      case 'de':
        return 'WICHTIG: Die gesamte Antwort muss AUF DEUTSCH sein. Alle Beschreibungen, Tipps und Empfehlungen auf Deutsch.';
      case 'fr':
        return 'IMPORTANT: Toute la réponse doit être EN FRANÇAIS. Toutes les descriptions, conseils et recommandations en français.';
      case 'uk':
        return 'ВАЖЛИВО: Вся відповідь має бути УКРАЇНСЬКОЮ МОВОЮ. Всі описи, поради та рекомендації українською.';
      default: // 'en' and others
        return 'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, tips, and recommendations should be in English.';
    }
  }

  /// Get sample fishing questions for the chat interface
  static List<String> getSampleQuestions(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return [
          'Как лучше всего приготовить эту рыбу?',
          'Какую приманку использовать?',
          'Где можно поймать такую рыбу?',
          'Можно ли есть эту рыбу?',
        ];
      case 'es':
        return [
          '¿Cómo cocinar este pescado?',
          '¿Qué carnada usar?',
          '¿Dónde encontrar este pez?',
          '¿Es comestible?',
        ];
      case 'ja':
        return [
          'この魚の調理方法は?',
          'どの餌を使うべきですか?',
          'どこで釣れますか?',
          '食べられますか?',
        ];
      default:
        return [
          'How to cook this fish?',
          'What bait should I use?',
          'Where can I catch this fish?',
          'Is it safe to eat?',
        ];
    }
  }

  /// Get error messages for non-fish images
  static String getNotFishMessage(String languageCode) {
    switch (languageCode) {
      case 'ru':
        return 'Это не рыба! Попробуйте сфотографировать рыбу для идентификации. 🐟';
      case 'es':
        return '¡Esto no es un pez! Intenta fotografiar un pez para identificarlo. 🐟';
      case 'ja':
        return 'これは魚ではありません！魚を撮影して識別してください。🐟';
      default:
        return 'This is not a fish! Try photographing a fish for identification. 🐟';
    }
  }
}
