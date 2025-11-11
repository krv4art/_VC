import 'package:flutter/material.dart';
import 'models/bot_joke_message.dart';
import 'widgets/bot_joke_popup.dart';

/// Тестовая страница для проверки BotJokePopup
class TestJokePopupScreen extends StatefulWidget {
  const TestJokePopupScreen({super.key});

  @override
  State<TestJokePopupScreen> createState() => _TestJokePopupScreenState();
}

class _TestJokePopupScreenState extends State<TestJokePopupScreen> {
  OverlayEntry? _jokeOverlay;

  void _showJoke() {
    final joke = BotJokeMessage(
      jokeText: '😂 Ваша пицца может стать отличным скрабом для лица! Просто добавьте оливковое масло! 🍕✨',
      botName: 'ACS Bot',
      timestamp: DateTime.now(),
    );

    _jokeOverlay = OverlayEntry(
      builder: (context) => BotJokePopup(
        message: joke,
        onDismiss: _dismissJoke,
      ),
    );

    Overlay.of(context).insert(_jokeOverlay!);
  }

  void _dismissJoke() {
    _jokeOverlay?.remove();
    _jokeOverlay = null;
  }

  @override
  void dispose() {
    _dismissJoke();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Joke Popup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _showJoke,
              child: const Text('Show Joke Popup'),
            ),
            const SizedBox(height: 20),
            const Text('Вы должны видеть экран и кнопку'),
            const Text('Серого фона быть НЕ должно'),
          ],
        ),
      ),
    );
  }
}
