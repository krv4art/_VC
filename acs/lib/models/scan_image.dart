import 'dart:convert';

/// Тип изображения в сканировании
enum ImageType {
  /// Главная этикетка продукта (для миниатюр)
  frontLabel,
  /// Этикетка с составом ингредиентов
  ingredients,
}

/// Расширение для работы с ImageType
extension ImageTypeExtension on ImageType {
  String get displayName {
    switch (this) {
      case ImageType.frontLabel:
        return 'Главная этикетка';
      case ImageType.ingredients:
        return 'Состав';
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
