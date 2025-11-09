import 'dart:convert';

/// Модель для хранения информации о голосе пользователя (один голос за один вариант)
class PollVote {
  final String id;
  final String deviceId;
  final String optionId;
  final DateTime createdAt;

  PollVote({
    required this.id,
    required this.deviceId,
    required this.optionId,
    required this.createdAt,
  });

  /// Преобразование в Map для сохранения
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'option_id': optionId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Создание из Map (для Supabase)
  factory PollVote.fromJson(Map<String, dynamic> json) {
    return PollVote(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      optionId: json['option_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Создание копии с изменениями
  PollVote copyWith({
    String? id,
    String? deviceId,
    String? optionId,
    DateTime? createdAt,
  }) {
    return PollVote(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      optionId: optionId ?? this.optionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'PollVote(id: $id, deviceId: $deviceId, optionId: $optionId, createdAt: $createdAt)';
  }
}
