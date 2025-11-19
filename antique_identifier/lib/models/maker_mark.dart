/// Модель для клейма производителя
class MakerMark {
  final String id;
  final String name; // Название производителя
  final String? imageUrl; // URL изображения клейма
  final String category; // Категория (pottery, silver, furniture, etc.)
  final String description;
  final String? period; // Период использования клейма
  final String? country; // Страна происхождения
  final List<String> keywords; // Ключевые слова для поиска
  final String? additionalInfo;

  MakerMark({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.category,
    required this.description,
    this.period,
    this.country,
    this.keywords = const [],
    this.additionalInfo,
  });

  factory MakerMark.fromJson(Map<String, dynamic> json) {
    return MakerMark(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      period: json['period'] as String?,
      country: json['country'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      additionalInfo: json['additionalInfo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'category': category,
      'description': description,
      'period': period,
      'country': country,
      'keywords': keywords,
      'additionalInfo': additionalInfo,
    };
  }
}
