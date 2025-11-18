import 'package:flutter/foundation.dart';
import '../theme/app_colors.dart';

/// Global application state provider
/// Manages theme, settings, and app-wide state
class AppStateProvider with ChangeNotifier {
  // === THEME ===
  bool _isDarkMode = false;
  AppThemeType _themeType = AppThemeType.professional;

  bool get isDarkMode => _isDarkMode;
  AppThemeType get themeType => _themeType;

  /// Get current color palette based on theme settings
  AppColors get colors {
    switch (_themeType) {
      case AppThemeType.professional:
        return _isDarkMode ? DarkProfessionalColors() : ProfessionalColors();
      case AppThemeType.minimalist:
        return MinimalistColors();
      case AppThemeType.greenBusiness:
        return GreenBusinessColors();
    }
  }

  /// Toggle dark mode
  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    // TODO: Save to database
  }

  /// Set dark mode explicitly
  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  /// Change theme type
  void setThemeType(AppThemeType type) {
    if (_themeType != type) {
      _themeType = type;
      notifyListeners();
      // TODO: Save to database
    }
  }

  // === AI SETTINGS ===
  bool _aiEnabled = true;
  bool _autoOCR = true;
  bool _autoClassification = true;

  bool get aiEnabled => _aiEnabled;
  bool get autoOCR => _autoOCR;
  bool get autoClassification => _autoClassification;

  void setAIEnabled(bool value) {
    if (_aiEnabled != value) {
      _aiEnabled = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  void setAutoOCR(bool value) {
    if (_autoOCR != value) {
      _autoOCR = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  void setAutoClassification(bool value) {
    if (_autoClassification != value) {
      _autoClassification = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  // === SCANNER SETTINGS ===
  bool _autoEdgeDetection = true;
  bool _autoEnhancement = true;

  bool get autoEdgeDetection => _autoEdgeDetection;
  bool get autoEnhancement => _autoEnhancement;

  void setAutoEdgeDetection(bool value) {
    if (_autoEdgeDetection != value) {
      _autoEdgeDetection = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  void setAutoEnhancement(bool value) {
    if (_autoEnhancement != value) {
      _autoEnhancement = value;
      notifyListeners();
      // TODO: Save to database
    }
  }

  // === INITIALIZATION ===

  /// Load saved settings from database
  Future<void> loadSettings() async {
    // TODO: Load from database service
    notifyListeners();
  }
}

/// Available theme types
enum AppThemeType {
  professional,
  minimalist,
  greenBusiness,
}
