/// Application-wide constants
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ==================== APP STORE LINKS ====================

  /// Google Play Store package ID
  /// TODO: Replace with your actual Google Play package ID before publishing
  /// Format: com.yourcompany.plantidentifier
  static const String androidPackageId = 'com.plantidentifier.app';

  /// Google Play Store URL for rating
  static String get googlePlayUrl =>
      'https://play.google.com/store/apps/details?id=$androidPackageId';

  /// Apple App Store ID
  /// TODO: Replace with your actual App Store ID after app is published
  static const String appleAppStoreId = '0000000000';

  /// Apple App Store URL for rating
  static String get appStoreUrl =>
      'https://apps.apple.com/app/id$appleAppStoreId';

  // ==================== EXTERNAL LINKS ====================

  /// Privacy Policy URL
  /// TODO: Add your privacy policy URL
  static const String privacyPolicyUrl = 'https://yourwebsite.com/privacy';

  /// Terms of Service URL
  /// TODO: Add your terms of service URL
  static const String termsOfServiceUrl = 'https://yourwebsite.com/terms';

  /// Support/Contact URL
  /// TODO: Add your support URL or email
  static const String supportUrl = 'https://yourwebsite.com/support';

  // ==================== RATING SYSTEM ====================

  /// Minimum rating to redirect to store (5 stars)
  static const int minRatingForStore = 5;

  /// Rating threshold for showing feedback form (1-4 stars)
  static const int maxRatingForFeedback = 4;

  // ==================== API ENDPOINTS ====================

  /// Feedback submission endpoint (optional)
  /// TODO: Add your backend endpoint for feedback submission
  static const String feedbackEndpoint = '';

  // ==================== FEATURE FLAGS ====================

  /// Enable feedback submission to backend
  static const bool enableFeedbackSubmission = false;

  /// Enable analytics tracking
  static const bool enableAnalytics = false;
}
