import 'dart:convert';

/// Skill model
class Skill {
  final String id;
  final String name;
  final SkillLevel level;
  final String category; // e.g., "Technical", "Soft Skills", "Languages"

  Skill({
    required this.id,
    required this.name,
    required this.level,
    required this.category,
  });

  Skill copyWith({
    String? id,
    String? name,
    SkillLevel? level,
    String? category,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level.toString().split('.').last,
      'category': category,
    };
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      name: json['name'],
      level: SkillLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['level'],
        orElse: () => SkillLevel.intermediate,
      ),
      category: json['category'],
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Skill.fromJsonString(String jsonString) {
    return Skill.fromJson(jsonDecode(jsonString));
  }
}

/// Skill proficiency levels
enum SkillLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

extension SkillLevelExtension on SkillLevel {
  String get displayName {
    switch (this) {
      case SkillLevel.beginner:
        return 'Beginner';
      case SkillLevel.intermediate:
        return 'Intermediate';
      case SkillLevel.advanced:
        return 'Advanced';
      case SkillLevel.expert:
        return 'Expert';
    }
  }

  double get percentage {
    switch (this) {
      case SkillLevel.beginner:
        return 0.25;
      case SkillLevel.intermediate:
        return 0.50;
      case SkillLevel.advanced:
        return 0.75;
      case SkillLevel.expert:
        return 1.0;
    }
  }
}
