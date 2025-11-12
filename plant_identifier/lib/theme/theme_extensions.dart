import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension for easy access to theme colors from BuildContext
extension ThemeExtensions on BuildContext {
  /// Get current theme colors
  AppColors get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark
        ? AppColors.darkTheme
        : AppColors.lightTheme;
  }
}
