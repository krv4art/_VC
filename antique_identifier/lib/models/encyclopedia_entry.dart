/// Запись в энциклопедии антиквариата
class EncyclopediaEntry {
  final String id;
  final String title;
  final String category; // 'style', 'term', 'period', 'technique', 'material'
  final String definition;
  final String? detailedDescription;
  final String? period; // Временной период
  final String? imageUrl;
  final List<String> relatedTerms;
  final List<String> examples;
  final Map<String, String>? translations; // Переводы на другие языки

  EncyclopediaEntry({
    required this.id,
    required this.title,
    required this.category,
    required this.definition,
    this.detailedDescription,
    this.period,
    this.imageUrl,
    this.relatedTerms = const [],
    this.examples = const [],
    this.translations,
  });

  factory EncyclopediaEntry.fromJson(Map<String, dynamic> json) {
    return EncyclopediaEntry(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      definition: json['definition'] as String? ?? '',
      detailedDescription: json['detailedDescription'] as String?,
      period: json['period'] as String?,
      imageUrl: json['imageUrl'] as String?,
      relatedTerms: (json['relatedTerms'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'definition': definition,
      'detailedDescription': detailedDescription,
      'period': period,
      'imageUrl': imageUrl,
      'relatedTerms': relatedTerms,
      'examples': examples,
      'translations': translations,
    };
  }
}
