/// Модель сообщения в чате
class ChatMessage {
  final int? id;
  final int dialogueId;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final String? antiqueImagePath;

  ChatMessage({
    this.id,
    required this.dialogueId,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.antiqueImagePath,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as int?,
      dialogueId: json['dialogue_id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      isUser: json['is_user'] == 1 || json['is_user'] == true,
      timestamp: json['timestamp'] is DateTime
          ? json['timestamp'] as DateTime
          : (json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null),
      antiqueImagePath: json['antique_image_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dialogue_id': dialogueId,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'timestamp': timestamp?.toIso8601String(),
      'antique_image_path': antiqueImagePath,
    };
  }

  ChatMessage copyWith({
    int? id,
    int? dialogueId,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? antiqueImagePath,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      dialogueId: dialogueId ?? this.dialogueId,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      antiqueImagePath: antiqueImagePath ?? this.antiqueImagePath,
    );
  }
}
