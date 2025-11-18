/// Achievement model for gamification
class Achievement {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final AchievementType type;
  final int targetValue;
  final int currentValue;
  final DateTime? unlockedAt;
  final int xpReward;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.targetValue,
    this.currentValue = 0,
    this.unlockedAt,
    this.xpReward = 100,
  });

  bool get isUnlocked => unlockedAt != null;
  double get progress =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    String? emoji,
    AchievementType? type,
    int? targetValue,
    int? currentValue,
    DateTime? unlockedAt,
    int? xpReward,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      emoji: emoji ?? this.emoji,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'emoji': emoji,
        'type': type.name,
        'target_value': targetValue,
        'current_value': currentValue,
        'unlocked_at': unlockedAt?.toIso8601String(),
        'xp_reward': xpReward,
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        emoji: json['emoji'],
        type: AchievementType.values.byName(json['type']),
        targetValue: json['target_value'],
        currentValue: json['current_value'] ?? 0,
        unlockedAt: json['unlocked_at'] != null
            ? DateTime.parse(json['unlocked_at'])
            : null,
        xpReward: json['xp_reward'] ?? 100,
      );
}

enum AchievementType {
  problemsSolved,
  streak,
  accuracy,
  subject,
  topic,
  speed,
  dedication,
}

/// Predefined achievements
class Achievements {
  static final firstSteps = Achievement(
    id: 'first_steps',
    name: 'First Steps',
    description: 'Solve your first problem',
    emoji: '👣',
    type: AchievementType.problemsSolved,
    targetValue: 1,
    xpReward: 50,
  );

  static final gettingStarted = Achievement(
    id: 'getting_started',
    name: 'Getting Started',
    description: 'Solve 10 problems',
    emoji: '🌱',
    type: AchievementType.problemsSolved,
    targetValue: 10,
    xpReward: 100,
  );

  static final problemSolver = Achievement(
    id: 'problem_solver',
    name: 'Problem Solver',
    description: 'Solve 50 problems',
    emoji: '🎯',
    type: AchievementType.problemsSolved,
    targetValue: 50,
    xpReward: 200,
  );

  static final mathWizard = Achievement(
    id: 'math_wizard',
    name: 'Math Wizard',
    description: 'Solve 100 problems',
    emoji: '🧙',
    type: AchievementType.problemsSolved,
    targetValue: 100,
    xpReward: 500,
  );

  static final streakBeginner = Achievement(
    id: 'streak_beginner',
    name: 'On a Roll',
    description: '3-day streak',
    emoji: '🔥',
    type: AchievementType.streak,
    targetValue: 3,
    xpReward: 100,
  );

  static final streakIntermediate = Achievement(
    id: 'streak_intermediate',
    name: 'Dedicated Learner',
    description: '7-day streak',
    emoji: '🌟',
    type: AchievementType.streak,
    targetValue: 7,
    xpReward: 250,
  );

  static final streakAdvanced = Achievement(
    id: 'streak_advanced',
    name: 'Unstoppable',
    description: '30-day streak',
    emoji: '⚡',
    type: AchievementType.streak,
    targetValue: 30,
    xpReward: 1000,
  );

  static final perfectionist = Achievement(
    id: 'perfectionist',
    name: 'Perfectionist',
    description: '100% accuracy on 10 problems',
    emoji: '💯',
    type: AchievementType.accuracy,
    targetValue: 10,
    xpReward: 300,
  );

  static final quickThinker = Achievement(
    id: 'quick_thinker',
    name: 'Quick Thinker',
    description: 'Solve 5 problems in under 1 minute each',
    emoji: '⚡',
    type: AchievementType.speed,
    targetValue: 5,
    xpReward: 200,
  );

  static final nightOwl = Achievement(
    id: 'night_owl',
    name: 'Night Owl',
    description: 'Practice after 10 PM',
    emoji: '🦉',
    type: AchievementType.dedication,
    targetValue: 1,
    xpReward: 50,
  );

  static final earlyBird = Achievement(
    id: 'early_bird',
    name: 'Early Bird',
    description: 'Practice before 6 AM',
    emoji: '🐦',
    type: AchievementType.dedication,
    targetValue: 1,
    xpReward: 50,
  );

  static final marathonRunner = Achievement(
    id: 'marathon_runner',
    name: 'Marathon Runner',
    description: 'Study for 60 minutes in one session',
    emoji: '🏃',
    type: AchievementType.dedication,
    targetValue: 60,
    xpReward: 300,
  );

  static List<Achievement> get all => [
        firstSteps,
        gettingStarted,
        problemSolver,
        mathWizard,
        streakBeginner,
        streakIntermediate,
        streakAdvanced,
        perfectionist,
        quickThinker,
        nightOwl,
        earlyBird,
        marathonRunner,
      ];

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }
}
