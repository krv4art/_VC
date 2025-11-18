/// Base exception for API errors
abstract class ApiException implements Exception {
  final String message;
  final String? technicalDetails;

  ApiException({required this.message, this.technicalDetails});

  @override
  String toString() => message;
}

/// Network-related errors (no internet, DNS failure, etc.)
class NetworkException extends ApiException {
  NetworkException({String? technicalDetails})
      : super(
          message: 'Network error. Please check your internet connection.',
          technicalDetails: technicalDetails,
        );
}

/// Rate limiting errors (429 Too Many Requests)
class RateLimitException extends ApiException {
  RateLimitException({String? technicalDetails})
      : super(
          message: 'Too many requests. Please try again later.',
          technicalDetails: technicalDetails,
        );
}

/// Service overload errors (503 Service Unavailable)
class ServiceOverloadedException extends ApiException {
  ServiceOverloadedException({String? technicalDetails})
      : super(
          message: 'Service is temporarily unavailable. Please try again later.',
          technicalDetails: technicalDetails,
        );
}

/// Authentication errors (401 Unauthorized, 403 Forbidden)
class AuthenticationException extends ApiException {
  AuthenticationException({String? technicalDetails})
      : super(
          message: 'Authentication failed. Please check your API key.',
          technicalDetails: technicalDetails,
        );
}

/// Timeout errors
class TimeoutException extends ApiException {
  TimeoutException({String? technicalDetails})
      : super(
          message: 'Request timed out. Please try again.',
          technicalDetails: technicalDetails,
        );
}

/// Invalid response errors (malformed JSON, unexpected format)
class InvalidResponseException extends ApiException {
  InvalidResponseException({String? technicalDetails})
      : super(
          message: 'Received invalid response from server.',
          technicalDetails: technicalDetails,
        );
}

/// General server errors (500 Internal Server Error)
class ServerException extends ApiException {
  ServerException({String? technicalDetails})
      : super(
          message: 'Server error occurred. Please try again later.',
          technicalDetails: technicalDetails,
        );
}

/// Content policy violation errors
class ContentPolicyException extends ApiException {
  ContentPolicyException({String? technicalDetails})
      : super(
          message: 'Content violates policy. Please try different content.',
          technicalDetails: technicalDetails,
        );
}
