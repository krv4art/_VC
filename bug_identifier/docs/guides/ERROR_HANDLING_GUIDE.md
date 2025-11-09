# Error Handling Guide

## Overview

This guide describes the error handling system implemented in the ACS (AI Cosmetic Scanner) application. The system provides user-friendly error messages without exposing technical implementation details.

## Architecture

### Custom Exception Classes

Location: `lib/exceptions/api_exceptions.dart`

The application uses custom exception classes to categorize different types of API errors:

#### Base Exception
- **`ApiException`**: Base class for all API-related exceptions
  - Contains user-facing message and optional technical details
  - Used for pattern matching and type checking

#### Specific Exceptions

1. **`ServiceOverloadedException`**
   - **When**: API service is temporarily overloaded or at capacity
   - **Triggers**: Error messages containing "overload", "capacity", "too many requests", or "resource exhausted"
   - **User sees**: Friendly message asking to try again in a moment

2. **`RateLimitException`**
   - **When**: API rate limit is exceeded (HTTP 429)
   - **Triggers**: Error messages containing "rate limit", "quota", or HTTP status 429
   - **User sees**: Message about too many requests with suggestion to wait

3. **`TimeoutException`**
   - **When**: Request times out or deadline is exceeded
   - **Triggers**: Error messages containing "timeout" or "deadline exceeded"
   - **User sees**: Message asking to check internet connection

4. **`NetworkException`**
   - **When**: Network connectivity issues
   - **Triggers**: Connection failures, network errors
   - **User sees**: Message about network error

5. **`AuthenticationException`**
   - **When**: Authentication or authorization fails (HTTP 401/403)
   - **Triggers**: Error messages containing "authentication", "unauthorized", "forbidden", or HTTP status 401/403
   - **User sees**: Message asking to restart the app

6. **`InvalidResponseException`**
   - **When**: Response format is invalid or malformed
   - **Triggers**: Error messages containing "invalid", "malformed", or "parse error"
   - **User sees**: Message about invalid response

7. **`ServerException`**
   - **When**: Generic server error (catch-all)
   - **Triggers**: Any other server error
   - **User sees**: Generic server error message

## Implementation

### Service Layer (GeminiService)

**File**: `lib/services/gemini_service.dart`

The `GeminiService` class analyzes error responses and throws appropriate custom exceptions:

```dart
ApiException _parseApiError(String errorMessage, int statusCode) {
  final errorLower = errorMessage.toLowerCase();

  // Check for overload/capacity errors
  if (errorLower.contains('overload') ||
      errorLower.contains('capacity') ||
      errorLower.contains('too many requests') ||
      errorLower.contains('resource exhausted')) {
    return ServiceOverloadedException(technicalDetails: errorMessage);
  }

  // ... other checks ...

  // Default to server exception
  return ServerException(technicalDetails: errorMessage);
}
```

**Key Points**:
- Error parsing is case-insensitive
- Technical details are preserved for debugging
- Network exceptions are thrown for general connection issues
- Custom exceptions are re-thrown if already caught

### UI Layer (ScanningScreen)

**File**: `lib/screens/scanning_screen.dart`

The UI layer catches custom exceptions and displays localized messages:

```dart
try {
  // ... image analysis ...
} on ApiException catch (e) {
  if (!mounted) return;
  final l10n = AppLocalizations.of(context)!;
  _showError(_getLocalizedErrorMessage(e, l10n));
} catch (e) {
  if (!mounted) return;
  final l10n = AppLocalizations.of(context)!;
  _showError(l10n.analysisFailed);
}
```

**Translation Method**:
```dart
String _getLocalizedErrorMessage(ApiException e, AppLocalizations l10n) {
  if (e is ServiceOverloadedException) {
    return l10n.errorServiceOverloaded;
  } else if (e is RateLimitException) {
    return l10n.errorRateLimitExceeded;
  }
  // ... other checks ...
  return l10n.analysisFailed;
}
```

## Localization

All error messages are fully localized in 7 languages:

| Language | Code | File |
|----------|------|------|
| English | en | `lib/l10n/app_en.arb` |
| Russian | ru | `lib/l10n/app_ru.arb` |
| Ukrainian | uk | `lib/l10n/app_uk.arb` |
| Spanish | es | `lib/l10n/app_es.arb` |
| German | de | `lib/l10n/app_de.arb` |
| French | fr | `lib/l10n/app_fr.arb` |
| Italian | it | `lib/l10n/app_it.arb` |

### Translation Keys

| Key | English Message | Purpose |
|-----|----------------|---------|
| `errorServiceOverloaded` | "Service is temporarily busy. Please try again in a moment." | Service overload |
| `errorRateLimitExceeded` | "Too many requests. Please wait a moment and try again." | Rate limiting |
| `errorTimeout` | "Request timed out. Please check your internet connection and try again." | Timeout |
| `errorNetwork` | "Network error. Please check your internet connection." | Network issues |
| `errorAuthentication` | "Authentication error. Please restart the app." | Auth failures |
| `errorInvalidResponse` | "Invalid response received. Please try again." | Invalid data |
| `errorServer` | "Server error. Please try again later." | Generic errors |

### Example: Service Overload Messages

- **English**: "Service is temporarily busy. Please try again in a moment."
- **Russian**: "Сервис временно перегружен. Попробуйте через несколько секунд."
- **Ukrainian**: "Сервіс тимчасово перевантажений. Спробуйте через кілька секунд."
- **Spanish**: "El servicio está temporalmente ocupado. Inténtelo de nuevo en un momento."
- **German**: "Der Dienst ist vorübergehend ausgelastet. Bitte versuchen Sie es in einem Moment erneut."
- **French**: "Le service est temporairement occupé. Veuillez réessayer dans un instant."
- **Italian**: "Il servizio è temporaneamente occupato. Riprova tra un momento."

## Benefits

1. **User-Friendly**: Technical jargon and implementation details (like "Gemini API") are hidden
2. **Localized**: All messages available in 7 languages
3. **Actionable**: Messages provide clear guidance on what to do
4. **Debuggable**: Technical details preserved for logging and debugging
5. **Maintainable**: Centralized exception handling makes updates easy
6. **Extensible**: Easy to add new exception types

## Adding New Error Types

To add a new error type:

1. **Create Exception Class** in `lib/exceptions/api_exceptions.dart`:
   ```dart
   class NewErrorException extends ApiException {
     NewErrorException({String? technicalDetails})
         : super('new_error_key', technicalDetails: technicalDetails);
   }
   ```

2. **Add Parsing Logic** in `GeminiService._parseApiError()`:
   ```dart
   if (errorLower.contains('new_error_pattern')) {
     return NewErrorException(technicalDetails: errorMessage);
   }
   ```

3. **Add Translation Handling** in `_ScanningScreenState._getLocalizedErrorMessage()`:
   ```dart
   else if (e is NewErrorException) {
     return l10n.errorNewError;
   }
   ```

4. **Add Translations** to all `.arb` files:
   ```json
   "errorNewError": "Your localized message here."
   ```

5. **Regenerate Localizations**:
   ```bash
   flutter gen-l10n
   ```

## Testing Recommendations

1. **Unit Tests**: Test error parsing logic with various error messages
2. **Integration Tests**: Verify exceptions are properly thrown from service layer
3. **UI Tests**: Confirm correct localized messages are displayed
4. **Manual Testing**: Test with simulated network issues, timeouts, etc.

## Best Practices

1. **Never expose technical details** to end users
2. **Always check `mounted`** before showing errors in Flutter
3. **Log technical details** for debugging while showing friendly messages
4. **Provide actionable guidance** in error messages
5. **Keep translations consistent** across all languages
6. **Handle unknown errors gracefully** with fallback messages

## Future Improvements

- Add retry logic with exponential backoff
- Implement error reporting/telemetry
- Add user-facing error codes for support
- Create error analytics dashboard
- Add contextual help links in error messages
