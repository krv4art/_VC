import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';

/// Fish Identifier Design System - Ocean Theme
///
/// This file contains the complete theme configuration for the app.
/// Colors, typography, and component styles follow an ocean/aquatic design philosophy.

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== FONT FAMILIES ====================

  static const String fontFamilySerif = 'Lora';
  static const String fontFamilySansSerif = 'Open Sans';

  // ==================== TEXT STYLES ====================

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.0,
  );

  // ==================== SHADOWS ====================

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow mediumShadow = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  /// Creates a colored shadow based on theme color
  static BoxShadow getColoredShadow(Color shadowColor) {
    return BoxShadow(
      color: shadowColor.withValues(alpha: 0.3),
      blurRadius: 15,
      offset: const Offset(0, 8),
    );
  }

  // ==================== GRADIENTS ====================

  /// Ocean wave gradient
  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF0077BE), Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Deep sea gradient
  static const LinearGradient deepSeaGradient = LinearGradient(
    colors: [Color(0xFF003D5C), Color(0xFF0077BE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Tropical waters gradient
  static const LinearGradient tropicalGradient = LinearGradient(
    colors: [Color(0xFF00ACC1), Color(0xFF26A69A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== THEME DATA ====================

  /// Creates ThemeData based on provided colors and dark mode flag
  static ThemeData getThemeData(AppColors colors, bool isDark) {
    return ThemeData(
      useMaterial3: true,

      // Color Scheme
      primaryColor: colors.primary,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        error: colors.error,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: colors.background,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: fontFamilySerif,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
        ),
        color: colors.cardBackground,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 4,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          textStyle: button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.primaryDark, width: 2),
          foregroundColor: colors.primaryDark,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
          ),
          textStyle: button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space12,
          ),
          textStyle: button,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colors.cardBackground.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          borderSide: BorderSide(color: colors.primaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        hintStyle: TextStyle(
          color: colors.onSurface.withValues(alpha: 0.5),
          fontFamily: fontFamilySansSerif,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space24,
          vertical: AppDimensions.space16,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 6,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: colors.primary, size: 24),

      // Typography
      fontFamily: fontFamilySansSerif,
      textTheme: TextTheme(
        displayLarge: h1.copyWith(color: colors.primary),
        displayMedium: h2.copyWith(color: colors.primary),
        titleLarge: h3.copyWith(color: colors.onBackground),
        titleMedium: h4.copyWith(color: colors.onBackground),
        bodyLarge: bodyLarge.copyWith(color: colors.onBackground),
        bodyMedium: body.copyWith(color: colors.onSurface),
        bodySmall: bodySmall.copyWith(color: colors.onSurface),
        labelLarge: button,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.onSurface.withValues(alpha: 0.1),
        thickness: 1,
        space: AppDimensions.space16,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.navBarColor,
        selectedItemColor: colors.primaryDark,
        unselectedItemColor:
            isDark ? Colors.white54 : const Color(0xFF757575),
        selectedLabelStyle: const TextStyle(
          fontFamily: fontFamilySansSerif,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: fontFamilySansSerif,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
