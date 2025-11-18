class AppConstants {
  // App Info
  static const String appName = 'AI Background Remover';
  static const String appVersion = '1.0.0';

  // Image Processing
  static const int maxImageSize = 4096;
  static const int thumbnailSize = 512;
  static const int jpegQuality = 95;

  // Database
  static const String dbName = 'background_remover.db';
  static const int dbVersion = 1;

  // Premium Features
  static const int freeProcessingLimit = 5;
  static const int premiumProcessingLimit = -1; // unlimited

  // Processing Options
  static const List<String> processingModes = [
    'Remove Background',
    'Remove Object',
    'Auto Enhance',
    'Smart Erase',
  ];

  // Export Formats
  static const List<String> exportFormats = [
    'PNG (Transparent)',
    'JPG (White BG)',
    'JPG (Custom BG)',
  ];

  // Background Options
  static const List<String> backgroundOptions = [
    'Transparent',
    'White',
    'Black',
    'Gradient',
    'Custom Color',
    'Custom Image',
  ];
}
