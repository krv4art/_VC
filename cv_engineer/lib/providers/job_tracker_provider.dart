// providers/job_tracker_provider.dart
// State management for job application tracking

import 'package:flutter/foundation.dart';
import 'package:cv_engineer/models/job_application.dart';
import 'package:cv_engineer/services/job_tracker_service.dart';

class JobTrackerProvider extends ChangeNotifier {
  List<JobApplication> _applications = [];
  bool _isLoading = false;
  String? _error;

  List<JobApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get applications by status
  List<JobApplication> getApplicationsByStatus(ApplicationStatus status) {
    return JobTrackerService.filterByStatus(_applications, status);
  }

  // Get statistics
  Map<String, dynamic> get statistics {
    return JobTrackerService.calculateStatistics(_applications);
  }

  // Get upcoming interviews
  List<Interview> get upcomingInterviews {
    return JobTrackerService.getUpcomingInterviews(_applications);
  }

  // Get pending reminders
  List<Reminder> get pendingReminders {
    return JobTrackerService.getPendingReminders(_applications);
  }

  // Add new application
  Future<void> addApplication(JobApplication application) async {
    try {
      _applications.add(application);
      notifyListeners();

      // TODO: Save to database
      await _saveToDatabase();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update application
  Future<void> updateApplication(JobApplication application) async {
    try {
      final index = _applications.indexWhere((app) => app.id == application.id);
      if (index != -1) {
        _applications[index] = application;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete application
  Future<void> deleteApplication(String id) async {
    try {
      _applications.removeWhere((app) => app.id == id);
      notifyListeners();

      // TODO: Save to database
      await _saveToDatabase();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update status
  Future<void> updateStatus(String id, ApplicationStatus status) async {
    try {
      final index = _applications.indexWhere((app) => app.id == id);
      if (index != -1) {
        final updated = JobTrackerService.updateStatus(_applications[index], status);
        _applications[index] = updated;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add interview
  Future<void> addInterview(String applicationId, Interview interview) async {
    try {
      final index = _applications.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        final updated = JobTrackerService.addInterview(_applications[index], interview);
        _applications[index] = updated;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Add reminder
  Future<void> addReminder(String applicationId, Reminder reminder) async {
    try {
      final index = _applications.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        final updated = JobTrackerService.addReminder(_applications[index], reminder);
        _applications[index] = updated;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Complete reminder
  Future<void> completeReminder(String applicationId, String reminderId) async {
    try {
      final index = _applications.indexWhere((app) => app.id == applicationId);
      if (index != -1) {
        final updated = JobTrackerService.completeReminder(_applications[index], reminderId);
        _applications[index] = updated;
        notifyListeners();

        // TODO: Save to database
        await _saveToDatabase();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Search applications
  List<JobApplication> search(String query) {
    return JobTrackerService.searchApplications(_applications, query);
  }

  // Sort applications
  List<JobApplication> sort({
    required String sortBy,
    required bool ascending,
  }) {
    return JobTrackerService.sortApplications(
      _applications,
      sortBy: sortBy,
      ascending: ascending,
    );
  }

  // Load applications from database
  Future<void> loadApplications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Load from database
      // _applications = await database.getApplications();
      _applications = []; // Temporary

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save to database
  Future<void> _saveToDatabase() async {
    // TODO: Implement database save
    // await database.saveApplications(_applications);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
