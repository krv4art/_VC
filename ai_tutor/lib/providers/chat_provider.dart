import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/subject.dart';

/// Provider for managing chat conversations
class ChatProvider with ChangeNotifier {
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  Subject? _currentSubject;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  Subject? get currentSubject => _currentSubject;

  /// Set current subject
  void setSubject(Subject subject) {
    _currentSubject = subject;
    _messages.clear();

    // Add welcome message
    addMessage(ChatMessage(
      content: "Hi! I'm your ${subject.emoji} ${subject.name} tutor. How can I help you today?",
      role: MessageRole.assistant,
      type: MessageType.text,
    ));

    notifyListeners();
  }

  /// Add a message to the chat
  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  /// Add user message
  void addUserMessage(String content, {MessageType type = MessageType.text}) {
    final message = ChatMessage(
      content: content,
      role: MessageRole.user,
      type: type,
    );
    addMessage(message);
  }

  /// Add assistant message
  void addAssistantMessage(String content, {MessageType type = MessageType.text}) {
    final message = ChatMessage(
      content: content,
      role: MessageRole.assistant,
      type: type,
    );
    addMessage(message);
  }

  /// Add system message
  void addSystemMessage(String content) {
    final message = ChatMessage(
      content: content,
      role: MessageRole.system,
      type: MessageType.text,
    );
    addMessage(message);
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Clear chat
  void clearChat() {
    _messages.clear();
    if (_currentSubject != null) {
      setSubject(_currentSubject!);
    }
    notifyListeners();
  }

  /// Clear all and reset
  void reset() {
    _messages.clear();
    _currentSubject = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Get chat history for API
  List<Map<String, String>> getChatHistory({int? maxMessages}) {
    final relevantMessages = _messages
        .where((m) => m.role != MessageRole.system)
        .toList();

    final messagesToSend = maxMessages != null && relevantMessages.length > maxMessages
        ? relevantMessages.sublist(relevantMessages.length - maxMessages)
        : relevantMessages;

    return messagesToSend
        .map((m) => {
              'role': m.role == MessageRole.user ? 'user' : 'assistant',
              'content': m.content,
            })
        .toList();
  }
}
