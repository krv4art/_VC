/// Model for chat dialogues in Math AI Solver
///
/// Represents a conversation thread with the AI assistant.
/// Each dialogue can contain multiple messages.
class Dialogue {
  final int? id;
  final String title;
  final DateTime createdAt;
  final DateTime lastMessageAt;

  Dialogue({
    this.id,
    required this.title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastMessageAt = lastMessageAt ?? DateTime.now();

  /// Convert dialogue to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'last_message_at': lastMessageAt.toIso8601String(),
    };
  }

  /// Create dialogue from database map
  factory Dialogue.fromMap(Map<String, dynamic> map) {
    return Dialogue(
      id: map['id'] as int?,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      lastMessageAt: DateTime.parse(map['last_message_at'] as String),
    );
  }

  /// Create a copy with modified fields
  Dialogue copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DateTime? lastMessageAt,
  }) {
    return Dialogue(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  @override
  String toString() =>
      'Dialogue(id: $id, title: $title, createdAt: $createdAt, lastMessageAt: $lastMessageAt)';
}
