import 'dart:convert';
import 'scan_image.dart';

class ScanResult {
  final int? id;

  /// Список всех изображений в сканировании
  final List<ScanImage> images;

  /// Устаревшее поле для обратной совместимости
  @Deprecated('Use images instead')
  final String? imagePath;

  final Map<String, dynamic> analysisResult;
  final DateTime scanDate;

  ScanResult({
    this.id,
    List<ScanImage>? images,
    @Deprecated('Use images instead') this.imagePath,
    required this.analysisResult,
    required this.scanDate,
  }) : images = images ?? [];

  /// Получить главную этикетку (для миниатюр)
  String? get frontLabelPath {
    final frontLabel = images.where((img) => img.type == ImageType.frontLabel).firstOrNull;
    return frontLabel?.imagePath ?? images.firstOrNull?.imagePath;
  }

  /// Получить все изображения с составом
  List<ScanImage> get ingredientImages {
    return images.where((img) => img.type == ImageType.ingredients).toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  /// Получить первое изображение (для обратной совместимости)
  String? get firstImagePath {
    return images.firstOrNull?.imagePath;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'images': jsonEncode(images.map((img) => img.toMap()).toList()),
      'imagePath': frontLabelPath ?? firstImagePath, // Для обратной совместимости
      'analysisResult': jsonEncode(analysisResult),
      'scanDate': scanDate.toIso8601String(),
    };
  }

  factory ScanResult.fromMap(Map<String, dynamic> map) {
    List<ScanImage> imagesList = [];

    // Пробуем загрузить новый формат (массив изображений)
    if (map['images'] != null && map['images'] is String && (map['images'] as String).isNotEmpty) {
      try {
        final imagesJson = jsonDecode(map['images'] as String) as List;
        imagesList = imagesJson.map((img) => ScanImage.fromMap(img as Map<String, dynamic>)).toList();
      } catch (e) {
        // Игнорируем ошибки парсинга
      }
    }

    // Если новый формат пустой, используем старый формат (одно изображение)
    if (imagesList.isEmpty && map['imagePath'] != null && (map['imagePath'] as String).isNotEmpty) {
      imagesList = [
        ScanImage(
          imagePath: map['imagePath'] as String,
          type: ImageType.ingredients,
          order: 0,
        ),
      ];
    }

    return ScanResult(
      id: map['id'] as int?,
      images: imagesList,
      analysisResult: jsonDecode(map['analysisResult'] as String) as Map<String, dynamic>,
      scanDate: DateTime.parse(map['scanDate'] as String),
    );
  }
}
