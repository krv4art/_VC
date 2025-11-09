import 'messenger_type.dart';
import 'message.dart';

/// Represents a conversation with a contact
class Conversation {
  final String id;
  final String contactName;
  final String? avatar;
  final MessengerType messenger;
  final DateTime lastMessageTime;
  final String? lastMessageText;
  final int unreadCount;
  final List<Message> messages;

  const Conversation({
    required this.id,
    required this.contactName,
    this.avatar,
    required this.messenger,
    required this.lastMessageTime,
    this.lastMessageText,
    this.unreadCount = 0,
    this.messages = const [],
  });

  /// Create Conversation from database map
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      contactName: map['contact_name'] as String,
      avatar: map['avatar'] as String?,
      messenger: MessengerType.values[map['messenger'] as int],
      lastMessageTime:
          DateTime.fromMillisecondsSinceEpoch(map['last_message_time'] as int),
      lastMessageText: map['last_message_text'] as String?,
      unreadCount: map['unread_count'] as int? ?? 0,
    );
  }

  /// Convert Conversation to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contact_name': contactName,
      'avatar': avatar,
      'messenger': messenger.index,
      'last_message_time': lastMessageTime.millisecondsSinceEpoch,
      'last_message_text': lastMessageText,
      'unread_count': unreadCount,
    };
  }

  /// Create a copy with modified fields
  Conversation copyWith({
    String? id,
    String? contactName,
    String? avatar,
    MessengerType? messenger,
    DateTime? lastMessageTime,
    String? lastMessageText,
    int? unreadCount,
    List<Message>? messages,
  }) {
    return Conversation(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      avatar: avatar ?? this.avatar,
      messenger: messenger ?? this.messenger,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessageText: lastMessageText ?? this.lastMessageText,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }

  /// Get formatted time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  String toString() {
    return 'Conversation(id: $id, contact: $contactName, messenger: ${messenger.displayName}, unread: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Conversation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
