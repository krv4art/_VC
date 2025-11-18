import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class QuickMathScreen extends StatefulWidget {
  const QuickMathScreen({super.key});

  @override
  State<QuickMathScreen> createState() => _QuickMathScreenState();
}

class _QuickMathScreenState extends State<QuickMathScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _currentRound = 0;
  int _totalRounds = 20;
  int _score = 0;
  int _correctAnswers = 0;
  late DateTime _startTime;
  late DateTime _roundStartTime;
  List<int> _responseTimes = [];

  String _problem = '';
  int _correctAnswer = 0;
  List<int> _options = [];

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
      _generateProblem();
      _roundStartTime = DateTime.now();
    });
  }

  void _generateProblem() {
    final random = Random();
    final operation = random.nextInt(4); // 0: +, 1: -, 2: *, 3: /

    int a, b;
    String op;

    switch (operation) {
      case 0: // Addition
        a = random.nextInt(50) + 1;
        b = random.nextInt(50) + 1;
        op = '+';
        _correctAnswer = a + b;
        break;
      case 1: // Subtraction
        a = random.nextInt(50) + 20;
        b = random.nextInt(a);
        op = '-';
        _correctAnswer = a - b;
        break;
      case 2: // Multiplication
        a = random.nextInt(12) + 1;
        b = random.nextInt(12) + 1;
        op = '×';
        _correctAnswer = a * b;
        break;
      case 3: // Division
        b = random.nextInt(11) + 2;
        _correctAnswer = random.nextInt(12) + 1;
        a = b * _correctAnswer;
        op = '÷';
        break;
      default:
        a = 1;
        b = 1;
        op = '+';
        _correctAnswer = 2;
    }

    _problem = '$a $op $b';
    _generateOptions();
  }

  void _generateOptions() {
    _options = [_correctAnswer];
    final random = Random();

    while (_options.length < 4) {
      int option = _correctAnswer + random.nextInt(10) - 5;
      if (option > 0 && !_options.contains(option)) {
        _options.add(option);
      }
    }

    _options.shuffle();
  }

  void _selectAnswer(int answer) {
    final responseTime = DateTime.now().difference(_roundStartTime).inMilliseconds;
    _responseTimes.add(responseTime);

    final isCorrect = answer == _correctAnswer;
    if (isCorrect) {
      _correctAnswers++;
      final points = max(5, 10 - (responseTime ~/ 1000));
      _score += points * 10;
    }

    _nextRound();
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);
    final accuracy = ((_correctAnswers / _totalRounds) * 100).round();
    final averageTime = _responseTimes.isEmpty
        ? 0
        : _responseTimes.reduce((a, b) => a + b) / _responseTimes.length;

    final result = ExerciseResult(
      exerciseType: ExerciseType.quickMath,
      score: _score,
      maxScore: _totalRounds * 100,
      duration: duration,
      accuracy: accuracy,
      details: {
        'correctAnswers': _correctAnswers,
        'totalRounds': _totalRounds,
        'averageTime': averageTime.round(),
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
        title: Text(_isRussian ? '➕ Готово!' : '➕ Complete!'),
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
              value: '${result.details['averageTime']}ms',
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
        title: Text(_isRussian ? 'Быстрый счет' : 'Quick Math'),
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
            const Text('➕', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Быстрый счет' : 'Quick Math',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Решайте математические задачи как можно быстрее!'
                  : 'Solve math problems as fast as you can!',
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
                    _isRussian ? '📋 Операции:' : '📋 Operations:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _OperationItem(icon: '➕', text: _isRussian ? 'Сложение' : 'Addition'),
                  _OperationItem(icon: '➖', text: _isRussian ? 'Вычитание' : 'Subtraction'),
                  _OperationItem(icon: '✖️', text: _isRussian ? 'Умножение' : 'Multiplication'),
                  _OperationItem(icon: '➗', text: _isRussian ? 'Деление' : 'Division'),
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
          Text(
            _isRussian ? 'Очки: $_score' : 'Score: $_score',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 60),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _problem,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: _options.map((option) {
                return ElevatedButton(
                  onPressed: () => _selectAnswer(option),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  child: Text('$option'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationItem extends StatelessWidget {
  final String icon;
  final String text;

  const _OperationItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Text(text),
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
