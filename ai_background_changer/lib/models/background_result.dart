import 'dart:convert';

/// Модель для представления результата обработки фона
class BackgroundResult {
  final String id;
  final String originalImagePath;
  final String? processedImagePath;
  final String? removedBgImagePath;
  final DateTime timestamp;
  final String? styleId;
  final String? styleName;
  final String? styleDescription;
  final String? userPrompt;
  final bool isFavorite;
  final ProcessingStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  BackgroundResult({
    required this.id,
    required this.originalImagePath,
    this.processedImagePath,
    this.removedBgImagePath,
    required this.timestamp,
    this.styleId,
    this.styleName,
    this.styleDescription,
    this.userPrompt,
    this.isFavorite = false,
    this.status = ProcessingStatus.pending,
    this.errorMessage,
    this.metadata,
  });

  /// Создание объекта из JSON
  factory BackgroundResult.fromJson(Map<String, dynamic> json) {
    return BackgroundResult(
      id: json['id'] as String,
      originalImagePath: json['original_image_path'] as String,
      processedImagePath: json['processed_image_path'] as String?,
      removedBgImagePath: json['removed_bg_image_path'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      styleId: json['style_id'] as String?,
      styleName: json['style_name'] as String?,
      styleDescription: json['style_description'] as String?,
      userPrompt: json['user_prompt'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
      status: ProcessingStatus.values.firstWhere(
        (e) => e.toString() == 'ProcessingStatus.${json['status']}',
        orElse: () => ProcessingStatus.pending,
      ),
      errorMessage: json['error_message'] as String?,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : null,
    );
  }

  /// Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'original_image_path': originalImagePath,
      'processed_image_path': processedImagePath,
      'removed_bg_image_path': removedBgImagePath,
      'timestamp': timestamp.toIso8601String(),
      'style_id': styleId,
      'style_name': styleName,
      'style_description': styleDescription,
      'user_prompt': userPrompt,
      'is_favorite': isFavorite,
      'status': status.toString().split('.').last,
      'error_message': errorMessage,
      'metadata': metadata,
    };
  }

  /// Создание копии с изменениями
  BackgroundResult copyWith({
    String? id,
    String? originalImagePath,
    String? processedImagePath,
    String? removedBgImagePath,
    DateTime? timestamp,
    String? styleId,
    String? styleName,
    String? styleDescription,
    String? userPrompt,
    bool? isFavorite,
    ProcessingStatus? status,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) {
    return BackgroundResult(
      id: id ?? this.id,
      originalImagePath: originalImagePath ?? this.originalImagePath,
      processedImagePath: processedImagePath ?? this.processedImagePath,
      removedBgImagePath: removedBgImagePath ?? this.removedBgImagePath,
      timestamp: timestamp ?? this.timestamp,
      styleId: styleId ?? this.styleId,
      styleName: styleName ?? this.styleName,
      styleDescription: styleDescription ?? this.styleDescription,
      userPrompt: userPrompt ?? this.userPrompt,
      isFavorite: isFavorite ?? this.isFavorite,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'BackgroundResult(id: $id, status: $status, styleName: $styleName)';
  }
}

/// Статусы обработки изображения
enum ProcessingStatus {
  pending,
  removingBackground,
  generatingBackground,
  completed,
  error,
}
