import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing onboarding experience
class OnboardingService {
  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;
  OnboardingService._internal();

  static const String _onboardingCompletedKey = 'onboarding_completed';

  /// Initialize onboarding service
  Future<void> initialize() async {
    // Nothing to initialize yet, but keeps API consistent
  }

  /// Check if onboarding has been completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
      debugPrint('Onboarding completed: $isCompleted');
      return isCompleted;
    } catch (e) {
      debugPrint('Error checking onboarding status: $e');
      return false;
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      debugPrint('Onboarding marked as completed');
    } catch (e) {
      debugPrint('Error marking onboarding as completed: $e');
    }
  }

  /// Reset onboarding (for testing)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      debugPrint('Onboarding reset');
    } catch (e) {
      debugPrint('Error resetting onboarding: $e');
    }
  }
}
