import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';

/// ACS Design System - Natural Beauty Theme
/// Based on Homepage Template 6
///
/// This file contains the complete theme configuration for the ACS app.
/// Colors, typography, and component styles follow the Natural & Organic design philosophy.

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ==================== COLOR PALETTE ====================

  /// Primary Colors
  static const Color saddleBrown = Color(0xFF8B4513);
  static const Color naturalGreen = Color(0xFF4CAF50);
  static const Color lightGreen = Color(0xFF8BC34A);
  static const Color paleGreen = Color(0xFFC3E0A1);

  /// Secondary Colors
  static const Color beige = Color(0xFFF5F5DC);
  static const Color deepBrown = Color(0xFF6D4C41);
  static const Color mediumBrown = Color(0xFF8D6E63);

  /// Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF8BC34A);

  /// Additional Colors for compatibility
  static const Color orange = Color(0xFFFF9800);
  static const Color red = Color(0xFFF44336);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color mediumGrey = Color(0xFFBDBDBD);
  static const Color darkGrey = Color(0xFF757575);

  /// Background Colors
  static const Color backgroundBeige = Color(0xFFF5F5DC);
  static final Color cardBackground = Colors.white.withValues(alpha: 0.8);
  static const Color surfaceWhite = Colors.white;

  // ==================== DARK THEME COLORS ====================

  /// Dark Theme Primary Colors
  static const Color darkSaddleBrown = Color(0xFFA0522D);
  static const Color darkNaturalGreen = Color(0xFF66BB6A);
  static const Color darkLightGreen = Color(0xFF9CCC65);
  static const Color darkPaleGreen = Color(0xFFDCEDC8);

  /// Dark Theme Secondary Colors
  static const Color darkDeepBrown = Color(0xFF5D4037);
  static const Color darkMediumBrown = Color(0xFF795548);
  static const Color darkLightBrown = Color(0xFF8D6E63);

  /// Dark Theme Background Colors
  static const Color darkBackground = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCardBackground = Color(0xFF2A2A2A);

  // ==================== GRADIENTS ====================

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightGreen, paleGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFFF9800), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFF44336), Color(0xFFF44336)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ==================== SPACING ====================

  static const double space4 = AppDimensions.space4;
  static const double space8 = AppDimensions.space8;
  static const double space12 = AppDimensions.space12;
  static const double space16 = AppDimensions.space16;
  static const double space18 = AppDimensions.space16 + AppDimensions.space4;
  static const double space20 = AppDimensions.space16 + AppDimensions.space4;
  static const double space24 = AppDimensions.space24;
  static const double space32 = AppDimensions.space32;
  static const double space40 = AppDimensions.space40;
  static const double space48 = AppDimensions.space48;

  // ==================== BORDER RADIUS ====================

  static const double radiusSmall = AppDimensions.space8;
  static const double radiusMedium = AppDimensions.radius12;
  static const double radiusStandard = AppDimensions.radius16;
  static const double radiusCard =
      AppDimensions.radius16 + AppDimensions.space4;
  static const double radiusLarge = AppDimensions.radius24;

  // ==================== SHADOWS ====================

  static const BoxShadow softShadow = BoxShadow(
    color: Color(0x14000000),
    blurRadius: AppDimensions.space8,
    offset: Offset(0, 2),
  );

  static const BoxShadow mediumShadow = BoxShadow(
    color: Color(0x1F000000),
    blurRadius: AppDimensions.space16,
    offset: Offset(0, 4),
  );

  static const BoxShadow coloredShadow = BoxShadow(
    color: Color(0x668BC34A),
    blurRadius: AppDimensions.space16 - AppDimensions.space4,
    offset: Offset(0, 8),
  );

  /// Создает цветную тень на основе цвета темы
  static BoxShadow getColoredShadow(Color shadowColor) {
    return BoxShadow(
      color: shadowColor.withValues(alpha: 0.4),
      blurRadius: 15,
      offset: const Offset(0, 8),
    );
  }

  // Alias for compatibility
  static BoxShadow get shadow => softShadow;

  // ==================== FONT FAMILIES ====================

  static const String fontFamilySerif = 'Lora';
  static const String fontFamilySansSerif = 'Open Sans';

  // ==================== TEXT STYLES ====================

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: naturalGreen,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: naturalGreen,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: deepBrown,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: deepBrown,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: deepBrown,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: mediumBrown,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: mediumBrown,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: mediumBrown,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    height: 1.0,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamilySansSerif,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.0,
  );

  // ==================== THEME DATA ====================

  /// Создает ThemeData на основе переданных цветов и флага темной темы
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
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        color: colors.cardBackground,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          elevation: 4,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusStandard),
          ),
          textStyle: button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.primaryDark, width: 2),
          foregroundColor: colors.primaryDark,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusStandard),
          ),
          textStyle: button,
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          padding: EdgeInsets.symmetric(
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space24,
          vertical: AppDimensions.space16,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 6,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: colors.primaryDark, size: 24),

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
        space: space16,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.navBarColor,
        selectedItemColor: colors.primaryDark,
        unselectedItemColor: isDark ? Colors.white54 : mediumGrey,
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
