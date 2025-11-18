/// Student progress tracking model
class StudentProgress {
  final String userId;
  final String subjectId;
  final int totalProblems;
  final int solvedProblems;
  final int correctAnswers;
  final int hintsUsed;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastPracticeDate;
  final Map<String, int> topicProgress; // topic -> problems solved
  final List<String> masteredTopics;
  final int totalMinutesStudied;

  StudentProgress({
    required this.userId,
    required this.subjectId,
    this.totalProblems = 0,
    this.solvedProblems = 0,
    this.correctAnswers = 0,
    this.hintsUsed = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    DateTime? lastPracticeDate,
    Map<String, int>? topicProgress,
    List<String>? masteredTopics,
    this.totalMinutesStudied = 0,
  })  : lastPracticeDate = lastPracticeDate ?? DateTime.now(),
        topicProgress = topicProgress ?? {},
        masteredTopics = masteredTopics ?? [];

  double get accuracy =>
      totalProblems > 0 ? (correctAnswers / totalProblems) * 100 : 0;

  double get completionRate =>
      totalProblems > 0 ? (solvedProblems / totalProblems) * 100 : 0;

  int get level => (totalProblems / 10).floor() + 1;

  int get xp => solvedProblems * 10 + correctAnswers * 5;

  StudentProgress copyWith({
    String? userId,
    String? subjectId,
    int? totalProblems,
    int? solvedProblems,
    int? correctAnswers,
    int? hintsUsed,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastPracticeDate,
    Map<String, int>? topicProgress,
    List<String>? masteredTopics,
    int? totalMinutesStudied,
  }) {
    return StudentProgress(
      userId: userId ?? this.userId,
      subjectId: subjectId ?? this.subjectId,
      totalProblems: totalProblems ?? this.totalProblems,
      solvedProblems: solvedProblems ?? this.solvedProblems,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      hintsUsed: hintsUsed ?? this.hintsUsed,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastPracticeDate: lastPracticeDate ?? this.lastPracticeDate,
      topicProgress: topicProgress ?? this.topicProgress,
      masteredTopics: masteredTopics ?? this.masteredTopics,
      totalMinutesStudied: totalMinutesStudied ?? this.totalMinutesStudied,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'subject_id': subjectId,
        'total_problems': totalProblems,
        'solved_problems': solvedProblems,
        'correct_answers': correctAnswers,
        'hints_used': hintsUsed,
        'current_streak': currentStreak,
        'longest_streak': longestStreak,
        'last_practice_date': lastPracticeDate.toIso8601String(),
        'topic_progress': topicProgress,
        'mastered_topics': masteredTopics,
        'total_minutes_studied': totalMinutesStudied,
      };

  factory StudentProgress.fromJson(Map<String, dynamic> json) =>
      StudentProgress(
        userId: json['user_id'],
        subjectId: json['subject_id'],
        totalProblems: json['total_problems'] ?? 0,
        solvedProblems: json['solved_problems'] ?? 0,
        correctAnswers: json['correct_answers'] ?? 0,
        hintsUsed: json['hints_used'] ?? 0,
        currentStreak: json['current_streak'] ?? 0,
        longestStreak: json['longest_streak'] ?? 0,
        lastPracticeDate: json['last_practice_date'] != null
            ? DateTime.parse(json['last_practice_date'])
            : null,
        topicProgress: json['topic_progress'] != null
            ? Map<String, int>.from(json['topic_progress'])
            : null,
        masteredTopics: json['mastered_topics'] != null
            ? List<String>.from(json['mastered_topics'])
            : null,
        totalMinutesStudied: json['total_minutes_studied'] ?? 0,
      );
}

/// Practice session for tracking time
class PracticeSession {
  final String id;
  final String userId;
  final String subjectId;
  final DateTime startTime;
  final DateTime? endTime;
  final int problemsSolved;
  final int correctAnswers;

  PracticeSession({
    String? id,
    required this.userId,
    required this.subjectId,
    DateTime? startTime,
    this.endTime,
    this.problemsSolved = 0,
    this.correctAnswers = 0,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        startTime = startTime ?? DateTime.now();

  int get durationMinutes {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'subject_id': subjectId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'problems_solved': problemsSolved,
        'correct_answers': correctAnswers,
      };

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      PracticeSession(
        id: json['id'],
        userId: json['user_id'],
        subjectId: json['subject_id'],
        startTime: DateTime.parse(json['start_time']),
        endTime:
            json['end_time'] != null ? DateTime.parse(json['end_time']) : null,
        problemsSolved: json['problems_solved'] ?? 0,
        correctAnswers: json['correct_answers'] ?? 0,
      );
}
