import 'package:flutter/foundation.dart';

/// Error handling utility for consistent error management
class ErrorHandler {
  /// Log an error with a context label
  static void logError(String context, dynamic error, [StackTrace? stackTrace]) {
    debugPrint('=== $context: $error ===');
    if (stackTrace != null) {
      debugPrint('=== Stack trace: $stackTrace ===');
    }
  }

  /// Log a warning message
  static void logWarning(String context, String message) {
    debugPrint('=== WARNING $context: $message ===');
  }

  /// Log a debug message
  static void logDebug(String context, String message) {
    debugPrint('=== DEBUG $context: $message ===');
  }

  /// Log a success message
  static void logSuccess(String context, String message) {
    debugPrint('=== SUCCESS $context: $message ===');
  }

  /// Handle error with optional callback
  static void handleError({
    required String context,
    required dynamic error,
    StackTrace? stackTrace,
    VoidCallback? onError,
  }) {
    logError(context, error, stackTrace);
    onError?.call();
  }

  /// Safe try-catch wrapper
  static Future<T?> tryCatch<T>({
    required String context,
    required Future<T> Function() operation,
    T? fallbackValue,
    bool logError = true,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      if (logError) {
        ErrorHandler.logError(context, e, stackTrace);
      }
      return fallbackValue;
    }
  }

  /// Synchronous try-catch wrapper
  static T? tryCatchSync<T>({
    required String context,
    required T Function() operation,
    T? fallbackValue,
    bool logError = true,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      if (logError) {
        ErrorHandler.logError(context, e, stackTrace);
      }
      return fallbackValue;
    }
  }
}
