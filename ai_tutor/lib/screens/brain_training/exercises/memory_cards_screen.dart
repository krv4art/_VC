import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class MemoryCardsScreen extends StatefulWidget {
  const MemoryCardsScreen({super.key});

  @override
  State<MemoryCardsScreen> createState() => _MemoryCardsScreenState();
}

class _MemoryCardsScreenState extends State<MemoryCardsScreen> {
  final List<String> _emojis = [
    '🍎', '🍌', '🍇', '🍊', '🍓', '🍒',
    '⚽', '🏀', '🎾', '🏈', '⚾', '🎱',
    '🐶', '🐱', '🐭', '🐹', '🐰', '🦊',
    '🚗', '🚕', '🚙', '🚌', '🚎', '🏎️',
  ];

  late bool _isRussian;
  bool _isPlaying = false;
  int _gridSize = 4; // 4x4, 6x6, or 8x8
  List<_CardData> _cards = [];
  int? _firstSelectedIndex;
  int? _secondSelectedIndex;
  bool _canTap = true;
  int _moves = 0;
  int _matchedPairs = 0;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isRussian = context.read<UserProfileProvider>().profile.preferredLanguage == 'ru';
    });
  }

  void _startGame(int gridSize) {
    setState(() {
      _gridSize = gridSize;
      _isPlaying = true;
      _moves = 0;
      _matchedPairs = 0;
      _firstSelectedIndex = null;
      _secondSelectedIndex = null;
      _canTap = true;
      _startTime = DateTime.now();
      _initializeCards();
    });
  }

  void _initializeCards() {
    final totalPairs = (_gridSize * _gridSize) ~/ 2;
    final selectedEmojis = (_emojis..shuffle()).take(totalPairs).toList();

    // Create pairs
    final allCards = <_CardData>[];
    for (int i = 0; i < selectedEmojis.length; i++) {
      allCards.add(_CardData(id: i, emoji: selectedEmojis[i]));
      allCards.add(_CardData(id: i, emoji: selectedEmojis[i]));
    }

    // Shuffle cards
    allCards.shuffle();
    _cards = allCards;
  }

  void _onCardTap(int index) {
    if (!_canTap || _cards[index].isMatched || _cards[index].isFlipped) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;

      if (_firstSelectedIndex == null) {
        _firstSelectedIndex = index;
      } else if (_secondSelectedIndex == null) {
        _secondSelectedIndex = index;
        _moves++;
        _canTap = false;

        // Check for match
        Timer(const Duration(milliseconds: 800), _checkMatch);
      }
    });
  }

  void _checkMatch() {
    if (_firstSelectedIndex == null || _secondSelectedIndex == null) return;

    final firstCard = _cards[_firstSelectedIndex!];
    final secondCard = _cards[_secondSelectedIndex!];

    if (firstCard.id == secondCard.id) {
      // Match found!
      setState(() {
        _cards[_firstSelectedIndex!].isMatched = true;
        _cards[_secondSelectedIndex!].isMatched = true;
        _matchedPairs++;
      });

      if (_matchedPairs == (_gridSize * _gridSize) ~/ 2) {
        _endGame();
      }
    } else {
      // No match, flip back
      setState(() {
        _cards[_firstSelectedIndex!].isFlipped = false;
        _cards[_secondSelectedIndex!].isFlipped = false;
      });
    }

    setState(() {
      _firstSelectedIndex = null;
      _secondSelectedIndex = null;
      _canTap = true;
    });
  }

  void _endGame() {
    final duration = DateTime.now().difference(_startTime);
    final totalPairs = (_gridSize * _gridSize) ~/ 2;

    // Calculate score: fewer moves = higher score
    final perfectMoves = totalPairs; // Minimum possible moves
    final efficiency = (perfectMoves / _moves * 100).clamp(0, 100);
    final score = (efficiency * 10).round();
    final accuracy = efficiency.round();

    final result = ExerciseResult(
      exerciseType: ExerciseType.memoryCards,
      score: score,
      maxScore: 1000,
      duration: duration,
      accuracy: accuracy,
      difficulty: '${_gridSize}x$_gridSize',
      details: {
        'gridSize': _gridSize,
        'moves': _moves,
        'perfectMoves': perfectMoves,
        'pairs': totalPairs,
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
        title: Text(_isRussian ? '🎉 Отлично!' : '🎉 Well Done!'),
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
              icon: '👆',
              label: _isRussian ? 'Ходов' : 'Moves',
              value: '${result.details['moves']}',
            ),
            _StatRow(
              icon: '🎯',
              label: _isRussian ? 'Эффективность' : 'Efficiency',
              value: '${result.accuracy}%',
            ),
            _StatRow(
              icon: '⏱️',
              label: _isRussian ? 'Время' : 'Time',
              value: '${result.duration.inSeconds}s',
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
        title: Text(_isRussian ? 'Карточки памяти' : 'Memory Cards'),
        actions: [
          if (_isPlaying)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _isRussian ? 'Ходы: $_moves' : 'Moves: $_moves',
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
            const Text('🃏', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Карточки памяти' : 'Memory Cards',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Найдите все пары одинаковых карточек!'
                  : 'Find all matching pairs of cards!',
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
              label: _isRussian ? 'Лёгкая (4×4)' : 'Easy (4×4)',
              subtitle: _isRussian ? '8 пар' : '8 pairs',
              color: Colors.green,
              onPressed: () => _startGame(4),
            ),
            const SizedBox(height: 12),
            _DifficultyButton(
              label: _isRussian ? 'Средняя (6×6)' : 'Medium (6×6)',
              subtitle: _isRussian ? '18 пар' : '18 pairs',
              color: Colors.orange,
              onPressed: () => _startGame(6),
            ),
            const SizedBox(height: 12),
            _DifficultyButton(
              label: _isRussian ? 'Сложная (8×8)' : 'Hard (8×8)',
              subtitle: _isRussian ? '32 пары' : '32 pairs',
              color: Colors.red,
              onPressed: () => _startGame(8),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _InfoChip(
                icon: '🎯',
                label: _isRussian ? 'Пары' : 'Pairs',
                value: '$_matchedPairs / ${(_gridSize * _gridSize) ~/ 2}',
              ),
              _InfoChip(
                icon: '👆',
                label: _isRussian ? 'Ходы' : 'Moves',
                value: '$_moves',
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _cards.length,
                  itemBuilder: (context, index) {
                    return _MemoryCard(
                      card: _cards[index],
                      onTap: () => _onCardTap(index),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardData {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;

  _CardData({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class _MemoryCard extends StatelessWidget {
  final _CardData card;
  final VoidCallback onTap;

  const _MemoryCard({
    required this.card,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: card.isMatched
              ? Colors.green[100]
              : card.isFlipped
                  ? Colors.white
                  : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: card.isMatched ? Colors.green : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (!card.isMatched)
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: card.isFlipped || card.isMatched
              ? Text(
                  card.emoji,
                  style: const TextStyle(fontSize: 32),
                )
              : const Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: 32,
                ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onPressed;

  const _DifficultyButton({
    required this.label,
    required this.subtitle,
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
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
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
