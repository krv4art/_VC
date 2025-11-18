import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/brain_training/exercise_type.dart';
import '../models/brain_training/exercise_result.dart';
import '../models/brain_training/exercise_stats.dart';

class BrainTrainingProvider with ChangeNotifier {
  Map<ExerciseType, ExerciseStats> _stats = {};
  bool _isLoading = true;

  Map<ExerciseType, ExerciseStats> get stats => _stats;
  bool get isLoading => _isLoading;

  BrainTrainingProvider() {
    _loadStats();
  }

  /// Get stats for a specific exercise
  ExerciseStats getStatsFor(ExerciseType type) {
    return _stats[type] ??
        ExerciseStats(
          exerciseType: type,
          timesPlayed: 0,
        );
  }

  /// Calculate total time spent across all exercises
  Duration get totalTimeSpent {
    return _stats.values
        .fold(Duration.zero, (sum, stat) => sum + stat.totalTimeSpent);
  }

  /// Total number of exercises completed
  int get totalExercisesCompleted {
    return _stats.values.fold(0, (sum, stat) => sum + stat.timesPlayed);
  }

  /// Average accuracy across all exercises
  double get overallAccuracy {
    if (_stats.isEmpty) return 0;
    final totalAccuracy =
        _stats.values.fold(0.0, (sum, stat) => sum + stat.averageAccuracy);
    return totalAccuracy / _stats.length;
  }

  /// Best performing exercise (by average score)
  ExerciseType? get bestExercise {
    if (_stats.isEmpty) return null;
    return _stats.entries
        .reduce((a, b) => a.value.averageScore > b.value.averageScore ? a : b)
        .key;
  }

  /// Record a new exercise result
  Future<void> recordResult(ExerciseResult result) async {
    final currentStats = getStatsFor(result.exerciseType);

    // Update recent results (keep last 10)
    final updatedRecent = [result, ...currentStats.recentResults].take(10).toList();

    // Calculate new average accuracy
    final totalAccuracy = currentStats.averageAccuracy * currentStats.timesPlayed +
        result.accuracy;
    final newAverageAccuracy = totalAccuracy / (currentStats.timesPlayed + 1);

    // Update best score and best time
    final newBestScore = result.score > currentStats.bestScore
        ? result.score
        : currentStats.bestScore;

    Duration newBestTime = currentStats.bestTime;
    if (currentStats.bestTime == Duration.zero ||
        result.duration < currentStats.bestTime) {
      newBestTime = result.duration;
    }

    // Create updated stats
    final updatedStats = currentStats.copyWith(
      timesPlayed: currentStats.timesPlayed + 1,
      totalScore: currentStats.totalScore + result.score,
      bestScore: newBestScore,
      averageAccuracy: newAverageAccuracy,
      totalTimeSpent: currentStats.totalTimeSpent + result.duration,
      bestTime: newBestTime,
      lastPlayed: result.timestamp,
      recentResults: updatedRecent,
    );

    _stats[result.exerciseType] = updatedStats;
    await _saveStats();
    notifyListeners();
  }

  /// Reset all stats
  Future<void> resetStats() async {
    _stats = {};
    await _saveStats();
    notifyListeners();
  }

  /// Reset stats for specific exercise
  Future<void> resetExerciseStats(ExerciseType type) async {
    _stats.remove(type);
    await _saveStats();
    notifyListeners();
  }

  /// Load stats from SharedPreferences
  Future<void> _loadStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsJson = prefs.getString('brain_training_stats');

      if (statsJson != null) {
        final Map<String, dynamic> decoded = json.decode(statsJson);
        _stats = decoded.map(
          (key, value) => MapEntry(
            ExerciseType.values.firstWhere((e) => e.name == key),
            ExerciseStats.fromJson(value as Map<String, dynamic>),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error loading brain training stats: $e');
      _stats = {};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save stats to SharedPreferences
  Future<void> _saveStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final statsMap = _stats.map(
        (key, value) => MapEntry(key.name, value.toJson()),
      );
      await prefs.setString('brain_training_stats', json.encode(statsMap));
    } catch (e) {
      debugPrint('Error saving brain training stats: $e');
    }
  }
}
