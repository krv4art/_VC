import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bug_identifier/theme/app_colors.dart';
import 'package:bug_identifier/theme/app_theme.dart';
import 'package:bug_identifier/models/custom_theme_data.dart';
import 'package:bug_identifier/services/theme_storage_service.dart';

/// Enum для всех доступных тем
enum AppThemeType {
  natural,
  dark, // Темная версия Natural темы
  ocean,
  darkOcean, // Темная версия Ocean темы
  forest,
  darkForest, // Темная версия Forest темы
  sunset,
  darkSunset, // Темная версия Sunset темы
  vibrant,
  darkVibrant, // Темная версия Vibrant темы
}

class ThemeProviderV2 extends ChangeNotifier {
  static const String _themeKey = 'app_theme_type_v2';
  static const String _lastLightThemeKey = 'last_light_theme_v2';
  static const String _customThemeIdKey = 'current_custom_theme_id_v2';

  AppThemeType _currentTheme = AppThemeType.vibrant;
  AppThemeType _lastLightTheme = AppThemeType.vibrant;
  AppColors? _cachedColors;

  // Custom themes support
  List<CustomThemeData> _customThemes = [];
  CustomThemeData? _currentCustomTheme;
  final ThemeStorageService _themeStorage = ThemeStorageService();

  AppThemeType get currentTheme => _currentTheme;

  /// Получить текущую кастомную тему (если активна)
  CustomThemeData? get currentCustomTheme => _currentCustomTheme;

  /// Получить список всех кастомных тем
  List<CustomThemeData> get customThemes => List.unmodifiable(_customThemes);

  /// Проверить, активна ли кастомная тема
  bool get isCustomThemeActive => _currentCustomTheme != null;

  /// Получить текущие цвета (с кешированием)
  AppColors get currentColors {
    // Если активна кастомная тема, возвращаем её цвета
    if (_currentCustomTheme != null) {
      _cachedColors ??= _currentCustomTheme!.colors;
      return _cachedColors!;
    }

    // Иначе используем preset тему
    _cachedColors ??= _createColorsForTheme(_currentTheme);
    return _cachedColors!;
  }

  /// Создать экземпляр цветов для указанной темы
  AppColors _createColorsForTheme(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.natural:
        return NaturalColors();
      case AppThemeType.dark:
        return DarkColors();
      case AppThemeType.ocean:
        return OceanColors();
      case AppThemeType.darkOcean:
        return DarkOceanColors();
      case AppThemeType.forest:
        return ForestColors();
      case AppThemeType.darkForest:
        return DarkForestColors();
      case AppThemeType.sunset:
        return SunsetColors();
      case AppThemeType.darkSunset:
        return DarkSunsetColors();
      case AppThemeType.vibrant:
        return VibrantColors();
      case AppThemeType.darkVibrant:
        return DarkVibrantColors();
    }
  }

  /// Получить ThemeData для текущей темы
  ThemeData get themeData {
    final colors = currentColors;
    final isDark = colors.brightness == Brightness.dark;

    // Используем готовый метод из AppTheme
    return AppTheme.getThemeData(colors, isDark);
  }

  ThemeProviderV2() {
    _loadTheme();
  }

  /// Загрузить сохраненную тему
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Загрузить все кастомные темы
      _customThemes = await _themeStorage.loadCustomThemes();
      debugPrint(
        '=== THEME PROVIDER: Loaded ${_customThemes.length} custom themes ===',
      );

      final savedThemeIndex = prefs.getInt(_themeKey);
      final savedLastLightIndex = prefs.getInt(_lastLightThemeKey);
      final savedCustomThemeId = prefs.getString(_customThemeIdKey);

      // Загрузить последнюю светлую тему
      if (savedLastLightIndex != null &&
          savedLastLightIndex >= 0 &&
          savedLastLightIndex < AppThemeType.values.length) {
        _lastLightTheme = AppThemeType.values[savedLastLightIndex];
      }

      // Проверить, была ли активна кастомная тема
      if (savedCustomThemeId != null) {
        final customTheme = _customThemes.firstWhere(
          (t) => t.id == savedCustomThemeId,
          orElse: () => throw Exception('Custom theme not found'),
        );
        _currentCustomTheme = customTheme;
        _cachedColors = null;
        debugPrint(
          '=== THEME PROVIDER: Loaded custom theme: ${customTheme.name} ===',
        );
        notifyListeners();
        return;
      }

      // Загрузить текущую preset тему
      if (savedThemeIndex != null &&
          savedThemeIndex >= 0 &&
          savedThemeIndex < AppThemeType.values.length) {
        _currentTheme = AppThemeType.values[savedThemeIndex];
        _cachedColors = null; // Сбросить кеш при загрузке новой темы
        notifyListeners();
      }
    } catch (e) {
      // В случае ошибки используем Vibrant тему
      debugPrint('=== THEME PROVIDER: Error loading theme: $e ===');
      _currentTheme = AppThemeType.vibrant;
      _currentCustomTheme = null;
      _cachedColors = null;
      notifyListeners();
    }
  }

  /// Установить конкретную тему
  Future<void> setTheme(AppThemeType theme) async {
    if (_currentTheme == theme && _currentCustomTheme == null) return;

    _currentTheme = theme;
    _currentCustomTheme = null; // Сбросить кастомную тему при выборе пресетной
    _cachedColors = null; // Сбросить кеш при смене темы

    // Сохранить как последнюю светлую или темную тему
    final colors = _createColorsForTheme(theme);
    if (colors.brightness == Brightness.light) {
      _lastLightTheme = theme;
    } else {}

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
      await prefs.remove(
        _customThemeIdKey,
      ); // Удаляем сохраненную кастомную тему

      // Сохранить последние светлую/темную темы
      if (colors.brightness == Brightness.light) {
        await prefs.setInt(_lastLightThemeKey, theme.index);
      } else {}
    } catch (e) {
      // Если не удалось сохранить, продолжаем работу с текущей темой
      debugPrint('Error saving theme: $e');
    }
  }

  /// Установить Natural тему
  Future<void> setNaturalTheme() async {
    await setTheme(AppThemeType.natural);
  }

  /// Установить темную тему
  Future<void> setDarkTheme() async {
    await setTheme(AppThemeType.dark);
  }

  /// Установить Ocean тему
  Future<void> setOceanTheme() async {
    await setTheme(AppThemeType.ocean);
  }

  /// Установить Forest тему
  Future<void> setForestTheme() async {
    await setTheme(AppThemeType.forest);
  }

  /// Установить Sunset тему
  Future<void> setSunsetTheme() async {
    await setTheme(AppThemeType.sunset);
  }

  /// Установить Vibrant тему
  Future<void> setVibrantTheme() async {
    await setTheme(AppThemeType.vibrant);
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

  /// Циклическое переключение тем (для тестирования)
  Future<void> cycleTheme() async {
    final currentIndex = AppThemeType.values.indexOf(_currentTheme);
    final nextIndex = (currentIndex + 1) % AppThemeType.values.length;
    await setTheme(AppThemeType.values[nextIndex]);
  }

  /// Получить темную версию светлой темы
  AppThemeType _getDarkVariant(AppThemeType lightTheme) {
    switch (lightTheme) {
      case AppThemeType.natural:
        return AppThemeType.dark;
      case AppThemeType.ocean:
        return AppThemeType.darkOcean;
      case AppThemeType.forest:
        return AppThemeType.darkForest;
      case AppThemeType.sunset:
        return AppThemeType.darkSunset;
      case AppThemeType.vibrant:
        return AppThemeType.darkVibrant;
      default:
        return AppThemeType.dark; // По умолчанию
    }
  }

  /// Получить название темы
  String getThemeName(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.natural:
        return 'Natural';
      case AppThemeType.dark:
        return 'Dark';
      case AppThemeType.ocean:
        return 'Ocean';
      case AppThemeType.darkOcean:
        return 'Dark Ocean';
      case AppThemeType.forest:
        return 'Forest';
      case AppThemeType.darkForest:
        return 'Dark Forest';
      case AppThemeType.sunset:
        return 'Sunset';
      case AppThemeType.darkSunset:
        return 'Dark Sunset';
      case AppThemeType.vibrant:
        return 'Vibrant';
      case AppThemeType.darkVibrant:
        return 'Dark Vibrant';
    }
  }

  /// Получить иконку для темы
  IconData getThemeIcon(AppThemeType theme) {
    switch (theme) {
      case AppThemeType.natural:
        return Icons.eco; // Экологичная иконка для Natural темы
      case AppThemeType.dark:
        return Icons.dark_mode;
      case AppThemeType.ocean:
        return Icons.water;
      case AppThemeType.darkOcean:
        return Icons.dark_mode; // Или Icons.water (с dark оттенком)
      case AppThemeType.forest:
        return Icons.forest;
      case AppThemeType.darkForest:
        return Icons.dark_mode; // Или Icons.forest (с dark оттенком)
      case AppThemeType.sunset:
        return Icons.wb_sunny;
      case AppThemeType.darkSunset:
        return Icons.dark_mode; // Или Icons.wb_sunny (с dark оттенком)
      case AppThemeType.vibrant:
        return Icons.auto_awesome;
      case AppThemeType.darkVibrant:
        return Icons.dark_mode; // Или Icons.auto_awesome (с dark оттенком)
    }
  }

  /// Проверить, является ли текущая тема темной
  bool get isDarkTheme => currentColors.brightness == Brightness.dark;

  /// Проверить, является ли текущая тема светлой
  bool get isLightTheme => currentColors.brightness == Brightness.light;

  // ========== CUSTOM THEMES METHODS ==========

  /// Применить кастомную тему
  Future<void> setCustomTheme(CustomThemeData theme) async {
    _currentCustomTheme = theme;
    _cachedColors = null; // Сбросить кеш

    // Обновить список кастомных тем если эта тема новая
    if (!_customThemes.any((t) => t.id == theme.id)) {
      await _reloadCustomThemes();
    }

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_customThemeIdKey, theme.id);
      await prefs.remove(_themeKey); // Убрать preset тему
      debugPrint('=== THEME PROVIDER: Custom theme applied: ${theme.name} ===');
    } catch (e) {
      debugPrint('=== THEME PROVIDER: Error saving custom theme: $e ===');
    }
  }

  /// Вернуться к preset теме
  Future<void> clearCustomTheme() async {
    if (_currentCustomTheme == null) return;

    _currentCustomTheme = null;
    _cachedColors = null;

    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_customThemeIdKey);
      await prefs.setInt(_themeKey, _currentTheme.index);
      debugPrint(
        '=== THEME PROVIDER: Cleared custom theme, back to preset ===',
      );
    } catch (e) {
      debugPrint('=== THEME PROVIDER: Error clearing custom theme: $e ===');
    }
  }

  /// Добавить новую кастомную тему
  Future<bool> addCustomTheme(CustomThemeData theme) async {
    final success = await _themeStorage.saveCustomTheme(theme);
    if (success) {
      await _reloadCustomThemes();
      debugPrint('=== THEME PROVIDER: Added custom theme: ${theme.name} ===');
    }
    return success;
  }

  /// Обновить существующую кастомную тему
  Future<bool> updateCustomTheme(CustomThemeData theme) async {
    final success = await _themeStorage.saveCustomTheme(theme);
    if (success) {
      await _reloadCustomThemes();

      // Если это текущая активная тема, обновить её
      if (_currentCustomTheme?.id == theme.id) {
        _currentCustomTheme = theme;
        _cachedColors = null;
        notifyListeners();
      }
      debugPrint('=== THEME PROVIDER: Updated custom theme: ${theme.name} ===');
    }
    return success;
  }

  /// Удалить кастомную тему
  Future<bool> deleteCustomTheme(String themeId) async {
    final success = await _themeStorage.deleteCustomTheme(themeId);
    if (success) {
      await _reloadCustomThemes();

      // Если удалили текущую активную тему, вернуться к preset
      if (_currentCustomTheme?.id == themeId) {
        await clearCustomTheme();
      }
      debugPrint('=== THEME PROVIDER: Deleted custom theme: $themeId ===');
    }
    return success;
  }

  /// Перезагрузить список кастомных тем
  Future<void> _reloadCustomThemes() async {
    _customThemes = await _themeStorage.loadCustomThemes();
    notifyListeners();
  }

  /// Перезагрузить все кастомные темы (публичный метод)
  Future<void> reloadCustomThemes() async {
    await _reloadCustomThemes();
  }

  /// Проверить, можно ли добавить еще одну тему
  Future<bool> canAddMoreThemes() async {
    return !(await _themeStorage.isMaxThemesReached());
  }

  /// Получить количество кастомных тем
  int get customThemesCount => _customThemes.length;
}
