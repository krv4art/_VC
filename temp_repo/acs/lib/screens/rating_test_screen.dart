import 'package:flutter/material.dart';
import '../services/rating_service.dart';
import '../config/app_config.dart';
import '../theme/theme_extensions_v2.dart';

/// Экран для тестирования функциональности сервиса оценки
class RatingTestScreen extends StatefulWidget {
  const RatingTestScreen({super.key});

  @override
  State<RatingTestScreen> createState() => _RatingTestScreenState();
}

class _RatingTestScreenState extends State<RatingTestScreen> {
  int _currentShows = 0;
  int _maxShows = 3;
  bool _shouldShow = false;
  String? _lastRatingDate;

  @override
  void initState() {
    super.initState();
    _loadRatingInfo();
  }

  Future<void> _loadRatingInfo() async {
    final currentShows = await RatingService().getRatingDialogShowsCount();
    final maxShows = AppConfig().maxRatingDialogShows;
    final shouldShow = await RatingService().shouldShowRatingDialog();
    final lastDate = await RatingService().getLastRatingDialogDate();

    setState(() {
      _currentShows = currentShows;
      _maxShows = maxShows;
      _shouldShow = shouldShow;
      _lastRatingDate = lastDate?.toIso8601String();
    });
  }

  Future<void> _simulateRatingShow() async {
    await RatingService().incrementRatingDialogShows();
    await _loadRatingInfo();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.surface,
          content: Text(
            'Счетчик показов увеличен',
            style: TextStyle(color: context.colors.onSurface),
          ),
        ),
      );
    }
  }

  Future<void> _resetRatingCounter() async {
    await RatingService().resetRatingDialogShows();
    await _loadRatingInfo();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: context.colors.surface,
          content: Text(
            'Счетчик показов сброшен',
            style: TextStyle(color: context.colors.onSurface),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text('Тестирование сервиса оценки'),
        backgroundColor: context.colors.surface,
        foregroundColor: context.colors.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Информация о состоянии сервиса оценки:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildInfoCard('Текущее количество показов', '$_currentShows'),
            _buildInfoCard('Максимальное количество показов', '$_maxShows'),
            _buildInfoCard(
              'Нужно ли показать диалог',
              _shouldShow ? 'Да' : 'Нет',
            ),
            _buildInfoCard(
              'Дата последнего показа',
              _lastRatingDate ?? 'Не показывался',
            ),
            const SizedBox(height: 24),
            Text('Действия:', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simulateRatingShow,
              child: Text('Симулировать показ диалога оценки'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _resetRatingCounter,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.warning,
                foregroundColor: Colors.white,
              ),
              child: Text('Сбросить счетчик показов'),
            ),
            const SizedBox(height: 16),
            Text(
              'Примечание: Этот экран предназначен для тестирования функциональности сервиса оценки. '
              'В реальном приложении диалог оценки будет показываться после сохранения результатов сканирования.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyLarge),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
