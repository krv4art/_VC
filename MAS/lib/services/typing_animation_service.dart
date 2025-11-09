import 'dart:async';
import 'package:flutter/material.dart';

/// Service for handling text typing animations
/// Manages the gradual display of text, character by character
class TypingAnimationService {
  final Map<int, String> _typingTexts = {};
  final Map<int, int> _typingProgress = {};
  Timer? _typingTimer;

  /// Get the current display text for a message based on typing progress
  String getDisplayText(int messageIndex, String fullText) {
    // If typing is in progress
    if (_typingProgress.containsKey(messageIndex) &&
        _typingTexts.containsKey(messageIndex)) {
      final progress = _typingProgress[messageIndex]!;
      final text = _typingTexts[messageIndex]!;
      return text.substring(0, progress.clamp(0, text.length));
    }

    // If typing is complete but animation data still exists
    if (fullText.isEmpty &&
        _typingTexts.containsKey(messageIndex) &&
        !_typingProgress.containsKey(messageIndex)) {
      return _typingTexts[messageIndex]!;
    }

    return fullText;
  }

  /// Start typing animation for a message
  /// Returns a callback to be called on each frame
  Function(VoidCallback updateUI) startTyping(
    int messageIndex,
    String fullText,
    VoidCallback onAnimationStateChange,
  ) {
    _typingTexts[messageIndex] = fullText;
    _typingProgress[messageIndex] = 0;

    _typingTimer?.cancel();

    onAnimationStateChange();

    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      final currentProgress = _typingProgress[messageIndex] ?? 0;

      if (currentProgress >= fullText.length) {
        timer.cancel();
        _typingTexts.remove(messageIndex);
        _typingProgress.remove(messageIndex);
        onAnimationStateChange();
        return;
      }

      _typingProgress[messageIndex] = currentProgress + 1;
      onAnimationStateChange();
    });

    return (VoidCallback updateUI) {
      updateUI();
    };
  }

  /// Get full text for a message (either from progress or from message text)
  String getFullText(int messageIndex, String messageText) {
    return _typingTexts.containsKey(messageIndex)
        ? _typingTexts[messageIndex]!
        : messageText;
  }

  /// Check if typing animation is in progress for a message
  bool isTypingInProgress(int messageIndex) {
    return _typingProgress.containsKey(messageIndex);
  }

  /// Cancel all typing animations
  void cancelAll() {
    _typingTimer?.cancel();
    _typingTexts.clear();
    _typingProgress.clear();
  }

  /// Dispose the service (clean up resources)
  void dispose() {
    cancelAll();
  }
}
