// models/job_application.dart
// Model for job application tracking

class JobApplication {
  final String id;
  final String companyName;
  final String positionTitle;
  final String? jobUrl;
  final ApplicationStatus status;
  final String? location;
  final String? salaryRange;
  final String? description;
  final String? notes;
  final String? resumeId;
  final String? coverLetterId;
  final DateTime? appliedDate;
  final DateTime? deadlineDate;
  final List<Interview> interviews;
  final List<Reminder> reminders;
  final DateTime createdAt;
  final DateTime updatedAt;

  JobApplication({
    required this.id,
    required this.companyName,
    required this.positionTitle,
    this.jobUrl,
    this.status = ApplicationStatus.applied,
    this.location,
    this.salaryRange,
    this.description,
    this.notes,
    this.resumeId,
    this.coverLetterId,
    this.appliedDate,
    this.deadlineDate,
    this.interviews = const [],
    this.reminders = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'positionTitle': positionTitle,
      'jobUrl': jobUrl,
      'status': status.name,
      'location': location,
      'salaryRange': salaryRange,
      'description': description,
      'notes': notes,
      'resumeId': resumeId,
      'coverLetterId': coverLetterId,
      'appliedDate': appliedDate?.toIso8601String(),
      'deadlineDate': deadlineDate?.toIso8601String(),
      'interviews': interviews.map((i) => i.toJson()).toList(),
      'reminders': reminders.map((r) => r.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      positionTitle: json['positionTitle'] as String,
      jobUrl: json['jobUrl'] as String?,
      status: ApplicationStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => ApplicationStatus.applied,
      ),
      location: json['location'] as String?,
      salaryRange: json['salaryRange'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      resumeId: json['resumeId'] as String?,
      coverLetterId: json['coverLetterId'] as String?,
      appliedDate: json['appliedDate'] != null
          ? DateTime.parse(json['appliedDate'] as String)
          : null,
      deadlineDate: json['deadlineDate'] != null
          ? DateTime.parse(json['deadlineDate'] as String)
          : null,
      interviews: (json['interviews'] as List<dynamic>?)
              ?.map((i) => Interview.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((r) => Reminder.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  JobApplication copyWith({
    String? id,
    String? companyName,
    String? positionTitle,
    String? jobUrl,
    ApplicationStatus? status,
    String? location,
    String? salaryRange,
    String? description,
    String? notes,
    String? resumeId,
    String? coverLetterId,
    DateTime? appliedDate,
    DateTime? deadlineDate,
    List<Interview>? interviews,
    List<Reminder>? reminders,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobApplication(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      positionTitle: positionTitle ?? this.positionTitle,
      jobUrl: jobUrl ?? this.jobUrl,
      status: status ?? this.status,
      location: location ?? this.location,
      salaryRange: salaryRange ?? this.salaryRange,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      resumeId: resumeId ?? this.resumeId,
      coverLetterId: coverLetterId ?? this.coverLetterId,
      appliedDate: appliedDate ?? this.appliedDate,
      deadlineDate: deadlineDate ?? this.deadlineDate,
      interviews: interviews ?? this.interviews,
      reminders: reminders ?? this.reminders,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

enum ApplicationStatus {
  saved,
  applied,
  phoneScreen,
  interview,
  offer,
  rejected,
  accepted,
  declined;

  String get displayName {
    switch (this) {
      case ApplicationStatus.saved:
        return 'Saved';
      case ApplicationStatus.applied:
        return 'Applied';
      case ApplicationStatus.phoneScreen:
        return 'Phone Screen';
      case ApplicationStatus.interview:
        return 'Interview';
      case ApplicationStatus.offer:
        return 'Offer';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.accepted:
        return 'Accepted';
      case ApplicationStatus.declined:
        return 'Declined';
    }
  }
}

class Interview {
  final String id;
  final DateTime dateTime;
  final String? interviewerName;
  final String? location;
  final InterviewType type;
  final String? notes;

  Interview({
    required this.id,
    required this.dateTime,
    this.interviewerName,
    this.location,
    required this.type,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'interviewerName': interviewerName,
      'location': location,
      'type': type.name,
      'notes': notes,
    };
  }

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      interviewerName: json['interviewerName'] as String?,
      location: json['location'] as String?,
      type: InterviewType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => InterviewType.other,
      ),
      notes: json['notes'] as String?,
    );
  }
}

enum InterviewType {
  phone,
  video,
  onsite,
  technical,
  behavioral,
  other;

  String get displayName {
    switch (this) {
      case InterviewType.phone:
        return 'Phone';
      case InterviewType.video:
        return 'Video';
      case InterviewType.onsite:
        return 'On-site';
      case InterviewType.technical:
        return 'Technical';
      case InterviewType.behavioral:
        return 'Behavioral';
      case InterviewType.other:
        return 'Other';
    }
  }
}

class Reminder {
  final String id;
  final DateTime date;
  final String message;
  final bool isCompleted;

  Reminder({
    required this.id,
    required this.date,
    required this.message,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'message': message,
      'isCompleted': isCompleted,
    };
  }

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      message: json['message'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}
