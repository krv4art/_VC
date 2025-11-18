/// Weekly progress report model
class WeeklyReport {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalProblems;
  final int correctProblems;
  final int totalMinutes;
  final int currentStreak;
  final Map<String, int> problemsBySubject;
  final List<String> topTopics;
  final double averageAccuracy;
  final int achievementsUnlocked;
  final int xpEarned;

  WeeklyReport({
    required this.weekStart,
    required this.weekEnd,
    this.totalProblems = 0,
    this.correctProblems = 0,
    this.totalMinutes = 0,
    this.currentStreak = 0,
    Map<String, int>? problemsBySubject,
    List<String>? topTopics,
    this.averageAccuracy = 0.0,
    this.achievementsUnlocked = 0,
    this.xpEarned = 0,
  })  : problemsBySubject = problemsBySubject ?? {},
        topTopics = topTopics ?? [];

  double get accuracy =>
      totalProblems > 0 ? (correctProblems / totalProblems) * 100 : 0;

  String get weekLabel {
    final start = '${weekStart.day}/${weekStart.month}';
    final end = '${weekEnd.day}/${weekEnd.month}';
    return '$start - $end';
  }

  Map<String, dynamic> toJson() => {
        'week_start': weekStart.toIso8601String(),
        'week_end': weekEnd.toIso8601String(),
        'total_problems': totalProblems,
        'correct_problems': correctProblems,
        'total_minutes': totalMinutes,
        'current_streak': currentStreak,
        'problems_by_subject': problemsBySubject,
        'top_topics': topTopics,
        'average_accuracy': averageAccuracy,
        'achievements_unlocked': achievementsUnlocked,
        'xp_earned': xpEarned,
      };

  factory WeeklyReport.fromJson(Map<String, dynamic> json) => WeeklyReport(
        weekStart: DateTime.parse(json['week_start']),
        weekEnd: DateTime.parse(json['week_end']),
        totalProblems: json['total_problems'] ?? 0,
        correctProblems: json['correct_problems'] ?? 0,
        totalMinutes: json['total_minutes'] ?? 0,
        currentStreak: json['current_streak'] ?? 0,
        problemsBySubject: json['problems_by_subject'] != null
            ? Map<String, int>.from(json['problems_by_subject'])
            : null,
        topTopics: json['top_topics'] != null
            ? List<String>.from(json['top_topics'])
            : null,
        averageAccuracy: json['average_accuracy']?.toDouble() ?? 0.0,
        achievementsUnlocked: json['achievements_unlocked'] ?? 0,
        xpEarned: json['xp_earned'] ?? 0,
      );
}
