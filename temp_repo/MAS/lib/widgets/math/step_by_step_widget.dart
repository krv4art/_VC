import 'package:flutter/material.dart';
import '../../models/solution_step.dart';
import '../../theme/app_theme.dart';
import 'math_formula_widget.dart';

/// Виджет для отображения пошагового решения задачи
class StepByStepWidget extends StatefulWidget {
  final List<SolutionStep> steps;
  final bool animateSteps;
  final Duration animationDelay;

  const StepByStepWidget({
    super.key,
    required this.steps,
    this.animateSteps = true,
    this.animationDelay = const Duration(milliseconds: 300),
  });

  @override
  State<StepByStepWidget> createState() => _StepByStepWidgetState();
}

class _StepByStepWidgetState extends State<StepByStepWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    if (widget.animateSteps) {
      _initializeAnimations();
      _startAnimations();
    }
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.steps.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 500),
        vsync: this,
      ),
    );

    _fadeAnimations = _controllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();

    _slideAnimations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, 0.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOut),
      );
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.animationDelay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.animateSteps) {
      for (var controller in _controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.steps.length,
      itemBuilder: (context, index) {
        final step = widget.steps[index];

        final stepCard = _StepCard(
          step: step,
          stepNumber: index + 1,
        );

        if (!widget.animateSteps) {
          return stepCard;
        }

        return FadeTransition(
          opacity: _fadeAnimations[index],
          child: SlideTransition(
            position: _slideAnimations[index],
            child: stepCard,
          ),
        );
      },
    );
  }
}

/// Карточка одного шага решения
class _StepCard extends StatefulWidget {
  final SolutionStep step;
  final int stepNumber;

  const _StepCard({
    required this.step,
    required this.stepNumber,
  });

  @override
  State<_StepCard> createState() => _StepCardState();
}

class _StepCardState extends State<_StepCard> {
  bool _isExpanded = true; // По умолчанию развёрнуто

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTheme.primaryPurple,
                width: 4,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with step number and description
              InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Step number badge
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${widget.stepNumber}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Description
                      Expanded(
                        child: Text(
                          widget.step.description,
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Expand/collapse icon
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppTheme.primaryPurple,
                      ),
                    ],
                  ),
                ),
              ),

              // Expandable content
              if (_isExpanded) ...[
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Formula
                      if (widget.step.formula.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MathFormulaWidget(
                            latex: widget.step.formula,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Explanation
                      if (widget.step.explanation.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 20,
                              color: AppTheme.warningOrange,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.step.explanation,
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Colors.grey[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
