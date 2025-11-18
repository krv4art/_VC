import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../models/brain_training/exercise_type.dart';
import '../../../models/brain_training/exercise_result.dart';
import '../../../providers/brain_training_provider.dart';
import '../../../providers/user_profile_provider.dart';

class SpeedReadingScreen extends StatefulWidget {
  const SpeedReadingScreen({super.key});

  @override
  State<SpeedReadingScreen> createState() => _SpeedReadingScreenState();
}

class _SpeedReadingScreenState extends State<SpeedReadingScreen> {
  late bool _isRussian;
  bool _isPlaying = false;
  int _speed = 250; // words per minute
  bool _useCurtain = true; // true = curtain, false = auto-scroll
  double _curtainPosition = 0.0;
  ScrollController _scrollController = ScrollController();
  Timer? _timer;
  late DateTime _startTime;
  String _selectedText = '';
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;

  final Map<String, List<Map<String, dynamic>>> _texts = {
    'en_easy': [
      {
        'title': 'The Solar System',
        'text':
            'The Solar System is the gravitationally bound system of the Sun and the objects that orbit it. The largest of such objects are the eight planets, in order from the Sun: Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, and Neptune. The four inner planets are rocky, while the four outer planets are gas giants. Between Mars and Jupiter is the asteroid belt, which contains thousands of rocky bodies.',
        'questions': [
          {
            'question': 'How many planets are in the Solar System?',
            'options': ['6', '7', '8', '9'],
            'correct': 2,
          },
          {
            'question': 'What are the outer planets made of?',
            'options': ['Rock', 'Gas', 'Ice', 'Metal'],
            'correct': 1,
          },
          {
            'question': 'What is located between Mars and Jupiter?',
            'options': ['Moon', 'Asteroid belt', 'Comet', 'Star'],
            'correct': 1,
          },
        ],
      },
    ],
    'ru_easy': [
      {
        'title': 'Солнечная система',
        'text':
            'Солнечная система - это гравитационно связанная система Солнца и объектов, которые вращаются вокруг него. Крупнейшими из таких объектов являются восемь планет по порядку от Солнца: Меркурий, Венера, Земля, Марс, Юпитер, Сатурн, Уран и Нептун. Четыре внутренние планеты каменистые, а четыре внешние планеты - газовые гиганты. Между Марсом и Юпитером находится пояс астероидов, который содержит тысячи каменных тел.',
        'questions': [
          {
            'question': 'Сколько планет в Солнечной системе?',
            'options': ['6', '7', '8', '9'],
            'correct': 2,
          },
          {
            'question': 'Из чего состоят внешние планеты?',
            'options': ['Камень', 'Газ', 'Лёд', 'Металл'],
            'correct': 1,
          },
          {
            'question': 'Что находится между Марсом и Юпитером?',
            'options': ['Луна', 'Пояс астероидов', 'Комета', 'Звезда'],
            'correct': 1,
          },
        ],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isRussian = context.read<UserProfileProvider>().profile.preferredLanguage == 'ru';
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startReading(int speed, bool useCurtain) {
    setState(() {
      _speed = speed;
      _useCurtain = useCurtain;
      _isPlaying = true;
      _curtainPosition = 0.0;
      _startTime = DateTime.now();
      _currentQuestionIndex = 0;
      _correctAnswers = 0;

      // Select text based on language
      final textKey = _isRussian ? 'ru_easy' : 'en_easy';
      final textData = _texts[textKey]![0];
      _selectedText = textData['text'] as String;
      _questions = List<Map<String, dynamic>>.from(textData['questions'] as List);
    });

    _scrollController = ScrollController();

    // Start animation
    final wordsInText = _selectedText.split(' ').length;
    final readingTimeSeconds = (wordsInText / _speed * 60).round();

    if (_useCurtain) {
      _startCurtainAnimation(readingTimeSeconds);
    } else {
      _startScrollAnimation(readingTimeSeconds);
    }
  }

  void _startCurtainAnimation(int durationSeconds) {
    const updateInterval = Duration(milliseconds: 50);
    final totalSteps = durationSeconds * 20; // 20 steps per second
    int currentStep = 0;

    _timer = Timer.periodic(updateInterval, (timer) {
      if (currentStep >= totalSteps) {
        timer.cancel();
        _showQuestions();
        return;
      }

      setState(() {
        _curtainPosition = (currentStep / totalSteps);
        currentStep++;
      });
    });
  }

  void _startScrollAnimation(int durationSeconds) {
    const updateInterval = Duration(milliseconds: 50);
    final totalSteps = durationSeconds * 20;
    int currentStep = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxScroll = _scrollController.position.maxScrollExtent;

      _timer = Timer.periodic(updateInterval, (timer) {
        if (currentStep >= totalSteps || !_scrollController.hasClients) {
          timer.cancel();
          _showQuestions();
          return;
        }

        final targetPosition = (currentStep / totalSteps) * maxScroll;
        _scrollController.jumpTo(targetPosition);
        currentStep++;
      });
    });
  }

  void _showQuestions() {
    // Stop animations
    setState(() {});
  }

  void _answerQuestion(int selectedOption) {
    final isCorrect =
        _questions[_currentQuestionIndex]['correct'] == selectedOption;
    if (isCorrect) {
      _correctAnswers++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _endExercise();
    }
  }

  void _endExercise() {
    final duration = DateTime.now().difference(_startTime);
    final accuracy = ((_correctAnswers / _questions.length) * 100).round();
    final score = (_correctAnswers * 100 / _questions.length * 10).round();

    final result = ExerciseResult(
      exerciseType: ExerciseType.speedReading,
      score: score,
      maxScore: 1000,
      duration: duration,
      accuracy: accuracy,
      details: {
        'speed': _speed,
        'mode': _useCurtain ? 'curtain' : 'scroll',
        'correctAnswers': _correctAnswers,
        'totalQuestions': _questions.length,
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
        title: Text(_isRussian ? '📖 Готово!' : '📖 Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isRussian ? 'Понимание текста' : 'Text Comprehension',
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
            _StatRow(
              icon: '✅',
              label: _isRussian ? 'Правильных' : 'Correct',
              value: '$_correctAnswers / ${_questions.length}',
            ),
            _StatRow(
              icon: '⚡',
              label: _isRussian ? 'Скорость' : 'Speed',
              value: '$_speed ${_isRussian ? "сл/мин" : "wpm"}',
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
        title: Text(_isRussian ? 'Скоростное чтение' : 'Speed Reading'),
      ),
      body: _isPlaying ? _buildReadingView() : _buildStartView(),
    );
  }

  Widget _buildStartView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📖', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              _isRussian ? 'Скоростное чтение' : 'Speed Reading',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              _isRussian
                  ? 'Тренируйте скорость чтения и понимание текста!'
                  : 'Train your reading speed and comprehension!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            Text(
              _isRussian ? 'Режим:' : 'Mode:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: true,
                  label: Text(_isRussian ? 'Шторка' : 'Curtain'),
                  icon: const Icon(Icons.window),
                ),
                ButtonSegment(
                  value: false,
                  label: Text(_isRussian ? 'Скролл' : 'Scroll'),
                  icon: const Icon(Icons.arrow_downward),
                ),
              ],
              selected: {_useCurtain},
              onSelectionChanged: (Set<bool> selection) {
                setState(() {
                  _useCurtain = selection.first;
                });
              },
            ),
            const SizedBox(height: 32),
            Text(
              _isRussian ? 'Скорость чтения:' : 'Reading Speed:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _SpeedButton(
              label: _isRussian ? 'Медленно (200 сл/мин)' : 'Slow (200 wpm)',
              speed: 200,
              color: Colors.green,
              onPressed: () => _startReading(200, _useCurtain),
            ),
            const SizedBox(height: 12),
            _SpeedButton(
              label: _isRussian ? 'Средне (300 сл/мин)' : 'Medium (300 wpm)',
              speed: 300,
              color: Colors.orange,
              onPressed: () => _startReading(300, _useCurtain),
            ),
            const SizedBox(height: 12),
            _SpeedButton(
              label: _isRussian ? 'Быстро (400 сл/мин)' : 'Fast (400 wpm)',
              speed: 400,
              color: Colors.red,
              onPressed: () => _startReading(400, _useCurtain),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingView() {
    if (_curtainPosition >= 1.0 || (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent)) {
      return _buildQuestionView();
    }

    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(24),
          child: Text(
            _selectedText,
            style: const TextStyle(fontSize: 20, height: 1.8),
          ),
        ),
        if (_useCurtain)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * _curtainPosition,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionView() {
    final question = _questions[_currentQuestionIndex];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _isRussian ? 'Вопрос ${_currentQuestionIndex + 1} из ${_questions.length}' : 'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            question['question'] as String,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ...(question['options'] as List<String>).asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ElevatedButton(
                onPressed: () => _answerQuestion(entry.key),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  final String label;
  final int speed;
  final Color color;
  final VoidCallback onPressed;

  const _SpeedButton({
    required this.label,
    required this.speed,
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
