import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';

class GreetingService {
  static const String _lastGreetingIndexKey = 'last_greeting_index';
  static const int _greetingsCount = 16;

  static Future<String> getRandomGreeting(AppLocalizations l10n) async {
    try {
      // Получаем SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Получаем индекс последнего использованного приветствия
      final lastGreetingIndex = prefs.getInt(_lastGreetingIndexKey) ?? -1;

      // Создаём список доступных индексов, исключая предыдущий
      final availableIndices = List<int>.generate(_greetingsCount, (i) => i);
      if (lastGreetingIndex >= 0 && lastGreetingIndex < _greetingsCount) {
        availableIndices.remove(lastGreetingIndex);
      }

      // Выбираем случайный индекс из доступных
      final random = Random();
      final newIndex = availableIndices[random.nextInt(availableIndices.length)];

      // Сохраняем новый индекс
      await prefs.setInt(_lastGreetingIndexKey, newIndex);

      // Возвращаем приветствие по индексу
      return _getGreetingByIndex(l10n, newIndex);
    } catch (e) {
      // В случае ошибки возвращаем приветствие по умолчанию
      return l10n.botGreeting1;
    }
  }

  static String _getGreetingByIndex(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.botGreeting1;
      case 1:
        return l10n.botGreeting2;
      case 2:
        return l10n.botGreeting3;
      case 3:
        return l10n.botGreeting4;
      case 4:
        return l10n.botGreeting5;
      case 5:
        return l10n.botGreeting6;
      case 6:
        return l10n.botGreeting7;
      case 7:
        return l10n.botGreeting8;
      case 8:
        return l10n.botGreeting9;
      case 9:
        return l10n.botGreeting10;
      case 10:
        return l10n.botGreeting11;
      case 11:
        return l10n.botGreeting12;
      case 12:
        return l10n.botGreeting13;
      case 13:
        return l10n.botGreeting14;
      case 14:
        return l10n.botGreeting15;
      case 15:
        return l10n.botGreeting16;
      default:
        return l10n.botGreeting1;
    }
  }
}
