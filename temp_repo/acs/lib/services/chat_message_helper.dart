import '../models/chat_message.dart';

/// Helper service for creating and managing chat messages
class ChatMessageHelper {
  /// Create a user message
  static ChatMessage createUserMessage({
    required int dialogueId,
    required String text,
  }) {
    return ChatMessage(
      dialogueId: dialogueId,
      text: text,
      isUser: true,
    );
  }

  /// Create a bot message (initially empty for typing animation)
  static ChatMessage createBotMessage({
    required int dialogueId,
    String text = '',
  }) {
    return ChatMessage(
      dialogueId: dialogueId,
      text: text,
      isUser: false,
    );
  }

  /// Create a temporary welcome message for new chats
  static ChatMessage createWelcomeMessage({String text = ''}) {
    return ChatMessage(
      dialogueId: -1, // Temporary ID for new chats
      text: text,
      isUser: false,
    );
  }

  /// Update a message's text (creates a new instance to maintain immutability)
  static ChatMessage updateMessageText(ChatMessage message, String newText) {
    return ChatMessage(
      id: message.id,
      dialogueId: message.dialogueId,
      text: newText,
      isUser: message.isUser,
      timestamp: message.timestamp,
      scanImagePath: message.scanImagePath,
    );
  }

  /// Check if a message is empty (no text)
  static bool isEmpty(ChatMessage message) {
    return message.text.isEmpty;
  }

  /// Check if a message is a bot message
  static bool isFromBot(ChatMessage message) {
    return !message.isUser;
  }

  /// Check if a message is a user message
  static bool isFromUser(ChatMessage message) {
    return message.isUser;
  }

  /// Count user messages (excluding bot messages)
  static int countUserMessages(List<ChatMessage> messages) {
    return messages.where((msg) => msg.isUser).length;
  }

  /// Get all bot messages
  static List<ChatMessage> getBotMessages(List<ChatMessage> messages) {
    return messages.where((msg) => !msg.isUser).toList();
  }

  /// Get all user messages
  static List<ChatMessage> getUserMessages(List<ChatMessage> messages) {
    return messages.where((msg) => msg.isUser).toList();
  }

  /// Truncate message for preview (e.g., for dialogue title)
  static String truncateForTitle(String text, {int maxLength = 50}) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength).trimRight()}...';
  }
}
