import 'package:flutter/material.dart';

/// Interface for all color palettes
abstract class AppColors {
  // === PRIMARY COLORS (Main accent - buttons, active states) ===
  Color get primary; // Main brand color
  Color get primaryLight; // Lighter shade for gradients
  Color get primaryPale; // Palest shade for gradients
  Color get primaryDark; // Darker shade

  // === SECONDARY COLORS (Supporting accent) - COMPUTED ===
  /// Secondary brand color computed from primary (hue shift -20°)
  Color get secondary {
    final hslColor = HSLColor.fromColor(primary);
    return hslColor
        .withHue((hslColor.hue - 20) % 360)
        .withSaturation((hslColor.saturation * 0.9).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darker secondary color (secondary with reduced lightness)
  Color get secondaryDark {
    final hslColor = HSLColor.fromColor(secondary);
    return hslColor
        .withLightness((hslColor.lightness * 0.7).clamp(0.0, 1.0))
        .toColor();
  }

  // === NEUTRAL COLORS (Gray scale) ===
  Color get neutral; // Mid-gray for borders, disabled

  // === BACKGROUND COLORS ===
  Color get background; // Main background
  Color get surface; // Card/surface background

  // === TEXT COLORS (On various backgrounds) ===
  Color get onBackground; // Text on background
  Color get onSurface; // Text on surface

  // === SEMANTIC COLORS ===
  Color get success; // Green for success
  Color get warning; // Orange/yellow for warnings
  Color get error; // Red for errors
  Color get info; // Blue for info

  // === COMPUTED PROPERTIES (derived from other colors) ===

  /// Text color on primary colored backgrounds
  Color get onPrimary =>
      brightness == Brightness.light ? Colors.white : const Color(0xFF212121);

  /// Text color on secondary colored elements
  Color get onSecondary => secondary;

  /// Cards use the same color as surface
  Color get cardBackground => surface;

  /// Shadow color derived from primary
  Color get shadowColor => primaryLight;

  /// AppBar uses surface color
  Color get appBarColor => surface;

  /// Navigation bar uses surface color
  Color get navBarColor => surface;

  // === GRADIENT ===
  LinearGradient get primaryGradient;

  // === BRIGHTNESS ===
  Brightness get brightness;
}

/// Green Nature Theme (Default) - Perfect for plants
class GreenNatureColors extends AppColors {
  @override
  final Color primary = const Color(0xFF4CAF50); // Fresh Green

  @override
  final Color primaryLight = const Color(0xFF81C784); // Light Green

  @override
  final Color primaryPale = const Color(0xFFC8E6C9); // Pale Green

  @override
  final Color primaryDark = const Color(0xFF2E7D32); // Dark Green

  @override
  final Color neutral = const Color(0xFFBDBDBD); // Medium Grey

  @override
  final Color background = const Color(0xFFF1F8E9); // Light Green Background

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF1B5E20); // Dark Green

  @override
  final Color onSurface = const Color(0xFF212121); // Dark Gray

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
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Forest Theme - Deep greens for mature plants
class ForestColors extends AppColors {
  @override
  final Color primary = const Color(0xFF558B2F); // Forest Green

  @override
  final Color primaryLight = const Color(0xFF7CB342); // Light Forest Green

  @override
  final Color primaryPale = const Color(0xFFC5E1A5); // Pale Forest Green

  @override
  final Color primaryDark = const Color(0xFF33691E); // Dark Green

  @override
  final Color neutral = const Color(0xFFA1887F);

  @override
  final Color background = const Color(0xFFDCEDC8); // Light Green

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF33691E); // Dark Green

  @override
  final Color onSurface = const Color(0xFF33691E); // Dark Green

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFF8D6E63); // Brown

  @override
  final Color error = const Color(0xFFD32F2F);

  @override
  final Color info = const Color(0xFF1976D2);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Botanical Garden Theme - Vibrant and fresh
class BotanicalColors extends AppColors {
  @override
  final Color primary = const Color(0xFF8BC34A); // Lime Green

  @override
  final Color primaryLight = const Color(0xFFAED581); // Light Lime

  @override
  final Color primaryPale = const Color(0xFFDCEDC8); // Pale Lime

  @override
  final Color primaryDark = const Color(0xFF689F38); // Dark Lime

  @override
  final Color neutral = const Color(0xFFBDBDBD);

  @override
  final Color background = const Color(0xFFF9FBE7); // Very Light Yellow-Green

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF33691E);

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color success = const Color(0xFF8BC34A);

  @override
  final Color warning = const Color(0xFFFFB300);

  @override
  final Color error = const Color(0xFFE53935);

  @override
  final Color info = const Color(0xFF039BE5);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Green Theme - For night mode plant lovers
class DarkGreenColors extends AppColors {
  @override
  final Color primary = const Color(0xFF81C784); // Light Green

  @override
  final Color primaryLight = const Color(0xFFA5D6A7); // Very Light Green

  @override
  final Color primaryPale = const Color(0xFFC8E6C9); // Pale Green

  @override
  final Color primaryDark = const Color(0xFF66BB6A); // Medium Light Green

  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1B1B1B); // Almost Black

  @override
  final Color surface = const Color(0xFF2D2D2D); // Dark Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

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
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;
}

/// Mushroom Theme - Earthy browns for fungi identification
class MushroomColors extends AppColors {
  @override
  final Color primary = const Color(0xFF8D6E63); // Brown

  @override
  final Color primaryLight = const Color(0xFFA1887F); // Light Brown

  @override
  final Color primaryPale = const Color(0xFFD7CCC8); // Pale Brown

  @override
  final Color primaryDark = const Color(0xFF5D4037); // Dark Brown

  @override
  final Color neutral = const Color(0xFFBCAAA4);

  @override
  final Color background = const Color(0xFFEFEBE9); // Very Light Brown

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF4E342E); // Very Dark Brown

  @override
  final Color onSurface = const Color(0xFF3E2723); // Nearly Black Brown

  @override
  final Color success = const Color(0xFF7CB342); // Green for edible

  @override
  final Color warning = const Color(0xFFFF9800); // Orange for caution

  @override
  final Color error = const Color(0xFFD32F2F); // Red for toxic

  @override
  final Color info = const Color(0xFF5E35B1); // Purple

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}
