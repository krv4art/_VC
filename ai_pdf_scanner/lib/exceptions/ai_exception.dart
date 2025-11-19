import 'app_exception.dart';

/// Base exception for AI-related errors
abstract class AIException extends AppException {
  AIException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for AI API errors
class AIAPIException extends AIException {
  final int? statusCode;
  final String? apiMessage;

  AIAPIException(
    super.message, {
    this.statusCode,
    this.apiMessage,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage {
    if (statusCode == 429) {
      return 'AI service rate limit reached. Please try again later';
    } else if (statusCode != null && statusCode! >= 500) {
      return 'AI service is temporarily unavailable';
    }
    return 'AI processing failed. Please try again';
  }
}

/// Exception for AI quota/limit exceeded
class AIQuotaExceededException extends AIException {
  final String? quotaType;

  AIQuotaExceededException(
    super.message, {
    this.quotaType,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      quotaType != null
          ? 'AI quota exceeded for $quotaType'
          : 'AI usage limit reached';
}

/// Exception for OCR errors
class OCRException extends AIException {
  final String? imageId;

  OCRException(
    super.message, {
    this.imageId,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Text recognition failed. Please try again';
}

/// Exception for AI image processing errors
class AIImageProcessingException extends AIException {
  AIImageProcessingException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Image processing failed: $message';
}

/// Exception for AI classification errors
class AIClassificationException extends AIException {
  AIClassificationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Document classification failed';
}

/// Exception for AI model loading errors
class AIModelException extends AIException {
  final String? modelName;

  AIModelException(
    super.message, {
    this.modelName,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      'AI model error${modelName != null ? ' ($modelName)' : ''}';
}

/// Exception for invalid AI input
class AIInvalidInputException extends AIException {
  final String? inputType;

  AIInvalidInputException(
    super.message, {
    this.inputType,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      inputType != null
          ? 'Invalid $inputType for AI processing'
          : 'Invalid input for AI processing';

  @override
  bool get shouldReport => false;
}

/// Exception for AI timeout
class AITimeoutException extends AIException {
  final Duration? timeout;

  AITimeoutException(
    super.message, {
    this.timeout,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      'AI processing timed out. Please try with a smaller file';
}

/// Exception for AI configuration errors
class AIConfigurationException extends AIException {
  AIConfigurationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'AI service configuration error';
}

/// Exception for unsupported AI features
class AIUnsupportedFeatureException extends AIException {
  final String feature;

  AIUnsupportedFeatureException(
    this.feature, {
    super.code,
    super.originalError,
    super.stackTrace,
  }) : super('Unsupported AI feature: $feature');

  @override
  String get userMessage => 'AI feature not available: $feature';

  @override
  bool get shouldReport => false;
}
