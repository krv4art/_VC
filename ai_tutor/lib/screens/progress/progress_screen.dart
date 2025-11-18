import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../providers/progress_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../models/subject.dart';
import '../../models/achievement.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progressProvider = context.watch<ProgressProvider>();
    final achievementProvider = context.watch<AchievementProvider>();
    final profileProvider = context.watch<UserProfileProvider>();

    final stats = progressProvider.getOverallStats();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Progress'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall stats card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.school,
                            label: 'Problems',
                            value: '${stats['total_problems']}',
                            color: colorScheme.primary,
                          ),
                          _StatItem(
                            icon: Icons.check_circle,
                            label: 'Correct',
                            value: '${stats['total_correct']}',
                            color: Colors.green,
                          ),
                          _StatItem(
                            icon: Icons.local_fire_department,
                            label: 'Streak',
                            value: '${stats['max_streak']}',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatItem(
                            icon: Icons.access_time,
                            label: 'Minutes',
                            value: '${stats['total_minutes']}',
                            color: colorScheme.secondary,
                          ),
                          _StatItem(
                            icon: Icons.percent,
                            label: 'Accuracy',
                            value: '${stats['accuracy'].toStringAsFixed(0)}%',
                            color: Colors.blue,
                          ),
                          _StatItem(
                            icon: Icons.stars,
                            label: 'XP',
                            value: '${achievementProvider.totalXP}',
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Achievements section
              Text(
                'Achievements',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${achievementProvider.unlockedAchievements.length}/${achievementProvider.achievements.length} unlocked',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),

              // Achievement grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: achievementProvider.achievements.length,
                itemBuilder: (context, index) {
                  final achievement =
                      achievementProvider.achievements.values.toList()[index];
                  return _AchievementCard(achievement: achievement);
                },
              ),
              const SizedBox(height: 24),

              // Subject progress
              Text(
                'Progress by Subject',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ...Subjects.all.map((subject) {
                final progress = progressProvider.getProgress(
                  profileProvider.profile.userId ?? '',
                  subject.id,
                );

                if (progress.totalProblems == 0) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _SubjectProgressCard(
                    subject: subject,
                    solvedProblems: progress.solvedProblems,
                    accuracy: progress.accuracy,
                    streak: progress.currentStreak,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onBackground.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isUnlocked = achievement.isUnlocked;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Text(achievement.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(child: Text(achievement.name)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(achievement.description),
                const SizedBox(height: 12),
                if (!isUnlocked) ...[
                  LinearProgressIndicator(
                    value: achievement.progress,
                    backgroundColor: colorScheme.surface,
                    valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${achievement.currentValue}/${achievement.targetValue}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.stars, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '+${achievement.xpReward} XP',
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? colorScheme.primary.withOpacity(0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.3,
              child: Text(
                achievement.emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              achievement.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? colorScheme.primary : null,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 4),
              Icon(
                Icons.check_circle,
                size: 16,
                color: colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SubjectProgressCard extends StatelessWidget {
  final Subject subject;
  final int solvedProblems;
  final double accuracy;
  final int streak;

  const _SubjectProgressCard({
    required this.subject,
    required this.solvedProblems,
    required this.accuracy,
    required this.streak,
  });

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
                Text(subject.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    subject.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '$solvedProblems',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Problems',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${accuracy.toStringAsFixed(0)}%',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Accuracy',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            size: 20, color: Colors.orange),
                        Text(
                          '$streak',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Streak',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
