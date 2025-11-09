import 'package:flutter/foundation.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/notification_data.dart';
import '../services/message_storage_service.dart';
import '../services/notification_listener_service.dart';
import 'dart:async';

/// Provider for managing messages and conversations
class MessagesProvider extends ChangeNotifier {
  final MessageStorageService _storageService = MessageStorageService();
  final NotificationListenerService _notificationService =
      NotificationListenerService();

  List<Conversation> _conversations = [];
  Map<String, List<Message>> _messagesByConversation = {};
  bool _isLoading = false;
  bool _isListening = false;
  StreamSubscription<NotificationData>? _notificationSubscription;

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  bool get isListening => _isListening;

  /// Get messages for a specific conversation
  List<Message> getMessages(String conversationId) {
    return _messagesByConversation[conversationId] ?? [];
  }

  /// Initialize provider
  Future<void> initialize() async {
    await loadConversations();
    await _setupNotificationListener();
  }

  /// Load all conversations from database
  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _storageService.getAllConversations();
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load messages for a specific conversation
  Future<void> loadMessages(String conversationId) async {
    try {
      final messages = await _storageService.getConversationMessages(conversationId);
      _messagesByConversation[conversationId] = messages;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  /// Setup notification listener
  Future<void> _setupNotificationListener() async {
    final hasPermission = await _notificationService.isPermissionGranted();

    if (!hasPermission) {
      debugPrint('Notification permission not granted');
      return;
    }

    // Initialize notification service
    final initialized = await _notificationService.initialize();
    if (!initialized) {
      debugPrint('Failed to initialize notification service');
      return;
    }

    // Start listening
    final started = await _notificationService.startListening();
    if (started) {
      _isListening = true;
      notifyListeners();

      // Subscribe to notification stream
      _notificationSubscription = _notificationService
          .getNotificationStream()
          .listen(_handleNotification);
    }
  }

  /// Handle incoming notification
  Future<void> _handleNotification(NotificationData notification) async {
    debugPrint('Received notification from ${notification.messenger.displayName}');

    try {
      // Save message to database
      await _storageService.saveMessageFromNotification(notification);

      // Reload conversations to show new message
      await loadConversations();

      // If conversation is open, reload messages
      final conversationId = notification.generatedConversationId;
      if (_messagesByConversation.containsKey(conversationId)) {
        await loadMessages(conversationId);
      }
    } catch (e) {
      debugPrint('Error handling notification: $e');
    }
  }

  /// Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    try {
      await _storageService.markAsRead(conversationId);
      await loadConversations();
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  /// Delete conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _storageService.deleteConversation(conversationId);
      _messagesByConversation.remove(conversationId);
      await loadConversations();
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
    }
  }

  /// Get deleted messages for a conversation
  Future<List<Message>> getDeletedMessages(String conversationId) async {
    try {
      return await _storageService.getDeletedMessages(conversationId);
    } catch (e) {
      debugPrint('Error getting deleted messages: $e');
      return [];
    }
  }

  /// Request notification permission
  Future<void> requestPermission() async {
    await _notificationService.openPermissionSettings();
  }

  /// Check if permission is granted
  Future<bool> hasPermission() async {
    return await _notificationService.isPermissionGranted();
  }

  /// Stop listening to notifications
  Future<void> stopListening() async {
    await _notificationService.stopListening();
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    _isListening = false;
    notifyListeners();
  }

  /// Resume listening to notifications
  Future<void> resumeListening() async {
    await _setupNotificationListener();
  }

  /// Clear all data (conversations and messages)
  Future<void> clearAllData() async {
    try {
      await _storageService.clearAllData();
      _conversations = [];
      _messagesByConversation = {};
      notifyListeners();
      debugPrint('All data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing data: $e');
      rethrow;
    }
  }

  /// Get statistics
  int get totalConversations => _conversations.length;

  int get totalUnreadMessages {
    return _conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
  }

  int get totalMessages {
    return _messagesByConversation.values
        .fold(0, (sum, messages) => sum + messages.length);
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _notificationService.dispose();
    super.dispose();
  }
}
