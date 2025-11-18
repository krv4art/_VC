import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/progress.dart';

/// Provider for tracking student progress
class ProgressProvider with ChangeNotifier {
  final Map<String, StudentProgress> _progressBySubject = {};
  PracticeSession? _currentSession;
  DateTime? _sessionStartTime;

  Map<String, StudentProgress> get progressBySubject => _progressBySubject;
  PracticeSession? get currentSession => _currentSession;
  bool get isSessionActive => _currentSession != null;

  /// Initialize progress data
  Future<void> initialize(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final progressJson = prefs.getString('progress_data');

      if (progressJson != null) {
        final data = json.decode(progressJson) as Map<String, dynamic>;
        data.forEach((subjectId, progressData) {
          _progressBySubject[subjectId] =
              StudentProgress.fromJson(progressData);
        });
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }

  /// Get progress for a subject
  StudentProgress getProgress(String userId, String subjectId) {
    return _progressBySubject[subjectId] ??
        StudentProgress(userId: userId, subjectId: subjectId);
  }

  /// Start practice session
  void startSession(String userId, String subjectId) {
    _currentSession = PracticeSession(
      userId: userId,
      subjectId: subjectId,
    );
    _sessionStartTime = DateTime.now();
    notifyListeners();
  }

  /// End practice session
  Future<void> endSession() async {
    if (_currentSession == null) return;

    final session = _currentSession!.copyWith(
      endTime: DateTime.now(),
    );

    // Update total study time
    final progress = getProgress(session.userId, session.subjectId);
    final updatedProgress = progress.copyWith(
      totalMinutesStudied: progress.totalMinutesStudied + session.durationMinutes,
      lastPracticeDate: DateTime.now(),
    );

    _progressBySubject[session.subjectId] = updatedProgress;
    _currentSession = null;
    _sessionStartTime = null;

    await _saveProgress();
    notifyListeners();
  }

  /// Record problem attempt
  Future<void> recordProblemAttempt({
    required String userId,
    required String subjectId,
    required bool isCorrect,
    required String topic,
    bool usedHint = false,
  }) async {
    final progress = getProgress(userId, subjectId);

    // Update topic progress
    final topicProgress = Map<String, int>.from(progress.topicProgress);
    topicProgress[topic] = (topicProgress[topic] ?? 0) + 1;

    // Check if topic is mastered (10+ problems with 80%+ accuracy)
    final masteredTopics = List<String>.from(progress.masteredTopics);
    if (topicProgress[topic]! >= 10 && !masteredTopics.contains(topic)) {
      masteredTopics.add(topic);
    }

    // Update streak
    final now = DateTime.now();
    final lastPractice = progress.lastPracticeDate;
    final daysSinceLastPractice = now.difference(lastPractice).inDays;

    int newStreak = progress.currentStreak;
    if (daysSinceLastPractice == 0) {
      // Same day, keep streak
      newStreak = progress.currentStreak;
    } else if (daysSinceLastPractice == 1) {
      // Next day, increment streak
      newStreak = progress.currentStreak + 1;
    } else {
      // Streak broken
      newStreak = 1;
    }

    final updatedProgress = progress.copyWith(
      totalProblems: progress.totalProblems + 1,
      solvedProblems: progress.solvedProblems + 1,
      correctAnswers: isCorrect ? progress.correctAnswers + 1 : progress.correctAnswers,
      hintsUsed: usedHint ? progress.hintsUsed + 1 : progress.hintsUsed,
      currentStreak: newStreak,
      longestStreak: newStreak > progress.longestStreak ? newStreak : progress.longestStreak,
      lastPracticeDate: now,
      topicProgress: topicProgress,
      masteredTopics: masteredTopics,
    );

    _progressBySubject[subjectId] = updatedProgress;

    // Update current session
    if (_currentSession != null && _currentSession!.subjectId == subjectId) {
      _currentSession = PracticeSession(
        id: _currentSession!.id,
        userId: userId,
        subjectId: subjectId,
        startTime: _currentSession!.startTime,
        problemsSolved: _currentSession!.problemsSolved + 1,
        correctAnswers: isCorrect
            ? _currentSession!.correctAnswers + 1
            : _currentSession!.correctAnswers,
      );
    }

    await _saveProgress();
    notifyListeners();
  }

  /// Get overall statistics
  Map<String, dynamic> getOverallStats() {
    int totalProblems = 0;
    int totalCorrect = 0;
    int totalMinutes = 0;
    int maxStreak = 0;

    for (final progress in _progressBySubject.values) {
      totalProblems += progress.totalProblems;
      totalCorrect += progress.correctAnswers;
      totalMinutes += progress.totalMinutesStudied;
      if (progress.longestStreak > maxStreak) {
        maxStreak = progress.longestStreak;
      }
    }

    return {
      'total_problems': totalProblems,
      'total_correct': totalCorrect,
      'total_minutes': totalMinutes,
      'max_streak': maxStreak,
      'accuracy': totalProblems > 0 ? (totalCorrect / totalProblems) * 100 : 0,
      'subjects_count': _progressBySubject.length,
    };
  }

  /// Save progress to storage
  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = <String, dynamic>{};

      _progressBySubject.forEach((subjectId, progress) {
        data[subjectId] = progress.toJson();
      });

      await prefs.setString('progress_data', json.encode(data));
    } catch (e) {
      debugPrint('Error saving progress: $e');
    }
  }

  /// Reset all progress (for testing)
  Future<void> resetProgress() async {
    _progressBySubject.clear();
    _currentSession = null;
    _sessionStartTime = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('progress_data');

    notifyListeners();
  }
}
