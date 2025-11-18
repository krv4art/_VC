/// Константы приложения
class AppConstants {
  // API & Timeouts
  static const Duration apiTimeout = Duration(seconds: 60);
  static const Duration chatTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;

  // Image Compression
  static const int compressionQuality = 85;
  static const int maxImageWidth = 1280;
  static const int maxImageHeight = 1280;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double appBarHeight = 56.0;

  // Chat
  static const int maxChatHistory = 50;
  static const int maxChatMessageLength = 1000;

  // Storage & Limits
  static const int maxAnalysesInHistory = 100;
  static const String analysisTableName = 'antique_analyses';
  static const String dialogueTableName = 'dialogues';
  static const String messageTableName = 'chat_messages';
  static const String storageBucketName = 'antique_photos';

  // Supported Languages
  static const List<String> supportedLanguages = [
    'en',
    'ru',
    'uk',
    'es',
    'de',
    'fr',
    'it',
    'pt',
    'ja',
    'zh',
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ru': 'Русский',
    'uk': 'Українська',
    'es': 'Español',
    'de': 'Deutsch',
    'fr': 'Français',
    'it': 'Italiano',
    'pt': 'Português',
    'ja': '日本語',
    'zh': '中文',
  };

  // API Endpoints
  static const String supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String geminiVisionEndpoint =
      '$supabaseUrl/functions/v1/gemini-vision-proxy';
  static const String geminiChatEndpoint =
      '$supabaseUrl/functions/v1/gemini-proxy';

  // Precision & Accuracy
  static const double minConfidenceThreshold = 0.5;
  static const List<String> defaultWarnings = [
    'This valuation is estimated based on visual inspection and may not reflect actual market value',
    'Professional appraisal recommended before selling at auction',
    'Condition and any restoration work significantly affect value',
    'Market values vary by region and current demand',
  ];
}

/// Маршруты приложения
class AppRoutes {
  static const String home = '/';
  static const String scan = '/scan';
  static const String results = '/results';
  static const String chat = '/chat';
  static const String history = '/history';
  static const String settings = '/settings';
}
