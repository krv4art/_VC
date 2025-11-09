import 'package:flutter/foundation.dart';
import 'usage_tracking_service.dart';

/// Service for validating chat operations
class ChatValidationService {
  /// Check if a message is valid (non-empty)
  static bool isMessageValid(String text) {
    return text.trim().isNotEmpty;
  }

  /// Check if a user can send a message (respects daily limits for free users)
  static Future<bool> canUserSendMessage({required bool isPremium}) async {
    if (isPremium) {
      return true; // Premium users have no limits
    }

    try {
      final canSend = await UsageTrackingService().canUserSendMessage();
      debugPrint('=== CHAT VALIDATION: canUserSendMessage = $canSend ===');
      return canSend;
    } catch (e) {
      debugPrint('=== CHAT VALIDATION: Error checking message limit: $e ===');
      // Default to allow on error (fail open)
      return true;
    }
  }

  /// Get remaining message count for free users
  static Future<int> getRemainingMessageCount() async {
    try {
      final remaining =
          await UsageTrackingService().getRemainingMessageCount();
      return remaining;
    } catch (e) {
      debugPrint('=== CHAT VALIDATION: Error getting remaining count: $e ===');
      return 0;
    }
  }

  /// Validate dialogue ID
  static bool isDialogueIdValid(int? dialogueId) {
    return dialogueId != null && dialogueId > 0;
  }

  /// Validate scan result ID
  static bool isScanResultIdValid(int? scanResultId) {
    return scanResultId != null && scanResultId > 0;
  }
}
