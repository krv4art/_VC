/// Custom exceptions for API errors
///
/// These exceptions provide user-friendly error messages without exposing
/// technical implementation details like "Gemini" or "API" to end users.
library;

/// Base class for all API-related exceptions
class ApiException implements Exception {
  final String message;
  final String? technicalDetails;

  ApiException(this.message, {this.technicalDetails});

  @override
  String toString() => message;
}

/// Exception thrown when the AI service is temporarily overloaded
class ServiceOverloadedException extends ApiException {
  ServiceOverloadedException({String? technicalDetails})
      : super(
          'service_overloaded',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown when there's a network connectivity issue
class NetworkException extends ApiException {
  NetworkException({String? technicalDetails})
      : super(
          'network_error',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown when the request times out
class TimeoutException extends ApiException {
  TimeoutException({String? technicalDetails})
      : super(
          'timeout_error',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown when the API rate limit is exceeded
class RateLimitException extends ApiException {
  RateLimitException({String? technicalDetails})
      : super(
          'rate_limit_exceeded',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown when there's an authentication/authorization issue
class AuthenticationException extends ApiException {
  AuthenticationException({String? technicalDetails})
      : super(
          'authentication_error',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown when the response format is invalid
class InvalidResponseException extends ApiException {
  InvalidResponseException({String? technicalDetails})
      : super(
          'invalid_response',
          technicalDetails: technicalDetails,
        );
}

/// Exception thrown for any other server errors
class ServerException extends ApiException {
  ServerException({String? technicalDetails})
      : super(
          'server_error',
          technicalDetails: technicalDetails,
        );
}
