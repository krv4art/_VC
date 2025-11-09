import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'lib/services/rating_service.dart';
import 'lib/config/app_config.dart';

/// Простой тест для проверки функциональности сервиса оценки
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем dotenv для тестирования
  await dotenv.load(fileName: 'assets/config/.env');

  // Инициализируем конфигурацию
  await AppConfig().initialize();

  // Инициализируем сервис оценки
  await RatingService().initialize();

  debugPrint('=== Тестирование сервиса оценки ===');

  // Получаем текущее количество показов
  final currentShows = await RatingService().getRatingDialogShowsCount();
  debugPrint('Текущее количество показов: $currentShows');

  // Получаем максимальное количество показов из конфигурации
  final maxShows = AppConfig().maxRatingDialogShows;
  debugPrint('Максимальное количество показов: $maxShows');

  // Проверяем, нужно ли показать диалог
  final shouldShow = await RatingService().shouldShowRatingDialog();
  debugPrint('Нужно ли показать диалог: $shouldShow');

  // Получаем дату последнего показа
  final lastDate = await RatingService().getLastRatingDialogDate();
  debugPrint(
    'Дата последнего показа: ${lastDate?.toIso8601String() ?? "Не показывался"}',
  );

  debugPrint('\n=== Симуляция сохранения результатов сканирования ===');

  // Симулируем сохранение результатов сканирования
  if (shouldShow) {
    debugPrint('Диалог оценки будет показан\n');
    debugPrint('Увеличиваем счетчик показов...');
    await RatingService().incrementRatingDialogShows();

    // Проверяем новое количество показов
    final newShows = await RatingService().getRatingDialogShowsCount();
    debugPrint('Новое количество показов: $newShows');

    // Проверяем, нужно ли показать диалог после увеличения счетчика
    final shouldShowAfter = await RatingService().shouldShowRatingDialog();
    debugPrint('Нужно ли показать диалог после увеличения: $shouldShowAfter');
  } else {
    debugPrint(
      'Диалог оценки не будет показан, так как достигнуто максимальное количество показов',
    );
  }

  debugPrint('\n=== Тест завершен ===');

  // Для тестирования можно раскомментировать следующую строку для сброса счетчика
  // await RatingService().resetRatingDialogShows();
}
