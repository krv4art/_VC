// models/job_description.dart
// Model for job description data used in ATS analysis

class JobDescription {
  final String id;
  final String jobTitle;
  final String companyName;
  final String description;
  final List<String> requiredSkills;
  final List<String> preferredSkills;
  final List<String> responsibilities;
  final List<String> qualifications;
  final String location;
  final String jobType; // Full-time, Part-time, Contract, etc.
  final String experienceLevel; // Entry, Mid, Senior
  final DateTime createdAt;
  final String? url;

  JobDescription({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.description,
    required this.requiredSkills,
    required this.preferredSkills,
    required this.responsibilities,
    required this.qualifications,
    required this.location,
    required this.jobType,
    required this.experienceLevel,
    required this.createdAt,
    this.url,
  });

  // Create from raw text description
  factory JobDescription.fromRawText({
    required String id,
    required String rawText,
    String? url,
  }) {
    return JobDescription(
      id: id,
      jobTitle: '',
      companyName: '',
      description: rawText,
      requiredSkills: [],
      preferredSkills: [],
      responsibilities: [],
      qualifications: [],
      location: '',
      jobType: '',
      experienceLevel: '',
      createdAt: DateTime.now(),
      url: url,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'description': description,
      'requiredSkills': requiredSkills,
      'preferredSkills': preferredSkills,
      'responsibilities': responsibilities,
      'qualifications': qualifications,
      'location': location,
      'jobType': jobType,
      'experienceLevel': experienceLevel,
      'createdAt': createdAt.toIso8601String(),
      'url': url,
    };
  }

  // Create from JSON
  factory JobDescription.fromJson(Map<String, dynamic> json) {
    return JobDescription(
      id: json['id'] as String,
      jobTitle: json['jobTitle'] as String,
      companyName: json['companyName'] as String,
      description: json['description'] as String,
      requiredSkills: (json['requiredSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      preferredSkills: (json['preferredSkills'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      responsibilities: (json['responsibilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      qualifications: (json['qualifications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      location: json['location'] as String,
      jobType: json['jobType'] as String,
      experienceLevel: json['experienceLevel'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      url: json['url'] as String?,
    );
  }

  // Get all keywords from job description
  List<String> getAllKeywords() {
    final keywords = <String>{};
    keywords.addAll(requiredSkills);
    keywords.addAll(preferredSkills);
    keywords.addAll(qualifications);
    return keywords.toList();
  }

  // Get combined text for keyword extraction
  String getCombinedText() {
    return [
      jobTitle,
      description,
      ...requiredSkills,
      ...preferredSkills,
      ...responsibilities,
      ...qualifications,
    ].join(' ');
  }

  JobDescription copyWith({
    String? id,
    String? jobTitle,
    String? companyName,
    String? description,
    List<String>? requiredSkills,
    List<String>? preferredSkills,
    List<String>? responsibilities,
    List<String>? qualifications,
    String? location,
    String? jobType,
    String? experienceLevel,
    DateTime? createdAt,
    String? url,
  }) {
    return JobDescription(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      description: description ?? this.description,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      preferredSkills: preferredSkills ?? this.preferredSkills,
      responsibilities: responsibilities ?? this.responsibilities,
      qualifications: qualifications ?? this.qualifications,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      createdAt: createdAt ?? this.createdAt,
      url: url ?? this.url,
    );
  }
}
