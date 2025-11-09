import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../models/conversation.dart';
import '../models/notification_data.dart';
import 'unseen_database_service.dart';

/// Service for storing and managing messages from notifications
class MessageStorageService {
  final UnseenDatabaseService _db = UnseenDatabaseService();
  final Uuid _uuid = const Uuid();

  /// Save message from notification data
  Future<Message> saveMessageFromNotification(NotificationData notificationData) async {
    // Create message from notification
    final message = Message(
      id: _uuid.v4(),
      conversationId: notificationData.generatedConversationId,
      text: notificationData.messageText,
      mediaUrl: notificationData.hasMedia ? notificationData.mediaUrls?.first : null,
      timestamp: notificationData.timestamp,
      senderId: notificationData.senderId ?? notificationData.senderName.hashCode.toString(),
      senderName: notificationData.senderName,
      messenger: notificationData.messenger,
      isDeleted: false,
      isRead: false,
    );

    // Save to database
    await _db.insertMessage(message);

    return message;
  }

  /// Get all conversations
  Future<List<Conversation>> getAllConversations() async {
    return await _db.getConversations();
  }

  /// Get messages for a conversation
  Future<List<Message>> getConversationMessages(String conversationId) async {
    return await _db.getMessages(conversationId);
  }

  /// Get recent messages
  Future<List<Message>> getRecentMessages(String conversationId, int limit) async {
    return await _db.getRecentMessages(conversationId, limit);
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    await _db.markConversationAsRead(conversationId);
  }

  /// Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    await _db.deleteConversation(conversationId);
  }

  /// Get deleted messages
  Future<List<Message>> getDeletedMessages(String conversationId) async {
    return await _db.getDeletedMessages(conversationId);
  }

  /// Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final totalMessages = await _db.getTotalMessagesCount();
    final messagesByMessenger = await _db.getMessagesCountByMessenger();

    return {
      'totalMessages': totalMessages,
      'messagesByMessenger': messagesByMessenger,
    };
  }

  /// Clear all data
  Future<void> clearAllData() async {
    await _db.deleteAllData();
  }
}
