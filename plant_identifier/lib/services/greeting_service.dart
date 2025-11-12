import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingService {
  static const String _lastGreetingIndexKey = 'last_greeting_index';

  // Plant identification greetings by language
  static const Map<String, List<String>> _greetings = {
    'en': [
      'Hello! I\'m your plant identification assistant. Upload a photo and I\'ll help you identify any plant!',
      'Welcome! Ready to discover the name of that beautiful plant? Just show me a picture!',
      'Hi there! I can identify plants, flowers, trees, and more. What would you like to identify today?',
      'Greetings! Let\'s explore the wonderful world of plants together. Share a photo to get started!',
      'Hello plant lover! I\'m here to help you identify any plant species. Just upload an image!',
      'Welcome back! Ready to identify more amazing plants? I\'m all set to help!',
      'Hi! I specialize in plant identification and can tell you all about the plants you photograph.',
      'Good to see you! Show me any plant photo and I\'ll identify it along with care tips!',
    ],
    'ru': [
      'Привет! Я ваш помощник по идентификации растений. Загрузите фото, и я помогу определить любое растение!',
      'Добро пожаловать! Готовы узнать название этого прекрасного растения? Просто покажите мне фото!',
      'Здравствуйте! Я могу идентифицировать растения, цветы, деревья и многое другое. Что хотите определить сегодня?',
      'Приветствую! Давайте вместе исследуем удивительный мир растений. Поделитесь фото для начала!',
      'Привет, любитель растений! Я помогу определить любой вид растений. Просто загрузите изображение!',
      'С возвращением! Готовы идентифицировать больше удивительных растений? Я готов помочь!',
      'Привет! Я специализируюсь на идентификации растений и расскажу всё о ваших фотографиях.',
      'Рад вас видеть! Покажите любое фото растения, и я определю его с советами по уходу!',
    ],
    'uk': [
      'Привіт! Я ваш помічник з ідентифікації рослин. Завантажте фото, і я допоможу визначити будь-яку рослину!',
      'Ласкаво просимо! Готові дізнатися назву цієї прекрасної рослини? Просто покажіть мені фото!',
      'Вітаю! Я можу ідентифікувати рослини, квіти, дерева і багато іншого. Що хочете визначити сьогодні?',
      'Вітання! Давайте разом досліджувати чудовий світ рослин. Поділіться фото для початку!',
      'Привіт, любителю рослин! Я допоможу визначити будь-який вид рослин. Просто завантажте зображення!',
      'З поверненням! Готові ідентифікувати більше дивовижних рослин? Я готовий допомогти!',
      'Привіт! Я спеціалізуюся на ідентифікації рослин і розповім все про ваші фотографії.',
      'Радий вас бачити! Покажіть будь-яке фото рослини, і я визначу його з порадами з догляду!',
    ],
  };

  static Future<String> getRandomGreeting(String languageCode) async {
    try {
      // Get greetings for the language (default to English if not found)
      final greetingsList = _greetings[languageCode] ?? _greetings['en']!;
      final greetingsCount = greetingsList.length;

      // Get SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Get last greeting index
      final lastGreetingIndex = prefs.getInt(_lastGreetingIndexKey) ?? -1;

      // Create list of available indices, excluding the previous one
      final availableIndices = List<int>.generate(greetingsCount, (i) => i);
      if (lastGreetingIndex >= 0 && lastGreetingIndex < greetingsCount) {
        availableIndices.remove(lastGreetingIndex);
      }

      // Choose random index from available ones
      final random = Random();
      final newIndex = availableIndices[random.nextInt(availableIndices.length)];

      // Save new index
      await prefs.setInt(_lastGreetingIndexKey, newIndex);

      // Return greeting by index
      return greetingsList[newIndex];
    } catch (e) {
      // In case of error, return default greeting
      return 'Hello! I\'m your plant identification assistant. Upload a photo and I\'ll help you identify any plant!';
    }
  }
}
