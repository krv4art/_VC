/// Model for user achievements and badges
class Achievement {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int pointsReward;
  final AchievementRequirement requirement;
  final DateTime? unlockedAt;
  final int currentProgress;
  final int totalRequired;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.rarity,
    required this.pointsReward,
    required this.requirement,
    this.unlockedAt,
    this.currentProgress = 0,
    required this.totalRequired,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconPath: json['icon_path'] as String,
      category: AchievementCategory.values.firstWhere(
        (e) => e.toString() == 'AchievementCategory.${json['category']}',
      ),
      rarity: AchievementRarity.values.firstWhere(
        (e) => e.toString() == 'AchievementRarity.${json['rarity']}',
      ),
      pointsReward: json['points_reward'] as int,
      requirement: AchievementRequirement.fromJson(
          json['requirement'] as Map<String, dynamic>),
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.parse(json['unlocked_at'] as String)
          : null,
      currentProgress: json['current_progress'] as int? ?? 0,
      totalRequired: json['total_required'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_path': iconPath,
      'category': category.toString().split('.').last,
      'rarity': rarity.toString().split('.').last,
      'points_reward': pointsReward,
      'requirement': requirement.toJson(),
      'unlocked_at': unlockedAt?.toIso8601String(),
      'current_progress': currentProgress,
      'total_required': totalRequired,
    };
  }

  bool get isUnlocked => unlockedAt != null;
  double get progressPercentage => (currentProgress / totalRequired) * 100;
}

enum AchievementCategory {
  catches,
  species,
  locations,
  measurements,
  social,
  streaks,
  special,
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

/// Achievement requirement
class AchievementRequirement {
  final String type; // "total_catches", "unique_species", etc.
  final int target;
  final Map<String, dynamic>? conditions;

  AchievementRequirement({
    required this.type,
    required this.target,
    this.conditions,
  });

  factory AchievementRequirement.fromJson(Map<String, dynamic> json) {
    return AchievementRequirement(
      type: json['type'] as String,
      target: json['target'] as int,
      conditions: json['conditions'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'target': target,
      'conditions': conditions,
    };
  }
}

/// Predefined achievements
class Achievements {
  static final List<Achievement> all = [
    // Catches
    Achievement(
      id: 'first_catch',
      name: 'First Catch',
      description: 'Identify your first fish',
      iconPath: 'assets/achievements/first_catch.png',
      category: AchievementCategory.catches,
      rarity: AchievementRarity.common,
      pointsReward: 10,
      requirement: AchievementRequirement(type: 'total_catches', target: 1),
      totalRequired: 1,
    ),
    Achievement(
      id: 'novice_angler',
      name: 'Novice Angler',
      description: 'Identify 10 fish',
      iconPath: 'assets/achievements/novice_angler.png',
      category: AchievementCategory.catches,
      rarity: AchievementRarity.common,
      pointsReward: 25,
      requirement: AchievementRequirement(type: 'total_catches', target: 10),
      totalRequired: 10,
    ),
    Achievement(
      id: 'experienced_angler',
      name: 'Experienced Angler',
      description: 'Identify 50 fish',
      iconPath: 'assets/achievements/experienced_angler.png',
      category: AchievementCategory.catches,
      rarity: AchievementRarity.uncommon,
      pointsReward: 100,
      requirement: AchievementRequirement(type: 'total_catches', target: 50),
      totalRequired: 50,
    ),
    Achievement(
      id: 'master_angler',
      name: 'Master Angler',
      description: 'Identify 100 fish',
      iconPath: 'assets/achievements/master_angler.png',
      category: AchievementCategory.catches,
      rarity: AchievementRarity.rare,
      pointsReward: 250,
      requirement: AchievementRequirement(type: 'total_catches', target: 100),
      totalRequired: 100,
    ),

    // Species diversity
    Achievement(
      id: 'species_explorer',
      name: 'Species Explorer',
      description: 'Identify 5 different species',
      iconPath: 'assets/achievements/species_explorer.png',
      category: AchievementCategory.species,
      rarity: AchievementRarity.common,
      pointsReward: 30,
      requirement: AchievementRequirement(type: 'unique_species', target: 5),
      totalRequired: 5,
    ),
    Achievement(
      id: 'ichthyologist',
      name: 'Ichthyologist',
      description: 'Identify 25 different species',
      iconPath: 'assets/achievements/ichthyologist.png',
      category: AchievementCategory.species,
      rarity: AchievementRarity.rare,
      pointsReward: 150,
      requirement: AchievementRequirement(type: 'unique_species', target: 25),
      totalRequired: 25,
    ),

    // Locations
    Achievement(
      id: 'explorer',
      name: 'Explorer',
      description: 'Fish in 5 different locations',
      iconPath: 'assets/achievements/explorer.png',
      category: AchievementCategory.locations,
      rarity: AchievementRarity.uncommon,
      pointsReward: 50,
      requirement: AchievementRequirement(type: 'unique_locations', target: 5),
      totalRequired: 5,
    ),

    // Measurements
    Achievement(
      id: 'trophy_hunter',
      name: 'Trophy Hunter',
      description: 'Catch a fish over 50cm',
      iconPath: 'assets/achievements/trophy_hunter.png',
      category: AchievementCategory.measurements,
      rarity: AchievementRarity.rare,
      pointsReward: 100,
      requirement: AchievementRequirement(
        type: 'min_length',
        target: 50,
      ),
      totalRequired: 1,
    ),

    // Social
    Achievement(
      id: 'social_butterfly',
      name: 'Social Butterfly',
      description: 'Get 100 likes on your posts',
      iconPath: 'assets/achievements/social_butterfly.png',
      category: AchievementCategory.social,
      rarity: AchievementRarity.uncommon,
      pointsReward: 75,
      requirement: AchievementRequirement(type: 'total_likes', target: 100),
      totalRequired: 100,
    ),

    // Streaks
    Achievement(
      id: 'dedicated',
      name: 'Dedicated',
      description: 'Fish for 7 consecutive days',
      iconPath: 'assets/achievements/dedicated.png',
      category: AchievementCategory.streaks,
      rarity: AchievementRarity.rare,
      pointsReward: 200,
      requirement: AchievementRequirement(type: 'daily_streak', target: 7),
      totalRequired: 7,
    ),
  ];
}

/// User's achievement statistics
class AchievementStats {
  final int totalUnlocked;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final Map<AchievementCategory, int> byCategory;
  final Map<AchievementRarity, int> byRarity;

  AchievementStats({
    required this.totalUnlocked,
    required this.totalPoints,
    required this.currentStreak,
    required this.longestStreak,
    required this.byCategory,
    required this.byRarity,
  });

  factory AchievementStats.fromJson(Map<String, dynamic> json) {
    return AchievementStats(
      totalUnlocked: json['total_unlocked'] as int,
      totalPoints: json['total_points'] as int,
      currentStreak: json['current_streak'] as int,
      longestStreak: json['longest_streak'] as int,
      byCategory: (json['by_category'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          AchievementCategory.values.firstWhere(
            (e) => e.toString() == 'AchievementCategory.$key',
          ),
          value as int,
        ),
      ),
      byRarity: (json['by_rarity'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          AchievementRarity.values.firstWhere(
            (e) => e.toString() == 'AchievementRarity.$key',
          ),
          value as int,
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_unlocked': totalUnlocked,
      'total_points': totalPoints,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'by_category': byCategory.map(
        (key, value) => MapEntry(key.toString().split('.').last, value),
      ),
      'by_rarity': byRarity.map(
        (key, value) => MapEntry(key.toString().split('.').last, value),
      ),
    };
  }
}
