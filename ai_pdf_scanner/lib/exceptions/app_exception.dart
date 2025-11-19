/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    var str = 'AppException: $message';
    if (code != null) str += ' (Code: $code)';
    if (originalError != null) str += '\nOriginal Error: $originalError';
    return str;
  }

  /// User-friendly error message for display
  String get userMessage => message;

  /// Whether this error should be logged to analytics
  bool get shouldLog => true;

  /// Whether this error should be reported to crash reporting service
  bool get shouldReport => true;
}

/// Exception for network-related errors
class NetworkException extends AppException {
  NetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Network error: Please check your internet connection';
}

/// Exception for storage/file system errors
class StorageException extends AppException {
  StorageException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Storage error: $message';
}

/// Exception for database errors
class DatabaseException extends AppException {
  DatabaseException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Database error occurred';
}

/// Exception for validation errors
class ValidationException extends AppException {
  ValidationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => message;

  @override
  bool get shouldReport => false; // Validation errors are expected
}

/// Exception for permission-related errors
class PermissionException extends AppException {
  final String permissionType;

  PermissionException(
    super.message, {
    required this.permissionType,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage =>
      'Permission required: Please grant $permissionType permission in settings';
}

/// Exception for configuration errors
class ConfigurationException extends AppException {
  ConfigurationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Configuration error: Please try again later';
}

/// Exception for unsupported operations
class UnsupportedOperationException extends AppException {
  UnsupportedOperationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String get userMessage => 'Operation not supported: $message';

  @override
  bool get shouldReport => false;
}
