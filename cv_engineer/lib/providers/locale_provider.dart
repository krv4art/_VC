import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';

  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  // Initialize locale from storage
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      final parts = localeCode.split('_');
      _locale = Locale(parts[0], parts.length > 1 ? parts[1] : '');
      notifyListeners();
    }
  }

  // Set locale
  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _localeKey,
        locale.countryCode != null && locale.countryCode!.isNotEmpty
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode,
      );
      notifyListeners();
    }
  }

  // Get available locales (matching feature requirements)
  List<Map<String, dynamic>> get availableLocales => [
    {'locale': const Locale('en', ''), 'name': 'English', 'nativeName': 'English'},
    {'locale': const Locale('es', 'ES'), 'name': 'Spanish', 'nativeName': 'Español'},
    {'locale': const Locale('de', ''), 'name': 'German', 'nativeName': 'Deutsch'},
    {'locale': const Locale('fr', ''), 'name': 'French', 'nativeName': 'Français'},
    {'locale': const Locale('it', ''), 'name': 'Italian', 'nativeName': 'Italiano'},
    {'locale': const Locale('pl', ''), 'name': 'Polish', 'nativeName': 'Polski'},
    {'locale': const Locale('pt', 'PT'), 'name': 'Portuguese', 'nativeName': 'Português'},
    {'locale': const Locale('tr', ''), 'name': 'Turkish', 'nativeName': 'Türkçe'},
  ];
}
