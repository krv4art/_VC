/// Модель для представления сообщения в чате
class ChatMessage {
  final String id;
  final String dialogueId;
  final String role;
  final String content;
  final DateTime timestamp;
  final String? imagePath;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.dialogueId,
    required this.role,
    required this.content,
    required this.timestamp,
    this.imagePath,
    this.metadata,
  });

  /// Создание объекта из JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      dialogueId: json['dialogue_id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['image_path'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }

  /// Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dialogue_id': dialogueId,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'image_path': imagePath,
      'metadata': metadata,
    };
  }

  /// Создание копии с изменениями
  /// Check if message is from user
  bool get isUser => role == 'user';

  ChatMessage copyWith({
    String? id,
    String? dialogueId,
    String? role,
    String? content,
    DateTime? timestamp,
    String? imagePath,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      dialogueId: dialogueId ?? this.dialogueId,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      imagePath: imagePath ?? this.imagePath,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}
