import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors_v2.dart';
import '../theme/app_theme.dart';

/// Enum для всех доступных тем
enum AppThemeType {
  oceanBlue,
  deepSea, // Темная версия Ocean Blue
  khakiCamo,
  khakiCamoDark, // Темная версия Khaki
  tropicalWaters,
  tropicalWatersDark, // Темная версия Tropical
}

class ThemeProviderV2 extends ChangeNotifier {
  static const String _themeKey = 'app_theme_type_v2';
  static const String _lastLightThemeKey = 'last_light_theme_v2';

  AppThemeType _currentTheme = AppThemeType.oceanBlue;
  AppThemeType _lastLightTheme = AppThemeType.oceanBlue;
  AppColorsV2? _cachedColors;

  AppThemeType get currentTheme => _currentTheme;

  /// Получить текущие цвета (с кешированием)
  AppColorsV2 get currentColors {
    _cachedColors ??= _createColorsForTheme(_currentTheme);
    return _cachedColors!;
  }

  /// Создать экземпляр цветов для указанной темы
  AppColorsV2 _createColorsForTheme(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.oceanBlue:
        return AppColorsV2.oceanBlue;
      case AppThemeType.deepSea:
        return AppColorsV2.deepSea;
      case AppThemeType.khakiCamo:
        return AppColorsV2.khakiCamo;
      case AppThemeType.khakiCamoDark:
        return AppColorsV2.khakiCamoDark;
      case AppThemeType.tropicalWaters:
        return AppColorsV2.tropicalWaters;
      case AppThemeType.tropicalWatersDark:
        return AppColorsV2.tropicalWatersDark;
    }
  }

  /// Получить ThemeData для текущей темы
  ThemeData get themeData {
    final colors = currentColors;
    final isDark = colors.brightness == Brightness.dark;

    // Используем готовый метод из AppTheme
    // Нужно будет адаптировать AppTheme.getThemeData для работы с AppColorsV2
    return _buildThemeData(colors, isDark);
  }

  /// Построить ThemeData из цветов
  ThemeData _buildThemeData(AppColorsV2 colors, bool isDark) {
    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      cardColor: colors.cardBackground,
      colorScheme: ColorScheme(
        brightness: colors.brightness,
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        secondary: colors.secondary,
        onSecondary: colors.onSecondary,
        error: colors.error,
        onError: Colors.white,
        surface: colors.surface,
        onSurface: colors.onSurface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.appBarColor,
        foregroundColor: colors.onPrimary,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        color: colors.cardBackground,
        elevation: 2,
      ),
      bottomNavigationBarTheme: BottomNavigationBarTheme(
        backgroundColor: colors.navBarColor,
        selectedItemColor: colors.primary,
        unselectedItemColor: colors.neutral,
      ),
    );
  }

  ThemeProviderV2() {
    _loadTheme();
  }

  /// Загрузить сохраненную тему
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedThemeIndex = prefs.getInt(_themeKey);
      final savedLastLightIndex = prefs.getInt(_lastLightThemeKey);

      // Загрузить последнюю светлую тему
      if (savedLastLightIndex != null &&
          savedLastLightIndex >= 0 &&
          savedLastLightIndex < AppThemeType.values.length) {
        _lastLightTheme = AppThemeType.values[savedLastLightIndex];
      }

      // Загрузить текущую тему
      if (savedThemeIndex != null &&
          savedThemeIndex >= 0 &&
          savedThemeIndex < AppThemeType.values.length) {
        _currentTheme = AppThemeType.values[savedThemeIndex];
        _cachedColors = null; // Сбросить кеш при загрузке новой темы
        notifyListeners();
      }
    } catch (e) {
      // В случае ошибки используем Ocean Blue тему
      debugPrint('=== THEME PROVIDER: Error loading theme: $e ===');
      _currentTheme = AppThemeType.oceanBlue;
      _cachedColors = null;
      notifyListeners();
    }
  }

  /// Установить конкретную тему
  Future<void> setTheme(AppThemeType theme) async {
    if (_currentTheme == theme) return;

    _currentTheme = theme;
    _cachedColors = null; // Сбросить кеш при смене темы

    // Сохранить как последнюю светлую или темную тему
    final colors = _createColorsForTheme(theme);
    if (colors.brightness == Brightness.light) {
      _lastLightTheme = theme;
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);

      // Сохранить последнюю светлую тему
      if (colors.brightness == Brightness.light) {
        await prefs.setInt(_lastLightThemeKey, theme.index);
      }
    } catch (e) {
      // Если не удалось сохранить, продолжаем работу с текущей темой
      debugPrint('Error saving theme: $e');
    }
  }

  /// Установить Ocean Blue тему
  Future<void> setOceanBlueTheme() async {
    await setTheme(AppThemeType.oceanBlue);
  }

  /// Установить Deep Sea тему (темная)
  Future<void> setDeepSeaTheme() async {
    await setTheme(AppThemeType.deepSea);
  }

  /// Установить Khaki Camo тему
  Future<void> setKhakiCamoTheme() async {
    await setTheme(AppThemeType.khakiCamo);
  }

  /// Установить Tropical Waters тему
  Future<void> setTropicalWatersTheme() async {
    await setTheme(AppThemeType.tropicalWaters);
  }

  /// Переключение между светлой и темной темой
  Future<void> toggleTheme() async {
    final currentColors = _createColorsForTheme(_currentTheme);

    if (currentColors.brightness == Brightness.light) {
      // Получить СООТВЕТСТВУЮЩУЮ темную версию текущей светлой темы
      final darkVariant = _getDarkVariant(_currentTheme);
      await setTheme(darkVariant);
    } else {
      // Переключаемся на последнюю светлую
      await setTheme(_lastLightTheme);
    }
  }

  /// Получить темную версию светлой темы
  AppThemeType _getDarkVariant(AppThemeType lightTheme) {
    switch (lightTheme) {
      case AppThemeType.oceanBlue:
        return AppThemeType.deepSea;
      case AppThemeType.khakiCamo:
        return AppThemeType.khakiCamoDark;
      case AppThemeType.tropicalWaters:
        return AppThemeType.tropicalWatersDark;
      default:
        return AppThemeType.deepSea; // По умолчанию
    }
  }

  /// Получить название темы
  String getThemeName(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.oceanBlue:
        return 'Ocean Blue';
      case AppThemeType.deepSea:
        return 'Deep Sea';
      case AppThemeType.khakiCamo:
        return 'Khaki Camo';
      case AppThemeType.khakiCamoDark:
        return 'Khaki Camo Dark';
      case AppThemeType.tropicalWaters:
        return 'Tropical Waters';
      case AppThemeType.tropicalWatersDark:
        return 'Tropical Waters Dark';
    }
  }

  /// Получить иконку для темы
  IconData getThemeIcon(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.oceanBlue:
        return Icons.water;
      case AppThemeType.deepSea:
        return Icons.dark_mode;
      case AppThemeType.khakiCamo:
        return Icons.terrain;
      case AppThemeType.khakiCamoDark:
        return Icons.dark_mode;
      case AppThemeType.tropicalWaters:
        return Icons.water_damage;
      case AppThemeType.tropicalWatersDark:
        return Icons.dark_mode;
    }
  }

  /// Проверить, является ли текущая тема темной
  bool get isDarkTheme => currentColors.brightness == Brightness.dark;

  /// Проверить, является ли текущая тема светлой
  bool get isLightTheme => currentColors.brightness == Brightness.light;
}
