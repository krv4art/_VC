import '../exceptions/api_exceptions.dart';
import '../l10n/app_localizations.dart';

/// Utility for localizing error messages
class ErrorMessageLocalizer {
  const ErrorMessageLocalizer();

  /// Returns a localized error message based on exception type
  static String getLocalizedMessage(ApiException e, AppLocalizations l10n) {
    if (e is ServiceOverloadedException) {
      return l10n.errorServiceOverloaded;
    } else if (e is RateLimitException) {
      return l10n.errorRateLimitExceeded;
    } else if (e is TimeoutException) {
      return l10n.errorTimeout;
    } else if (e is NetworkException) {
      return l10n.errorNetwork;
    } else if (e is AuthenticationException) {
      return l10n.errorAuthentication;
    } else if (e is InvalidResponseException) {
      return l10n.errorInvalidResponse;
    } else if (e is ServerException) {
      return l10n.errorServer;
    }
    return l10n.analysisFailed;
  }
}
