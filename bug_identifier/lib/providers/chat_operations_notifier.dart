import 'package:flutter/material.dart';
import 'chat_state.dart';

/// Notifier for managing chat async operations
class ChatOperationsNotifier extends ChangeNotifier {
  ChatOperationsState _state = const ChatOperationsState();

  ChatOperationsState get state => _state;

  bool get isSendingMessage => _state.isSendingMessage;

  bool get isLoadingMessages => _state.isLoadingMessages;

  bool get isLoadingScanResult => _state.isLoadingScanResult;

  String? get operationError => _state.operationError;

  bool get isAnyOperationInProgress => _state.isAnyOperationInProgress;

  DateTime? get lastMessageSentAt => _state.lastMessageSentAt;

  /// Set sending message state
  void setSendingMessage(bool sending) {
    _state = _state.copyWith(isSendingMessage: sending);
    notifyListeners();
  }

  /// Set loading messages state
  void setLoadingMessages(bool loading) {
    _state = _state.copyWith(isLoadingMessages: loading);
    notifyListeners();
  }

  /// Set loading scan result state
  void setLoadingScanResult(bool loading) {
    _state = _state.copyWith(isLoadingScanResult: loading);
    notifyListeners();
  }

  /// Set operation error
  void setOperationError(String? error) {
    _state = _state.copyWith(operationError: error);
    notifyListeners();
  }

  /// Clear operation error
  void clearError() {
    _state = _state.copyWith(operationError: null);
    notifyListeners();
  }

  /// Record message sent timestamp
  void recordMessageSent() {
    _state = _state.copyWith(
      lastMessageSentAt: DateTime.now(),
      isSendingMessage: false,
    );
    notifyListeners();
  }

  /// Update multiple operation states at once
  void updateOperationState({
    bool? isSendingMessage,
    bool? isLoadingMessages,
    bool? isLoadingScanResult,
    String? operationError,
    DateTime? lastMessageSentAt,
  }) {
    _state = _state.copyWith(
      isSendingMessage: isSendingMessage,
      isLoadingMessages: isLoadingMessages,
      isLoadingScanResult: isLoadingScanResult,
      operationError: operationError,
      lastMessageSentAt: lastMessageSentAt,
    );
    notifyListeners();
  }

  /// Check if can send message (rate limiting)
  bool canSendMessage({Duration throttleDuration = const Duration(seconds: 1)}) {
    if (lastMessageSentAt == null) {
      return true;
    }
    final timeSinceLastMessage = DateTime.now().difference(lastMessageSentAt!);
    return timeSinceLastMessage.compareTo(throttleDuration) > 0;
  }

  /// Reset to initial state
  void reset() {
    _state = const ChatOperationsState();
    notifyListeners();
  }

  @override
  String toString() =>
      'ChatOperationsNotifier(sending: $isSendingMessage, loading: $isLoadingMessages, '
      'scanLoading: $isLoadingScanResult)';
}
