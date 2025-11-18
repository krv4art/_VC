import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/brain_training/exercise_type.dart';
import '../../providers/brain_training_provider.dart';
import '../../providers/user_profile_provider.dart';
import 'exercises/stroop_test_screen.dart';
import 'exercises/memory_cards_screen.dart';
import 'exercises/speed_reading_screen.dart';
import 'exercises/shape_counter_screen.dart';
import 'exercises/number_sequences_screen.dart';
import 'exercises/n_back_test_screen.dart';
import 'exercises/quick_math_screen.dart';
import 'exercises/spot_difference_screen.dart';

class BrainTrainingScreen extends StatelessWidget {
  const BrainTrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(isRussian ? 'Тренировки мозга' : 'Brain Training'),
        elevation: 0,
      ),
      body: Consumer<BrainTrainingProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // Overall Stats Summary
              SliverToBoxAdapter(
                child: _OverallStatsCard(
                  totalExercises: provider.totalExercisesCompleted,
                  totalTime: provider.totalTimeSpent,
                  averageAccuracy: provider.overallAccuracy,
                  isRussian: isRussian,
                ),
              ),

              // Exercises Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final exerciseType = ExerciseType.values[index];
                      final stats = provider.getStatsFor(exerciseType);

                      return _ExerciseCard(
                        exerciseType: exerciseType,
                        stats: stats,
                        isRussian: isRussian,
                        onTap: () => _navigateToExercise(context, exerciseType),
                      );
                    },
                    childCount: ExerciseType.values.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToExercise(BuildContext context, ExerciseType type) {
    Widget screen;
    switch (type) {
      case ExerciseType.stroopTest:
        screen = const StroopTestScreen();
        break;
      case ExerciseType.memoryCards:
        screen = const MemoryCardsScreen();
        break;
      case ExerciseType.speedReading:
        screen = const SpeedReadingScreen();
        break;
      case ExerciseType.shapeCounter:
        screen = const ShapeCounterScreen();
        break;
      case ExerciseType.numberSequences:
        screen = const NumberSequencesScreen();
        break;
      case ExerciseType.nBackTest:
        screen = const NBackTestScreen();
        break;
      case ExerciseType.quickMath:
        screen = const QuickMathScreen();
        break;
      case ExerciseType.spotTheDifference:
        screen = const SpotDifferenceScreen();
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

class _OverallStatsCard extends StatelessWidget {
  final int totalExercises;
  final Duration totalTime;
  final double averageAccuracy;
  final bool isRussian;

  const _OverallStatsCard({
    required this.totalExercises,
    required this.totalTime,
    required this.averageAccuracy,
    required this.isRussian,
  });

  @override
  Widget build(BuildContext context) {
    final hours = totalTime.inHours;
    final minutes = totalTime.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isRussian ? '🧠 Общая статистика' : '🧠 Overall Stats',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: '🎯',
                value: totalExercises.toString(),
                label: isRussian ? 'Упражнений' : 'Exercises',
              ),
              _StatItem(
                icon: '⏱️',
                value: hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m',
                label: isRussian ? 'Времени' : 'Time',
              ),
              _StatItem(
                icon: '📊',
                value: '${averageAccuracy.toStringAsFixed(0)}%',
                label: isRussian ? 'Точность' : 'Accuracy',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseType exerciseType;
  final dynamic stats;
  final bool isRussian;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.exerciseType,
    required this.stats,
    required this.isRussian,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final timesPlayed = stats.timesPlayed as int;
    final bestScore = stats.bestScore as int;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Text(
                exerciseType.icon,
                style: const TextStyle(fontSize: 48),
              ),
              const SizedBox(height: 12),

              // Name
              Text(
                isRussian ? exerciseType.nameRu : exerciseType.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Stats
              if (timesPlayed > 0) ...[
                Text(
                  isRussian ? 'Сыграно: $timesPlayed' : 'Played: $timesPlayed',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                if (bestScore > 0)
                  Text(
                    isRussian ? 'Рекорд: $bestScore' : 'Best: $bestScore',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ] else
                Text(
                  isRussian ? 'Новое!' : 'New!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
