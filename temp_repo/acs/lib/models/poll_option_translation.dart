/// Модель для переводов вариантов опроса
class PollOptionTranslation {
  final String id;
  final String optionId;
  final String languageCode;
  final String text;
  final DateTime createdAt;

  PollOptionTranslation({
    required this.id,
    required this.optionId,
    required this.languageCode,
    required this.text,
    required this.createdAt,
  });

  /// Преобразование в Map для Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'option_id': optionId,
      'language_code': languageCode,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Создание из Map (для Supabase)
  factory PollOptionTranslation.fromJson(Map<String, dynamic> json) {
    return PollOptionTranslation(
      id: json['id'] as String,
      optionId: json['option_id'] as String,
      languageCode: json['language_code'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Создание копии с изменениями
  PollOptionTranslation copyWith({
    String? id,
    String? optionId,
    String? languageCode,
    String? text,
    DateTime? createdAt,
  }) {
    return PollOptionTranslation(
      id: id ?? this.id,
      optionId: optionId ?? this.optionId,
      languageCode: languageCode ?? this.languageCode,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'PollOptionTranslation(id: $id, optionId: $optionId, languageCode: $languageCode, text: $text, createdAt: $createdAt)';
  }
}
