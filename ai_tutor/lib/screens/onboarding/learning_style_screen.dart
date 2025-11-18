import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';

class LearningStyleScreen extends StatefulWidget {
  const LearningStyleScreen({super.key});

  @override
  State<LearningStyleScreen> createState() => _LearningStyleScreenState();
}

class _LearningStyleScreenState extends State<LearningStyleScreen> {
  LearningStyle _selectedStyle = LearningStyle.balanced;

  @override
  void initState() {
    super.initState();
    // Load existing selection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProfileProvider>();
      setState(() {
        _selectedStyle = provider.profile.learningStyle;
      });
    });
  }

  Future<void> _continue() async {
    final provider = context.read<UserProfileProvider>();
    await provider.updateLearningStyle(_selectedStyle);

    if (mounted) {
      context.go('/onboarding/level');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Style'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/theme'),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    'How do you learn best?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'I\'ll adapt my teaching style to match your preference',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Learning styles
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: LearningStyle.values.map((style) {
                  final isSelected = _selectedStyle == style;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _StyleCard(
                      style: style,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedStyle = style;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _continue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final LearningStyle style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleCard({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  String _getDescription(LearningStyle style) {
    switch (style) {
      case LearningStyle.visual:
        return 'I learn best with charts, diagrams, and visual representations';
      case LearningStyle.practical:
        return 'I learn best by doing - give me lots of examples and practice';
      case LearningStyle.theoretical:
        return 'I love detailed explanations and understanding the "why"';
      case LearningStyle.balanced:
        return 'I like a mix of everything - theory, visuals, and practice';
      case LearningStyle.quick:
        return 'Keep it short and concise - I learn fast';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.15)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Emoji
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withOpacity(0.2)
                    : colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                style.emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style.displayName.split(' (')[0],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? colorScheme.primary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getDescription(style),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onBackground.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Radio button
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: colorScheme.primary,
                size: 28,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: colorScheme.outline,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
