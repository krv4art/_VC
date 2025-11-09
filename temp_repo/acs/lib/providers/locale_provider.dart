import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      // Загружаем сохраненный язык
      _locale = Locale(languageCode);
      notifyListeners();
    } else {
      // Если язык не сохранен, используем системный язык
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      final supportedLanguages = ['en', 'ru', 'uk', 'es', 'de', 'fr', 'it'];

      // Проверяем, поддерживается ли системный язык
      if (supportedLanguages.contains(systemLocale.languageCode)) {
        _locale = Locale(systemLocale.languageCode);
      } else {
        // Если системный язык не поддерживается, используем английский
        _locale = const Locale('en');
      }

      // Сохраняем выбранный язык в SharedPreferences
      await prefs.setString('languageCode', _locale!.languageCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('languageCode');
    notifyListeners();
  }

  /// Метод для сброса языковых настроек (псевдоним для clearLocale)
  Future<void> resetLocale() async {
    await clearLocale();
  }

  /// Метод для немедленной очистки состояния без сохранения в SharedPreferences
  void clearStateImmediately() {
    debugPrint('LocaleProvider.clearStateImmediately() вызван');
    debugPrint('До очистки: locale=$_locale');

    _locale = null;

    debugPrint('После очистки: locale=$_locale');
    debugPrint('notifyListeners() вызван в LocaleProvider');

    notifyListeners();
  }
}
