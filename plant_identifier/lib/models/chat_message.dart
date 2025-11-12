class ChatMessage {
  final int? id;
  final int dialogueId;
  final String text;
  final bool isUser;
  final DateTime? timestamp;
  final String? plantImagePath;

  ChatMessage({
    this.id,
    required this.dialogueId,
    required this.text,
    required this.isUser,
    this.timestamp,
    this.plantImagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dialogueId': dialogueId,
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
      'plantImagePath': plantImagePath,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int?,
      dialogueId: map['dialogueId'] as int,
      text: map['text'] as String,
      isUser: (map['isUser'] as int) == 1,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : null,
      plantImagePath: map['plantImagePath'] as String?,
    );
  }
}
