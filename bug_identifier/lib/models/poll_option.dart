import 'dart:convert';

/// Модель для варианта ответа в опросе
class PollOption {
  final String id;
  final String text;
  final int voteCount;
  final DateTime createdAt;
  final bool isUserCreated;

  PollOption({
    required this.id,
    required this.text,
    this.voteCount = 0,
    required this.createdAt,
    this.isUserCreated = false,
  });

  /// Преобразование в Map для сохранения
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'voteCount': voteCount,
      'createdAt': createdAt.toIso8601String(),
      'isUserCreated': isUserCreated,
    };
  }

  /// Создание из Map
  factory PollOption.fromJson(Map<String, dynamic> json) {
    return PollOption(
      id: json['id'] as String,
      text: json['text'] as String,
      voteCount: json['voteCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isUserCreated: json['isUserCreated'] as bool? ?? false,
    );
  }

  /// Создание копии с изменениями
  PollOption copyWith({
    String? id,
    String? text,
    int? voteCount,
    DateTime? createdAt,
    bool? isUserCreated,
  }) {
    return PollOption(
      id: id ?? this.id,
      text: text ?? this.text,
      voteCount: voteCount ?? this.voteCount,
      createdAt: createdAt ?? this.createdAt,
      isUserCreated: isUserCreated ?? this.isUserCreated,
    );
  }

  @override
  String toString() {
    return 'PollOption(id: $id, text: $text, voteCount: $voteCount, createdAt: $createdAt, isUserCreated: $isUserCreated)';
  }
}
