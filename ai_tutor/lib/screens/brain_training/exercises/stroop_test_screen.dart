import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class StroopTestScreen extends StatefulWidget {
  const StroopTestScreen({super.key});

  @override
  State<StroopTestScreen> createState() => _StroopTestScreenState();
}

class _StroopTestScreenState extends State<StroopTestScreen> {
  final List<_ColorData> _colors = [
    _ColorData('RED', 'КРАСНЫЙ', Colors.red),
    _ColorData('BLUE', 'СИНИЙ', Colors.blue),
    _ColorData('GREEN', 'ЗЕЛЁНЫЙ', Colors.green),
    _ColorData('YELLOW', 'ЖЁЛТЫЙ', Colors.yellow[700]!),
    _ColorData('PURPLE', 'ФИОЛЕТОВЫЙ', Colors.purple),
    _ColorData('ORANGE', 'ОРАНЖЕВЫЙ', Colors.orange),
  ];

  late bool _isRussian;
  bool _isPlaying = false;
  int _currentRound = 0;
  int _totalRounds = 20;
  int _score = 0;
  int _correctAnswers = 0;
  late DateTime _startTime;
  late DateTime _roundStartTime;
  List<int> _responseTimes = [];

  _ColorData? _currentWord;
  Color? _currentColor;
  List<Color> _options = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isRussian = context.read<UserProfileProvider>().profile.preferredLanguage == 'ru';
    });
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _currentRound = 0;
      _score = 0;
      _correctAnswers = 0;
      _responseTimes = [];
      _startTime = DateTime.now();
    });
    _nextRound();
  }

  void _nextRound() {
    if (_currentRound >= _totalRounds) {
      _endGame();
      return;
    }

    setState(() {
      _currentRound++;
      final random = Random();

      // Pick a random word
      _currentWord = _colors[random.nextInt(_colors.length)];

      // Pick a random color (might be same as word, that's the point!)
      _currentColor = _colors[random.nextInt(_colors.length)].color;

      // Create options (4 random colors including the correct one)
      _options = [_currentColor!];
      while (_options.length < 4) {
        final option = _colors[random.nextInt(_colors.length)].color;
        if (!_options.contains(option)) {
          _options.add(option);
        }
      }
      _options.shuffle();

      _roundStartTime = DateTime.now();
    });
  }

  void _selectColor(Color selectedColor) {
    final responseTime = DateTime.now().difference(_roundStartTime).inMilliseconds;
    _responseTimes.add(responseTime);

    final isCorrect = selectedColor == _currentColor;
    if (isCorrect) {
      _correctAnswers++;
      // Faster responses get more points (max 100 points per question)
      final points = max(50, 100 - (responseTime ~/ 50));
      _score += points;
    }

    _nextRound();
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);
    final accuracy = ((_correctAnswers / _totalRounds) * 100).round();
    final averageResponseTime = _responseTimes.isEmpty
        ? 0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;

    final result = ExerciseResult(
      exerciseType: ExerciseType.stroopTest,
      score: _score,
      maxScore: _totalRounds * 100,
      duration: duration,
      accuracy: accuracy,
      details: {
        'correctAnswers': _correctAnswers,
        'totalRounds': _totalRounds,
        'averageResponseTime': averageResponseTime.round(),
      },
    );

    context.read<BrainTrainingProvider>().recordResult(result);

    _showResultDialog(result);
  }

  void _showResultDialog(ExerciseResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(_isRussian ? '🎉 Готово!' : '🎉 Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRussian ? 'Ваш результат' : 'Your Score',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${result.score}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Text(
              '${_isRussian ? "из" : "out of"} ${result.maxScore}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                result.stars,
                (index) => const Icon(Icons.star, color: Colors.amber, size: 32),
              ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: '🎯',
              label: _isRussian ? 'Точность' : 'Accuracy',
              value: '${result.accuracy}%',
            ),
            _StatRow(
              icon: '⏱️',
              label: _isRussian ? 'Среднее время' : 'Avg Time',
              value: '${result.details['averageResponseTime']}ms',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(_isRussian ? 'Назад' : 'Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: Text(_isRussian ? 'Ещё раз' : 'Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'Тест Струппа' : 'Stroop Test'),
        actions: [
          if (_isPlaying)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_currentRound / $_totalRounds',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: _isPlaying ? _buildGameView() : _buildStartView(),
    );
  }

  Widget _buildStartView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🎨',
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Тест Струппа' : 'Stroop Test',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Выберите цвет текста, а не то, что написано!'
                  : 'Select the color of the text, not the word itself!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isRussian ? '📋 Как играть:' : '📋 How to Play:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _InstructionItem(
                    number: '1',
                    text: _isRussian
                        ? 'Вы увидите название цвета'
                        : 'You will see a color name',
                  ),
                  _InstructionItem(
                    number: '2',
                    text: _isRussian
                        ? 'Текст будет написан другим цветом'
                        : 'The text will be in a different color',
                  ),
                  _InstructionItem(
                    number: '3',
                    text: _isRussian
                        ? 'Выберите ЦВЕТ текста, игнорируя слово'
                        : 'Choose the COLOR of the text, ignore the word',
                  ),
                  _InstructionItem(
                    number: '4',
                    text: _isRussian
                        ? 'Чем быстрее ответ, тем больше очков!'
                        : 'Faster responses earn more points!',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _startGame,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: Text(_isRussian ? 'Начать' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Score
          Text(
            _isRussian ? 'Очки: $_score' : 'Score: $_score',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),

          // The word in colored text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _isRussian ? _currentWord!.nameRu : _currentWord!.name,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: _currentColor,
              ),
            ),
          ),
          const SizedBox(height: 60),

          // Instructions
          Text(
            _isRussian ? 'Выберите цвет текста:' : 'Select the color of the text:',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // Color options
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: _options.map((color) {
              return InkWell(
                onTap: () => _selectColor(color),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ColorData {
  final String name;
  final String nameRu;
  final Color color;

  _ColorData(this.name, this.nameRu, this.color);
}

class _InstructionItem extends StatelessWidget {
  final String number;
  final String text;

  const _InstructionItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
