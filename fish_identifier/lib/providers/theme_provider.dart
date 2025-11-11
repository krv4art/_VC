import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Theme provider for managing app theme (Ocean Blue, Deep Sea, Tropical, Khaki)
class ThemeProvider with ChangeNotifier {
  String _currentTheme = 'ocean_blue';
  bool _isDarkMode = false;

  String get currentTheme => _currentTheme;
  bool get isDarkMode => _isDarkMode;

  AppColors get colors {
    switch (_currentTheme) {
      case 'deep_sea':
        return AppColors.deepSea;
      case 'tropical':
        return AppColors.tropicalWaters;
      case 'khaki_camo':
        return AppColors.khakiCamo;
      case 'ocean_blue':
      default:
        return AppColors.oceanBlue;
    }
  }

  ThemeData get themeData {
    return AppTheme.getThemeData(colors, _isDarkMode);
  }

  void setTheme(String theme) {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      notifyListeners();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }
}
