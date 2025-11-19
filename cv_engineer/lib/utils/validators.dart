/// Validators for form fields
class Validators {
  /// Validates email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Empty is valid, field is optional
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Empty is valid, field is optional
    }

    // Remove common separators
    final cleanedPhone = value.replaceAll(RegExp(r'[\s\-\(\)\+]'), '');

    // Check if it contains only digits and has reasonable length
    if (!RegExp(r'^\d{7,15}$').hasMatch(cleanedPhone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates URL
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Empty is valid, field is optional
    }

    try {
      final uri = Uri.parse(value.trim());

      // Check if it has a valid scheme or add https:// if missing
      if (!uri.hasScheme) {
        // Try with https prefix
        final uriWithScheme = Uri.parse('https://$value');
        if (!uriWithScheme.hasAuthority) {
          return 'Please enter a valid URL';
        }
        return null;
      }

      // Check if it has a valid scheme and authority
      if ((uri.scheme == 'http' || uri.scheme == 'https') && uri.hasAuthority) {
        return null;
      }

      return 'Please enter a valid URL';
    } catch (e) {
      return 'Please enter a valid URL';
    }
  }

  /// Validates LinkedIn URL
  static String? validateLinkedIn(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Empty is valid, field is optional
    }

    final linkedInPattern = RegExp(
      r'^(https?://)?(www\.)?linkedin\.com/in/[a-zA-Z0-9\-]+/?$',
      caseSensitive: false,
    );

    // Also accept just the username
    final usernamePattern = RegExp(
      r'^[a-zA-Z0-9\-]+$',
    );

    if (linkedInPattern.hasMatch(value.trim()) || usernamePattern.hasMatch(value.trim())) {
      return null;
    }

    return 'Please enter a valid LinkedIn profile URL or username';
  }

  /// Validates GitHub URL
  static String? validateGitHub(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Empty is valid, field is optional
    }

    final githubPattern = RegExp(
      r'^(https?://)?(www\.)?github\.com/[a-zA-Z0-9\-]+/?$',
      caseSensitive: false,
    );

    // Also accept just the username
    final usernamePattern = RegExp(
      r'^[a-zA-Z0-9\-]+$',
    );

    if (githubPattern.hasMatch(value.trim()) || usernamePattern.hasMatch(value.trim())) {
      return null;
    }

    return 'Please enter a valid GitHub profile URL or username';
  }

  /// Validates that a string is not empty
  static String? validateRequired(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates minimum length
  static String? validateMinLength(String? value, int minLength, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Let required validator handle empty
    }

    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Validates maximum length
  static String? validateMaxLength(String? value, int maxLength, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Let required validator handle empty
    }

    if (value.trim().length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }

    return null;
  }

  /// Combines multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }
}
