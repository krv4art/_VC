import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/custom_theme_data.dart';

/// Сервис для сохранения и загрузки пользовательских тем
class ThemeStorageService {
  static final ThemeStorageService _instance = ThemeStorageService._internal();
  factory ThemeStorageService() => _instance;
  ThemeStorageService._internal();

  static const String _storageKey = 'custom_themes_v1';
  static const int _maxThemes = 10;

  /// Получить все кастомные темы
  Future<List<CustomThemeData>> loadCustomThemes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);

      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('=== THEME STORAGE: No custom themes found ===');
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      final themes = jsonList
          .map((json) => CustomThemeData.fromJson(json as Map<String, dynamic>))
          .toList();

      debugPrint(
        '=== THEME STORAGE: Loaded ${themes.length} custom themes ===',
      );
      return themes;
    } catch (e) {
      debugPrint('=== THEME STORAGE: Error loading themes: $e ===');
      return [];
    }
  }

  /// Сохранить кастомную тему
  Future<bool> saveCustomTheme(CustomThemeData theme) async {
    try {
      final themes = await loadCustomThemes();

      // Проверяем лимит (если это новая тема)
      final existingIndex = themes.indexWhere((t) => t.id == theme.id);
      if (existingIndex == -1 && themes.length >= _maxThemes) {
        debugPrint(
          '=== THEME STORAGE: Max themes limit reached ($_maxThemes) ===',
        );
        return false;
      }

      // Обновляем существующую или добавляем новую
      if (existingIndex != -1) {
        themes[existingIndex] = theme;
        debugPrint('=== THEME STORAGE: Updated theme: ${theme.name} ===');
      } else {
        themes.add(theme);
        debugPrint('=== THEME STORAGE: Added new theme: ${theme.name} ===');
      }

      // Сохраняем в SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final jsonList = themes.map((t) => t.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await prefs.setString(_storageKey, jsonString);

      debugPrint('=== THEME STORAGE: Saved ${themes.length} themes ===');
      return true;
    } catch (e) {
      debugPrint('=== THEME STORAGE: Error saving theme: $e ===');
      return false;
    }
  }

  /// Удалить кастомную тему по ID
  Future<bool> deleteCustomTheme(String id) async {
    try {
      final themes = await loadCustomThemes();
      final initialLength = themes.length;

      themes.removeWhere((t) => t.id == id);

      if (themes.length == initialLength) {
        debugPrint('=== THEME STORAGE: Theme with id $id not found ===');
        return false;
      }

      // Сохраняем обновленный список
      final prefs = await SharedPreferences.getInstance();
      if (themes.isEmpty) {
        await prefs.remove(_storageKey);
        debugPrint('=== THEME STORAGE: All themes deleted ===');
      } else {
        final jsonList = themes.map((t) => t.toJson()).toList();
        final jsonString = jsonEncode(jsonList);
        await prefs.setString(_storageKey, jsonString);
        debugPrint(
          '=== THEME STORAGE: Deleted theme, ${themes.length} remaining ===',
        );
      }

      return true;
    } catch (e) {
      debugPrint('=== THEME STORAGE: Error deleting theme: $e ===');
      return false;
    }
  }

  /// Получить одну тему по ID
  Future<CustomThemeData?> getCustomTheme(String id) async {
    try {
      final themes = await loadCustomThemes();
      return themes.firstWhere(
        (t) => t.id == id,
        orElse: () => throw Exception('Theme not found'),
      );
    } catch (e) {
      debugPrint('=== THEME STORAGE: Theme with id $id not found ===');
      return null;
    }
  }

  /// Проверить, достигнут ли лимит тем
  Future<bool> isMaxThemesReached() async {
    final themes = await loadCustomThemes();
    return themes.length >= _maxThemes;
  }

  /// Получить количество сохраненных тем
  Future<int> getThemesCount() async {
    final themes = await loadCustomThemes();
    return themes.length;
  }

  /// Очистить все кастомные темы (для тестирования)
  Future<void> clearAllThemes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      debugPrint('=== THEME STORAGE: All custom themes cleared ===');
    } catch (e) {
      debugPrint('=== THEME STORAGE: Error clearing themes: $e ===');
    }
  }

  /// Экспорт темы в JSON строку (для share/backup)
  String exportTheme(CustomThemeData theme) {
    return jsonEncode(theme.toJson());
  }

  /// Импорт темы из JSON строки
  CustomThemeData? importTheme(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CustomThemeData.fromJson(json);
    } catch (e) {
      debugPrint('=== THEME STORAGE: Error importing theme: $e ===');
      return null;
    }
  }
}
