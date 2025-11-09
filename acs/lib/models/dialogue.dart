class Dialogue {
  final int id;
  final String title;
  final DateTime createdAt;
  final String? scanImagePath;
  final int? scanResultId; // НОВОЕ ПОЛЕ

  Dialogue({
    required this.id,
    required this.title,
    required this.createdAt,
    this.scanImagePath,
    this.scanResultId, // НОВОЕ ПОЛЕ
  });

  factory Dialogue.fromMap(Map<String, dynamic> map) {
    return Dialogue(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      scanImagePath: map['scan_image_path'] as String?,
      scanResultId: map['scan_result_id'] as int?, // НОВОЕ ПОЛЕ
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'scan_image_path': scanImagePath,
      'scan_result_id': scanResultId, // НОВОЕ ПОЛЕ
    };
  }
}
