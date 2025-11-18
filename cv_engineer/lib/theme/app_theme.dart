import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';

/// CV Engineer Design System
/// Professional Resume Builder Theme Configuration

class AppTheme {
  // Private constructor
  AppTheme._();

  // ==================== SPACING ====================

  static const double space4 = AppDimensions.space4;
  static const double space8 = AppDimensions.space8;
  static const double space12 = AppDimensions.space12;
  static const double space16 = AppDimensions.space16;
  static const double space20 = AppDimensions.space20;
  static const double space24 = AppDimensions.space24;
  static const double space32 = AppDimensions.space32;
  static const double space40 = AppDimensions.space40;
  static const double space48 = AppDimensions.space48;

  // ==================== BORDER RADIUS ====================

  static const double radiusSmall = AppDimensions.space8;
  static const double radiusMedium = AppDimensions.radius12;
  static const double radiusStandard = AppDimensions.radius16;
  static const double radiusCard = AppDimensions.radius20;
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

  static const BoxShadow strongShadow = BoxShadow(
    color: Color(0x29000000),
    blurRadius: AppDimensions.space24,
    offset: Offset(0, 8),
  );

  static BoxShadow getColoredShadow(Color shadowColor) {
    return BoxShadow(
      color: shadowColor.withValues(alpha: 0.4),
      blurRadius: 15,
      offset: const Offset(0, 8),
    );
  }

  static BoxShadow get shadow => softShadow;

  // ==================== FONT FAMILIES ====================

  static const String fontFamilyPrimary = 'Roboto';
  static const String fontFamilySerif = 'Merriweather';

  // ==================== TEXT STYLES ====================

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamilySerif,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    height: 1.4,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamilyPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );

  // ==================== THEME DATA ====================

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
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: h4.copyWith(
          color: colors.onPrimary,
        ),
        iconTheme: IconThemeData(color: colors.onPrimary),
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
          elevation: 2,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.primary, width: 2),
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space24,
            vertical: AppDimensions.space16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
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
            ? colors.surface.withValues(alpha: 0.5)
            : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(
            color: colors.neutral.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(
            color: colors.neutral.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(color: colors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        hintStyle: TextStyle(
          color: colors.onSurface.withValues(alpha: 0.5),
          fontFamily: fontFamilyPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 4,
      ),

      // Icon Theme
      iconTheme: IconThemeData(color: colors.primary, size: 24),

      // Typography
      fontFamily: fontFamilyPrimary,
      textTheme: TextTheme(
        displayLarge: h1.copyWith(color: colors.onBackground),
        displayMedium: h2.copyWith(color: colors.onBackground),
        displaySmall: h3.copyWith(color: colors.onBackground),
        headlineMedium: h4.copyWith(color: colors.onBackground),
        headlineSmall: h5.copyWith(color: colors.onBackground),
        bodyLarge: bodyLarge.copyWith(color: colors.onBackground),
        bodyMedium: body.copyWith(color: colors.onSurface),
        bodySmall: bodySmall.copyWith(color: colors.onSurface),
        labelLarge: button,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: colors.neutral.withValues(alpha: 0.2),
        thickness: 1,
        space: space16,
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surface,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.neutral,
        selectedLabelStyle: const TextStyle(
          fontFamily: fontFamilyPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: fontFamilyPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: colors.surface,
        selectedColor: colors.primary.withValues(alpha: 0.2),
        disabledColor: colors.neutral.withValues(alpha: 0.1),
        labelStyle: bodySmall.copyWith(color: colors.onSurface),
        side: BorderSide(color: colors.neutral.withValues(alpha: 0.3)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),

      // Dialog
      dialogTheme: DialogTheme(
        backgroundColor: colors.surface,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusStandard),
        ),
        titleTextStyle: h4.copyWith(color: colors.onSurface),
      ),
    );
  }
}
