import 'package:flutter/material.dart';

/// Ocean-themed color palette for Fish Identifier app
class AppColors {
  // Core Ocean Blue Theme Colors
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryDark;
  final Color accent;

  // UI Colors
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color onPrimary;
  final Color onSecondary;
  final Color onBackground;
  final Color onSurface;

  // Semantic Colors
  final Color error;
  final Color success;
  final Color warning;
  final Color info;

  // App Bar and Navigation
  final Color appBarColor;
  final Color navBarColor;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.accent,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.appBarColor,
    required this.navBarColor,
  });

  /// Ocean Blue Theme - Light Mode
  static const AppColors oceanBlue = AppColors(
    primary: Color(0xFF0077BE), // Ocean Blue
    primaryDark: Color(0xFF005A8D), // Deep Ocean
    primaryLight: Color(0xFF4FA3D1), // Light Ocean
    secondary: Color(0xFF00BCD4), // Aqua/Cyan
    secondaryDark: Color(0xFF00838F), // Dark Aqua
    accent: Color(0xFFFF6F61), // Coral (for highlights)
    background: Color(0xFFF0F8FF), // Alice Blue (very light blue)
    surface: Color(0xFFFFFFFF), // White
    cardBackground: Color(0xFFFFFFFF), // White
    onPrimary: Color(0xFFFFFFFF), // White text on primary
    onSecondary: Color(0xFFFFFFFF), // White text on secondary
    onBackground: Color(0xFF1A237E), // Deep Blue text
    onSurface: Color(0xFF263238), // Blue Grey text
    error: Color(0xFFF44336), // Red
    success: Color(0xFF4CAF50), // Green
    warning: Color(0xFFFF9800), // Orange
    info: Color(0xFF2196F3), // Blue
    appBarColor: Color(0xFF0077BE), // Ocean Blue
    navBarColor: Color(0xFFFFFFFF), // White
  );

  /// Deep Sea Theme - Dark Mode
  static const AppColors deepSea = AppColors(
    primary: Color(0xFF1E88E5), // Bright Ocean Blue
    primaryDark: Color(0xFF1565C0), // Deep Blue
    primaryLight: Color(0xFF42A5F5), // Light Blue
    secondary: Color(0xFF26C6DA), // Bright Aqua
    secondaryDark: Color(0xFF00ACC1), // Dark Aqua
    accent: Color(0xFFFF8A65), // Light Coral
    background: Color(0xFF0A1929), // Deep Navy
    surface: Color(0xFF1A2332), // Dark Blue Grey
    cardBackground: Color(0xFF1E2A3A), // Slightly lighter
    onPrimary: Color(0xFFFFFFFF), // White
    onSecondary: Color(0xFFFFFFFF), // White
    onBackground: Color(0xFFE3F2FD), // Very Light Blue
    onSurface: Color(0xFFB3E5FC), // Light Cyan
    error: Color(0xFFEF5350), // Light Red
    success: Color(0xFF66BB6A), // Light Green
    warning: Color(0xFFFFB74D), // Light Orange
    info: Color(0xFF42A5F5), // Light Blue
    appBarColor: Color(0xFF0D47A1), // Dark Blue
    navBarColor: Color(0xFF1A2332), // Dark surface
  );

  /// Khaki Camouflage Theme - Earth Tones
  static const AppColors khakiCamo = AppColors(
    primary: Color(0xFF806B3A), // Khaki Brown
    primaryDark: Color(0xFF5C4E2A), // Dark Khaki
    primaryLight: Color(0xFFA08960), // Light Khaki
    secondary: Color(0xFF8B7355), // Sand Brown
    secondaryDark: Color(0xFF6B5644), // Dark Sand
    accent: Color(0xFFD4AF37), // Golden accent
    background: Color(0xFFF5F3E8), // Light Beige
    surface: Color(0xFFFFFFFF), // White
    cardBackground: Color(0xFFFFFFFF), // White
    onPrimary: Color(0xFFFFFFFF), // White
    onSecondary: Color(0xFFFFFFFF), // White
    onBackground: Color(0xFF3E3529), // Dark Brown
    onSurface: Color(0xFF4A4035), // Medium Brown
    error: Color(0xFFF44336), // Red
    success: Color(0xFF4CAF50), // Green
    warning: Color(0xFFFF9800), // Orange
    info: Color(0xFF806B3A), // Khaki
    appBarColor: Color(0xFF806B3A), // Khaki Brown
    navBarColor: Color(0xFFFFFFFF), // White
  );

  /// Tropical Waters Theme - Bright & Vivid
  static const AppColors tropicalWaters = AppColors(
    primary: Color(0xFF00ACC1), // Turquoise
    primaryDark: Color(0xFF00838F), // Dark Turquoise
    primaryLight: Color(0xFF4DD0E1), // Light Turquoise
    secondary: Color(0xFF26A69A), // Teal
    secondaryDark: Color(0xFF00897B), // Dark Teal
    accent: Color(0xFFFFAB40), // Amber (sunset)
    background: Color(0xFFE0F7FA), // Light Cyan
    surface: Color(0xFFFFFFFF), // White
    cardBackground: Color(0xFFFFFFFF), // White
    onPrimary: Color(0xFFFFFFFF), // White
    onSecondary: Color(0xFFFFFFFF), // White
    onBackground: Color(0xFF004D40), // Dark Teal
    onSurface: Color(0xFF00695C), // Medium Teal
    error: Color(0xFFF44336), // Red
    success: Color(0xFF4CAF50), // Green
    warning: Color(0xFFFF9800), // Orange
    info: Color(0xFF00BCD4), // Cyan
    appBarColor: Color(0xFF00ACC1), // Turquoise
    navBarColor: Color(0xFFFFFFFF), // White
  );
}
