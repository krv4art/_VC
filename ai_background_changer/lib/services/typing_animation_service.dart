import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service for animating text typing effect
class TypingAnimationService {
  static final TypingAnimationService _instance = TypingAnimationService._internal();
  factory TypingAnimationService() => _instance;
  TypingAnimationService._internal();

  final Map<String, StreamController<String>> _controllers = {};
  final Map<String, Timer?> _timers = {};

  // Characters per interval for typing effect
  static const int _charsPerInterval = 2;
  static const Duration _typingInterval = Duration(milliseconds: 30);

  /// Start typing animation for a message
  Stream<String> animateTyping(String messageId, String fullText) {
    // Cancel existing animation if any
    cancelAnimation(messageId);

    final controller = StreamController<String>();
    _controllers[messageId] = controller;

    int currentIndex = 0;

    _timers[messageId] = Timer.periodic(_typingInterval, (timer) {
      if (currentIndex >= fullText.length) {
        timer.cancel();
        controller.add(fullText);
        controller.close();
        _cleanup(messageId);
        return;
      }

      // Add characters gradually
      currentIndex = (currentIndex + _charsPerInterval).clamp(0, fullText.length);
      final currentText = fullText.substring(0, currentIndex);

      if (!controller.isClosed) {
        controller.add(currentText);
      }
    });

    return controller.stream;
  }

  /// Cancel typing animation for a message
  void cancelAnimation(String messageId) {
    _timers[messageId]?.cancel();
    _timers.remove(messageId);

    if (_controllers.containsKey(messageId)) {
      if (!_controllers[messageId]!.isClosed) {
        _controllers[messageId]!.close();
      }
      _controllers.remove(messageId);
    }
  }

  /// Cleanup resources for a message
  void _cleanup(String messageId) {
    _timers.remove(messageId);
    _controllers.remove(messageId);
  }

  /// Dispose all animations
  void dispose() {
    for (var timer in _timers.values) {
      timer?.cancel();
    }
    _timers.clear();

    for (var controller in _controllers.values) {
      if (!controller.isClosed) {
        controller.close();
      }
    }
    _controllers.clear();
  }

  /// Check if animation is active for a message
  bool isAnimating(String messageId) {
    return _timers.containsKey(messageId) && _timers[messageId]?.isActive == true;
  }
}
