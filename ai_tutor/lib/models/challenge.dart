import 'package:flutter/foundation.dart';

/// Daily challenge model
class DailyChallenge {
  final String id;
  final DateTime date;
  final String subjectId;
  final String topic;
  final String title;
  final String description;
  final int targetProblems;
  final int difficulty;
  final int xpReward;
  final bool isCompleted;
  final int currentProgress;

  DailyChallenge({
    String? id,
    DateTime? date,
    required this.subjectId,
    required this.topic,
    required this.title,
    required this.description,
    this.targetProblems = 5,
    this.difficulty = 5,
    this.xpReward = 100,
    this.isCompleted = false,
    this.currentProgress = 0,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        date = date ?? DateTime.now();

  double get progress =>
      targetProblems > 0 ? (currentProgress / targetProblems).clamp(0.0, 1.0) : 0.0;

  DailyChallenge copyWith({
    String? id,
    DateTime? date,
    String? subjectId,
    String? topic,
    String? title,
    String? description,
    int? targetProblems,
    int? difficulty,
    int? xpReward,
    bool? isCompleted,
    int? currentProgress,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      date: date ?? this.date,
      subjectId: subjectId ?? this.subjectId,
      topic: topic ?? this.topic,
      title: title ?? this.title,
      description: description ?? this.description,
      targetProblems: targetProblems ?? this.targetProblems,
      difficulty: difficulty ?? this.difficulty,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'subject_id': subjectId,
        'topic': topic,
        'title': title,
        'description': description,
        'target_problems': targetProblems,
        'difficulty': difficulty,
        'xp_reward': xpReward,
        'is_completed': isCompleted,
        'current_progress': currentProgress,
      };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) => DailyChallenge(
        id: json['id'],
        date: DateTime.parse(json['date']),
        subjectId: json['subject_id'],
        topic: json['topic'],
        title: json['title'],
        description: json['description'],
        targetProblems: json['target_problems'] ?? 5,
        difficulty: json['difficulty'] ?? 5,
        xpReward: json['xp_reward'] ?? 100,
        isCompleted: json['is_completed'] ?? false,
        currentProgress: json['current_progress'] ?? 0,
      );
}

/// Study goal model
class StudyGoal {
  final String id;
  final String title;
  final String description;
  final GoalType type;
  final int targetValue;
  final int currentValue;
  final DateTime deadline;
  final bool isCompleted;
  final DateTime createdAt;

  StudyGoal({
    String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    required this.deadline,
    this.isCompleted = false,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  double get progress =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  StudyGoal copyWith({
    String? id,
    String? title,
    String? description,
    GoalType? type,
    int? targetValue,
    int? currentValue,
    DateTime? deadline,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return StudyGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'target_value': targetValue,
        'current_value': currentValue,
        'deadline': deadline.toIso8601String(),
        'is_completed': isCompleted,
        'created_at': createdAt.toIso8601String(),
      };

  factory StudyGoal.fromJson(Map<String, dynamic> json) => StudyGoal(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        type: GoalType.values.byName(json['type']),
        targetValue: json['target_value'],
        currentValue: json['current_value'] ?? 0,
        deadline: DateTime.parse(json['deadline']),
        isCompleted: json['is_completed'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
      );
}

enum GoalType {
  problemsSolved,
  accuracy,
  streak,
  studyTime,
  topicMastery,
}

extension GoalTypeExtension on GoalType {
  String get displayName {
    switch (this) {
      case GoalType.problemsSolved:
        return 'Problems Solved';
      case GoalType.accuracy:
        return 'Accuracy';
      case GoalType.streak:
        return 'Streak';
      case GoalType.studyTime:
        return 'Study Time';
      case GoalType.topicMastery:
        return 'Topic Mastery';
    }
  }

  String get emoji {
    switch (this) {
      case GoalType.problemsSolved:
        return '🎯';
      case GoalType.accuracy:
        return '💯';
      case GoalType.streak:
        return '🔥';
      case GoalType.studyTime:
        return '⏱️';
      case GoalType.topicMastery:
        return '🎓';
    }
  }
}
