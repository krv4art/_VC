import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Провайдер для управления темой приложения
class ThemeProvider with ChangeNotifier {
  static const String _themeKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Инициализирует тему из shared preferences
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);

      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.light,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  /// Переключает тему
  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _saveTheme();
    notifyListeners();
  }

  /// Устанавливает тему
  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _saveTheme();
    notifyListeners();
  }

  /// Сохраняет тему
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, _themeMode.toString());
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }

  /// Светлая тема
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: const Color(0xFFD4AF37), // Золотой
        secondary: const Color(0xFF4A5568), // Темно-серый
        surface: const Color(0xFFF7FAFC),
        background: const Color(0xFFFFFFFF),
        error: const Color(0xFFE53E3E),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A202C),
        onBackground: const Color(0xFF1A202C),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarTheme(
        selectedItemColor: Color(0xFFD4AF37),
        unselectedItemColor: Color(0xFF718096),
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Темная тема
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFFFFD700), // Яркое золото
        secondary: const Color(0xFFCBD5E0),
        surface: const Color(0xFF2D3748),
        background: const Color(0xFF1A202C),
        error: const Color(0xFFFC8181),
        onPrimary: const Color(0xFF1A202C),
        onSecondary: const Color(0xFF1A202C),
        onSurface: const Color(0xFFF7FAFC),
        onBackground: const Color(0xFFF7FAFC),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF2D3748),
        foregroundColor: Color(0xFFF7FAFC),
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 4,
        color: const Color(0xFF2D3748),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD700),
          foregroundColor: const Color(0xFF1A202C),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: const Color(0xFF2D3748),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarTheme(
        selectedItemColor: Color(0xFFFFD700),
        unselectedItemColor: Color(0xFFCBD5E0),
        backgroundColor: Color(0xFF2D3748),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
