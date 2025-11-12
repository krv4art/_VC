import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/database/local_database_service.dart';

/// Provider for managing chat state in Math AI Solver
///
/// Handles:
/// - Message history
/// - Current dialogue
/// - Loading states
/// - Error handling
class ChatProvider extends ChangeNotifier {
  final LocalDatabaseService _dbService = LocalDatabaseService.instance;

  List<ChatMessage> _messages = [];
  int? _currentDialogueId;
  bool _isLoading = false;
  bool _isSendingMessage = false;
  String? _errorMessage;

  // Getters
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  int? get currentDialogueId => _currentDialogueId;
  bool get isLoading => _isLoading;
  bool get isSendingMessage => _isSendingMessage;
  String? get errorMessage => _errorMessage;
  int get messageCount => _messages.length;
  ChatMessage? get lastMessage => _messages.isEmpty ? null : _messages.last;
  bool get isAnyOperationInProgress => _isLoading || _isSendingMessage;

  /// Initialize chat with a dialogue ID (load existing conversation)
  Future<bool> initializeDialogue(int dialogueId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentDialogueId = dialogueId;
      _messages = await _dbService.getMessages(dialogueId);

      debugPrint('✅ Loaded ${_messages.length} messages for dialogue $dialogueId');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('❌ Error loading dialogue: $e');
      _errorMessage = 'Failed to load chat history';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create a new dialogue and set as current
  Future<int> createDialogue(String title) async {
    try {
      final id = await _dbService.createDialogue(title);
      _currentDialogueId = id;
      _messages = [];
      debugPrint('✅ Created new dialogue: $id');
      notifyListeners();
      return id;
    } catch (e) {
      debugPrint('❌ Error creating dialogue: $e');
      throw Exception('Failed to create dialogue');
    }
  }

  /// Ensure dialogue exists (create if needed)
  Future<int> ensureDialogueExists(String firstMessage) async {
    if (_currentDialogueId != null && _currentDialogueId! > 0) {
      return _currentDialogueId!;
    }

    // Create new dialogue with truncated title
    final title = firstMessage.length > 50
        ? '${firstMessage.substring(0, 50)}...'
        : firstMessage;

    return await createDialogue(title);
  }

  /// Add user message
  void addUserMessage(String text) {
    final message = ChatMessage(
      dialogueId: _currentDialogueId ?? 0,
      text: text,
      isUser: true,
    );
    _messages.add(message);
    notifyListeners();
  }

  /// Add bot message
  void addBotMessage(String text) {
    final message = ChatMessage(
      dialogueId: _currentDialogueId ?? 0,
      text: text,
      isUser: false,
    );
    _messages.add(message);
    notifyListeners();
  }

  /// Update message text (for typing animation)
  void updateMessageText(int index, String text) {
    if (index >= 0 && index < _messages.length) {
      _messages[index] = _messages[index].copyWith(text: text);
      notifyListeners();
    }
  }

  /// Save message to database
  Future<void> saveMessage(ChatMessage message) async {
    try {
      await _dbService.insertMessage(message);
      debugPrint('💾 Saved message to DB: ${message.isUser ? "user" : "bot"}');
    } catch (e) {
      debugPrint('❌ Error saving message: $e');
    }
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set sending message state
  void setSendingMessage(bool sending) {
    _isSendingMessage = sending;
    notifyListeners();
  }

  /// Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Clear all messages (but keep dialogue)
  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  /// Reset entire state (for new chat)
  void reset() {
    _messages = [];
    _currentDialogueId = null;
    _isLoading = false;
    _isSendingMessage = false;
    _errorMessage = null;
    notifyListeners();
  }

  @override
  String toString() =>
      'ChatProvider(messages: ${_messages.length}, dialogueId: $_currentDialogueId, loading: $_isLoading, sending: $_isSendingMessage)';
}
