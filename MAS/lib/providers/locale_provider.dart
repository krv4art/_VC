import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

/// Provider for managing app locale (language) at runtime
///
/// Supports Math AI Solver's 13 languages:
/// en, ru, uk, es, de, fr, it, ar, ko, cs, da, el, fi, etc.
///
/// Features:
/// - Runtime language switching without app restart
/// - Persists user's language choice
/// - Falls back to system language if supported
/// - Defaults to English if system language unsupported
class LocaleProvider with ChangeNotifier {
  Locale? _locale;

  /// Current selected locale
  Locale? get locale => _locale;

  /// Supported languages in Math AI Solver
  static const List<String> supportedLanguages = [
    'en', // English
    'ru', // Russian
    'uk', // Ukrainian
    'es', // Spanish
    'de', // German
    'fr', // French
    'it', // Italian
    'ar', // Arabic
    'ko', // Korean
    'cs', // Czech
    'da', // Danish
    'el', // Greek
    'fi', // Finnish
    'hi', // Hindi
    'hu', // Hungarian
    'id', // Indonesian
    'ja', // Japanese
    'nl', // Dutch
    'no', // Norwegian
    'pl', // Polish
    'pt', // Portuguese
    'ro', // Romanian
    'sv', // Swedish
    'th', // Thai
    'tr', // Turkish
    'vi', // Vietnamese
    'zh', // Chinese
  ];

  LocaleProvider() {
    _loadLocale();
  }

  /// Load saved locale or detect system locale
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode');

    if (languageCode != null) {
      // Load saved language
      _locale = Locale(languageCode);
      debugPrint('🌍 Loaded saved locale: $languageCode');
      notifyListeners();
    } else {
      // Detect system language
      final systemLocale = ui.PlatformDispatcher.instance.locale;
      debugPrint('🌍 System locale detected: ${systemLocale.languageCode}');

      // Check if system language is supported
      if (supportedLanguages.contains(systemLocale.languageCode)) {
        _locale = Locale(systemLocale.languageCode);
        debugPrint('✅ Using system locale: ${_locale!.languageCode}');
      } else {
        // Fallback to English
        _locale = const Locale('en');
        debugPrint('⚠️ System locale not supported, using English');
      }

      // Save chosen language
      await prefs.setString('languageCode', _locale!.languageCode);
      notifyListeners();
    }
  }

  /// Set new locale and persist it
  Future<void> setLocale(Locale locale) async {
    if (_locale?.languageCode == locale.languageCode) {
      debugPrint('🌍 Locale already set to: ${locale.languageCode}');
      return;
    }

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);

    debugPrint('🌍 Locale changed to: ${locale.languageCode}');
    notifyListeners();
  }

  /// Clear saved locale (resets to system language on next load)
  Future<void> clearLocale() async {
    _locale = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('languageCode');

    debugPrint('🌍 Locale cleared');
    notifyListeners();
  }

  /// Reset to system language
  Future<void> resetToSystemLanguage() async {
    final systemLocale = ui.PlatformDispatcher.instance.locale;

    if (supportedLanguages.contains(systemLocale.languageCode)) {
      await setLocale(Locale(systemLocale.languageCode));
    } else {
      await setLocale(const Locale('en'));
    }

    debugPrint('🌍 Reset to system language');
  }

  /// Check if given language code is supported
  static bool isLanguageSupported(String languageCode) {
    return supportedLanguages.contains(languageCode);
  }
}
