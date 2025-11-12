import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_colors.dart';
import '../providers/theme_provider.dart';

/// Extension for easy access to theme colors from BuildContext
extension ThemeExtensions on BuildContext {
  /// Get theme-aware colors based on current theme
  ThemeColors get colors => ThemeColors(this);
}

/// Theme-aware color getter
class ThemeColors {
  final BuildContext context;

  ThemeColors(this.context);

  /// Get current colors from ThemeProvider
  AppColors get currentColors {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      return themeProvider.currentColors;
    } catch (e) {
      // Fallback to default colors if provider not found
      final brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark
          ? DarkGreenColors()
          : GreenNatureColors();
    }
  }

  bool get isDark => currentColors.brightness == Brightness.dark;

  // Primary colors
  Color get primary => currentColors.primary;
  Color get primaryLight => currentColors.primaryLight;
  Color get primaryPale => currentColors.primaryPale;
  Color get primaryDark => currentColors.primaryDark;

  // Secondary colors
  Color get secondary => currentColors.secondary;

  // Neutral colors
  Color get neutral => currentColors.neutral;

  // Background colors
  Color get background => currentColors.background;
  Color get surface => currentColors.surface;
  Color get cardBackground => currentColors.cardBackground;

  // Text colors
  Color get onBackground => currentColors.onBackground;
  Color get onSurface => currentColors.onSurface;
  Color get onSecondary => currentColors.onSecondary;
  Color get onPrimary => currentColors.onPrimary;

  // Semantic colors
  Color get success => currentColors.success;
  Color get warning => currentColors.warning;
  Color get error => currentColors.error;
  Color get info => currentColors.info;

  // Gradients
  LinearGradient get primaryGradient => currentColors.primaryGradient;

  // Shadow color
  Color get shadowColor => currentColors.shadowColor;
}
