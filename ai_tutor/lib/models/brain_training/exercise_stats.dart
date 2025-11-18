import 'exercise_type.dart';
import 'exercise_result.dart';

/// Statistics for a specific exercise type
class ExerciseStats {
  final ExerciseType exerciseType;
  final int timesPlayed;
  final int totalScore;
  final int bestScore;
  final double averageAccuracy;
  final Duration totalTimeSpent;
  final Duration bestTime;
  final DateTime? lastPlayed;
  final List<ExerciseResult> recentResults; // Last 10 results

  ExerciseStats({
    required this.exerciseType,
    this.timesPlayed = 0,
    this.totalScore = 0,
    this.bestScore = 0,
    this.averageAccuracy = 0,
    this.totalTimeSpent = Duration.zero,
    this.bestTime = Duration.zero,
    this.lastPlayed,
    this.recentResults = const [],
  });

  /// Average score per game
  double get averageScore =>
      timesPlayed > 0 ? totalScore / timesPlayed : 0;

  /// Calculate improvement trend (positive = improving, negative = declining)
  double get improvementTrend {
    if (recentResults.length < 2) return 0;

    final recent = recentResults.take(3).toList();
    final older = recentResults.skip(3).take(3).toList();

    if (recent.isEmpty || older.isEmpty) return 0;

    final recentAvg =
        recent.map((r) => r.percentage).reduce((a, b) => a + b) / recent.length;
    final olderAvg =
        older.map((r) => r.percentage).reduce((a, b) => a + b) / older.length;

    return recentAvg - olderAvg;
  }

  Map<String, dynamic> toJson() => {
        'exerciseType': exerciseType.name,
        'timesPlayed': timesPlayed,
        'totalScore': totalScore,
        'bestScore': bestScore,
        'averageAccuracy': averageAccuracy,
        'totalTimeSpent': totalTimeSpent.inSeconds,
        'bestTime': bestTime.inSeconds,
        'lastPlayed': lastPlayed?.toIso8601String(),
        'recentResults': recentResults.map((r) => r.toJson()).toList(),
      };

  factory ExerciseStats.fromJson(Map<String, dynamic> json) {
    return ExerciseStats(
      exerciseType: ExerciseType.values.firstWhere(
        (e) => e.name == json['exerciseType'],
      ),
      timesPlayed: json['timesPlayed'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 0,
      totalTimeSpent: Duration(seconds: json['totalTimeSpent'] as int? ?? 0),
      bestTime: Duration(seconds: json['bestTime'] as int? ?? 0),
      lastPlayed: json['lastPlayed'] != null
          ? DateTime.parse(json['lastPlayed'] as String)
          : null,
      recentResults: (json['recentResults'] as List<dynamic>?)
              ?.map((r) => ExerciseResult.fromJson(r as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  ExerciseStats copyWith({
    ExerciseType? exerciseType,
    int? timesPlayed,
    int? totalScore,
    int? bestScore,
    double? averageAccuracy,
    Duration? totalTimeSpent,
    Duration? bestTime,
    DateTime? lastPlayed,
    List<ExerciseResult>? recentResults,
  }) {
    return ExerciseStats(
      exerciseType: exerciseType ?? this.exerciseType,
      timesPlayed: timesPlayed ?? this.timesPlayed,
      totalScore: totalScore ?? this.totalScore,
      bestScore: bestScore ?? this.bestScore,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      bestTime: bestTime ?? this.bestTime,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      recentResults: recentResults ?? this.recentResults,
    );
  }
}
