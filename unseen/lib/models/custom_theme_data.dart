import '../theme/custom_colors.dart';

/// Модель данных для пользовательской темы
class CustomThemeData {
  /// Уникальный идентификатор (timestamp)
  final String id;

  /// Название темы
  final String name;

  /// Цвета темы
  final CustomColors colors;

  /// Дата создания
  final DateTime createdAt;

  /// Дата последнего обновления
  final DateTime updatedAt;

  /// Светлая или темная тема
  final bool isDark;

  /// ID предустановленной темы, на основе которой создана (опционально)
  final String? basedOn;

  CustomThemeData({
    required this.id,
    required this.name,
    required this.colors,
    required this.createdAt,
    required this.updatedAt,
    required this.isDark,
    this.basedOn,
  });

  /// Создать новую кастомную тему
  factory CustomThemeData.create({
    required String name,
    required CustomColors colors,
    required bool isDark,
    String? basedOn,
  }) {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();

    return CustomThemeData(
      id: id,
      name: name,
      colors: colors,
      createdAt: now,
      updatedAt: now,
      isDark: isDark,
      basedOn: basedOn,
    );
  }

  /// Создать копию с изменениями
  CustomThemeData copyWith({
    String? name,
    CustomColors? colors,
    DateTime? updatedAt,
    bool? isDark,
    String? basedOn,
  }) {
    return CustomThemeData(
      id: id,
      name: name ?? this.name,
      colors: colors ?? this.colors,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isDark: isDark ?? this.isDark,
      basedOn: basedOn ?? this.basedOn,
    );
  }

  /// Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colors': colors.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDark': isDark,
      'basedOn': basedOn,
    };
  }

  /// Десериализация из JSON
  factory CustomThemeData.fromJson(Map<String, dynamic> json) {
    return CustomThemeData(
      id: json['id'] as String,
      name: json['name'] as String,
      colors: CustomColors.fromJson(json['colors'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDark: json['isDark'] as bool,
      basedOn: json['basedOn'] as String?,
    );
  }

  @override
  String toString() {
    return 'CustomThemeData(id: $id, name: $name, isDark: $isDark, basedOn: $basedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomThemeData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
