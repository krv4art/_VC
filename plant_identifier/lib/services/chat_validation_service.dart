import 'package:flutter/foundation.dart';

/// Service for validating chat operations
class ChatValidationService {
  /// Check if a message is valid (non-empty)
  static bool isMessageValid(String text) {
    return text.trim().isNotEmpty;
  }

  /// Check if a user can send a message
  /// For plant identifier, we allow unlimited messages
  static Future<bool> canUserSendMessage({required bool isPremium}) async {
    // For now, allow unlimited messages for all users
    // This can be extended with usage tracking in the future
    return true;
  }

  /// Get remaining message count
  /// For plant identifier, return unlimited (-1)
  static Future<int> getRemainingMessageCount() async {
    // Return -1 to indicate unlimited messages
    return -1;
  }

  /// Validate dialogue ID
  static bool isDialogueIdValid(int? dialogueId) {
    return dialogueId != null && dialogueId > 0;
  }

  /// Validate plant result ID
  static bool isPlantResultIdValid(String? plantResultId) {
    return plantResultId != null && plantResultId.isNotEmpty;
  }
}
