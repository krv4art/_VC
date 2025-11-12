/// Конфигурация для Telegram бота
/// Используется для отправки негативных отзывов
class TelegramConfig {
  /// Включена ли отправка в Telegram
  /// Установите false если не хотите получать уведомления
  static const bool enabled = false; // TODO: Set to true when configured

  /// Bot Token от @BotFather
  /// Получить можно здесь: https://t.me/BotFather
  static const String botToken = 'YOUR_BOT_TOKEN_HERE';

  /// Chat ID куда отправлять сообщения
  /// Можно получить от @userinfobot или @getidsbot
  static const String chatId = 'YOUR_CHAT_ID_HERE';

  /// Проверка, настроен ли Telegram
  static bool get isConfigured {
    return botToken != 'YOUR_BOT_TOKEN_HERE' &&
        chatId != 'YOUR_CHAT_ID_HERE' &&
        botToken.isNotEmpty &&
        chatId.isNotEmpty;
  }
}
