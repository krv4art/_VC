import 'dart:convert';

/// Language proficiency model
class Language {
  final String id;
  final String name;
  final LanguageProficiency proficiency;

  Language({
    required this.id,
    required this.name,
    required this.proficiency,
  });

  Language copyWith({
    String? id,
    String? name,
    LanguageProficiency? proficiency,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'proficiency': proficiency.toString().split('.').last,
    };
  }

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name'],
      proficiency: LanguageProficiency.values.firstWhere(
        (e) => e.toString().split('.').last == json['proficiency'],
        orElse: () => LanguageProficiency.intermediate,
      ),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Language.fromJsonString(String jsonString) {
    return Language.fromJson(jsonDecode(jsonString));
  }
}

/// Language proficiency levels (CEFR standard)
enum LanguageProficiency {
  a1, // Beginner
  a2, // Elementary
  b1, // Intermediate
  b2, // Upper Intermediate
  c1, // Advanced
  c2, // Proficient/Native
}

extension LanguageProficiencyExtension on LanguageProficiency {
  String get displayName {
    switch (this) {
      case LanguageProficiency.a1:
        return 'A1 - Beginner';
      case LanguageProficiency.a2:
        return 'A2 - Elementary';
      case LanguageProficiency.b1:
        return 'B1 - Intermediate';
      case LanguageProficiency.b2:
        return 'B2 - Upper Intermediate';
      case LanguageProficiency.c1:
        return 'C1 - Advanced';
      case LanguageProficiency.c2:
        return 'C2 - Proficient/Native';
    }
  }

  String get shortName {
    return toString().split('.').last.toUpperCase();
  }
}
