/// Модель для представления диалога в чате
class Dialogue {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;
  final String? lastMessage;
  final String? resultId;

  Dialogue({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messageCount = 0,
    this.lastMessage,
    this.resultId,
  });

  /// Создание объекта из JSON
  factory Dialogue.fromJson(Map<String, dynamic> json) {
    return Dialogue(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      messageCount: json['message_count'] as int? ?? 0,
      lastMessage: json['last_message'] as String?,
      resultId: json['result_id'] as String?,
    );
  }

  /// Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'message_count': messageCount,
      'last_message': lastMessage,
      'result_id': resultId,
    };
  }

  /// Создание копии с изменениями
  Dialogue copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? messageCount,
    String? lastMessage,
    String? resultId,
  }) {
    return Dialogue(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messageCount: messageCount ?? this.messageCount,
      lastMessage: lastMessage ?? this.lastMessage,
      resultId: resultId ?? this.resultId,
    );
  }

  @override
  String toString() {
    return 'Dialogue(id: $id, title: $title, messageCount: $messageCount)';
  }
}
