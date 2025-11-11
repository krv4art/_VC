import '../models/chat_message.dart';
import '../models/scan_result.dart';
import '../models/analysis_result.dart';
import '../widgets/animated/animated_ai_avatar.dart';

/// UI state for chat screen
class ChatUIState {
  final bool isLoading;
  final bool showDisclaimer;
  final AvatarAnimationState avatarState;
  final bool isInputEnabled;
  final String? errorMessage;

  const ChatUIState({
    this.isLoading = false,
    this.showDisclaimer = true,
    this.avatarState = AvatarAnimationState.speaking,
    this.isInputEnabled = true,
    this.errorMessage,
  });

  ChatUIState copyWith({
    bool? isLoading,
    bool? showDisclaimer,
    AvatarAnimationState? avatarState,
    bool? isInputEnabled,
    String? errorMessage,
  }) {
    return ChatUIState(
      isLoading: isLoading ?? this.isLoading,
      showDisclaimer: showDisclaimer ?? this.showDisclaimer,
      avatarState: avatarState ?? this.avatarState,
      isInputEnabled: isInputEnabled ?? this.isInputEnabled,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'ChatUIState(isLoading: $isLoading, showDisclaimer: $showDisclaimer, '
      'avatarState: $avatarState, isInputEnabled: $isInputEnabled)';
}

/// Chat data state
class ChatDataState {
  final List<ChatMessage> messages;
  final int? currentDialogueId;
  final ScanResult? linkedScanResult;
  final AnalysisResult? linkedAnalysisResult;

  const ChatDataState({
    this.messages = const [],
    this.currentDialogueId,
    this.linkedScanResult,
    this.linkedAnalysisResult,
  });

  ChatDataState copyWith({
    List<ChatMessage>? messages,
    int? currentDialogueId,
    ScanResult? linkedScanResult,
    AnalysisResult? linkedAnalysisResult,
  }) {
    return ChatDataState(
      messages: messages ?? this.messages,
      currentDialogueId: currentDialogueId ?? this.currentDialogueId,
      linkedScanResult: linkedScanResult ?? this.linkedScanResult,
      linkedAnalysisResult: linkedAnalysisResult ?? this.linkedAnalysisResult,
    );
  }

  @override
  String toString() =>
      'ChatDataState(messages: ${messages.length}, dialogueId: $currentDialogueId)';
}

/// Operations state for async operations
class ChatOperationsState {
  final bool isSendingMessage;
  final bool isLoadingMessages;
  final bool isLoadingScanResult;
  final String? operationError;
  final DateTime? lastMessageSentAt;

  const ChatOperationsState({
    this.isSendingMessage = false,
    this.isLoadingMessages = false,
    this.isLoadingScanResult = false,
    this.operationError,
    this.lastMessageSentAt,
  });

  ChatOperationsState copyWith({
    bool? isSendingMessage,
    bool? isLoadingMessages,
    bool? isLoadingScanResult,
    String? operationError,
    DateTime? lastMessageSentAt,
  }) {
    return ChatOperationsState(
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      isLoadingScanResult: isLoadingScanResult ?? this.isLoadingScanResult,
      operationError: operationError ?? this.operationError,
      lastMessageSentAt: lastMessageSentAt ?? this.lastMessageSentAt,
    );
  }

  bool get isAnyOperationInProgress =>
      isSendingMessage || isLoadingMessages || isLoadingScanResult;

  @override
  String toString() =>
      'ChatOperationsState(isSending: $isSendingMessage, isLoading: $isLoadingMessages)';
}
