import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class NBackTestScreen extends StatefulWidget {
  const NBackTestScreen({super.key});

  @override
  State<NBackTestScreen> createState() => _NBackTestScreenState();
}

class _NBackTestScreenState extends State<NBackTestScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _nBack = 2; // Default to 2-back
  int _currentIndex = 0;
  List<String> _sequence = [];
  List<bool> _userResponses = [];
  List<bool> _correctResponses = [];
  String _currentItem = '';
  Timer? _timer;
  late DateTime _startTime;
  int _score = 0;

  final List<String> _items = ['🔴', '🔵', '🟢', '🟡', '🟣', '🟤', '⚫', '⚪'];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame(int nBack) {
    setState(() {
      _nBack = nBack;
      _isPlaying = true;
      _currentIndex = 0;
      _userResponses = [];
      _correctResponses = [];
      _score = 0;
      _startTime = DateTime.now();
      _generateSequence();
    });

    _showNextItem();
  }

  void _generateSequence() {
    final random = Random();
    _sequence = [];
    _correctResponses = [];

    // Generate 20 items
    for (int i = 0; i < 20; i++) {
      if (i >= _nBack && random.nextDouble() < 0.3) {
        // 30% chance to repeat n-back item
        _sequence.add(_sequence[i - _nBack]);
        _correctResponses.add(true);
      } else {
        String item;
        do {
          item = _items[random.nextInt(_items.length)];
        } while (i >= _nBack && item == _sequence[i - _nBack]);
        _sequence.add(item);
        _correctResponses.add(false);
      }
    }
  }

  void _showNextItem() {
    if (_currentIndex >= _sequence.length) {
      _endGame();
      return;
    }

    setState(() {
      _currentItem = _sequence[_currentIndex];
    });

    _timer = Timer(const Duration(milliseconds: 2500), () {
      if (_currentIndex < _userResponses.length) {
        // User didn't respond, count as "No"
        _userResponses.add(false);
      } else {
        _userResponses.add(false);
      }

      _currentIndex++;
      _showNextItem();
    });
  }

  void _respond(bool isMatch) {
    _timer?.cancel();
    _userResponses.add(isMatch);

    // Check if correct
    if (_currentIndex >= _nBack) {
      final expected = _correctResponses[_currentIndex];
      if (isMatch == expected) {
        _score += 10;
      }
    }

    _currentIndex++;
    _showNextItem();
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);

    // Calculate accuracy from responses where it matters (after n-back)
    int correctCount = 0;
    int totalRelevant = 0;

    for (int i = _nBack; i < _sequence.length && i < _userResponses.length; i++) {
      totalRelevant++;
      if (_userResponses[i] == _correctResponses[i]) {
        correctCount++;
      }
    }

    final accuracy = totalRelevant > 0 ? ((correctCount / totalRelevant) * 100).round() : 0;

    final result = ExerciseResult(
      exerciseType: ExerciseType.nBackTest,
      score: _score,
      maxScore: 200,
      duration: duration,
      accuracy: accuracy,
      difficulty: '$_nBack-back',
      details: {
        'nBack': _nBack,
        'correctCount': correctCount,
        'totalRelevant': totalRelevant,
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
        title: Text(_isRussian ? '🧠 Отлично!' : '🧠 Great!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRussian ? 'Ваш результат' : 'Your Score',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${result.accuracy}%',
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
            Text(
              _isRussian ? 'Уровень: $_nBack-back' : 'Level: $_nBack-back',
              style: const TextStyle(fontSize: 16),
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
              setState(() => _isPlaying = false);
            },
            child: Text(_isRussian ? 'Ещё раз' : 'Try Again'),
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
        title: Text(_isRussian ? 'N-Back тест' : 'N-Back Test'),
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
            const Text('🧠', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'N-Back тест' : 'N-Back Test',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Тренировка рабочей памяти. Нажимайте "Да", если текущий элемент совпадает с элементом N шагов назад.'
                  : 'Working memory training. Press "Yes" if current item matches the item N steps back.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Text(
              _isRussian ? 'Выберите сложность:' : 'Choose Difficulty:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _DifficultyButton(
              label: _isRussian ? '2-Back (Средне)' : '2-Back (Medium)',
              color: Colors.green,
              onPressed: () => _startGame(2),
            ),
            const SizedBox(height: 12),
            _DifficultyButton(
              label: _isRussian ? '3-Back (Сложно)' : '3-Back (Hard)',
              color: Colors.orange,
              onPressed: () => _startGame(3),
            ),
            const SizedBox(height: 12),
            _DifficultyButton(
              label: _isRussian ? '4-Back (Эксперт)' : '4-Back (Expert)',
              color: Colors.red,
              onPressed: () => _startGame(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isRussian ? '$_nBack-Back' : '$_nBack-Back',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          _isRussian
              ? 'Совпадает с $_nBack шагов назад?'
              : 'Matches $_nBack steps back?',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 40),
        Text(
          _currentItem,
          style: const TextStyle(fontSize: 100),
        ),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _respond(false),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                _isRussian ? 'НЕТ' : 'NO',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () => _respond(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              child: Text(
                _isRussian ? 'ДА' : 'YES',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _DifficultyButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
