// services/job_tracker_service.dart
// Service for job application tracking

import 'package:cv_engineer/models/job_application.dart';
import 'package:uuid/uuid.dart';

class JobTrackerService {
  static const _uuid = Uuid();

  /// Create new job application
  static JobApplication createApplication({
    required String companyName,
    required String positionTitle,
    String? jobUrl,
    String? location,
    String? salaryRange,
    String? description,
    String? resumeId,
    String? coverLetterId,
  }) {
    return JobApplication(
      id: _uuid.v4(),
      companyName: companyName,
      positionTitle: positionTitle,
      jobUrl: jobUrl,
      location: location,
      salaryRange: salaryRange,
      description: description,
      resumeId: resumeId,
      coverLetterId: coverLetterId,
      status: ApplicationStatus.saved,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Update application status
  static JobApplication updateStatus(
    JobApplication application,
    ApplicationStatus newStatus,
  ) {
    return application.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
  }

  /// Add interview to application
  static JobApplication addInterview(
    JobApplication application,
    Interview interview,
  ) {
    final updatedInterviews = [...application.interviews, interview];
    return application.copyWith(
      interviews: updatedInterviews,
      status: ApplicationStatus.interview,
      updatedAt: DateTime.now(),
    );
  }

  /// Add reminder to application
  static JobApplication addReminder(
    JobApplication application,
    Reminder reminder,
  ) {
    final updatedReminders = [...application.reminders, reminder];
    return application.copyWith(
      reminders: updatedReminders,
      updatedAt: DateTime.now(),
    );
  }

  /// Mark reminder as completed
  static JobApplication completeReminder(
    JobApplication application,
    String reminderId,
  ) {
    final updatedReminders = application.reminders.map((r) {
      if (r.id == reminderId) {
        return Reminder(
          id: r.id,
          date: r.date,
          message: r.message,
          isCompleted: true,
        );
      }
      return r;
    }).toList();

    return application.copyWith(
      reminders: updatedReminders,
      updatedAt: DateTime.now(),
    );
  }

  /// Get applications by status
  static List<JobApplication> filterByStatus(
    List<JobApplication> applications,
    ApplicationStatus status,
  ) {
    return applications.where((app) => app.status == status).toList();
  }

  /// Get upcoming interviews
  static List<Interview> getUpcomingInterviews(
    List<JobApplication> applications,
  ) {
    final now = DateTime.now();
    final allInterviews = <Interview>[];

    for (final app in applications) {
      allInterviews.addAll(app.interviews);
    }

    return allInterviews.where((interview) {
      return interview.dateTime.isAfter(now);
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  /// Get pending reminders
  static List<Reminder> getPendingReminders(
    List<JobApplication> applications,
  ) {
    final allReminders = <Reminder>[];

    for (final app in applications) {
      allReminders.addAll(
        app.reminders.where((r) => !r.isCompleted),
      );
    }

    return allReminders..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Calculate statistics
  static Map<String, dynamic> calculateStatistics(
    List<JobApplication> applications,
  ) {
    final total = applications.length;
    final byStatus = <ApplicationStatus, int>{};

    for (final status in ApplicationStatus.values) {
      byStatus[status] = applications.where((app) => app.status == status).length;
    }

    final interviewRate = total > 0
        ? (byStatus[ApplicationStatus.interview]! +
           byStatus[ApplicationStatus.offer]! +
           byStatus[ApplicationStatus.accepted]!) / total * 100
        : 0.0;

    final offerRate = total > 0
        ? (byStatus[ApplicationStatus.offer]! + byStatus[ApplicationStatus.accepted]!) / total * 100
        : 0.0;

    return {
      'total': total,
      'byStatus': byStatus,
      'interviewRate': interviewRate,
      'offerRate': offerRate,
      'pending': byStatus[ApplicationStatus.applied]! + byStatus[ApplicationStatus.phoneScreen]!,
      'active': byStatus[ApplicationStatus.interview]!,
      'successful': byStatus[ApplicationStatus.accepted]!,
      'unsuccessful': byStatus[ApplicationStatus.rejected]! + byStatus[ApplicationStatus.declined]!,
    };
  }

  /// Search applications
  static List<JobApplication> searchApplications(
    List<JobApplication> applications,
    String query,
  ) {
    final lowerQuery = query.toLowerCase();

    return applications.where((app) {
      return app.companyName.toLowerCase().contains(lowerQuery) ||
          app.positionTitle.toLowerCase().contains(lowerQuery) ||
          (app.location?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Sort applications
  static List<JobApplication> sortApplications(
    List<JobApplication> applications, {
    required String sortBy,
    required bool ascending,
  }) {
    final sorted = List<JobApplication>.from(applications);

    switch (sortBy) {
      case 'company':
        sorted.sort((a, b) => a.companyName.compareTo(b.companyName));
        break;
      case 'position':
        sorted.sort((a, b) => a.positionTitle.compareTo(b.positionTitle));
        break;
      case 'appliedDate':
        sorted.sort((a, b) {
          if (a.appliedDate == null && b.appliedDate == null) return 0;
          if (a.appliedDate == null) return 1;
          if (b.appliedDate == null) return -1;
          return a.appliedDate!.compareTo(b.appliedDate!);
        });
        break;
      case 'deadline':
        sorted.sort((a, b) {
          if (a.deadlineDate == null && b.deadlineDate == null) return 0;
          if (a.deadlineDate == null) return 1;
          if (b.deadlineDate == null) return -1;
          return a.deadlineDate!.compareTo(b.deadlineDate!);
        });
        break;
      case 'created':
      default:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    return ascending ? sorted : sorted.reversed.toList();
  }
}
