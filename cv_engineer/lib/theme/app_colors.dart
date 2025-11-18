import 'package:flutter/material.dart';

/// Interface for all color palettes
abstract class AppColors {
  // === PRIMARY COLORS ===
  Color get primary;
  Color get primaryLight;
  Color get primaryDark;

  // === SECONDARY COLORS ===
  Color get secondary;
  Color get secondaryDark;

  // === NEUTRAL COLORS ===
  Color get neutral;

  // === BACKGROUND COLORS ===
  Color get background;
  Color get surface;

  // === TEXT COLORS ===
  Color get onBackground;
  Color get onSurface;
  Color get onPrimary;
  Color get onSecondary;

  // === SEMANTIC COLORS ===
  Color get success;
  Color get warning;
  Color get error;
  Color get info;

  // === COMPUTED PROPERTIES ===
  Color get cardBackground => surface;
  Color get shadowColor => primaryLight;
  Color get appBarColor => surface;
  Color get navBarColor => surface;

  // === GRADIENT ===
  LinearGradient get primaryGradient;

  // === BRIGHTNESS ===
  Brightness get brightness;
}

/// Professional Theme (Default - Blue/Navy)
class ProfessionalColors extends AppColors {
  @override
  final Color primary = const Color(0xFF1976D2); // Professional Blue

  @override
  final Color primaryLight = const Color(0xFF42A5F5);

  @override
  final Color primaryDark = const Color(0xFF0D47A1);

  @override
  final Color secondary = const Color(0xFF424242); // Dark Gray

  @override
  final Color secondaryDark = const Color(0xFF212121);

  @override
  final Color neutral = const Color(0xFFBDBDBD);

  @override
  final Color background = const Color(0xFFF5F5F5);

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF212121);

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color onPrimary = Colors.white;

  @override
  final Color onSecondary = Colors.white;

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF2196F3);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Professional Theme
class DarkProfessionalColors extends AppColors {
  @override
  final Color primary = const Color(0xFF42A5F5);

  @override
  final Color primaryLight = const Color(0xFF64B5F6);

  @override
  final Color primaryDark = const Color(0xFF1976D2);

  @override
  final Color secondary = const Color(0xFF90CAF9);

  @override
  final Color secondaryDark = const Color(0xFF64B5F6);

  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF121212);

  @override
  final Color surface = const Color(0xFF1E1E1E);

  @override
  final Color onBackground = const Color(0xFFE0E0E0);

  @override
  final Color onSurface = const Color(0xFFE0E0E0);

  @override
  final Color onPrimary = const Color(0xFF000000);

  @override
  final Color onSecondary = const Color(0xFF000000);

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF42A5F5);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;
}

/// Creative Theme (Purple/Pink)
class CreativeColors extends AppColors {
  @override
  final Color primary = const Color(0xFF9C27B0); // Purple

  @override
  final Color primaryLight = const Color(0xFFBA68C8);

  @override
  final Color primaryDark = const Color(0xFF7B1FA2);

  @override
  final Color secondary = const Color(0xFFE91E63); // Pink

  @override
  final Color secondaryDark = const Color(0xFFC2185B);

  @override
  final Color neutral = const Color(0xFFBDBDBD);

  @override
  final Color background = const Color(0xFFFCE4EC);

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF212121);

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color onPrimary = Colors.white;

  @override
  final Color onSecondary = Colors.white;

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF9C27B0);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, Color(0xFFE91E63)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Creative Theme
class DarkCreativeColors extends AppColors {
  @override
  final Color primary = const Color(0xFFBA68C8);

  @override
  final Color primaryLight = const Color(0xFFCE93D8);

  @override
  final Color primaryDark = const Color(0xFF9C27B0);

  @override
  final Color secondary = const Color(0xFFF06292);

  @override
  final Color secondaryDark = const Color(0xFFE91E63);

  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF121212);

  @override
  final Color surface = const Color(0xFF1E1E1E);

  @override
  final Color onBackground = const Color(0xFFE0E0E0);

  @override
  final Color onSurface = const Color(0xFFE0E0E0);

  @override
  final Color onPrimary = const Color(0xFF000000);

  @override
  final Color onSecondary = const Color(0xFF000000);

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFFBA68C8);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, Color(0xFFF06292)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;
}

/// Modern Theme (Teal/Cyan)
class ModernColors extends AppColors {
  @override
  final Color primary = const Color(0xFF009688); // Teal

  @override
  final Color primaryLight = const Color(0xFF4DB6AC);

  @override
  final Color primaryDark = const Color(0xFF00796B);

  @override
  final Color secondary = const Color(0xFF00BCD4); // Cyan

  @override
  final Color secondaryDark = const Color(0xFF0097A7);

  @override
  final Color neutral = const Color(0xFFBDBDBD);

  @override
  final Color background = const Color(0xFFE0F2F1);

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF212121);

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color onPrimary = Colors.white;

  @override
  final Color onSecondary = Colors.white;

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF00BCD4);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Modern Theme
class DarkModernColors extends AppColors {
  @override
  final Color primary = const Color(0xFF4DB6AC);

  @override
  final Color primaryLight = const Color(0xFF80CBC4);

  @override
  final Color primaryDark = const Color(0xFF009688);

  @override
  final Color secondary = const Color(0xFF26C6DA);

  @override
  final Color secondaryDark = const Color(0xFF00BCD4);

  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF121212);

  @override
  final Color surface = const Color(0xFF1E1E1E);

  @override
  final Color onBackground = const Color(0xFFE0E0E0);

  @override
  final Color onSurface = const Color(0xFFE0E0E0);

  @override
  final Color onPrimary = const Color(0xFF000000);

  @override
  final Color onSecondary = const Color(0xFF000000);

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF26C6DA);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;
}
