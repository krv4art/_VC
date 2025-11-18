import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/user_profile_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';
    final progress = context.watch<ProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isRussian ? 'Аналитика' : 'Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isRussian ? 'Общая статистика' : 'Overall Statistics',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    _buildStatRow(
                      context,
                      '📊',
                      isRussian ? 'Решено задач' : 'Problems Solved',
                      '${progress.problemsSolved}',
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      '✅',
                      isRussian ? 'Точность' : 'Accuracy',
                      '${progress.accuracyPercentage.toStringAsFixed(0)}%',
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      '🔥',
                      isRussian ? 'Текущая серия' : 'Current Streak',
                      '${progress.currentStreak} ${isRussian ? "дней" : "days"}',
                    ),
                    const Divider(height: 24),
                    _buildStatRow(
                      context,
                      '⏱️',
                      isRussian ? 'Время обучения' : 'Study Time',
                      _formatDuration(progress.totalStudyTime, isRussian),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subject Progress
            Text(
              isRussian ? 'Прогресс по предметам' : 'Subject Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...progress.topicProgress.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: LinearProgressIndicator(
                    value: entry.value / 100,
                    backgroundColor: Colors.grey[200],
                  ),
                  trailing: Text('${entry.value}%'),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Topic Mastery
            Text(
              isRussian ? 'Мастерство тем' : 'Topic Mastery',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ...progress.topicMastery.entries.map((entry) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(entry.key),
                  subtitle: _buildMasteryBar((entry.value * 100).toInt()),
                  trailing: Text('${(entry.value * 100).toInt()}%'),
                ),
              );
            }),
            const SizedBox(height: 16),

            // Recommendations
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          isRussian ? 'Рекомендации' : 'Recommendations',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.blue[900],
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isRussian
                          ? '• Уделите больше внимания слабым темам\n• Поддерживайте серию для максимального прогресса\n• Решайте задачи ежедневно для лучших результатов'
                          : '• Focus more on weak topics\n• Maintain your streak for maximum progress\n• Practice daily for best results',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String emoji,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildMasteryBar(int level) {
    Color color;
    if (level >= 80) {
      color = Colors.green;
    } else if (level >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: level / 100,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration, bool isRussian) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours > 0) {
      return isRussian ? '$hours ч $minutes мин' : '${hours}h ${minutes}m';
    } else {
      return isRussian ? '$minutes мин' : '${minutes}m';
    }
  }
}
