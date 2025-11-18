import 'package:flutter/material.dart';

/// Abstract interface for all color palettes
/// This allows easy theme switching while maintaining type safety
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

  // === PDF-SPECIFIC COLORS ===
  Color get annotationHighlight; // Yellow for highlights
  Color get annotationNote; // Blue for notes
  Color get annotationDrawing; // Red for drawings
  Color get scannedDocument; // Color for scanned documents
  Color get convertedDocument; // Color for converted documents

  // === COMPUTED PROPERTIES (derived from other colors) ===

  /// Text color on primary colored backgrounds
  Color get onPrimary =>
      brightness == Brightness.light ? Colors.white : const Color(0xFF212121);

  /// Text color on secondary colored elements
  Color get onSecondary => secondary;

  /// Cards use the same color as surface
  Color get cardBackground => surface;

  /// Shadow color derived from primary
  Color get shadowColor => primaryLight.withOpacity(0.3);

  /// AppBar uses surface color
  Color get appBarColor => surface;

  /// Navigation bar uses surface color
  Color get navBarColor => surface;

  // === GRADIENT ===
  LinearGradient get primaryGradient;

  // === BRIGHTNESS ===
  Brightness get brightness;
}

/// Professional Blue Theme (Default)
/// Modern, professional color scheme suitable for business documents
class ProfessionalColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF2196F3); // Blue

  @override
  final Color primaryLight = const Color(0xFF64B5F6); // Light Blue

  @override
  final Color primaryPale = const Color(0xFFBBDEFB); // Pale Blue

  @override
  final Color primaryDark = const Color(0xFF1976D2); // Dark Blue

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBDBDBD); // Medium Grey

  @override
  final Color background = const Color(0xFFF5F5F5); // Light Grey

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF212121); // Dark Gray

  @override
  final Color onSurface = const Color(0xFF212121); // Dark Gray

  @override
  final Color success = const Color(0xFF4CAF50); // Green

  @override
  final Color warning = const Color(0xFFFF9800); // Orange

  @override
  final Color error = const Color(0xFFF44336); // Red

  @override
  final Color info = const Color(0xFF2196F3); // Blue

  // === PDF-SPECIFIC COLORS ===
  @override
  final Color annotationHighlight = const Color(0xFFFFEB3B); // Yellow

  @override
  final Color annotationNote = const Color(0xFF2196F3); // Blue

  @override
  final Color annotationDrawing = const Color(0xFFF44336); // Red

  @override
  final Color scannedDocument = const Color(0xFF4CAF50); // Green

  @override
  final Color convertedDocument = const Color(0xFF9C27B0); // Purple

  @override
  LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryLight, primaryPale],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Professional Theme
/// Dark mode version of professional theme
class DarkProfessionalColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF64B5F6); // Light Blue

  @override
  final Color primaryLight = const Color(0xFF90CAF9); // Very Light Blue

  @override
  final Color primaryPale = const Color(0xFFBBDEFB); // Pale Blue

  @override
  final Color primaryDark = const Color(0xFF42A5F5); // Medium Blue

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF121212); // Dark Gray

  @override
  final Color surface = const Color(0xFF1E1E1E); // Darker Gray

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

  // === PDF-SPECIFIC COLORS ===
  @override
  final Color annotationHighlight = const Color(0xFFFDD835); // Yellow

  @override
  final Color annotationNote = const Color(0xFF42A5F5); // Blue

  @override
  final Color annotationDrawing = const Color(0xFFEF5350); // Red

  @override
  final Color scannedDocument = const Color(0xFF66BB6A); // Green

  @override
  final Color convertedDocument = const Color(0xFFAB47BC); // Purple

  @override
  LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryLight, primaryPale],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Brightness get brightness => Brightness.dark;
}

/// Minimalist Gray Theme
/// Clean, minimal color scheme for focused document work
class MinimalistColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF424242); // Dark Gray

  @override
  final Color primaryLight = const Color(0xFF757575); // Medium Gray

  @override
  final Color primaryPale = const Color(0xFFBDBDBD); // Light Gray

  @override
  final Color primaryDark = const Color(0xFF212121); // Very Dark Gray

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFE0E0E0);

  @override
  final Color background = const Color(0xFFFAFAFA); // Very Light Gray

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF212121);

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF2196F3);

  // === PDF-SPECIFIC COLORS ===
  @override
  final Color annotationHighlight = const Color(0xFFFFEB3B);

  @override
  final Color annotationNote = const Color(0xFF2196F3);

  @override
  final Color annotationDrawing = const Color(0xFFF44336);

  @override
  final Color scannedDocument = const Color(0xFF4CAF50);

  @override
  final Color convertedDocument = const Color(0xFF9C27B0);

  @override
  LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryLight, primaryPale],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Brightness get brightness => Brightness.light;
}

/// Green Business Theme
/// Eco-friendly, business-oriented color scheme
class GreenBusinessColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF43A047); // Green

  @override
  final Color primaryLight = const Color(0xFF66BB6A); // Light Green

  @override
  final Color primaryPale = const Color(0xFFA5D6A7); // Pale Green

  @override
  final Color primaryDark = const Color(0xFF2E7D32); // Dark Green

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBDBDBD);

  @override
  final Color background = const Color(0xFFF1F8E9); // Light Green tint

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF1B5E20); // Dark Green

  @override
  final Color onSurface = const Color(0xFF212121);

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF2196F3);

  // === PDF-SPECIFIC COLORS ===
  @override
  final Color annotationHighlight = const Color(0xFFFFEB3B);

  @override
  final Color annotationNote = const Color(0xFF2196F3);

  @override
  final Color annotationDrawing = const Color(0xFFF44336);

  @override
  final Color scannedDocument = const Color(0xFF66BB6A);

  @override
  final Color convertedDocument = const Color(0xFF9C27B0);

  @override
  LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryLight, primaryPale],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Brightness get brightness => Brightness.light;
}
