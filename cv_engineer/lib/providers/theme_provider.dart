import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Theme Provider for managing app theme and dark mode
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'selected_theme';
  static const String _darkModeKey = 'dark_mode_enabled';

  // Current theme name
  String _currentTheme = 'professional';
  bool _isDarkMode = false;

  String get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  // Get current colors based on theme and dark mode
  AppColors get colors {
    if (_isDarkMode) {
      switch (_currentTheme) {
        case 'professional':
          return DarkProfessionalColors();
        case 'creative':
          return DarkCreativeColors();
        case 'modern':
          return DarkModernColors();
        default:
          return DarkProfessionalColors();
      }
    } else {
      switch (_currentTheme) {
        case 'professional':
          return ProfessionalColors();
        case 'creative':
          return CreativeColors();
        case 'modern':
          return ModernColors();
        default:
          return ProfessionalColors();
      }
    }
  }

  // Get ThemeData
  ThemeData get themeData => AppTheme.getThemeData(colors, _isDarkMode);

  // Initialize theme from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentTheme = prefs.getString(_themeKey) ?? 'professional';
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    notifyListeners();
  }

  // Set theme
  Future<void> setTheme(String themeName) async {
    if (_currentTheme != themeName) {
      _currentTheme = themeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, themeName);
      notifyListeners();
    }
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  // Set dark mode explicitly
  Future<void> setDarkMode(bool enabled) async {
    if (_isDarkMode != enabled) {
      _isDarkMode = enabled;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, enabled);
      notifyListeners();
    }
  }

  // Get available themes
  List<Map<String, String>> get availableThemes => [
    {'id': 'professional', 'name': 'Professional', 'description': 'Clean and professional blue theme'},
    {'id': 'creative', 'name': 'Creative', 'description': 'Bold purple and pink theme'},
    {'id': 'modern', 'name': 'Modern', 'description': 'Fresh teal and cyan theme'},
  ];
}
