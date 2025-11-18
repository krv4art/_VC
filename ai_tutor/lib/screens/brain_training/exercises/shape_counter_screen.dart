import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

enum ShapeType { triangle, circle, square, star, diamond }

class ShapeCounterScreen extends StatefulWidget {
  const ShapeCounterScreen({super.key});

  @override
  State<ShapeCounterScreen> createState() => _ShapeCounterScreenState();
}

class _ShapeCounterScreenState extends State<ShapeCounterScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _currentRound = 0;
  int _totalRounds = 10;
  int _score = 0;
  int _correctAnswers = 0;
  late DateTime _startTime;

  List<_Shape> _shapes = [];
  ShapeType? _targetShape;
  int _correctCount = 0;
  int? _userAnswer;

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
      _userAnswer = null;
      _generateShapes();
    });
  }

  void _generateShapes() {
    final random = Random();
    _shapes = [];

    // Pick random target shape
    _targetShape = ShapeType.values[random.nextInt(ShapeType.values.length)];

    // Generate 15-30 shapes
    final totalShapes = 15 + random.nextInt(16);
    _correctCount = 0;

    // Ensure at least some target shapes exist
    final minTargetShapes = 3 + random.nextInt(5);

    for (int i = 0; i < totalShapes; i++) {
      ShapeType type;
      if (i < minTargetShapes) {
        type = _targetShape!;
      } else {
        type = ShapeType.values[random.nextInt(ShapeType.values.length)];
      }

      if (type == _targetShape) {
        _correctCount++;
      }

      // Try to place shape without overlap
      int attempts = 0;
      while (attempts < 50) {
        final size = 20.0 + random.nextDouble() * 30; // 20-50
        final left = random.nextDouble() * (350 - size);
        final top = random.nextDouble() * (400 - size);

        final newShape = _Shape(
          type: type,
          left: left,
          top: top,
          size: size,
          color: _getRandomColor(random),
        );

        // Check for overlap
        bool overlaps = false;
        for (var existing in _shapes) {
          if (_shapesOverlap(newShape, existing)) {
            overlaps = true;
            break;
          }
        }

        if (!overlaps) {
          _shapes.add(newShape);
          break;
        }

        attempts++;
      }
    }

    // Shuffle to mix target shapes with others
    _shapes.shuffle();
  }

  bool _shapesOverlap(_Shape a, _Shape b) {
    final padding = 5.0;
    return !(a.left + a.size + padding < b.left ||
        b.left + b.size + padding < a.left ||
        a.top + a.size + padding < b.top ||
        b.top + b.size + padding < a.top);
  }

  Color _getRandomColor(Random random) {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];
    return colors[random.nextInt(colors.length)];
  }

  void _submitAnswer(int answer) {
    final isCorrect = answer == _correctCount;

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
          isCorrect ? (_isRussian ? '✅ Правильно!' : '✅ Correct!') : (_isRussian ? '❌ Неправильно' : '❌ Incorrect'),
        ),
        content: Text(
          _isRussian
              ? 'Правильный ответ: $_correctCount'
              : 'Correct answer: $_correctCount',
          style: const TextStyle(fontSize: 18),
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
      exerciseType: ExerciseType.shapeCounter,
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

  String _getShapeName(ShapeType type) {
    if (_isRussian) {
      switch (type) {
        case ShapeType.triangle:
          return 'треугольников';
        case ShapeType.circle:
          return 'кругов';
        case ShapeType.square:
          return 'квадратов';
        case ShapeType.star:
          return 'звёзд';
        case ShapeType.diamond:
          return 'ромбов';
      }
    } else {
      switch (type) {
        case ShapeType.triangle:
          return 'triangles';
        case ShapeType.circle:
          return 'circles';
        case ShapeType.square:
          return 'squares';
        case ShapeType.star:
          return 'stars';
        case ShapeType.diamond:
          return 'diamonds';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'Подсчет фигур' : 'Shape Counter'),
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
            const Text('🔺', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Подсчет фигур' : 'Shape Counter',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Посчитайте определенные фигуры среди множества других!'
                  : 'Count specific shapes among many others!',
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
                        ? 'Вы увидите множество фигур'
                        : 'You will see many shapes',
                  ),
                  _InstructionItem(
                    number: '2',
                    text: _isRussian
                        ? 'Посчитайте фигуры указанного типа'
                        : 'Count the shapes of the specified type',
                  ),
                  _InstructionItem(
                    number: '3',
                    text: _isRussian
                        ? 'Введите количество'
                        : 'Enter the count',
                  ),
                  _InstructionItem(
                    number: '4',
                    text: _isRussian
                        ? 'Чем точнее, тем больше очков!'
                        : 'More accurate = more points!',
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
          child: Column(
            children: [
              Text(
                _isRussian ? 'Очки: $_score' : 'Score: $_score',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _isRussian
                    ? 'Сколько ${_getShapeName(_targetShape!)}?'
                    : 'How many ${_getShapeName(_targetShape!)}?',
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: _shapes
                  .map((shape) => Positioned(
                        left: shape.left,
                        top: shape.top,
                        child: _ShapeWidget(shape: shape),
                      ))
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: _isRussian ? 'Введите число' : 'Enter number',
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _userAnswer = int.tryParse(value);
                  },
                  onSubmitted: (value) {
                    final answer = int.tryParse(value);
                    if (answer != null) {
                      _submitAnswer(answer);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  if (_userAnswer != null) {
                    _submitAnswer(_userAnswer!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                ),
                child: Text(_isRussian ? 'Ответить' : 'Submit'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Shape {
  final ShapeType type;
  final double left;
  final double top;
  final double size;
  final Color color;

  _Shape({
    required this.type,
    required this.left,
    required this.top,
    required this.size,
    required this.color,
  });
}

class _ShapeWidget extends StatelessWidget {
  final _Shape shape;

  const _ShapeWidget({required this.shape});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: shape.size,
      height: shape.size,
      child: CustomPaint(
        painter: _ShapePainter(
          type: shape.type,
          color: shape.color,
        ),
      ),
    );
  }
}

class _ShapePainter extends CustomPainter {
  final ShapeType type;
  final Color color;

  _ShapePainter({required this.type, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (type) {
      case ShapeType.circle:
        canvas.drawCircle(
          Offset(size.width / 2, size.height / 2),
          size.width / 2,
          paint,
        );
        break;

      case ShapeType.square:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
        break;

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        break;

      case ShapeType.star:
        _drawStar(canvas, size, paint);
        break;

      case ShapeType.diamond:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(0, size.height / 2)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Size size, Paint paint) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.4;

    for (int i = 0; i < 10; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * pi / 5) - pi / 2;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
