import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/validation_result.dart';
import '../../theme/app_theme.dart';

/// Screen displaying validation results for checked solutions
class ValidationResultsScreen extends StatefulWidget {
  final ValidationResult validation;
  final String imagePath;

  const ValidationResultsScreen({
    super.key,
    required this.validation,
    required this.imagePath,
  });

  @override
  State<ValidationResultsScreen> createState() =>
      _ValidationResultsScreenState();
}

class _ValidationResultsScreenState extends State<ValidationResultsScreen>
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

    final sectionCount = 3 + widget.validation.stepValidations.length;

    _fadeAnimations = List.generate(sectionCount, (index) {
      final start = index * 0.06;
      final end = (start + 0.5).clamp(0.0, 1.0);

      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _slideAnimations = List.generate(sectionCount, (index) {
      final start = index * 0.06;
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
            'Результаты проверки',
            style: TextStyle(fontWeight: FontWeight.w600),
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
              int animIndex = 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image preview
                  _buildAnimatedSection(
                    index: animIndex++,
                    child: _ImagePreviewCard(imagePath: widget.imagePath),
                  ),
                  const SizedBox(height: 16),

                  // Overall result card
                  _buildAnimatedSection(
                    index: animIndex++,
                    child: _OverallResultCard(
                      isCorrect: widget.validation.isCorrect,
                      accuracy: widget.validation.accuracy,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Step validations
                  ...widget.validation.stepValidations.map((stepValidation) {
                    return Column(
                      children: [
                        _buildAnimatedSection(
                          index: animIndex++,
                          child: _StepValidationCard(
                            stepValidation: stepValidation,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    );
                  }),

                  const SizedBox(height: 12),

                  // Hints section
                  if (widget.validation.hints.isNotEmpty)
                    _buildAnimatedSection(
                      index: animIndex++,
                      child: _HintsCard(hints: widget.validation.hints),
                    ),

                  const SizedBox(height: 16),

                  // Final verdict
                  _buildAnimatedSection(
                    index: animIndex++,
                    child: _FinalVerdictCard(
                      verdict: widget.validation.finalVerdict,
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
    if (index >= _fadeAnimations.length) {
      return child;
    }

    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: child,
      ),
    );
  }
}

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

class _OverallResultCard extends StatelessWidget {
  final bool isCorrect;
  final double accuracy;

  const _OverallResultCard({
    required this.isCorrect,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? Colors.green : Colors.orange;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.shade400,
            color.shade600,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
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
              Icon(
                isCorrect ? Icons.check_circle : Icons.warning_amber,
                color: Colors.white,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                isCorrect ? 'Решение верное!' : 'Есть ошибки',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Точность: ${accuracy.toStringAsFixed(1)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepValidationCard extends StatelessWidget {
  final StepValidation stepValidation;

  const _StepValidationCard({required this.stepValidation});

  @override
  Widget build(BuildContext context) {
    final isCorrect = stepValidation.isCorrect;
    final borderColor = isCorrect ? Colors.green : Colors.red;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step number badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: Center(
                child: Text(
                  '${stepValidation.stepNumber}',
                  style: TextStyle(
                    color: borderColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Step details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isCorrect ? Icons.check_circle : Icons.cancel,
                        color: borderColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? 'Верно' : 'Ошибка',
                        style: TextStyle(
                          color: borderColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  if (stepValidation.errorType != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _getErrorTypeLabel(stepValidation.errorType!),
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],

                  if (stepValidation.hint != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.blue.shade200,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              stepValidation.hint!,
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getErrorTypeLabel(ErrorType type) {
    switch (type) {
      case ErrorType.arithmetic:
        return 'Арифметическая ошибка';
      case ErrorType.logical:
        return 'Логическая ошибка';
      case ErrorType.missingStep:
        return 'Пропущен шаг';
      case ErrorType.wrongMethod:
        return 'Неправильный метод';
      case ErrorType.signError:
        return 'Ошибка в знаке';
      case ErrorType.algebraic:
        return 'Алгебраическая ошибка';
      case ErrorType.unknown:
        return 'Неизвестная ошибка';
    }
  }
}

class _HintsCard extends StatelessWidget {
  final List<String> hints;

  const _HintsCard({required this.hints});

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
                  Icons.tips_and_updates,
                  color: Colors.amber.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Рекомендации',
                  style: AppTheme.headingMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...hints.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTheme.bodyMedium.copyWith(height: 1.6),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _FinalVerdictCard extends StatelessWidget {
  final String verdict;

  const _FinalVerdictCard({required this.verdict});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_turned_in,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Заключение',
                  style: AppTheme.headingMedium.copyWith(
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              verdict,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.6,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
