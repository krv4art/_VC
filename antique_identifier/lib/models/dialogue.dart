/// Модель диалога с результатами анализа антиквариата
class Dialogue {
  final int? id;
  final String title;
  final String? antiqueImagePath;
  final String? analysisResultId; // ID результата анализа из Supabase
  final DateTime createdAt;
  final DateTime? updatedAt;

  Dialogue({
    this.id,
    required this.title,
    this.antiqueImagePath,
    this.analysisResultId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Dialogue.fromJson(Map<String, dynamic> json) {
    return Dialogue(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Untitled',
      antiqueImagePath: json['antique_image_path'] as String?,
      analysisResultId: json['analysis_result_id'] as String?,
      createdAt: json['created_at'] is DateTime
          ? json['created_at'] as DateTime
          : DateTime.parse(json['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: json['updated_at'] is DateTime
          ? json['updated_at'] as DateTime
          : (json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'antique_image_path': antiqueImagePath,
      'analysis_result_id': analysisResultId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Dialogue copyWith({
    int? id,
    String? title,
    String? antiqueImagePath,
    String? analysisResultId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Dialogue(
      id: id ?? this.id,
      title: title ?? this.title,
      antiqueImagePath: antiqueImagePath ?? this.antiqueImagePath,
      analysisResultId: analysisResultId ?? this.analysisResultId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
