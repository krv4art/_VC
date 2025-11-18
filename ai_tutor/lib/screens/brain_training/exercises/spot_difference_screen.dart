import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class SpotDifferenceScreen extends StatefulWidget {
  const SpotDifferenceScreen({super.key});

  @override
  State<SpotDifferenceScreen> createState() => _SpotDifferenceScreenState();
}

class _SpotDifferenceScreenState extends State<SpotDifferenceScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _differencesCount = 5;
  List<int> _differences = [];
  Set<int> _foundDifferences = {};
  late DateTime _startTime;

  final List<String> _emojis = ['🍎', '🍌', '🍇', '🍊', '🍓', '⚽', '🏀', '🎾', '🐶', '🐱', '🐭', '🐹', '🚗', '🚕', '🚙', '🏠'];

  List<String> _leftGrid = [];
  List<String> _rightGrid = [];

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
      _foundDifferences = {};
      _startTime = DateTime.now();
      _generateGrids();
    });
  }

  void _generateGrids() {
    final random = Random();

    // Create a 6x6 grid (36 cells)
    _leftGrid = List.generate(36, (_) => _emojis[random.nextInt(_emojis.length)]);

    // Copy to right grid
    _rightGrid = List.from(_leftGrid);

    // Pick random positions for differences
    _differences = [];
    while (_differences.length < _differencesCount) {
      final pos = random.nextInt(36);
      if (!_differences.contains(pos)) {
        _differences.add(pos);
        // Change emoji at this position
        String newEmoji;
        do {
          newEmoji = _emojis[random.nextInt(_emojis.length)];
        } while (newEmoji == _rightGrid[pos]);
        _rightGrid[pos] = newEmoji;
      }
    }
  }

  void _onTap(int index) {
    if (_differences.contains(index) && !_foundDifferences.contains(index)) {
      setState(() {
        _foundDifferences.add(index);
      });

      if (_foundDifferences.length == _differencesCount) {
        _endGame();
      }
    }
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);
    final score = max(100, 1000 - (duration.inSeconds * 10));

    final result = ExerciseResult(
      exerciseType: ExerciseType.spotTheDifference,
      score: score,
      maxScore: 1000,
      duration: duration,
      accuracy: 100,
      details: {
        'differencesCount': _differencesCount,
        'timeSeconds': duration.inSeconds,
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
        title: Text(_isRussian ? '🔍 Отлично!' : '🔍 Excellent!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRussian ? 'Время' : 'Time',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${result.duration.inSeconds}s',
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
              _isRussian
                  ? 'Найдено: $_differencesCount отличий'
                  : 'Found: $_differencesCount differences',
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
        title: Text(_isRussian ? 'Найди отличия' : 'Spot the Difference'),
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
            const Text('🔍', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Найди отличия' : 'Spot the Difference',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Найдите все отличия между двумя картинками!'
                  : 'Find all differences between two grids!',
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
                        ? 'Сравните две сетки эмодзи'
                        : 'Compare two emoji grids',
                  ),
                  _InstructionItem(
                    number: '2',
                    text: _isRussian
                        ? 'Найдите все отличия'
                        : 'Find all differences',
                  ),
                  _InstructionItem(
                    number: '3',
                    text: _isRussian
                        ? 'Нажмите на отличия справа'
                        : 'Tap differences on the right',
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            _isRussian
                ? 'Найдено: ${_foundDifferences.length} / $_differencesCount'
                : 'Found: ${_foundDifferences.length} / $_differencesCount',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildGrid(_leftGrid, false),
              ),
              Container(
                width: 2,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildGrid(_rightGrid, true),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<String> grid, bool isInteractive) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: grid.length,
      itemBuilder: (context, index) {
        final isDifference = _differences.contains(index);
        final isFound = _foundDifferences.contains(index);

        return GestureDetector(
          onTap: isInteractive ? () => _onTap(index) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isFound
                  ? Colors.green[100]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFound ? Colors.green : Colors.grey[400]!,
                width: isFound ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                grid[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        );
      },
    );
  }
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
