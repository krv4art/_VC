/// Application configuration
/// Contains app-wide settings and constants
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // ==================== APP INFO ====================
  static const String appName = 'AI PDF Scanner';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // ==================== PDF SETTINGS ====================

  /// Maximum file size for PDF upload (in bytes)
  /// Default: 50 MB
  static const int maxPdfFileSize = 50 * 1024 * 1024;

  /// Default PDF quality (0-100)
  static const int defaultPdfQuality = 85;

  /// Default PDF compression level
  static const PdfCompressionLevel defaultCompressionLevel =
      PdfCompressionLevel.medium;

  // ==================== SCANNER SETTINGS ====================

  /// Default image quality for scanned documents (0-100)
  static const int defaultScanQuality = 90;

  /// Maximum number of pages per scan session
  static const int maxPagesPerScan = 50;

  /// Auto-enhance scanned images by default
  static const bool autoEnhanceScans = true;

  /// Auto-detect edges by default
  static const bool autoDetectEdges = true;

  // ==================== AI SETTINGS ====================

  /// Enable AI features by default
  static const bool aiEnabledByDefault = true;

  /// Auto-OCR on scanned documents
  static const bool autoOCR = true;

  /// Auto-classify documents
  static const bool autoClassify = true;

  /// AI confidence threshold (0-1)
  static const double aiConfidenceThreshold = 0.7;

  // ==================== STORAGE SETTINGS ====================

  /// Local storage path for PDF files
  static const String localPdfPath = 'pdf_documents';

  /// Local storage path for thumbnails
  static const String localThumbnailPath = 'thumbnails';

  /// Auto-cleanup old files after days
  static const int autoCleanupDays = 30;

  // ==================== UI SETTINGS ====================

  /// Default theme mode
  static const bool darkModeByDefault = false;

  /// Animation duration in milliseconds
  static const int animationDuration = 200;

  /// Show onboarding on first launch
  static const bool showOnboarding = true;
}

/// PDF compression levels
enum PdfCompressionLevel {
  low,
  medium,
  high,
  maximum,
}

extension PdfCompressionLevelExtension on PdfCompressionLevel {
  /// Get compression quality (0-100)
  int get quality {
    switch (this) {
      case PdfCompressionLevel.low:
        return 90;
      case PdfCompressionLevel.medium:
        return 75;
      case PdfCompressionLevel.high:
        return 60;
      case PdfCompressionLevel.maximum:
        return 40;
    }
  }

  /// Get display name
  String get displayName {
    switch (this) {
      case PdfCompressionLevel.low:
        return 'Low (Best Quality)';
      case PdfCompressionLevel.medium:
        return 'Medium';
      case PdfCompressionLevel.high:
        return 'High';
      case PdfCompressionLevel.maximum:
        return 'Maximum (Smallest Size)';
    }
  }
}
