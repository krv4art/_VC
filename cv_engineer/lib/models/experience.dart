import 'dart:convert';

/// Work experience model
class Experience {
  final String id;
  final String jobTitle;
  final String company;
  final String? location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;
  final String? description;
  final List<String> responsibilities;

  Experience({
    required this.id,
    required this.jobTitle,
    required this.company,
    this.location,
    required this.startDate,
    this.endDate,
    this.isCurrentJob = false,
    this.description,
    this.responsibilities = const [],
  });

  Experience copyWith({
    String? id,
    String? jobTitle,
    String? company,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCurrentJob,
    String? description,
    List<String>? responsibilities,
  }) {
    return Experience(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      company: company ?? this.company,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCurrentJob: isCurrentJob ?? this.isCurrentJob,
      description: description ?? this.description,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'company': company,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'isCurrentJob': isCurrentJob,
      'description': description,
      'responsibilities': responsibilities,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      jobTitle: json['jobTitle'],
      company: json['company'],
      location: json['location'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      isCurrentJob: json['isCurrentJob'] ?? false,
      description: json['description'],
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory Experience.fromJsonString(String jsonString) {
    return Experience.fromJson(jsonDecode(jsonString));
  }

  // Calculate duration
  String getDuration() {
    final end = isCurrentJob ? DateTime.now() : (endDate ?? DateTime.now());
    final diff = end.difference(startDate);
    final years = diff.inDays ~/ 365;
    final months = (diff.inDays % 365) ~/ 30;

    if (years > 0 && months > 0) {
      return '$years yr${years > 1 ? 's' : ''} $months mo${months > 1 ? 's' : ''}';
    } else if (years > 0) {
      return '$years yr${years > 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months mo${months > 1 ? 's' : ''}';
    } else {
      return 'Less than a month';
    }
  }
}
