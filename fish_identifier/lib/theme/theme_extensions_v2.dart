import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_colors_v2.dart';
import '../providers/theme_provider_v2.dart';

/// Extension to help widgets access theme-aware colors
/// This ensures colors adapt properly to theme changes (light/dark mode)
extension ThemeExtension on BuildContext {
  /// Get current theme
  ThemeData get theme => Theme.of(this);

  /// Check if current theme is dark
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  /// Get theme-aware colors based on current theme
  ThemeColors get colors => ThemeColors(this);
}

/// Theme-aware color getter
class ThemeColors {
  final BuildContext context;

  ThemeColors(this.context);

  /// Get current colors from ThemeProviderV2
  AppColorsV2 get currentColors {
    final themeProvider = Provider.of<ThemeProviderV2>(context, listen: false);
    return themeProvider.currentColors;
  }

  bool get isDark => currentColors.brightness == Brightness.dark;

  // Primary colors
  Color get primary => currentColors.primary;
  Color get primaryLight => currentColors.primaryLight;
  Color get primaryDark => currentColors.primaryDark;

  // Secondary colors
  Color get secondary => currentColors.secondary;
  Color get secondaryDark => currentColors.secondaryDark;

  // Accent
  Color get accent => currentColors.accent;

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

  // App navigation
  Color get appBarColor => currentColors.appBarColor;
  Color get navBarColor => currentColors.navBarColor;

  // Gradients
  LinearGradient get primaryGradient => currentColors.primaryGradient;

  // Shadow color
  Color get shadowColor => currentColors.shadowColor;
}
