import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:acs/l10n/app_localizations.dart';

/// Тип изображения в сканировании
enum ImageType {
  /// Главная этикетка продукта (для миниатюр)
  frontLabel,
  /// Этикетка с составом ингредиентов
  ingredients,
}

/// Расширение для работы с ImageType
extension ImageTypeExtension on ImageType {
  /// Получить локализованное название типа изображения
  String getDisplayName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case ImageType.frontLabel:
        return l10n.frontLabelType;
      case ImageType.ingredients:
        return l10n.ingredientsType;
    }
  }

  /// Старое свойство для обратной совместимости (возвращает английский текст)
  String get displayName {
    switch (this) {
      case ImageType.frontLabel:
        return 'Front Label';
      case ImageType.ingredients:
        return 'Ingredients';
    }
  }

  String toJson() {
    switch (this) {
      case ImageType.frontLabel:
        return 'front_label';
      case ImageType.ingredients:
        return 'ingredients';
    }
  }

  static ImageType fromJson(String json) {
    switch (json) {
      case 'front_label':
        return ImageType.frontLabel;
      case 'ingredients':
        return ImageType.ingredients;
      default:
        return ImageType.ingredients;
    }
  }
}

/// Модель для хранения информации об одном изображении в сканировании
class ScanImage {
  /// Путь к файлу изображения
  final String imagePath;

  /// Тип изображения (главная этикетка или состав)
  final ImageType type;

  /// Порядковый номер (для сортировки)
  final int order;

  ScanImage({
    required this.imagePath,
    required this.type,
    required this.order,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'type': type.toJson(),
      'order': order,
    };
  }

  factory ScanImage.fromMap(Map<String, dynamic> map) {
    return ScanImage(
      imagePath: map['imagePath'] as String,
      type: ImageTypeExtension.fromJson(map['type'] as String),
      order: map['order'] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ScanImage.fromJson(String source) =>
      ScanImage.fromMap(jsonDecode(source) as Map<String, dynamic>);

  ScanImage copyWith({
    String? imagePath,
    ImageType? type,
    int? order,
  }) {
    return ScanImage(
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      order: order ?? this.order,
    );
  }
}
