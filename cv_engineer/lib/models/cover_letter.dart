// models/cover_letter.dart
// Model for cover letter

class CoverLetter {
  final String id;
  final String resumeId;
  final String companyName;
  final String position;
  final String hiringManagerName;
  final String content;
  final CoverLetterTemplate template;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoverLetter({
    required this.id,
    required this.resumeId,
    required this.companyName,
    required this.position,
    this.hiringManagerName = '',
    required this.content,
    required this.template,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resumeId': resumeId,
      'companyName': companyName,
      'position': position,
      'hiringManagerName': hiringManagerName,
      'content': content,
      'template': template.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CoverLetter.fromJson(Map<String, dynamic> json) {
    return CoverLetter(
      id: json['id'] as String,
      resumeId: json['resumeId'] as String,
      companyName: json['companyName'] as String,
      position: json['position'] as String,
      hiringManagerName: json['hiringManagerName'] as String? ?? '',
      content: json['content'] as String,
      template: CoverLetterTemplate.values.firstWhere(
        (t) => t.name == json['template'],
        orElse: () => CoverLetterTemplate.professional,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  CoverLetter copyWith({
    String? id,
    String? resumeId,
    String? companyName,
    String? position,
    String? hiringManagerName,
    String? content,
    CoverLetterTemplate? template,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoverLetter(
      id: id ?? this.id,
      resumeId: resumeId ?? this.resumeId,
      companyName: companyName ?? this.companyName,
      position: position ?? this.position,
      hiringManagerName: hiringManagerName ?? this.hiringManagerName,
      content: content ?? this.content,
      template: template ?? this.template,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum CoverLetterTemplate {
  professional,
  creative,
  modern,
  executive,
  entryLevel;

  String get displayName {
    switch (this) {
      case CoverLetterTemplate.professional:
        return 'Professional';
      case CoverLetterTemplate.creative:
        return 'Creative';
      case CoverLetterTemplate.modern:
        return 'Modern';
      case CoverLetterTemplate.executive:
        return 'Executive';
      case CoverLetterTemplate.entryLevel:
        return 'Entry Level';
    }
  }
}
