import 'package:flutter/foundation.dart';
import '../models/ai_bot_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AiBotProvider extends ChangeNotifier {
  AiBotSettings? _settings;
  bool _isLoading = false;
  String? _error;

  static const String _prefsKey = 'ai_bot_settings';

  // Геттеры
  AiBotSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Удобные геттеры для доступа к основным полям
  String get botName => _settings?.name ?? 'ACS';
  String get botDescription =>
      _settings?.description ??
      'Hi! I\'m ACS — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.';

  // Геттеры для дополнительных полей
  bool get isCustomPromptEnabled => _settings?.isCustomPromptEnabled ?? false;
  String get customPrompt => _settings?.customPrompt ?? '';

  // Загрузка настроек из SharedPreferences
  Future<void> loadSettings() async {
    _setLoading(true);
    _clearError();

    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_prefsKey);

      if (settingsJson != null) {
        final Map<String, dynamic> json = jsonDecode(settingsJson);
        _settings = AiBotSettings.fromJson(json);
      } else {
        _settings = AiBotSettings.defaultSettings();
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading AI bot settings: $e');
      // Используем настройки по умолчанию при ошибке
      _settings = AiBotSettings.defaultSettings();
      _error = null;
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Сохранение настроек в SharedPreferences
  Future<void> _saveSettings(AiBotSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(settings.toJson());
      await prefs.setString(_prefsKey, settingsJson);
      _settings = settings;
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving AI bot settings: $e');
      rethrow;
    }
  }

  // Обновление имени бота
  Future<void> updateName(String name) async {
    _settings ??= AiBotSettings.defaultSettings();

    _clearError();
    final updatedSettings = _settings!.copyWith(
      name: name.isEmpty ? 'ACS' : name,
      updatedAt: DateTime.now(),
    );

    try {
      await _saveSettings(updatedSettings);
    } catch (e) {
      _setError('Failed to update bot name: $e');
      debugPrint('Error updating bot name: $e');
    }
  }

  // Обновление описания бота
  Future<void> updateDescription(String description) async {
    _settings ??= AiBotSettings.defaultSettings();

    _clearError();
    final updatedSettings = _settings!.copyWith(
      description: description.isEmpty
          ? getDefaultDescription(botName)
          : description,
      updatedAt: DateTime.now(),
    );

    try {
      await _saveSettings(updatedSettings);
    } catch (e) {
      _setError('Failed to update bot description: $e');
      debugPrint('Error updating bot description: $e');
    }
  }

  // Обновление дополнительного промпта
  Future<void> updateCustomPrompt(String prompt, bool isEnabled) async {
    _settings ??= AiBotSettings.defaultSettings();

    _clearError();
    final updatedSettings = _settings!.copyWith(
      customPrompt: prompt,
      isCustomPromptEnabled: isEnabled,
      updatedAt: DateTime.now(),
    );

    try {
      await _saveSettings(updatedSettings);
    } catch (e) {
      _setError('Failed to update custom prompt: $e');
      debugPrint('Error updating custom prompt: $e');
    }
  }

  // Обновление всех настроек сразу
  Future<void> updateAllSettings({
    String? name,
    String? description,
  }) async {
    _settings ??= AiBotSettings.defaultSettings();

    _clearError();
    final updatedSettings = _settings!.copyWith(
      name: name?.isEmpty == true ? 'ACS' : name,
      description: description?.isEmpty == true
          ? getDefaultDescription(name ?? botName)
          : description,
      updatedAt: DateTime.now(),
    );

    try {
      await _saveSettings(updatedSettings);
    } catch (e) {
      _setError('Failed to update bot settings: $e');
      debugPrint('Error updating bot settings: $e');
    }
  }

  // Сброс к настройкам по умолчанию
  Future<void> resetToDefault() async {
    _clearError();
    final defaultSettings = AiBotSettings.defaultSettings();

    try {
      await _saveSettings(defaultSettings);
    } catch (e) {
      _setError('Failed to reset bot settings: $e');
      debugPrint('Error resetting bot settings: $e');
    }
  }

  // Получение описания по умолчанию с подстановкой имени
  String getDefaultDescription(String name) {
    return 'Hi! I\'m $name — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.';
  }

  // Приватные методы для управления состоянием
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }
}
