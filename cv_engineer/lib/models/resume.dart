import 'dart:convert';
import 'personal_info.dart';
import 'experience.dart';
import 'education.dart';
import 'skill.dart';
import 'language.dart';
import 'custom_section.dart';
import 'social_links.dart';

/// Main Resume model
class Resume {
  final String id;
  final String templateId;
  final PersonalInfo personalInfo;
  final List<Experience> experiences;
  final List<Education> educations;
  final List<Skill> skills;
  final List<Language> languages;
  final List<CustomSection> customSections;
  final List<SocialLink> socialLinks;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Formatting options
  final double fontSize;
  final double marginSize;
  final String fontFamily;

  Resume({
    required this.id,
    required this.templateId,
    required this.personalInfo,
    this.experiences = const [],
    this.educations = const [],
    this.skills = const [],
    this.languages = const [],
    this.customSections = const [],
    this.socialLinks = const [],
    required this.createdAt,
    required this.updatedAt,
    this.fontSize = 11.0,
    this.marginSize = 20.0,
    this.fontFamily = 'Roboto',
  });

  Resume copyWith({
    String? id,
    String? templateId,
    PersonalInfo? personalInfo,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Language>? languages,
    List<CustomSection>? customSections,
    List<SocialLink>? socialLinks,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? fontSize,
    double? marginSize,
    String? fontFamily,
  }) {
    return Resume(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      personalInfo: personalInfo ?? this.personalInfo,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      languages: languages ?? this.languages,
      customSections: customSections ?? this.customSections,
      socialLinks: socialLinks ?? this.socialLinks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fontSize: fontSize ?? this.fontSize,
      marginSize: marginSize ?? this.marginSize,
      fontFamily: fontFamily ?? this.fontFamily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateId': templateId,
      'personalInfo': personalInfo.toJson(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'languages': languages.map((l) => l.toJson()).toList(),
      'customSections': customSections.map((cs) => cs.toJson()).toList(),
      'socialLinks': socialLinks.map((sl) => sl.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'fontSize': fontSize,
      'marginSize': marginSize,
      'fontFamily': fontFamily,
    };
  }

  factory Resume.fromJson(Map<String, dynamic> json) {
    return Resume(
      id: json['id'],
      templateId: json['templateId'],
      personalInfo: PersonalInfo.fromJson(json['personalInfo']),
      experiences: (json['experiences'] as List)
          .map((e) => Experience.fromJson(e))
          .toList(),
      educations: (json['educations'] as List)
          .map((e) => Education.fromJson(e))
          .toList(),
      skills: (json['skills'] as List)
          .map((s) => Skill.fromJson(s))
          .toList(),
      languages: (json['languages'] as List)
          .map((l) => Language.fromJson(l))
          .toList(),
      customSections: (json['customSections'] as List)
          .map((cs) => CustomSection.fromJson(cs))
          .toList(),
      socialLinks: (json['socialLinks'] as List?)
          ?.map((sl) => SocialLink.fromJson(sl))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      fontSize: json['fontSize'] ?? 11.0,
      marginSize: json['marginSize'] ?? 20.0,
      fontFamily: json['fontFamily'] ?? 'Roboto',
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Resume.fromJsonString(String jsonString) {
    return Resume.fromJson(jsonDecode(jsonString));
  }

  // Create empty resume
  static Resume empty() {
    final now = DateTime.now();
    return Resume(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      templateId: 'professional',
      personalInfo: PersonalInfo.empty(),
      createdAt: now,
      updatedAt: now,
    );
  }

  // Calculate completeness percentage
  double get completenessPercentage {
    int completed = 0;
    int total = 8;

    if (personalInfo.fullName.isNotEmpty) completed++;
    if (personalInfo.email.isNotEmpty) completed++;
    if (personalInfo.phone.isNotEmpty) completed++;
    if (personalInfo.profileSummary != null && personalInfo.profileSummary!.isNotEmpty) completed++;
    if (experiences.isNotEmpty) completed++;
    if (educations.isNotEmpty) completed++;
    if (skills.isNotEmpty) completed++;
    if (languages.isNotEmpty) completed++;

    return (completed / total) * 100;
  }
}
