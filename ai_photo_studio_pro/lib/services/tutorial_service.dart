import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for interactive tutorials and tooltips
class TutorialService {
  static final TutorialService _instance = TutorialService._internal();
  factory TutorialService() => _instance;
  TutorialService._internal();

  static const String _keyTutorialCompleted = 'tutorial_completed';
  static const String _keyFeaturesTooltipsShown = 'feature_tooltips_shown';

  /// Check if main tutorial has been completed
  Future<bool> isTutorialCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyTutorialCompleted) ?? false;
    } catch (e) {
      debugPrint('Error checking tutorial status: $e');
      return false;
    }
  }

  /// Mark main tutorial as completed
  Future<void> markTutorialCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyTutorialCompleted, true);
    } catch (e) {
      debugPrint('Error marking tutorial completed: $e');
    }
  }

  /// Check if a specific feature tooltip has been shown
  Future<bool> isFeatureTooltipShown(String featureId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getStringList(_keyFeaturesTooltipsShown) ?? [];
      return shown.contains(featureId);
    } catch (e) {
      debugPrint('Error checking feature tooltip: $e');
      return false;
    }
  }

  /// Mark a feature tooltip as shown
  Future<void> markFeatureTooltipShown(String featureId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shown = prefs.getStringList(_keyFeaturesTooltipsShown) ?? [];
      if (!shown.contains(featureId)) {
        shown.add(featureId);
        await prefs.setStringList(_keyFeaturesTooltipsShown, shown);
      }
    } catch (e) {
      debugPrint('Error marking feature tooltip shown: $e');
    }
  }

  /// Reset all tutorials
  Future<void> resetTutorials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyTutorialCompleted);
      await prefs.remove(_keyFeaturesTooltipsShown);
    } catch (e) {
      debugPrint('Error resetting tutorials: $e');
    }
  }

  /// Get tutorial steps for main onboarding
  List<TutorialStep> getMainTutorialSteps() {
    return [
      TutorialStep(
        id: 'welcome',
        title: 'Welcome to AI Photo Studio Pro! 👋',
        description: 'Create stunning AI headshots in seconds with professional quality.',
        icon: Icons.celebration,
        action: null,
      ),
      TutorialStep(
        id: 'camera',
        title: 'Take a Photo 📸',
        description: 'Start by taking a selfie or uploading a photo from your gallery.',
        icon: Icons.camera_alt,
        action: TutorialAction.openCamera,
      ),
      TutorialStep(
        id: 'styles',
        title: 'Choose Your Style 🎨',
        description: 'Browse through professional, casual, creative, and more styles.',
        icon: Icons.palette,
        action: TutorialAction.openStyles,
      ),
      TutorialStep(
        id: 'generate',
        title: 'Generate AI Photo ✨',
        description: 'Our AI will transform your photo in seconds with professional quality.',
        icon: Icons.auto_awesome,
        action: null,
      ),
      TutorialStep(
        id: 'share',
        title: 'Share & Save 💾',
        description: 'Save to gallery, share to social media, or add to favorites.',
        icon: Icons.share,
        action: null,
      ),
      TutorialStep(
        id: 'premium',
        title: 'Go Premium 👑',
        description: 'Unlock unlimited generations, exclusive styles, and more features!',
        icon: Icons.star,
        action: TutorialAction.openPremium,
      ),
    ];
  }

  /// Get feature tooltips
  Map<String, FeatureTooltip> getFeatureTooltips() {
    return {
      'before_after': FeatureTooltip(
        id: 'before_after',
        title: 'Compare Photos',
        message: 'Swipe to see before and after! Use the slider to compare your original photo with the AI-generated version.',
        targetKey: 'compare_button',
      ),
      'favorites': FeatureTooltip(
        id: 'favorites',
        title: 'Save to Favorites',
        message: 'Tap the heart icon to add photos to your favorites for quick access later.',
        targetKey: 'favorite_button',
      ),
      'achievements': FeatureTooltip(
        id: 'achievements',
        title: 'Unlock Achievements',
        message: 'Complete challenges to earn XP, unlock achievements, and level up!',
        targetKey: 'achievements_button',
      ),
      'referrals': FeatureTooltip(
        id: 'referrals',
        title: 'Invite Friends',
        message: 'Share your referral code with friends. You both get 5 free scans when they sign up!',
        targetKey: 'referral_button',
      ),
      'batch_generation': FeatureTooltip(
        id: 'batch_generation',
        title: 'Batch Processing',
        message: 'Generate multiple styles at once! Select multiple styles to save time.',
        targetKey: 'batch_button',
      ),
      'cloud_backup': FeatureTooltip(
        id: 'cloud_backup',
        title: 'Cloud Backup',
        message: 'Your photos are automatically backed up to the cloud. Access them from any device!',
        targetKey: 'backup_button',
      ),
    };
  }
}

/// Tutorial step model
class TutorialStep {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final TutorialAction? action;

  TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.action,
  });
}

/// Tutorial actions
enum TutorialAction {
  openCamera,
  openStyles,
  openGallery,
  openPremium,
}

/// Feature tooltip model
class FeatureTooltip {
  final String id;
  final String title;
  final String message;
  final String targetKey;

  FeatureTooltip({
    required this.id,
    required this.title,
    required this.message,
    required this.targetKey,
  });
}
