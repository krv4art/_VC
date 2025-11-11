import 'package:flutter/material.dart';

/// Locale provider for managing app language (en, ru, es, ja)
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void setLocaleFromCode(String languageCode) {
    setLocale(Locale(languageCode));
  }

  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ru'), // Russian
    Locale('es'), // Spanish
    Locale('ja'), // Japanese
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ru': 'Русский',
    'es': 'Español',
    'ja': '日本語',
  };
}
