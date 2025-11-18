import 'package:flutter/material.dart' hide AnimationStyle;
import '../models/cultural_theme.dart';

/// Provider for managing app theme based on cultural preferences
class ThemeProvider with ChangeNotifier {
  CulturalTheme _currentTheme = CulturalThemes.classic;

  CulturalTheme get currentTheme => _currentTheme;
  ThemeData get themeData => _buildThemeData(_currentTheme);
  bool get isDark => _currentTheme.colors.background.computeLuminance() < 0.5;

  /// Update theme
  void setTheme(CulturalTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  /// Build ThemeData from CulturalTheme
  ThemeData _buildThemeData(CulturalTheme theme) {
    final colors = theme.colors;
    final isDarkTheme = colors.background.computeLuminance() < 0.5;

    return ThemeData(
      useMaterial3: true,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        onPrimary: _getContrastColor(colors.primary),
        secondary: colors.secondary,
        onSecondary: _getContrastColor(colors.secondary),
        error: Colors.red,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.textPrimary,
        background: colors.background,
        onBackground: colors.textPrimary,
      ),
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: _getContrastColor(colors.primary),
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: _getContrastColor(colors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.secondary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: colors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: colors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: colors.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Get contrasting color for text on colored background
  Color _getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  /// Get accent color
  Color get accentColor => _currentTheme.colors.accent;

  /// Get animation duration based on theme
  Duration getAnimationDuration() {
    switch (_currentTheme.animationStyle) {
      case AnimationStyle.minimal:
        return const Duration(milliseconds: 150);
      case AnimationStyle.moderate:
        return const Duration(milliseconds: 300);
      case AnimationStyle.expressive:
        return const Duration(milliseconds: 500);
      case AnimationStyle.cultural:
        return const Duration(milliseconds: 400);
    }
  }
}
