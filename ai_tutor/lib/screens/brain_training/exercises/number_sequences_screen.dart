import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class NumberSequencesScreen extends StatefulWidget {
  const NumberSequencesScreen({super.key});

  @override
  State<NumberSequencesScreen> createState() => _NumberSequencesScreenState();
}

class _NumberSequencesScreenState extends State<NumberSequencesScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _currentRound = 0;
  int _totalRounds = 10;
  int _score = 0;
  int _correctAnswers = 0;
  late DateTime _startTime;

  List<int> _sequence = [];
  int _correctAnswer = 0;
  List<int> _options = [];
  String _pattern = '';

  final List<String> _patternTypes = [
    '+n', // Add constant
    '*n', // Multiply by constant
    '+1,+2,+3...', // Increasing additions
    'x2', // Double each time
    'fibonacci', // Fibonacci sequence
    'squares', // Square numbers
  ];

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
      _generateSequence();
    });
  }

  void _generateSequence() {
    final random = Random();
    final patternType = _patternTypes[random.nextInt(_patternTypes.length)];

    switch (patternType) {
      case '+n':
        _generateAdditionSequence(random);
        break;
      case '*n':
        _generateMultiplicationSequence(random);
        break;
      case '+1,+2,+3...':
        _generateIncreasingAdditionSequence(random);
        break;
      case 'x2':
        _generateDoublingSequence(random);
        break;
      case 'fibonacci':
        _generateFibonacciSequence(random);
        break;
      case 'squares':
        _generateSquaresSequence(random);
        break;
    }

    _generateOptions();
  }

  void _generateAdditionSequence(Random random) {
    final start = random.nextInt(10) + 1;
    final step = random.nextInt(9) + 2;
    _sequence = List.generate(5, (i) => start + (i * step));
    _correctAnswer = start + (5 * step);
    _pattern = _isRussian ? 'Добавление +$step' : 'Add +$step';
  }

  void _generateMultiplicationSequence(Random random) {
    final start = random.nextInt(3) + 2;
    final multiplier = random.nextInt(2) + 2;
    _sequence = List.generate(5, (i) => start * pow(multiplier, i).toInt());
    _correctAnswer = start * pow(multiplier, 5).toInt();
    _pattern = _isRussian ? 'Умножение ×$multiplier' : 'Multiply ×$multiplier';
  }

  void _generateIncreasingAdditionSequence(Random random) {
    final start = random.nextInt(10) + 1;
    _sequence = [start];
    for (int i = 1; i <= 4; i++) {
      _sequence.add(_sequence.last + i);
    }
    _correctAnswer = _sequence.last + 5;
    _pattern = _isRussian ? '+1, +2, +3...' : '+1, +2, +3...';
  }

  void _generateDoublingSequence(Random random) {
    final start = random.nextInt(3) + 1;
    _sequence = List.generate(5, (i) => start * pow(2, i).toInt());
    _correctAnswer = start * pow(2, 5).toInt();
    _pattern = _isRussian ? 'Удвоение (×2)' : 'Doubling (×2)';
  }

  void _generateFibonacciSequence(Random random) {
    final offset = random.nextInt(5);
    _sequence = [offset, offset + 1];
    for (int i = 2; i < 5; i++) {
      _sequence.add(_sequence[i - 1] + _sequence[i - 2]);
    }
    _correctAnswer = _sequence[4] + _sequence[3];
    _pattern = _isRussian ? 'Фибоначчи' : 'Fibonacci';
  }

  void _generateSquaresSequence(Random random) {
    final start = random.nextInt(3) + 1;
    _sequence = List.generate(5, (i) => pow(start + i, 2).toInt());
    _correctAnswer = pow(start + 5, 2).toInt();
    _pattern = _isRussian ? 'Квадраты чисел' : 'Square numbers';
  }

  void _generateOptions() {
    _options = [_correctAnswer];

    final random = Random();
    while (_options.length < 4) {
      int option;
      if (_correctAnswer < 100) {
        option = _correctAnswer + random.nextInt(20) - 10;
      } else {
        option = _correctAnswer + random.nextInt(40) - 20;
      }

      if (option > 0 && !_options.contains(option)) {
        _options.add(option);
      }
    }

    _options.shuffle();
  }

  void _selectAnswer(int answer) {
    final isCorrect = answer == _correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
      _score += 100;
    }

    _showFeedback(isCorrect);
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          isCorrect
              ? (_isRussian ? '✅ Правильно!' : '✅ Correct!')
              : (_isRussian ? '❌ Неправильно' : '❌ Incorrect'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRussian ? 'Правильный ответ:' : 'Correct answer:',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              '$_correctAnswer',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _isRussian ? 'Закономерность:' : 'Pattern:',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              _pattern,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _nextRound();
            },
            child: Text(_isRussian ? 'Дальше' : 'Next'),
          ),
        ],
      ),
    );
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);
    final accuracy = ((_correctAnswers / _totalRounds) * 100).round();

    final result = ExerciseResult(
      exerciseType: ExerciseType.numberSequences,
      score: _score,
      maxScore: _totalRounds * 100,
      duration: duration,
      accuracy: accuracy,
      details: {
        'correctAnswers': _correctAnswers,
        'totalRounds': _totalRounds,
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
              icon: '✅',
              label: _isRussian ? 'Правильных' : 'Correct',
              value: '$_correctAnswers / $_totalRounds',
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
        title: Text(_isRussian ? 'Числовые последовательности' : 'Number Sequences'),
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
            const Text('🔢', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Числовые последовательности' : 'Number Sequences',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Найдите закономерность и продолжите последовательность!'
                  : 'Find the pattern and complete the sequence!',
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
                    _isRussian ? '📋 Типы закономерностей:' : '📋 Pattern Types:',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _PatternExample(text: _isRussian ? '➕ Сложение' : '➕ Addition'),
                  _PatternExample(text: _isRussian ? '✖️ Умножение' : '✖️ Multiplication'),
                  _PatternExample(text: _isRussian ? '📈 Прогрессии' : '📈 Progressions'),
                  _PatternExample(text: _isRussian ? '🔢 Фибоначчи' : '🔢 Fibonacci'),
                  _PatternExample(text: _isRussian ? '²  Квадраты' : '²  Squares'),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isRussian ? 'Очки: $_score' : 'Score: $_score',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text(
              _isRussian ? 'Найдите следующее число:' : 'Find the next number:',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            // Show sequence
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              children: [
                ..._sequence.map((num) => _NumberBox(number: num.toString())),
                _NumberBox(number: '?', isQuestion: true),
              ],
            ),
            const SizedBox(height: 48),
            // Options
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: _options.map((option) {
                return ElevatedButton(
                  onPressed: () => _selectAnswer(option),
                  style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  child: Text('$option'),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberBox extends StatelessWidget {
  final String number;
  final bool isQuestion;

  const _NumberBox({
    required this.number,
    this.isQuestion = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: isQuestion ? Colors.orange[100] : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isQuestion ? Colors.orange : Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isQuestion ? Colors.orange[700] : Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class _PatternExample extends StatelessWidget {
  final String text;

  const _PatternExample({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
          const SizedBox(width: 8),
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
