import 'dart:convert';

/// Cover Letter model
class CoverLetter {
  final String id;
  final String? title; // Custom title for organization
  final String senderName;
  final String senderEmail;
  final String? senderPhone;
  final String? senderAddress;
  final String recipientName;
  final String? recipientTitle;
  final String companyName;
  final String? companyAddress;
  final DateTime date;
  final String salutation; // e.g., "Dear Hiring Manager"
  final String body; // Main content paragraphs
  final String closing; // e.g., "Sincerely"
  final String? associatedResumeId; // Link to resume
  final CoverLetterTemplate template; // Template style
  final DateTime createdAt;
  final DateTime updatedAt;

  CoverLetter({
    required this.id,
    this.title,
    required this.senderName,
    required this.senderEmail,
    this.senderPhone,
    this.senderAddress,
    required this.recipientName,
    this.recipientTitle,
    required this.companyName,
    this.companyAddress,
    required this.date,
    this.salutation = 'Dear Hiring Manager',
    required this.body,
    this.closing = 'Sincerely',
    this.associatedResumeId,
    this.template = CoverLetterTemplate.professional,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get display title
  String get displayTitle {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    return '$companyName - Cover Letter';
  }

  /// Calculate completeness percentage
  double get completenessPercentage {
    int total = 0;
    int filled = 0;

    // Required fields
    total += 5;
    if (senderName.isNotEmpty) filled++;
    if (senderEmail.isNotEmpty) filled++;
    if (recipientName.isNotEmpty) filled++;
    if (companyName.isNotEmpty) filled++;
    if (body.isNotEmpty) filled++;

    // Optional but important fields
    total += 5;
    if (senderPhone != null && senderPhone!.isNotEmpty) filled++;
    if (senderAddress != null && senderAddress!.isNotEmpty) filled++;
    if (recipientTitle != null && recipientTitle!.isNotEmpty) filled++;
    if (companyAddress != null && companyAddress!.isNotEmpty) filled++;
    if (associatedResumeId != null) filled++;

    return (filled / total) * 100;
  }

  CoverLetter copyWith({
    String? id,
    String? title,
    String? senderName,
    String? senderEmail,
    String? senderPhone,
    String? senderAddress,
    String? recipientName,
    String? recipientTitle,
    String? companyName,
    String? companyAddress,
    DateTime? date,
    String? salutation,
    String? body,
    String? closing,
    String? associatedResumeId,
    CoverLetterTemplate? template,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoverLetter(
      id: id ?? this.id,
      title: title ?? this.title,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      senderPhone: senderPhone ?? this.senderPhone,
      senderAddress: senderAddress ?? this.senderAddress,
      recipientName: recipientName ?? this.recipientName,
      recipientTitle: recipientTitle ?? this.recipientTitle,
      companyName: companyName ?? this.companyName,
      companyAddress: companyAddress ?? this.companyAddress,
      date: date ?? this.date,
      salutation: salutation ?? this.salutation,
      body: body ?? this.body,
      closing: closing ?? this.closing,
      associatedResumeId: associatedResumeId ?? this.associatedResumeId,
      template: template ?? this.template,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'senderPhone': senderPhone,
      'senderAddress': senderAddress,
      'recipientName': recipientName,
      'recipientTitle': recipientTitle,
      'companyName': companyName,
      'companyAddress': companyAddress,
      'date': date.toIso8601String(),
      'salutation': salutation,
      'body': body,
      'closing': closing,
      'associatedResumeId': associatedResumeId,
      'template': template.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CoverLetter.fromJson(Map<String, dynamic> json) {
    return CoverLetter(
      id: json['id'] as String,
      title: json['title'] as String?,
      senderName: json['senderName'] as String,
      senderEmail: json['senderEmail'] as String,
      senderPhone: json['senderPhone'] as String?,
      senderAddress: json['senderAddress'] as String?,
      recipientName: json['recipientName'] as String,
      recipientTitle: json['recipientTitle'] as String?,
      companyName: json['companyName'] as String,
      companyAddress: json['companyAddress'] as String?,
      date: DateTime.parse(json['date'] as String),
      salutation: json['salutation'] as String? ?? 'Dear Hiring Manager',
      body: json['body'] as String,
      closing: json['closing'] as String? ?? 'Sincerely',
      associatedResumeId: json['associatedResumeId'] as String?,
      template: json['template'] != null
          ? CoverLetterTemplate.values.firstWhere(
              (t) => t.name == json['template'],
              orElse: () => CoverLetterTemplate.professional,
            )
          : CoverLetterTemplate.professional,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory CoverLetter.fromJsonString(String jsonString) {
    return CoverLetter.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
  }

  /// Create empty cover letter
  factory CoverLetter.empty(String id) {
    final now = DateTime.now();
    return CoverLetter(
      id: id,
      senderName: '',
      senderEmail: '',
      recipientName: '',
      companyName: '',
      date: now,
      body: '',
      createdAt: now,
      updatedAt: now,
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
