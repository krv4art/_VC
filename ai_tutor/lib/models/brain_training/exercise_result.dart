import 'exercise_type.dart';

/// Result of a brain training exercise session
class ExerciseResult {
  final ExerciseType exerciseType;
  final int score;
  final int maxScore;
  final Duration duration;
  final int accuracy; // 0-100%
  final Map<String, dynamic> details; // Exercise-specific details
  final DateTime timestamp;
  final String? difficulty;

  ExerciseResult({
    required this.exerciseType,
    required this.score,
    required this.maxScore,
    required this.duration,
    required this.accuracy,
    this.details = const {},
    DateTime? timestamp,
    this.difficulty,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Percentage score (0-100)
  double get percentage => maxScore > 0 ? (score / maxScore * 100) : 0;

  /// Star rating (0-3)
  int get stars {
    final percent = percentage;
    if (percent >= 90) return 3;
    if (percent >= 70) return 2;
    if (percent >= 50) return 1;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'exerciseType': exerciseType.name,
        'score': score,
        'maxScore': maxScore,
        'duration': duration.inSeconds,
        'accuracy': accuracy,
        'details': details,
        'timestamp': timestamp.toIso8601String(),
        'difficulty': difficulty,
      };

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      exerciseType: ExerciseType.values.firstWhere(
        (e) => e.name == json['exerciseType'],
      ),
      score: json['score'] as int,
      maxScore: json['maxScore'] as int,
      duration: Duration(seconds: json['duration'] as int),
      accuracy: json['accuracy'] as int,
      details: Map<String, dynamic>.from(json['details'] ?? {}),
      timestamp: DateTime.parse(json['timestamp'] as String),
      difficulty: json['difficulty'] as String?,
    );
  }

  ExerciseResult copyWith({
    ExerciseType? exerciseType,
    int? score,
    int? maxScore,
    Duration? duration,
    int? accuracy,
    Map<String, dynamic>? details,
    DateTime? timestamp,
    String? difficulty,
  }) {
    return ExerciseResult(
      exerciseType: exerciseType ?? this.exerciseType,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      duration: duration ?? this.duration,
      accuracy: accuracy ?? this.accuracy,
      details: details ?? this.details,
      timestamp: timestamp ?? this.timestamp,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}
