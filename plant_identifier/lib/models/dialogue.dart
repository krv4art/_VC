class Dialogue {
  final int id;
  final String title;
  final DateTime createdAt;
  final String? plantImagePath;
  final int? identificationResultId;

  Dialogue({
    required this.id,
    required this.title,
    required this.createdAt,
    this.plantImagePath,
    this.identificationResultId,
  });

  factory Dialogue.fromMap(Map<String, dynamic> map) {
    return Dialogue(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      plantImagePath: map['plant_image_path'] as String?,
      identificationResultId: map['identification_result_id'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'plant_image_path': plantImagePath,
      'identification_result_id': identificationResultId,
    };
  }
}
