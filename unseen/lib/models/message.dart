import 'messenger_type.dart';

/// Represents a single message from a conversation
class Message {
  final String id;
  final String conversationId;
  final String text;
  final String? mediaUrl;
  final DateTime timestamp;
  final String senderId;
  final String senderName;
  final MessengerType messenger;
  final bool isDeleted;
  final bool isRead;

  const Message({
    required this.id,
    required this.conversationId,
    required this.text,
    this.mediaUrl,
    required this.timestamp,
    required this.senderId,
    required this.senderName,
    required this.messenger,
    this.isDeleted = false,
    this.isRead = false,
  });

  /// Create Message from database map
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] as String,
      conversationId: map['conversation_id'] as String,
      text: map['text'] as String? ?? '',
      mediaUrl: map['media_url'] as String?,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
      senderId: map['sender_id'] as String,
      senderName: map['sender_name'] as String,
      messenger: MessengerType.values[map['messenger'] as int],
      isDeleted: (map['is_deleted'] as int? ?? 0) == 1,
      isRead: (map['is_read'] as int? ?? 0) == 1,
    );
  }

  /// Convert Message to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'text': text,
      'media_url': mediaUrl,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'sender_id': senderId,
      'sender_name': senderName,
      'messenger': messenger.index,
      'is_deleted': isDeleted ? 1 : 0,
      'is_read': isRead ? 1 : 0,
    };
  }

  /// Create a copy with modified fields
  Message copyWith({
    String? id,
    String? conversationId,
    String? text,
    String? mediaUrl,
    DateTime? timestamp,
    String? senderId,
    String? senderName,
    MessengerType? messenger,
    bool? isDeleted,
    bool? isRead,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      timestamp: timestamp ?? this.timestamp,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      messenger: messenger ?? this.messenger,
      isDeleted: isDeleted ?? this.isDeleted,
      isRead: isRead ?? this.isRead,
    );
  }

  /// Check if message has media
  bool get hasMedia => mediaUrl != null && mediaUrl!.isNotEmpty;

  @override
  String toString() {
    return 'Message(id: $id, from: $senderName, text: $text, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
