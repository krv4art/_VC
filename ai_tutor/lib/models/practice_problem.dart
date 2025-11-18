/// Practice problem model
class PracticeProblem {
  final String id;
  final String subjectId;
  final String topic;
  final String problem;
  final int difficulty;
  final List<String> hints;
  final List<String> solutionSteps;
  final String answer;
  final List<String> concepts;
  final DateTime createdAt;

  PracticeProblem({
    String? id,
    required this.subjectId,
    required this.topic,
    required this.problem,
    required this.difficulty,
    this.hints = const [],
    this.solutionSteps = const [],
    required this.answer,
    this.concepts = const [],
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  String get correctAnswer => answer;

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_id': subjectId,
        'topic': topic,
        'problem': problem,
        'difficulty': difficulty,
        'hints': hints,
        'solution_steps': solutionSteps,
        'answer': answer,
        'concepts': concepts,
        'created_at': createdAt.toIso8601String(),
      };

  factory PracticeProblem.fromJson(Map<String, dynamic> json) =>
      PracticeProblem(
        id: json['id'],
        subjectId: json['subject_id'],
        topic: json['topic'],
        problem: json['problem'],
        difficulty: json['difficulty'],
        hints: json['hints'] != null ? List<String>.from(json['hints']) : [],
        solutionSteps: json['solution_steps'] != null
            ? List<String>.from(json['solution_steps'])
            : [],
        answer: json['answer'],
        concepts:
            json['concepts'] != null ? List<String>.from(json['concepts']) : [],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );
}

/// Problem attempt tracking
class ProblemAttempt {
  final String problemId;
  final String userAnswer;
  final bool isCorrect;
  final int hintsUsed;
  final DateTime attemptedAt;
  final int timeSpentSeconds;

  ProblemAttempt({
    required this.problemId,
    required this.userAnswer,
    required this.isCorrect,
    this.hintsUsed = 0,
    DateTime? attemptedAt,
    this.timeSpentSeconds = 0,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'problem_id': problemId,
        'user_answer': userAnswer,
        'is_correct': isCorrect,
        'hints_used': hintsUsed,
        'attempted_at': attemptedAt.toIso8601String(),
        'time_spent_seconds': timeSpentSeconds,
      };

  factory ProblemAttempt.fromJson(Map<String, dynamic> json) =>
      ProblemAttempt(
        problemId: json['problem_id'],
        userAnswer: json['user_answer'],
        isCorrect: json['is_correct'],
        hintsUsed: json['hints_used'] ?? 0,
        attemptedAt: json['attempted_at'] != null
            ? DateTime.parse(json['attempted_at'])
            : null,
        timeSpentSeconds: json['time_spent_seconds'] ?? 0,
      );
}
