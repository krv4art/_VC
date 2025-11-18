import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/subject.dart';
import '../../models/practice_problem.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../services/practice_service.dart';

class PracticeScreen extends StatefulWidget {
  final String subjectId;

  const PracticeScreen({super.key, required this.subjectId});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  List<PracticeProblem> _problems = [];
  int _currentProblemIndex = 0;
  bool _isLoading = false;
  int _hintsShown = 0;
  final TextEditingController _answerController = TextEditingController();
  bool? _isCorrect;
  String? _feedback;

  @override
  void initState() {
    super.initState();
    _generateProblems();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _generateProblems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileProvider = context.read<UserProfileProvider>();
      final practiceService = PracticeService(
        supabase: context.read(),
      );

      final subject = Subjects.getById(widget.subjectId);
      if (subject == null) return;

      final problems = await practiceService.generateProblems(
        subjectId: widget.subjectId,
        topic: subject.topics.first,
        difficulty: 5,
        userProfile: profileProvider.profile,
        count: 5,
      );

      setState(() {
        _problems = problems;
        _currentProblemIndex = 0;
        _hintsShown = 0;
        _isCorrect = null;
        _feedback = null;
        _answerController.clear();
      });
    } catch (e) {
      debugPrint('Error generating problems: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showHint() {
    if (_currentProblem.hints.isEmpty) return;
    if (_hintsShown >= _currentProblem.hints.length) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hint ${_hintsShown + 1}'),
        content: Text(_currentProblem.hints[_hintsShown]),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _hintsShown++;
              });
            },
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAnswer() async {
    if (_answerController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an answer')),
      );
      return;
    }

    final practiceService = PracticeService(supabase: context.read());
    final result = await practiceService.checkAnswer(
      problem: _currentProblem,
      userAnswer: _answerController.text,
    );

    setState(() {
      _isCorrect = result['is_correct'];
      _feedback = result['feedback'];
    });

    // Record progress
    final profileProvider = context.read<UserProfileProvider>();
    final progressProvider = context.read<ProgressProvider>();
    final achievementProvider = context.read<AchievementProvider>();

    await progressProvider.recordProblemAttempt(
      userId: profileProvider.profile.userId ?? '',
      subjectId: widget.subjectId,
      isCorrect: _isCorrect!,
      topic: _currentProblem.topic,
      usedHint: _hintsShown > 0,
    );

    // Check achievements
    final progress = progressProvider.getProgress(
      profileProvider.profile.userId ?? '',
      widget.subjectId,
    );
    final newAchievements = await achievementProvider.checkAchievements(progress);

    // Show achievement notifications
    if (newAchievements.isNotEmpty && mounted) {
      for (final achievement in newAchievements) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Text(achievement.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Achievement Unlocked!',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(achievement.name),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.amber,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _nextProblem() {
    if (_currentProblemIndex < _problems.length - 1) {
      setState(() {
        _currentProblemIndex++;
        _hintsShown = 0;
        _isCorrect = null;
        _feedback = null;
        _answerController.clear();
      });
    } else {
      // Show completion dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Practice Complete! 🎉'),
          content: const Text('Great job! Would you like to practice more?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _generateProblems();
              },
              child: const Text('More Practice'),
            ),
          ],
        ),
      );
    }
  }

  PracticeProblem get _currentProblem => _problems[_currentProblemIndex];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subject = Subjects.getById(widget.subjectId);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${subject?.emoji ?? ''} Practice'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_problems.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${subject?.emoji ?? ''} Practice'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('Failed to generate problems'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _generateProblems,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${subject?.emoji ?? ''} Practice'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${_currentProblemIndex + 1}/${_problems.length}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Difficulty indicator
              Row(
                children: [
                  Text(
                    'Difficulty: ',
                    style: theme.textTheme.bodyMedium,
                  ),
                  ...List.generate(
                    10,
                    (index) => Icon(
                      index < _currentProblem.difficulty
                          ? Icons.star
                          : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Problem
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    _currentProblem.problem,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Answer input
              TextField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Your Answer',
                  hintText: 'Enter your answer here...',
                  enabled: _isCorrect == null,
                ),
                onSubmitted: (_) => _checkAnswer(),
              ),
              const SizedBox(height: 16),

              // Feedback
              if (_feedback != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCorrect!
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect! ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Text(
                    _feedback!,
                    style: TextStyle(
                      color: _isCorrect! ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              const Spacer(),

              // Actions
              if (_isCorrect == null) ...[
                if (_currentProblem.hints.isNotEmpty &&
                    _hintsShown < _currentProblem.hints.length)
                  OutlinedButton.icon(
                    onPressed: _showHint,
                    icon: const Icon(Icons.lightbulb_outline),
                    label: Text('Hint (${_hintsShown}/${_currentProblem.hints.length} used)'),
                  ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _checkAnswer,
                  child: const Text('Check Answer'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: _nextProblem,
                  child: Text(_currentProblemIndex < _problems.length - 1
                      ? 'Next Problem'
                      : 'Finish'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
