import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'app_config.dart';

/// Менеджер для управления промптами приложения
/// Поддерживает загрузку из локальных файлов и шаблонизацию переменных
class PromptsManager {
  static Map<String, dynamic> _prompts = {};
  static bool _isInitialized = false;

  /// Инициализация менеджера промптов
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _loadLocalPrompts();
      _isInitialized = true;

      if (AppConfig().enableDebugMode) {
        debugPrint('PromptsManager initialized successfully');
      }
    } catch (e) {
      debugPrint('Error initializing PromptsManager: $e');
      // Создаем полную структуру с fallback-значениями для всех языков
      _prompts = {
        'chat': {
          'system_prompts': {
            'default':
                'You are a helpful AI assistant specializing in cosmetics and skincare.',
            'cosmetic_expert':
                'You are a professional cosmetic chemist and skincare expert.',
          },
          'language_instructions': {
            'ru':
                'ВАЖНО: Предоставь весь ответ на РУССКОМ языке. Все описания, предупреждения и рекомендации должны быть на русском языке.',
            'uk':
                'ВАЖЛИВО: Надай всю відповідь УКРАЇНСЬКОЮ мовою. Усі описи, попередження та рекомендації мають бути українською мовою.',
            'es':
                'IMPORTANTE: Proporciona toda la respuesta en ESPAÑOL. Todas las descripciones, advertencias y recomendaciones deben estar en español.',
            'en':
                'IMPORTANT: Provide the entire response in ENGLISH. All descriptions, warnings, and recommendations should be in English.',
            'de':
                'WICHTIG: Geben Sie die gesamte Antwort auf DEUTSCH. Alle Beschreibungen, Warnungen und Empfehlungen müssen auf Deutsch sein.',
            'fr':
                'IMPORTANT: Fournissez toute la réponse en FRANÇAIS. Toutes les descriptions, avertissements et recommandations doivent être en français.',
            'it':
                'IMPORTANTE: Fornisci l\'intera risposta in ITALIANO. Tutte le descrizioni, avvertenze e raccomandazioni devono essere in italiano.',
          },
          'welcome_messages': {
            'ru': 'Привет! Я ваш AI-ассистент по косметике. Чем могу помочь?',
            'uk': 'Привіт! Я ваш AI-асистент з косметики. Чим можу допомогти?',
            'es':
                '¡Hola! Soy tu asistente de IA especializado en cosmética. ¿En qué puedo ayudarte?',
            'en':
                'Hello! I\'m your AI assistant specializing in cosmetics. How can I help you?',
            'de':
                'Hallo! Ich bin Ihr KI-Assistent für Kosmetik. Wie kann ich Ihnen helfen?',
            'fr':
                'Bonjour ! Je suis votre assistant IA spécialisé en cosmétiques. Comment puis-je vous aider ?',
            'it':
                'Ciao! Sono il tuo assistente IA specializzato in cosmetica. Come posso aiutarti?',
          },
          'error_messages': {
            'ru': 'Извините, произошла ошибка. Попробуйте позже.',
            'uk': 'Вибачте, сталася помилка. Спробуйте пізніше.',
            'es': 'Lo siento, ha ocurrido un error. Inténtelo más tarde.',
            'en': 'Sorry, an error occurred. Please try again later.',
            'de':
                'Entschuldigung, es ist ein Fehler aufgetreten. Bitte versuchen Sie es später erneut.',
            'fr':
                'Désolé, une erreur s\'est produite. Veuillez réessayer plus tard.',
            'it': 'Scusi, si è verificato un errore. Riprova più tardi.',
          },
          'context_messages': {
            'scan_results': {
              'ru':
                  'Я вижу результаты вашего сканирования. Можете задавать любые вопросы об ингредиентах, безопасности или рекомендациях.',
              'uk':
                  'Я бачу результати вашого сканування. Можете ставити будь-які питання про інгредієнти, безпеку або рекомендації.',
              'es':
                  'Veo los resultados de tu escaneo. Puedes hacer cualquier pregunta sobre ingredientes, preocupaciones de seguridad o recomendaciones.',
              'en':
                  'I can see your scan results. Feel free to ask me any questions about the ingredients, safety concerns, or recommendations.',
              'de':
                  'Ich kann Ihre Scanergebnisse sehen. Fühlen Sie sich frei, mir Fragen zu den Inhaltsstoffen, Sicherheitsbedenken oder Empfehlungen zu stellen.',
              'fr':
                  'Je vois les résultats de votre analyse. N\'hésitez pas à me poser des questions sur les ingrédients, les problèmes de sécurité ou les recommandations.',
              'it':
                  'Vedo i risultati della tua scansione. Sentiti libero di farmi domande sugli ingredienti, preoccupazioni sulla sicurezza o raccomandazioni.',
            },
          },
          'scanning': {
            'analysis_prompt':
                'You are an expert cosmetic ingredient analyst.\n\nLANGUAGE: {{language_code}}\nIMPORTANT: ALL text in your response MUST be in the language specified by languageCode above. This includes:\n- humorous_message (if not cosmetic)\n- ALL hint fields for ingredients (high_risk, moderate_risk, low_risk)\n- personalized_warnings\n- benefits_analysis\n- recommended_alternatives (name, description, reason)\n\nSTEP 1: DETERMINE OBJECT TYPE\nFirst, carefully examine the image and determine if this is a cosmetic product label/packaging.\n\nCosmetic products include: creams, lotions, shampoos, soaps, makeup, perfumes, deodorants, sunscreens, skincare products, hair care products, etc.\n\nIf this is NOT a cosmetic product label:\n- Set "is_cosmetic_label" to false\n- Create a humorous, creative message (20-40 words) about how this object could be used for skincare/beauty in a funny way\n- IMPORTANT: The humorous message MUST be in the language {{language_code}}\n- Use emojis to make it fun! 😄\n- Leave all other fields empty/default\n\nIf this IS a cosmetic product label:\n- Set "is_cosmetic_label" to true\n- Proceed with full analysis below\n\nSTEP 2: FULL COSMETIC ANALYSIS (only if it\'s a cosmetic label):\n1. Extract ALL ingredient names from sections labeled \'Ingredients:\', \'INCI:\', or ingredient lists.\n2. For EACH ingredient, save BOTH:\n   - The ORIGINAL name as written on the label (in original language, e.g., Korean, Japanese, etc.)\n   - The TRANSLATED name in {{language_code}} for user understanding\n3. Analyze each ingredient\'s safety level considering the user\'s profile.\n4. Provide personalized warnings based on user\'s allergies and conditions.\n5. Calculate overall safety score (0-10 scale).\n6. Suggest benefits and alternative products.\n\nREQUIRED OUTPUT FORMAT (valid JSON only):\n{\n  "is_cosmetic_label": true/false,\n  "humorous_message": "😂 Your pizza box could make a great exfoliating face mask! Just add some olive oil and voilà! 🍕✨" (only if is_cosmetic_label is false, MUST be in {{language_code}}),\n  "ingredients": ["AQUA", "GLYCERIN", "CETYL ALCOHOL"],\n  "overall_safety_score": 8.5,\n  "high_risk_ingredients": [\n    {\n      "name": "FRAGRANCE",\n      "original_name": "香料" (the EXACT name as it appears on the product label, in original script/language),\n      "hint": "Can cause allergic reactions and skin irritation, especially for sensitive skin types. Contains undisclosed chemical compounds." (MUST be in {{language_code}})\n    },\n    {\n      "name": "ALCOHOL DENAT",\n      "original_name": "変性アルコール" (the EXACT name as it appears on the product label, in original script/language),\n      "hint": "May cause dryness and irritation, particularly problematic for dry or sensitive skin." (MUST be in {{language_code}})\n    }\n  ],\n  "moderate_risk_ingredients": [\n    {\n      "name": "PHENOXYETHANOL",\n      "original_name": "PHENOXYETHANOL" (if the label uses Latin/English script, keep it as-is),\n      "hint": "Generally safe preservative in small amounts, but may cause mild irritation in sensitive individuals." (MUST be in {{language_code}})\n    }\n  ],\n  "low_risk_ingredients": [\n    {\n      "name": "AQUA",\n      "original_name": "水" (or "AQUA" if already in Latin script),\n      "hint": "Water - completely safe base ingredient with no known risks." (MUST be in {{language_code}})\n    },\n    {\n      "name": "GLYCERIN",\n      "original_name": "グリセリン" (the EXACT name from label),\n      "hint": "Excellent humectant that attracts moisture to skin. Safe and beneficial for all skin types." (MUST be in {{language_code}})\n    },\n    {\n      "name": "CETYL ALCOHOL",\n      "original_name": "セチルアルコール" (the EXACT name from label),\n      "hint": "Fatty alcohol that acts as emollient and thickener. Safe and non-irritating despite the name." (MUST be in {{language_code}})\n    }\n  ],\n  "personalized_warnings": [\n    "Contains fragrance which may cause irritation for sensitive skin" (MUST be in {{language_code}})\n  ],\n  "benefits_analysis": "This product is formulated to hydrate and soothe the skin with gentle ingredients." (MUST be in {{language_code}}),\n  "recommended_alternatives": [\n    {\n      "name": "Gentle Cleanser" (MUST be in {{language_code}}),\n      "description": "Fragrance-free cleanser" (MUST be in {{language_code}}),\n      "reason": "Better for sensitive skin" (MUST be in {{language_code}})\n    }\n  ]\n}\n\nSAFETY CRITERIA:\n- HIGH RISK: Allergens from user allergy list, pregnancy/breastfeeding restrictions, harsh chemicals for user skin type\n- MODERATE RISK: Potentially irritating ingredients based on skin type\n\nFor each ingredient, provide a brief explanation (hint) in the language {{language_code}}:\n- For HIGH RISK ingredients: explain WHY it poses high risk (allergies, irritation, harmful effects)\n- For MODERATE RISK ingredients: explain WHY it poses moderate risk (potential concerns, conditions)\n- For LOW RISK ingredients: explain WHY it is safe (benefits, harmlessness, positive properties)\n\nKeep hints concise (20-60 words), informative, and in user-friendly language.\n\n{{user_profile}}',
            'non_cosmetic_messages': {
              'ru':
                  '😂 Эта коробка из-под пиццы могла бы стать отличной отшелушивающей маской для лица! Просто добавьте оливковое масло и вуаля! 🍕✨',
              'uk':
                  '😂 Ця коробка з-під піци могла б стати чудовим скрабом для обличчя! Просто додайте оливкову олію і вуаля! 🍕✨',
              'es':
                  '¡😂 Esta caja de pizza podría hacer una gran máscara exfoliante facial! Solo agrega aceite de oliva y voilà! 🍕✨',
              'en':
                  '😂 Your pizza box could make a great exfoliating face mask! Just add some olive oil and voilà! 🍕✨',
              'de':
                  '😂 Deine Pizzabox könnte eine großartige Gesichtspeelingmaske sein! Füge einfach etwas Olivenöl hinzu et voilà! 🍕✨',
              'fr':
                  '😂 Votre boîte à pizza pourrait faire un excellent masque de gommage pour le visage! Ajoutez simplement un peu d\'huile d\'olive et voilà! 🍕✨',
              'it':
                  '😂 La tua scatola della pizza potrebbe fare un\'ottima maschera esfoliante per il viso! Aggiungi solo un po\' d\'olio d\'oliva et voilà! 🍕✨',
            },
          },
        },
      };
      _isInitialized = true;
    }
  }

  /// Загрузка промптов из локального файла assets
  static Future<void> _loadLocalPrompts() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/config/prompts.json',
      );
      final Map<String, dynamic> data = json.decode(jsonString);
      _prompts = data;

      if (AppConfig().enableDebugMode) {
        debugPrint(
          'Loaded ${_prompts.length} prompt categories from local file',
        );
      }
    } catch (e) {
      debugPrint('Error loading local prompts: $e');
      rethrow;
    }
  }

  /// Получить промпт по ключу с поддержкой вложенности
  /// Пример: getPrompt('chat.system_prompts.default')
  static String? getPrompt(String key) {
    if (!_isInitialized) {
      debugPrint(
        'Warning: PromptsManager not initialized. Call initialize() first.',
      );
      return null;
    }

    final List<String> keys = key.split('.');
    dynamic currentValue = _prompts;

    for (final k in keys) {
      if (currentValue is Map<String, dynamic> && currentValue.containsKey(k)) {
        currentValue = currentValue[k];
      } else {
        if (AppConfig().enableDebugMode) {
          debugPrint('Prompt key not found: $key');
        }
        return null;
      }
    }

    return currentValue?.toString();
  }

  /// Получить промпт с подстановкой переменных
  /// Переменные указываются в формате {{variable_name}}
  static String? getPromptWithVariables(
    String key,
    Map<String, String> variables,
  ) {
    String? prompt = getPrompt(key);
    if (prompt == null) return null;

    variables.forEach((varKey, varValue) {
      prompt = prompt!.replaceAll('{{$varKey}}', varValue);
    });

    return prompt;
  }

  /// Получить системный промпт для чата
  static String? getChatSystemPrompt({String type = 'default'}) {
    return getPrompt('chat.system_prompts.$type');
  }

  /// Получить системный промпт с учетом дополнительного промпта
  static String? getChatSystemPromptWithCustom({
    String type = 'default',
    String? customPrompt,
    bool includeCustom = false,
  }) {
    String? basePrompt = getPrompt('chat.system_prompts.$type');
    if (basePrompt == null) return null;

    if (includeCustom && customPrompt != null && customPrompt.isNotEmpty) {
      return '$basePrompt\n\nAdditional instructions: $customPrompt';
    }

    return basePrompt;
  }

  /// Получить языковую инструкцию
  static String? getLanguageInstruction(String languageCode) {
    return getPrompt('chat.language_instructions.$languageCode');
  }

  /// Получить приветственное сообщение
  static String? getWelcomeMessage(String languageCode) {
    return getPrompt('chat.welcome_messages.$languageCode');
  }

  /// Получить приветственное сообщение с динамическим именем бота
  static String? getWelcomeMessageWithBotName(
    String languageCode,
    String botName,
  ) {
    String? message = getPrompt('chat.welcome_messages.$languageCode');
    if (message == null) return null;

    // Заменяем стандартное приветствие на персонализированное
    switch (languageCode) {
      case 'ru':
        return 'Привет! Я $botName — AI Косметический Сканер. Я помогу вам понять состав вашей косметики. У меня огромные знания в области косметологии и ухода. Я буду рад ответить на любые ваши вопросы.';
      case 'uk':
        return 'Привіт! Я $botName — AI Косметичний Сканер. Я допоможу вам зрозуміти склад вашої косметики. У мене великі знання в області косметології та догляду. Я буду радий відповісти на будь-які ваші запитання.';
      case 'es':
        return '¡Hola! Soy $botName — Escáner Cosmético IA. Te ayudaré a entender la composición de tus cosméticos. Tengo un gran conocimiento en cosmetología y cuidado. Estaré encantado de responder a todas tus preguntas.';
      case 'en':
        return 'Hi! I\'m $botName — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.';
      case 'de':
        return 'Hallo! Ich bin $botName — AI Kosmetik-Scanner. Ich helfe Ihnen, die Zusammensetzung Ihrer Kosmetikprodukte zu verstehen. Ich habe ein riesiges Wissen in der Kosmetologie und Pflege. Ich werde gerne alle Ihre Fragen beantworten.';
      case 'fr':
        return 'Bonjour ! Je suis $botName — Scanner Cosmétique IA. Je vais vous aider à comprendre la composition de vos cosmétiques. J\'ai une immense connaissance en cosmétologie et soins. Je serai ravi de répondre à toutes vos questions.';
      case 'it':
        return 'Ciao! Sono $botName — Scanner Cosmetico IA. Ti aiuterò a capire la composizione dei tuoi cosmetici. Ho una grande conoscenza in cosmetologia e cura. Sarò felice di rispondere a tutte le tue domande.';
      default:
        return message;
    }
  }

  /// Получить сообщение об ошибке
  static String? getErrorMessage(String languageCode) {
    return getPrompt('chat.error_messages.$languageCode');
  }

  /// Получить контекстное сообщение для результатов сканирования
  static String? getScanContextMessage(String languageCode) {
    return getPrompt('chat.context_messages.scan_results.$languageCode');
  }

  /// Получить промпт для анализа изображения
  static String? getScanningAnalysisPrompt() {
    return getPrompt('scanning.analysis_prompt');
  }

  /// Получить промпт для анализа изображения с подстановкой переменных
  static String? getScanningAnalysisPromptWithVariables(
    Map<String, String> variables,
  ) {
    return getPromptWithVariables('scanning.analysis_prompt', variables);
  }

  /// Получить забавное сообщение для не косметических продуктов
  static String? getNonCosmeticMessage(String languageCode) {
    return getPrompt('scanning.non_cosmetic_messages.$languageCode');
  }

  /// Проверить, содержит ли промпт переменные
  static bool hasVariables(String prompt) {
    final RegExp variableRegex = RegExp(r'\{\{[^}]+\}\}');
    return variableRegex.hasMatch(prompt);
  }

  /// Извлечь все переменные из промпта
  static List<String> extractVariables(String prompt) {
    final RegExp variableRegex = RegExp(r'\{\{([^}]+)\}\}');
    final Iterable<Match> matches = variableRegex.allMatches(prompt);
    return matches.map((match) => match.group(1)!).toList();
  }

  /// Получить все доступные ключи промптов
  static List<String> getAllPromptKeys() {
    List<String> keys = [];
    void collectKeys(Map<String, dynamic> map, String prefix) {
      map.forEach((key, value) {
        final fullKey = prefix.isEmpty ? key : '$prefix.$key';
        if (value is Map<String, dynamic>) {
          collectKeys(value, fullKey);
        } else {
          keys.add(fullKey);
        }
      });
    }

    collectKeys(_prompts, '');
    return keys;
  }

  /// Проверить инициализацию
  static bool get isInitialized => _isInitialized;

  /// Получить все промпты (для отладки)
  static Map<String, dynamic> get allPrompts => Map.unmodifiable(_prompts);
}
