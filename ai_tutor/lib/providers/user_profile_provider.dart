import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/user_profile.dart';
import '../models/interest.dart';
import '../models/cultural_theme.dart';

/// Provider for managing user profile and personalization
class UserProfileProvider with ChangeNotifier {
  UserProfile _profile = UserProfile();
  bool _isLoading = false;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isOnboardingComplete => _profile.isOnboardingComplete;

  // Getters for easier access
  List<Interest> get selectedInterests => _profile.interests;
  CulturalTheme get culturalTheme => _profile.culturalTheme;
  LearningStyle get learningStyle => _profile.learningStyle;

  /// Initialize and load profile from storage
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('user_profile');

      if (profileJson != null) {
        final data = json.decode(profileJson);
        _profile = UserProfile.fromJson(data);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save profile to storage
  Future<void> _saveProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = json.encode(_profile.toJson());
      await prefs.setString('user_profile', profileJson);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  /// Update selected interests
  Future<void> updateInterests(List<String> interestIds) async {
    _profile = _profile.copyWith(selectedInterests: interestIds);
    await _saveProfile();
    notifyListeners();
  }

  /// Add interest
  Future<void> addInterest(String interestId) async {
    if (!_profile.selectedInterests.contains(interestId)) {
      final updated = List<String>.from(_profile.selectedInterests)
        ..add(interestId);
      await updateInterests(updated);
    }
  }

  /// Remove interest
  Future<void> removeInterest(String interestId) async {
    if (_profile.selectedInterests.contains(interestId)) {
      final updated = List<String>.from(_profile.selectedInterests)
        ..remove(interestId);
      await updateInterests(updated);
    }
  }

  /// Toggle interest
  Future<void> toggleInterest(String interestId) async {
    if (_profile.selectedInterests.contains(interestId)) {
      await removeInterest(interestId);
    } else {
      await addInterest(interestId);
    }
  }

  /// Update cultural theme
  Future<void> updateCulturalTheme(String themeId) async {
    _profile = _profile.copyWith(culturalThemeId: themeId);
    await _saveProfile();
    notifyListeners();
  }

  /// Update learning style
  Future<void> updateLearningStyle(LearningStyle style) async {
    _profile = _profile.copyWith(learningStyle: style);
    await _saveProfile();
    notifyListeners();
  }

  /// Update subject level
  Future<void> updateSubjectLevel(String subjectId, int level) async {
    final updatedLevels = Map<String, int>.from(_profile.subjectLevels);
    updatedLevels[subjectId] = level;
    _profile = _profile.copyWith(subjectLevels: updatedLevels);
    await _saveProfile();
    notifyListeners();
  }

  /// Update goals
  Future<void> updateGoals(List<String> goals) async {
    _profile = _profile.copyWith(goals: goals);
    await _saveProfile();
    notifyListeners();
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    _profile = _profile.copyWith(lastActiveAt: DateTime.now());
    await _saveProfile();
    notifyListeners();
  }

  /// Reset profile (for testing)
  Future<void> resetProfile() async {
    _profile = UserProfile();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    notifyListeners();
  }

  /// Get personalization context for AI
  String getPersonalizationContext() {
    final interests = selectedInterests.map((i) => i.name).join(', ');
    final theme = culturalTheme;
    final keywords = selectedInterests
        .expand((i) => i.keywords)
        .take(10)
        .join(', ');

    return '''
User Profile:
- Interests: $interests
- Cultural Theme: ${theme.name} (${theme.description})
- Dialog Style: ${theme.dialogStyle.name}
- Learning Style: ${learningStyle.displayName}
- Cultural Keywords: ${theme.culturalKeywords.join(', ')}
- Interest Keywords: $keywords

Instructions:
- Use examples and contexts related to the user's interests
- Adapt language and tone to match the cultural theme
- Incorporate keywords naturally into explanations
- Match the dialog style (${theme.dialogStyle.name})
''';
  }

  /// Generate personalized greeting
  String getPersonalizedGreeting() {
    final theme = culturalTheme;
    final hour = DateTime.now().hour;

    String timeGreeting;
    if (hour < 12) {
      timeGreeting = 'Good morning';
    } else if (hour < 18) {
      timeGreeting = 'Good afternoon';
    } else {
      timeGreeting = 'Good evening';
    }

    switch (theme.dialogStyle) {
      case DialogStyle.casual:
        return "Hey! Ready to learn something cool? 🚀";
      case DialogStyle.formal:
        return "$timeGreeting. How may I assist you with your studies today?";
      case DialogStyle.respectful:
        return "$timeGreeting. I'm honored to be your tutor today.";
      case DialogStyle.enthusiastic:
        return "$timeGreeting! Let's make today awesome! 🌟";
    }
  }
}
