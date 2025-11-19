import 'package:intl/intl.dart';

/// Utility functions for time formatting
class TimeUtils {
  /// Format a DateTime to show relative time (e.g., "2m ago", "3h ago")
  /// or absolute date for older entries
  static String formatLastEdited(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(dateTime);
    }
  }

  /// Format DateTime to readable string (e.g., "Jan 15, 2024")
  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  /// Format DateTime to long readable string (e.g., "January 15, 2024")
  static String formatLongDate(DateTime dateTime) {
    return DateFormat('MMMM d, yyyy').format(dateTime);
  }

  /// Format DateTime to include time (e.g., "Jan 15, 2024 at 3:45 PM")
  static String formatDateWithTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy \'at\' h:mm a').format(dateTime);
  }
}
