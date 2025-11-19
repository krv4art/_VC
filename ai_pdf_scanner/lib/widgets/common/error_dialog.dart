import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../exceptions/app_exception.dart';

/// Error dialog widget for displaying errors to users
class ErrorDialog {
  ErrorDialog._();

  /// Show error dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onDismiss,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(title),
            ),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }

  /// Show error from exception
  static Future<void> showFromException(
    BuildContext context,
    AppException exception, {
    VoidCallback? onDismiss,
  }) {
    return show(
      context,
      title: 'Error',
      message: exception.userMessage,
      onDismiss: onDismiss,
    );
  }

  /// Show network error
  static Future<void> showNetworkError(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.orange),
            SizedBox(width: AppDimensions.space12),
            Text('Network Error'),
          ],
        ),
        content: const Text(
          'Please check your internet connection and try again.',
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
