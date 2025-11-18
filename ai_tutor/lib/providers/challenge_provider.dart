import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

import '../models/challenge.dart';
import '../models/subject.dart';

/// Provider for managing daily challenges and study goals
class ChallengeProvider with ChangeNotifier {
  DailyChallenge? _todayChallenge;
  final List<StudyGoal> _goals = [];
  bool _isLoading = false;

  DailyChallenge? get todayChallenge => _todayChallenge;
  List<StudyGoal> get goals => List.unmodifiable(_goals);
  List<StudyGoal> get activeGoals =>
      _goals.where((g) => !g.isCompleted).toList();
  List<StudyGoal> get completedGoals =>
      _goals.where((g) => g.isCompleted).toList();
  bool get isLoading => _isLoading;

  /// Initialize challenges and goals
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      // Load today's challenge
      final challengeJson = prefs.getString('daily_challenge');
      if (challengeJson != null) {
        final data = json.decode(challengeJson);
        final challenge = DailyChallenge.fromJson(data);

        // Check if challenge is for today
        final today = DateTime.now();
        if (challenge.date.year == today.year &&
            challenge.date.month == today.month &&
            challenge.date.day == today.day) {
          _todayChallenge = challenge;
        } else {
          // Generate new challenge for today
          _todayChallenge = _generateDailyChallenge();
          await _saveChallenge();
        }
      } else {
        // Generate first challenge
        _todayChallenge = _generateDailyChallenge();
        await _saveChallenge();
      }

      // Load goals
      final goalsJson = prefs.getString('study_goals');
      if (goalsJson != null) {
        final data = json.decode(goalsJson) as List;
        _goals.clear();
        _goals.addAll(data.map((g) => StudyGoal.fromJson(g)));
      }
    } catch (e) {
      debugPrint('Error loading challenges: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Generate daily challenge
  DailyChallenge _generateDailyChallenge() {
    final random = Random();
    final subjects = Subjects.all;
    final subject = subjects[random.nextInt(subjects.length)];
    final topic = subject.topics[random.nextInt(subject.topics.length)];

    final challenges = [
      {
        'title': 'Quick Practice',
        'description': 'Solve 5 ${subject.name} problems',
        'target': 5,
        'xp': 100,
      },
      {
        'title': 'Perfect Score',
        'description': 'Get 3 problems correct in a row',
        'target': 3,
        'xp': 150,
      },
      {
        'title': 'Topic Master',
        'description': 'Complete 10 $topic problems',
        'target': 10,
        'xp': 200,
      },
      {
        'title': 'Speed Run',
        'description': 'Solve 5 problems in under 10 minutes',
        'target': 5,
        'xp': 180,
      },
      {
        'title': 'Consistency',
        'description': 'Practice for at least 15 minutes',
        'target': 15,
        'xp': 120,
      },
    ];

    final selectedChallenge = challenges[random.nextInt(challenges.length)];

    return DailyChallenge(
      date: DateTime.now(),
      subjectId: subject.id,
      topic: topic,
      title: selectedChallenge['title'] as String,
      description: selectedChallenge['description'] as String,
      targetProblems: selectedChallenge['target'] as int,
      difficulty: 5 + random.nextInt(5),
      xpReward: selectedChallenge['xp'] as int,
    );
  }

  /// Update challenge progress
  Future<void> updateChallengeProgress(int progress) async {
    if (_todayChallenge == null) return;

    final newProgress = _todayChallenge!.currentProgress + progress;
    final isCompleted = newProgress >= _todayChallenge!.targetProblems;

    _todayChallenge = _todayChallenge!.copyWith(
      currentProgress: newProgress,
      isCompleted: isCompleted,
    );

    await _saveChallenge();
    notifyListeners();
  }

  /// Complete today's challenge
  Future<void> completeChallenge() async {
    if (_todayChallenge == null) return;

    _todayChallenge = _todayChallenge!.copyWith(isCompleted: true);
    await _saveChallenge();
    notifyListeners();
  }

  /// Add study goal
  Future<void> addGoal(StudyGoal goal) async {
    _goals.add(goal);
    await _saveGoals();
    notifyListeners();
  }

  /// Update goal progress
  Future<void> updateGoalProgress(String goalId, int progress) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1) return;

    final goal = _goals[index];
    final newProgress = goal.currentValue + progress;
    final isCompleted = newProgress >= goal.targetValue;

    _goals[index] = goal.copyWith(
      currentValue: newProgress,
      isCompleted: isCompleted,
    );

    await _saveGoals();
    notifyListeners();
  }

  /// Complete goal
  Future<void> completeGoal(String goalId) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index == -1) return;

    _goals[index] = _goals[index].copyWith(isCompleted: true);
    await _saveGoals();
    notifyListeners();
  }

  /// Delete goal
  Future<void> deleteGoal(String goalId) async {
    _goals.removeWhere((g) => g.id == goalId);
    await _saveGoals();
    notifyListeners();
  }

  /// Save challenge
  Future<void> _saveChallenge() async {
    try {
      if (_todayChallenge == null) return;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'daily_challenge',
        json.encode(_todayChallenge!.toJson()),
      );
    } catch (e) {
      debugPrint('Error saving challenge: $e');
    }
  }

  /// Save goals
  Future<void> _saveGoals() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _goals.map((g) => g.toJson()).toList();
      await prefs.setString('study_goals', json.encode(data));
    } catch (e) {
      debugPrint('Error saving goals: $e');
    }
  }

  /// Check and update goals based on progress
  Future<void> checkGoalsProgress({
    int? problemsSolved,
    double? accuracy,
    int? streak,
    int? studyMinutes,
    String? masteredTopic,
  }) async {
    for (var i = 0; i < _goals.length; i++) {
      final goal = _goals[i];
      if (goal.isCompleted) continue;

      int? newValue;
      switch (goal.type) {
        case GoalType.problemsSolved:
          if (problemsSolved != null) {
            newValue = goal.currentValue + problemsSolved;
          }
          break;
        case GoalType.accuracy:
          if (accuracy != null) {
            newValue = accuracy.round();
          }
          break;
        case GoalType.streak:
          if (streak != null) {
            newValue = streak;
          }
          break;
        case GoalType.studyTime:
          if (studyMinutes != null) {
            newValue = goal.currentValue + studyMinutes;
          }
          break;
        case GoalType.topicMastery:
          // Handled separately
          break;
      }

      if (newValue != null && newValue != goal.currentValue) {
        await updateGoalProgress(goal.id, newValue - goal.currentValue);
      }
    }
  }

  /// Reset (for testing)
  Future<void> reset() async {
    _todayChallenge = null;
    _goals.clear();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('daily_challenge');
    await prefs.remove('study_goals');

    notifyListeners();
  }
}
