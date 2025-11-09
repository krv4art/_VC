import 'math_expression.dart';

/// Похожая задача для тренировки
class SimilarProblem {
  final MathExpression problem;
  final DifficultyLevel difficulty;
  final List<String>? answerOptions; // Варианты ответов (если режим с выбором)
  final String correctAnswer;
  final String? explanation; // Объяснение решения

  SimilarProblem({
    required this.problem,
    required this.difficulty,
    this.answerOptions,
    required this.correctAnswer,
    this.explanation,
  });

  factory SimilarProblem.fromJson(Map<String, dynamic> json) {
    return SimilarProblem(
      problem: MathExpression.fromJson(json['problem'] as Map<String, dynamic>),
      difficulty: DifficultyLevel.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => DifficultyLevel.medium,
      ),
      answerOptions: (json['answer_options'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'problem': problem.toJson(),
      'difficulty': difficulty.name,
      'answer_options': answerOptions,
      'correct_answer': correctAnswer,
      'explanation': explanation,
    };
  }
}

/// Попытка решения в режиме тренировки
class PracticeAttempt {
  final SimilarProblem problem;
  final String userAnswer;
  final bool isCorrect;
  final Duration timeSpent;
  final DateTime timestamp;

  PracticeAttempt({
    required this.problem,
    required this.userAnswer,
    required this.isCorrect,
    required this.timeSpent,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory PracticeAttempt.fromJson(Map<String, dynamic> json) {
    return PracticeAttempt(
      problem: SimilarProblem.fromJson(json['problem'] as Map<String, dynamic>),
      userAnswer: json['user_answer'] as String? ?? '',
      isCorrect: json['is_correct'] as bool? ?? false,
      timeSpent: Duration(seconds: json['time_spent_seconds'] as int? ?? 0),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'problem': problem.toJson(),
      'user_answer': userAnswer,
      'is_correct': isCorrect,
      'time_spent_seconds': timeSpent.inSeconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

/// Сессия тренировки
class TrainingSession {
  final int? id;
  final DateTime startTime;
  final List<PracticeAttempt> attempts;
  final int correctAnswers;
  final double accuracy; // Процент правильных ответов
  final Duration totalDuration;
  final bool isCompleted;

  TrainingSession({
    this.id,
    required this.startTime,
    required this.attempts,
    required this.correctAnswers,
    required this.accuracy,
    required this.totalDuration,
    this.isCompleted = false,
  });

  int get totalProblems => attempts.length;

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      id: json['id'] as int?,
      startTime: DateTime.parse(json['start_time'] as String),
      attempts: (json['attempts'] as List<dynamic>?)
              ?.map((e) => PracticeAttempt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      correctAnswers: json['correct_answers'] as int? ?? 0,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      totalDuration: Duration(seconds: json['total_duration_seconds'] as int? ?? 0),
      isCompleted: json['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'attempts': attempts.map((e) => e.toJson()).toList(),
      'correct_answers': correctAnswers,
      'accuracy': accuracy,
      'total_duration_seconds': totalDuration.inSeconds,
      'is_completed': isCompleted,
    };
  }

  /// Создать новую сессию
  factory TrainingSession.create() {
    return TrainingSession(
      startTime: DateTime.now(),
      attempts: [],
      correctAnswers: 0,
      accuracy: 0.0,
      totalDuration: Duration.zero,
    );
  }

  /// Добавить попытку
  TrainingSession addAttempt(PracticeAttempt attempt) {
    final newAttempts = List<PracticeAttempt>.from(attempts)..add(attempt);
    final newCorrectAnswers = correctAnswers + (attempt.isCorrect ? 1 : 0);
    final newAccuracy = newAttempts.isEmpty
        ? 0.0
        : (newCorrectAnswers / newAttempts.length) * 100;
    final newDuration = totalDuration + attempt.timeSpent;

    return TrainingSession(
      id: id,
      startTime: startTime,
      attempts: newAttempts,
      correctAnswers: newCorrectAnswers,
      accuracy: newAccuracy,
      totalDuration: newDuration,
      isCompleted: isCompleted,
    );
  }

  /// Завершить сессию
  TrainingSession complete() {
    return TrainingSession(
      id: id,
      startTime: startTime,
      attempts: attempts,
      correctAnswers: correctAnswers,
      accuracy: accuracy,
      totalDuration: totalDuration,
      isCompleted: true,
    );
  }
}
