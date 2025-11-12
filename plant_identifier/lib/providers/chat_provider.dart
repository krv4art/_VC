import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_initialization_service.dart';
import '../services/chat_message_helper.dart';
import '../services/database_service.dart';
import '../widgets/animated/animated_ai_avatar.dart';
import 'chat_messages_notifier.dart';
import 'chat_ui_notifier.dart';
import 'chat_operations_notifier.dart';

/// Main chat provider that coordinates all chat state and operations
class ChatProvider extends ChangeNotifier {
  final ChatMessagesNotifier messagesNotifier;
  final ChatUINotifier uiNotifier;
  final ChatOperationsNotifier operationsNotifier;

  ChatProvider({
    ChatMessagesNotifier? messagesNotifier,
    ChatUINotifier? uiNotifier,
    ChatOperationsNotifier? operationsNotifier,
  }) : messagesNotifier = messagesNotifier ?? ChatMessagesNotifier(),
       uiNotifier = uiNotifier ?? ChatUINotifier(),
       operationsNotifier = operationsNotifier ?? ChatOperationsNotifier() {
    // Listen to sub-notifiers and propagate changes
    this.messagesNotifier.addListener(_onMessagesChanged);
    this.uiNotifier.addListener(_onUIChanged);
    this.operationsNotifier.addListener(_onOperationsChanged);
  }

  // Delegates to notifiers
  List<ChatMessage> get messages => messagesNotifier.messages;
  int? get currentDialogueId => messagesNotifier.currentDialogueId;
  bool get isLoading => uiNotifier.isLoading;
  bool get showDisclaimer => uiNotifier.showDisclaimer;
  AvatarAnimationState get avatarState => uiNotifier.avatarState;
  bool get isInputEnabled => uiNotifier.isInputEnabled;
  String? get errorMessage => uiNotifier.errorMessage;
  bool get isSendingMessage => operationsNotifier.isSendingMessage;
  bool get isLoadingMessages => operationsNotifier.isLoadingMessages;
  bool get isAnyOperationInProgress =>
      operationsNotifier.isAnyOperationInProgress;

  int get messageCount => messagesNotifier.messageCount;

  ChatMessage? get lastMessage => messagesNotifier.lastMessage;

  /// Initialize chat with dialogue ID
  Future<bool> initializeDialogue(int dialogueId) async {
    uiNotifier.setLoading(true);
    operationsNotifier.setLoadingMessages(true);

    try {
      messagesNotifier.setDialogueId(dialogueId);
      final success = await messagesNotifier.loadMessages(dialogueId);

      if (success) {
        await _loadLinkedPlantResult(dialogueId);
      }

      uiNotifier.setLoading(false);
      operationsNotifier.setLoadingMessages(false);

      return success;
    } catch (e) {
      debugPrint('Error initializing dialogue: $e');
      uiNotifier.setErrorMessage('Failed to load chat');
      uiNotifier.setLoading(false);
      operationsNotifier.setLoadingMessages(false);
      return false;
    }
  }

  /// Load plant result for dialogue
  Future<void> _loadLinkedPlantResult(int dialogueId) async {
    try {
      final plantResult =
          await ChatInitializationService.loadPlantResultForDialogue(dialogueId);
      if (plantResult != null) {
        messagesNotifier.setLinkedPlantResult(plantResult);
      }
    } catch (e) {
      debugPrint('Error loading plant result: $e');
    }
  }

  /// Load plant result by ID
  Future<bool> loadPlantResultById(String plantResultId) async {
    operationsNotifier.setLoadingPlantResult(true);

    try {
      final plantResult = await ChatInitializationService.loadPlantResultById(
        plantResultId,
      );

      if (plantResult != null) {
        messagesNotifier.setLinkedPlantResult(plantResult);
        operationsNotifier.setLoadingPlantResult(false);
        return true;
      }

      operationsNotifier.setLoadingPlantResult(false);
      return false;
    } catch (e) {
      debugPrint('Error loading plant result: $e');
      operationsNotifier.setOperationError('Failed to load plant result');
      operationsNotifier.setLoadingPlantResult(false);
      return false;
    }
  }

  /// Add user message
  void addUserMessage(String text) {
    final message = ChatMessageHelper.createUserMessage(
      dialogueId: currentDialogueId ?? 0,
      text: text,
    );
    messagesNotifier.addMessage(message);
  }

  /// Add bot message
  void addBotMessage(String text) {
    final message = ChatMessageHelper.createBotMessage(
      dialogueId: currentDialogueId ?? 0,
      text: text,
    );
    messagesNotifier.addMessage(message);
  }

  /// Update message text
  void updateMessageText(int index, String text) {
    messagesNotifier.updateMessageText(index, text);
  }

  /// Clear all messages
  void clearMessages() {
    messagesNotifier.clearMessages();
  }

  /// Set loading state
  void setLoading(bool loading) {
    uiNotifier.setLoading(loading);
  }

  /// Set avatar state
  void setAvatarState(AvatarAnimationState state) {
    uiNotifier.setAvatarState(state);
  }

  /// Dismiss disclaimer
  Future<void> dismissDisclaimer() async {
    uiNotifier.dismissDisclaimer();
    // Note: Implement saving disclaimer status if needed
    // await DatabaseService().saveDisclaimerStatus(true);
  }

  /// Set input enabled
  void setInputEnabled(bool enabled) {
    uiNotifier.setInputEnabled(enabled);
  }

  /// Set sending message
  void setSendingMessage(bool sending) {
    operationsNotifier.setSendingMessage(sending);
  }

  /// Record message sent
  void recordMessageSent() {
    operationsNotifier.recordMessageSent();
  }

  /// Set operation error
  void setError(String? error) {
    uiNotifier.setErrorMessage(error);
    operationsNotifier.setOperationError(error);
  }

  /// Clear error
  void clearError() {
    uiNotifier.clearError();
    operationsNotifier.clearError();
  }

  /// Reset all state
  void reset() {
    messagesNotifier.clearState();
    uiNotifier.reset();
    operationsNotifier.reset();
  }

  /// Create dialogue if it doesn't exist and return its ID
  /// Used when user sends first message in a new chat
  Future<int> ensureDialogueExists(
    String firstMessage, {
    String? plantResultId,
  }) async {
    // If dialogue already exists, return its ID
    if (currentDialogueId != null && currentDialogueId! > 0) {
      return currentDialogueId!;
    }

    // Create new dialogue with truncated title
    final title = firstMessage.length > 50
        ? firstMessage.substring(0, 50)
        : firstMessage;

    final dialogueId = await DatabaseService().createDialogue(
      title,
      identificationResultId: plantResultId,
    );

    // Update current dialogue ID
    messagesNotifier.setDialogueId(dialogueId);

    debugPrint('✅ Created new dialogue: $dialogueId');
    return dialogueId;
  }

  /// Save message to database
  Future<void> saveMessage(ChatMessage message) async {
    await DatabaseService().saveChatMessage(message);
    debugPrint('✅ Saved message to DB: ${message.isUser ? "user" : "bot"}');
  }

  /// Get linked plant result
  get linkedPlantResult => messagesNotifier.linkedPlantResult;

  /// Listen to messages changes
  void _onMessagesChanged() {
    notifyListeners();
  }

  /// Listen to UI changes
  void _onUIChanged() {
    notifyListeners();
  }

  /// Listen to operations changes
  void _onOperationsChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    messagesNotifier.removeListener(_onMessagesChanged);
    uiNotifier.removeListener(_onUIChanged);
    operationsNotifier.removeListener(_onOperationsChanged);

    messagesNotifier.dispose();
    uiNotifier.dispose();
    operationsNotifier.dispose();

    super.dispose();
  }

  @override
  String toString() =>
      'ChatProvider(messages: ${messages.length}, loading: $isLoading, '
      'sending: $isSendingMessage)';
}
