import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/challenge_provider.dart';
import '../../models/challenge.dart';
import '../../models/subject.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final challengeProvider = context.watch<ChallengeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges & Goals'),
      ),
      body: challengeProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Daily Challenge
                  Text(
                    'Daily Challenge',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (challengeProvider.todayChallenge != null)
                    _DailyChallengeCard(
                      challenge: challengeProvider.todayChallenge!,
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.check_circle,
                                  size: 48, color: Colors.green),
                              const SizedBox(height: 12),
                              Text(
                                'No challenge today',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // Study Goals
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Study Goals',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showAddGoalDialog(context),
                        icon: const Icon(Icons.add_circle),
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Active Goals
                  if (challengeProvider.activeGoals.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.flag,
                                  size: 48,
                                  color: colorScheme.primary.withOpacity(0.5)),
                              const SizedBox(height: 12),
                              Text(
                                'No active goals',
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () => _showAddGoalDialog(context),
                                icon: const Icon(Icons.add),
                                label: const Text('Add Goal'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...challengeProvider.activeGoals.map(
                      (goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _StudyGoalCard(goal: goal),
                      ),
                    ),

                  // Completed Goals
                  if (challengeProvider.completedGoals.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'Completed Goals',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...challengeProvider.completedGoals.map(
                      (goal) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Opacity(
                          opacity: 0.6,
                          child: _StudyGoalCard(goal: goal),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _AddGoalDialog(),
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;

  const _DailyChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subject = Subjects.getById(challenge.subjectId);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: challenge.isCompleted
                ? [Colors.green.shade300, Colors.green.shade500]
                : [colorScheme.primary, colorScheme.primary.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (subject != null)
                    Text(subject.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (challenge.isCompleted)
                    const Icon(Icons.check_circle, color: Colors.white, size: 32),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: challenge.progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(Colors.white),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${challenge.currentProgress}/${challenge.targetProblems} completed',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.stars, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '+${challenge.xpReward} XP',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (!challenge.isCompleted) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/practice/${challenge.subjectId}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: colorScheme.primary,
                    ),
                    child: const Text('Start Challenge'),
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

class _StudyGoalCard extends StatelessWidget {
  final StudyGoal goal;

  const _StudyGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(goal.type.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        goal.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (goal.isCompleted)
                  Icon(Icons.check_circle, color: Colors.green, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: goal.progress,
              backgroundColor: colorScheme.surface,
              valueColor: AlwaysStoppedAnimation(
                goal.isCompleted ? Colors.green : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.currentValue}/${goal.targetValue} ${goal.type.displayName}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  goal.daysRemaining > 0
                      ? '${goal.daysRemaining} days left'
                      : 'Deadline passed',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: goal.daysRemaining > 0
                        ? colorScheme.primary
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddGoalDialog extends StatefulWidget {
  const _AddGoalDialog();

  @override
  State<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<_AddGoalDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetController = TextEditingController();
  GoalType _selectedType = GoalType.problemsSolved;
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _createGoal() {
    if (_titleController.text.isEmpty || _targetController.text.isEmpty) {
      return;
    }

    final goal = StudyGoal(
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
      targetValue: int.parse(_targetController.text),
      deadline: _deadline,
    );

    context.read<ChallengeProvider>().addGoal(goal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Create Study Goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Goal Title',
                hintText: 'e.g., Master Algebra',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional description',
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<GoalType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Goal Type'),
              items: GoalType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text('${type.emoji} ${type.displayName}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: 'Target Value',
                hintText: 'e.g., 100',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(
                '${_deadline.day}/${_deadline.month}/${_deadline.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _deadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    _deadline = date;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createGoal,
          child: const Text('Create'),
        ),
      ],
    );
  }
}
