/// Конфигурация для Telegram бота
///
/// Для получения токена бота и chat_id:
/// 1. Создайте бота через @BotFather в Telegram
/// 2. Получите токен бота
/// 3. Отправьте сообщение боту
/// 4. Получите chat_id через `https://api.telegram.org/bot<TOKEN>/getUpdates`
class TelegramConfig {
  /// Токен вашего Telegram бота (получить у @BotFather)
  /// Пример: '123456789:ABCdefGHIjklMNOpqrsTUVwxyz'
  static const String botToken =
      '8345942232:AAEipgNKS0yEC3qDkBBBQ-M7QN0oIqL8bZ8';

  /// ID чата, куда будут отправляться сообщения
  /// Пример: '123456789' (ваш личный chat_id)
  /// или '-100123456789' (chat_id группы)
  static const String chatId = '357670937';

  /// Включить/выключить отправку в Telegram
  /// Установите false для отключения отправки (например, во время разработки)
  static const bool enabled = true;

  /// Проверка корректности конфигурации
  static bool get isConfigured {
    return botToken != 'YOUR_BOT_TOKEN' &&
        chatId != 'YOUR_CHAT_ID' &&
        botToken.isNotEmpty &&
        chatId.isNotEmpty;
  }
}
