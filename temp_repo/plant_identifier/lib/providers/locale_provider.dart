import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  /// Load saved locale
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey) ?? 'en';
      _locale = Locale(localeCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading locale: $e');
    }
  }

  /// Set new locale
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;

    _locale = newLocale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  /// Get supported locales
  List<Locale> get supportedLocales => const [
        Locale('en'), // English
        Locale('ru'), // Russian
        Locale('uk'), // Ukrainian
      ];

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      case 'uk':
        return 'Українська';
      default:
        return locale.languageCode;
    }
  }
}
