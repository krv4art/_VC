import 'interest.dart';
import 'cultural_theme.dart';

/// User's learning profile with personalization settings
class UserProfile {
  final String? userId;
  final List<String> selectedInterests; // Interest IDs
  final String culturalThemeId;
  final LearningStyle learningStyle;
  final Map<String, int> subjectLevels; // subject -> grade level
  final List<String> goals;
  final String preferredLanguage;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  UserProfile({
    this.userId,
    List<String>? selectedInterests,
    String? culturalThemeId,
    LearningStyle? learningStyle,
    Map<String, int>? subjectLevels,
    List<String>? goals,
    String? preferredLanguage,
    DateTime? createdAt,
    this.lastActiveAt,
  })  : selectedInterests = selectedInterests ?? [],
        culturalThemeId = culturalThemeId ?? 'classic',
        learningStyle = learningStyle ?? LearningStyle.balanced,
        subjectLevels = subjectLevels ?? {},
        goals = goals ?? [],
        preferredLanguage = preferredLanguage ?? 'en',
        createdAt = createdAt ?? DateTime.now();

  // Get actual Interest objects from IDs
  List<Interest> get interests => selectedInterests
      .map((id) => Interests.getById(id))
      .whereType<Interest>()
      .toList();

  // Get actual CulturalTheme object
  CulturalTheme get culturalTheme =>
      CulturalThemes.getById(culturalThemeId) ?? CulturalThemes.classic;

  UserProfile copyWith({
    String? userId,
    List<String>? selectedInterests,
    String? culturalThemeId,
    LearningStyle? learningStyle,
    Map<String, int>? subjectLevels,
    List<String>? goals,
    String? preferredLanguage,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      selectedInterests: selectedInterests ?? this.selectedInterests,
      culturalThemeId: culturalThemeId ?? this.culturalThemeId,
      learningStyle: learningStyle ?? this.learningStyle,
      subjectLevels: subjectLevels ?? this.subjectLevels,
      goals: goals ?? this.goals,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'selected_interests': selectedInterests,
        'cultural_theme_id': culturalThemeId,
        'learning_style': learningStyle.name,
        'subject_levels': subjectLevels,
        'goals': goals,
        'preferred_language': preferredLanguage,
        'created_at': createdAt.toIso8601String(),
        'last_active_at': lastActiveAt?.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json['user_id'],
        selectedInterests: json['selected_interests'] != null
            ? List<String>.from(json['selected_interests'])
            : null,
        culturalThemeId: json['cultural_theme_id'],
        learningStyle: json['learning_style'] != null
            ? LearningStyle.values.byName(json['learning_style'])
            : null,
        subjectLevels: json['subject_levels'] != null
            ? Map<String, int>.from(json['subject_levels'])
            : null,
        goals: json['goals'] != null ? List<String>.from(json['goals']) : null,
        preferredLanguage: json['preferred_language'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        lastActiveAt: json['last_active_at'] != null
            ? DateTime.parse(json['last_active_at'])
            : null,
      );

  bool get isOnboardingComplete =>
      selectedInterests.isNotEmpty && subjectLevels.isNotEmpty;
}

/// Learning style preferences
enum LearningStyle {
  visual, // Lots of diagrams and charts
  practical, // Many examples and practice
  theoretical, // Detailed explanations
  balanced, // Mix of everything
  quick, // Fast and concise
}

/// Learning goals
enum LearningGoal {
  examPrep, // Preparing for exams (ЕГЭ, ОГЭ, SAT, etc.)
  improveGrades, // Better grades in school
  curiosity, // Just interested in learning
  olympiad, // Preparing for competitions
  homework, // Help with homework
}

extension LearningGoalExtension on LearningGoal {
  String get displayName {
    switch (this) {
      case LearningGoal.examPrep:
        return 'Exam Preparation';
      case LearningGoal.improveGrades:
        return 'Improve Grades';
      case LearningGoal.curiosity:
        return 'Learn for Fun';
      case LearningGoal.olympiad:
        return 'Olympiad/Competition';
      case LearningGoal.homework:
        return 'Homework Help';
    }
  }

  String get emoji {
    switch (this) {
      case LearningGoal.examPrep:
        return '📝';
      case LearningGoal.improveGrades:
        return '📈';
      case LearningGoal.curiosity:
        return '🤔';
      case LearningGoal.olympiad:
        return '🏆';
      case LearningGoal.homework:
        return '📚';
    }
  }
}

extension LearningStyleExtension on LearningStyle {
  String get displayName {
    switch (this) {
      case LearningStyle.visual:
        return 'Visual (Charts & Diagrams)';
      case LearningStyle.practical:
        return 'Practical (Examples & Practice)';
      case LearningStyle.theoretical:
        return 'Theoretical (Detailed Explanations)';
      case LearningStyle.balanced:
        return 'Balanced (Mix of Everything)';
      case LearningStyle.quick:
        return 'Quick (Fast & Concise)';
    }
  }

  String get emoji {
    switch (this) {
      case LearningStyle.visual:
        return '📊';
      case LearningStyle.practical:
        return '🎯';
      case LearningStyle.theoretical:
        return '📖';
      case LearningStyle.balanced:
        return '⚖️';
      case LearningStyle.quick:
        return '⚡';
    }
  }
}
