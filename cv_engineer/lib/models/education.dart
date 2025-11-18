import 'dart:convert';

/// Education model
class Education {
  final String id;
  final String degree;
  final String institution;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrent;
  final String? gpa;
  final String? description;
  final List<String> achievements;

  Education({
    required this.id,
    required this.degree,
    required this.institution,
    this.location,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.gpa,
    this.description,
    this.achievements = const [],
  });

  Education copyWith({
    String? id,
    String? degree,
    String? institution,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrent,
    String? gpa,
    String? description,
    List<String>? achievements,
  }) {
    return Education(
      id: id ?? this.id,
      degree: degree ?? this.degree,
      institution: institution ?? this.institution,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrent: isCurrent ?? this.isCurrent,
      gpa: gpa ?? this.gpa,
      description: description ?? this.description,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'gpa': gpa,
      'description': description,
      'achievements': achievements,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      degree: json['degree'],
      institution: json['institution'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrent: json['isCurrent'] ?? false,
      gpa: json['gpa'],
      description: json['description'],
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Education.fromJsonString(String jsonString) {
    return Education.fromJson(jsonDecode(jsonString));
  }
}
