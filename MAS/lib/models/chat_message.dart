/// Model for chat messages in Math AI Solver
///
/// Represents a single message in a dialogue between user and AI.
/// Messages are persisted in SQLite database for chat history.
class ChatMessage {
  final int? id;
  final int dialogueId;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    this.id,
    required this.dialogueId,
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Convert message to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dialogue_id': dialogueId,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create message from database map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int?,
      dialogueId: map['dialogue_id'] as int,
      text: map['text'] as String,
      isUser: (map['is_user'] as int) == 1,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  /// Create a copy with modified fields
  ChatMessage copyWith({
    int? id,
    int? dialogueId,
    String? text,
    bool? isUser,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      dialogueId: dialogueId ?? this.dialogueId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'ChatMessage(id: $id, dialogueId: $dialogueId, isUser: $isUser, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...)';
}
