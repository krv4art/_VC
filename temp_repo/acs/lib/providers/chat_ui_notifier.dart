import 'package:flutter/material.dart';
import '../widgets/animated/animated_ai_avatar.dart';
import 'chat_state.dart';

/// Notifier for managing chat UI state
class ChatUINotifier extends ChangeNotifier {
  ChatUIState _state = const ChatUIState();

  ChatUIState get state => _state;

  bool get isLoading => _state.isLoading;

  bool get showDisclaimer => _state.showDisclaimer;

  AvatarAnimationState get avatarState => _state.avatarState;

  bool get isInputEnabled => _state.isInputEnabled;

  String? get errorMessage => _state.errorMessage;

  /// Set loading state
  void setLoading(bool loading) {
    _state = _state.copyWith(isLoading: loading);
    notifyListeners();
  }

  /// Set avatar state
  void setAvatarState(AvatarAnimationState state) {
    _state = _state.copyWith(avatarState: state);
    notifyListeners();
  }

  /// Dismiss disclaimer
  void dismissDisclaimer() {
    _state = _state.copyWith(showDisclaimer: false);
    notifyListeners();
  }

  /// Show disclaimer
  void showDisclaimerBanner() {
    _state = _state.copyWith(showDisclaimer: true);
    notifyListeners();
  }

  /// Set input enabled/disabled
  void setInputEnabled(bool enabled) {
    _state = _state.copyWith(isInputEnabled: enabled);
    notifyListeners();
  }

  /// Set error message
  void setErrorMessage(String? error) {
    _state = _state.copyWith(errorMessage: error);
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }

  /// Update multiple UI states at once
  void updateUIState({
    bool? isLoading,
    bool? showDisclaimer,
    AvatarAnimationState? avatarState,
    bool? isInputEnabled,
    String? errorMessage,
  }) {
    _state = _state.copyWith(
      isLoading: isLoading,
      showDisclaimer: showDisclaimer,
      avatarState: avatarState,
      isInputEnabled: isInputEnabled,
      errorMessage: errorMessage,
    );
    notifyListeners();
  }

  /// Reset to initial state
  void reset() {
    _state = const ChatUIState();
    notifyListeners();
  }

  @override
  String toString() =>
      'ChatUINotifier(loading: $isLoading, disclaimer: $showDisclaimer, '
      'avatar: $avatarState)';
}
