import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app theme mode (light/dark/system)
class ThemeModeProvider with ChangeNotifier {
  static const String _keyThemeMode = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    // For system mode, we'd need to check system brightness
    // This will be handled by the MaterialApp
    return false;
  }

  /// Initialize theme mode from storage
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final modeString = prefs.getString(_keyThemeMode);

      if (modeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == modeString,
          orElse: () => ThemeMode.system,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      _themeMode = mode;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyThemeMode, mode.toString());

      debugPrint('Theme mode changed to: $mode');
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else {
      await setThemeMode(ThemeMode.light);
    }
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    await setThemeMode(ThemeMode.light);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    await setThemeMode(ThemeMode.dark);
  }

  /// Set system theme (follow system preference)
  Future<void> setSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
