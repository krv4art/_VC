import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/subject.dart';
import '../../models/user_profile.dart';
import '../../providers/user_profile_provider.dart';
import '../../config/app_config.dart';

class LevelAssessmentScreen extends StatefulWidget {
  const LevelAssessmentScreen({super.key});

  @override
  State<LevelAssessmentScreen> createState() => _LevelAssessmentScreenState();
}

class _LevelAssessmentScreenState extends State<LevelAssessmentScreen> {
  final Map<String, int> _subjectLevels = {};
  final Set<String> _selectedGoals = {};

  @override
  void initState() {
    super.initState();
    // Initialize with default levels
    for (final subject in Subjects.all) {
      _subjectLevels[subject.id] = 8; // Default to grade 8
    }
  }

  Future<void> _completeOnboarding() async {
    final provider = context.read<UserProfileProvider>();

    // Update subject levels
    for (final entry in _subjectLevels.entries) {
      await provider.updateSubjectLevel(entry.key, entry.value);
    }

    // Update goals
    await provider.updateGoals(_selectedGoals.toList());

    // Mark onboarding as complete
    await provider.completeOnboarding();
    await AppConfig().setOnboardingComplete();

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Almost Done!'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding/style'),
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
                    'What\'s your level?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select your grade level for each subject',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Subject levels
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Subjects
                    Text(
                      'Subjects',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...Subjects.all.map((subject) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _SubjectLevelCard(
                          subject: subject,
                          level: _subjectLevels[subject.id] ?? 8,
                          onLevelChanged: (level) {
                            setState(() {
                              _subjectLevels[subject.id] = level;
                            });
                          },
                        ),
                      );
                    }).toList(),

                    const SizedBox(height: 24),

                    // Goals
                    Text(
                      'What are your goals?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select all that apply',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: LearningGoal.values.map((goal) {
                        final isSelected = _selectedGoals.contains(goal.name);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(goal.emoji),
                              const SizedBox(width: 4),
                              Text(goal.displayName),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedGoals.add(goal.name);
                              } else {
                                _selectedGoals.remove(goal.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Complete button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _completeOnboarding,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size.fromHeight(56),
                ),
                child: const Text(
                  'Start Learning! 🚀',
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

class _SubjectLevelCard extends StatelessWidget {
  final Subject subject;
  final int level;
  final ValueChanged<int> onLevelChanged;

  const _SubjectLevelCard({
    required this.subject,
    required this.level,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(subject.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text(
                subject.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Grade $level',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Slider(
            value: level.toDouble(),
            min: subject.minGrade.toDouble(),
            max: subject.maxGrade.toDouble(),
            divisions: subject.maxGrade - subject.minGrade,
            label: 'Grade $level',
            onChanged: (value) => onLevelChanged(value.round()),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grade ${subject.minGrade}',
                style: theme.textTheme.bodySmall,
              ),
              Text(
                'Grade ${subject.maxGrade}',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
