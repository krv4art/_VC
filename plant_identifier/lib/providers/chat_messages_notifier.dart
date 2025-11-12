import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_initialization_service.dart';
import 'chat_state.dart';

/// Notifier for managing chat messages state
class ChatMessagesNotifier extends ChangeNotifier {
  ChatDataState _state = const ChatDataState();

  ChatDataState get state => _state;

  List<ChatMessage> get messages => _state.messages;

  int? get currentDialogueId => _state.currentDialogueId;

  /// Initialize with dialogue ID
  void setDialogueId(int dialogueId) {
    _state = _state.copyWith(currentDialogueId: dialogueId);
    notifyListeners();
  }

  /// Add a single message
  void addMessage(ChatMessage message) {
    final messages = [..._state.messages, message];
    _state = _state.copyWith(messages: messages);
    notifyListeners();
  }

  /// Update message at specific index
  void updateMessageAtIndex(int index, ChatMessage message) {
    if (index < 0 || index >= _state.messages.length) {
      debugPrint('Invalid message index: $index');
      return;
    }
    final messages = [..._state.messages];
    messages[index] = message;
    _state = _state.copyWith(messages: messages);
    notifyListeners();
  }

  /// Update message text at specific index
  void updateMessageText(int index, String text) {
    if (index < 0 || index >= _state.messages.length) {
      return;
    }
    final message = _state.messages[index];
    final updatedMessage = ChatMessage(
      id: message.id,
      dialogueId: message.dialogueId,
      text: text,
      isUser: message.isUser,
      timestamp: DateTime.now(),
      plantImagePath: message.plantImagePath,
    );
    updateMessageAtIndex(index, updatedMessage);
  }

  /// Clear all messages
  void clearMessages() {
    _state = _state.copyWith(messages: const []);
    notifyListeners();
  }

  /// Load messages from service
  Future<bool> loadMessages(int dialogueId) async {
    try {
      final messages = await ChatInitializationService.loadMessagesForDialogue(
        dialogueId,
      );
      _state = _state.copyWith(
        messages: messages,
        currentDialogueId: dialogueId,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error loading messages: $e');
      return false;
    }
  }

  /// Set linked plant result
  void setLinkedPlantResult(dynamic linkedPlantResult) {
    _state = _state.copyWith(
      linkedPlantResult: linkedPlantResult,
    );
    notifyListeners();
  }

  /// Get message count
  int get messageCount => _state.messages.length;

  /// Get user message count
  int getUserMessageCount() {
    return _state.messages.where((m) => m.isUser).length;
  }

  /// Get linked plant result
  dynamic get linkedPlantResult => _state.linkedPlantResult;

  /// Get last message or null
  ChatMessage? get lastMessage =>
      _state.messages.isNotEmpty ? _state.messages.last : null;

  /// Clear error state helper
  void clearState() {
    _state = const ChatDataState();
    notifyListeners();
  }

  @override
  String toString() => 'ChatMessagesNotifier(${_state.messages.length} messages)';
}
