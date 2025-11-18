class ProcessedImage {
  final String id;
  final String originalPath;
  final String processedPath;
  final String processingMode;
  final DateTime createdAt;
  final bool isPremium;
  final Map<String, dynamic>? metadata;

  ProcessedImage({
    required this.id,
    required this.originalPath,
    required this.processedPath,
    required this.processingMode,
    required this.createdAt,
    this.isPremium = false,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'originalPath': originalPath,
      'processedPath': processedPath,
      'processingMode': processingMode,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium ? 1 : 0,
      'metadata': metadata != null ? metadata.toString() : null,
    };
  }

  factory ProcessedImage.fromMap(Map<String, dynamic> map) {
    return ProcessedImage(
      id: map['id'],
      originalPath: map['originalPath'],
      processedPath: map['processedPath'],
      processingMode: map['processingMode'],
      createdAt: DateTime.parse(map['createdAt']),
      isPremium: map['isPremium'] == 1,
      metadata: map['metadata'],
    );
  }

  ProcessedImage copyWith({
    String? id,
    String? originalPath,
    String? processedPath,
    String? processingMode,
    DateTime? createdAt,
    bool? isPremium,
    Map<String, dynamic>? metadata,
  }) {
    return ProcessedImage(
      id: id ?? this.id,
      originalPath: originalPath ?? this.originalPath,
      processedPath: processedPath ?? this.processedPath,
      processingMode: processingMode ?? this.processingMode,
      createdAt: createdAt ?? this.createdAt,
      isPremium: isPremium ?? this.isPremium,
      metadata: metadata ?? this.metadata,
    );
  }
}
