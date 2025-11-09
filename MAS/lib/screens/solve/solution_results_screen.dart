import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/math_expression.dart';
import '../../models/math_solution.dart';
import '../../theme/app_theme.dart';
import '../../widgets/math/math_formula_widget.dart';
import '../../widgets/math/step_by_step_widget.dart';

/// Screen displaying the mathematical solution results
class SolutionResultsScreen extends StatefulWidget {
  final MathSolution solution;
  final String imagePath;

  const SolutionResultsScreen({
    super.key,
    required this.solution,
    required this.imagePath,
  });

  @override
  State<SolutionResultsScreen> createState() => _SolutionResultsScreenState();
}

class _SolutionResultsScreenState extends State<SolutionResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create 6 staggered animations for different sections
    _fadeAnimations = List.generate(6, (index) {
      final start = index * 0.08;
      final end = (start + 0.5).clamp(0.0, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(6, (index) {
      final start = index * 0.08;
      final end = (start + 0.5).clamp(0.0, 1.0);

      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text(
            'Решение задачи',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 0. Scanned image preview
                  _buildAnimatedSection(
                    index: 0,
                    child: _ImagePreviewCard(imagePath: widget.imagePath),
                  ),
                  const SizedBox(height: 16),

                  // 1. Problem statement
                  _buildAnimatedSection(
                    index: 1,
                    child: _ProblemCard(
                      problem: widget.solution.problem,
                      difficulty: widget.solution.difficulty,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 2. Step-by-step solution
                  _buildAnimatedSection(
                    index: 2,
                    child: StepByStepWidget(
                      steps: widget.solution.steps,
                      animateSteps: true,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Final answer card
                  _buildAnimatedSection(
                    index: 3,
                    child: _FinalAnswerCard(
                      answer: widget.solution.finalAnswer,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 4. Explanation card (if available)
                  if (widget.solution.explanation.isNotEmpty)
                    _buildAnimatedSection(
                      index: 4,
                      child: _ExplanationCard(
                        explanation: widget.solution.explanation,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // 5. Action buttons
                  _buildAnimatedSection(
                    index: 5,
                    child: _ActionButtons(
                      onSave: _handleSave,
                      onShare: _handleShare,
                      onTrySimilar: _handleTrySimilar,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSection({
    required int index,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Решение сохранено в историю'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleShare() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция "Поделиться" будет добавлена'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTrySimilar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Генерация похожих задач скоро будет доступна'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Image preview card showing the scanned photo
class _ImagePreviewCard extends StatelessWidget {
  final String imagePath;

  const _ImagePreviewCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(imagePath),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// Problem statement card
class _ProblemCard extends StatelessWidget {
  final MathExpression problem;
  final DifficultyLevel difficulty;

  const _ProblemCard({
    required this.problem,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Задача',
                  style: AppTheme.headingMedium,
                ),
                _DifficultyBadge(difficulty: difficulty),
              ],
            ),
            const SizedBox(height: 16),

            // Problem type
            Text(
              _getTypeLabel(problem.type),
              style: AppTheme.bodySmall.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),

            // LaTeX formula
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: MathFormulaWidget(
                  latex: problem.latexFormula,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(ExpressionType type) {
    switch (type) {
      case ExpressionType.equation:
        return 'Уравнение';
      case ExpressionType.inequality:
        return 'Неравенство';
      case ExpressionType.expression:
        return 'Выражение';
      case ExpressionType.system:
        return 'Система уравнений';
      case ExpressionType.derivative:
        return 'Производная';
      case ExpressionType.integral:
        return 'Интеграл';
      case ExpressionType.limit:
        return 'Предел';
      case ExpressionType.geometry:
        return 'Геометрия';
      case ExpressionType.wordProblem:
        return 'Текстовая задача';
      case ExpressionType.unknown:
        return 'Математика';
    }
  }
}

/// Difficulty badge
class _DifficultyBadge extends StatelessWidget {
  final DifficultyLevel difficulty;

  const _DifficultyBadge({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    final Color color = switch (difficulty) {
      DifficultyLevel.easy => Colors.green,
      DifficultyLevel.medium => Colors.orange,
      DifficultyLevel.hard => Colors.red,
    };

    final String label = switch (difficulty) {
      DifficultyLevel.easy => 'Легко',
      DifficultyLevel.medium => 'Средне',
      DifficultyLevel.hard => 'Сложно',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Final answer card with prominent display
class _FinalAnswerCard extends StatelessWidget {
  final String answer;

  const _FinalAnswerCard({required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Ответ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: MathFormulaWidget(
                    latex: answer,
                    fontSize: 26,
                    textColor: AppTheme.primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Explanation card
class _ExplanationCard extends StatelessWidget {
  final String explanation;

  const _ExplanationCard({required this.explanation});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryPurple,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Объяснение',
                  style: AppTheme.headingMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              explanation,
              style: AppTheme.bodyMedium.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Action buttons row
class _ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onTrySimilar;

  const _ActionButtons({
    required this.onSave,
    required this.onShare,
    required this.onTrySimilar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary action: Try similar problems
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: onTrySimilar,
            icon: const Icon(Icons.replay, size: 24),
            label: const Text(
              'Попробовать похожую задачу',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Secondary actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onSave,
                icon: const Icon(Icons.bookmark_border),
                label: const Text('Сохранить'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                  side: BorderSide(color: AppTheme.primaryPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share),
                label: const Text('Поделиться'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryPurple,
                  side: BorderSide(color: AppTheme.primaryPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
