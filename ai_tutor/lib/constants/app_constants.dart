/// Application constants
class AppConstants {
  // App info
  static const String appName = 'AI Tutor';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Personalized learning with cultural themes';

  // Storage keys
  static const String userProfileKey = 'user_profile';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String themeKey = 'theme_id';

  // Limits
  static const int maxInterestsSelection = 5;
  static const int minInterestsSelection = 1;
  static const int maxChatHistory = 20;
  static const int maxMessageLength = 5000;

  // UI
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 150);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Free tier limits
  static const int freeMessagesPerDay = 10;
  static const int freeSubjects = 2;
}
