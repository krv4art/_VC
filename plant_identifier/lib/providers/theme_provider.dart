import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Provider for managing app themes
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const String _darkModeKey = 'dark_mode';

  AppColors _colors = GreenNatureColors();
  bool _isDarkMode = false;

  AppColors get colors => _colors;
  AppColors get currentColors => _colors;
  bool get isDarkMode => _isDarkMode;
  ThemeData get themeData => AppTheme.getThemeData(_colors, _isDarkMode);

  ThemeProvider() {
    _loadTheme();
  }

  /// Load theme from preferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey) ?? 'green_nature';
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      _setColorsByThemeName(savedTheme);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  /// Set colors based on theme name
  void _setColorsByThemeName(String themeName) {
    switch (themeName) {
      case 'green_nature':
        _colors = _isDarkMode ? DarkGreenColors() : GreenNatureColors();
        break;
      case 'forest':
        _colors = ForestColors();
        break;
      case 'botanical':
        _colors = BotanicalColors();
        break;
      case 'mushroom':
        _colors = MushroomColors();
        break;
      case 'dark_green':
        _colors = DarkGreenColors();
        break;
      default:
        _colors = GreenNatureColors();
    }
  }

  /// Set theme by name
  Future<void> setTheme(String themeName) async {
    _setColorsByThemeName(themeName);
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeName);
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;

    // Update colors for dark mode if needed
    if (_isDarkMode) {
      _colors = DarkGreenColors();
    } else {
      _colors = GreenNatureColors();
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _isDarkMode);
    } catch (e) {
      debugPrint('Error saving dark mode preference: $e');
    }
  }

  /// Get available theme names
  List<String> get availableThemes => [
        'green_nature',
        'forest',
        'botanical',
        'mushroom',
        'dark_green',
      ];
}
