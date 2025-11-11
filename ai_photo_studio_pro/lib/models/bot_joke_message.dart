class BotJokeMessage {
  final String jokeText; // Текст шутки от AI
  final String botName; // Имя бота
  final DateTime timestamp; // Время создания

  BotJokeMessage({
    required this.jokeText,
    required this.botName,
    required this.timestamp,
  });
}
