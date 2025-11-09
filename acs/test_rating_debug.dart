import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('=== RATING DEBUG SCRIPT ===');

  final prefs = await SharedPreferences.getInstance();

  // Проверяем все ключи, связанные с рейтингом
  debugPrint('\n--- Current Rating State ---');

  final isRatingCompleted = prefs.getBool('rating_completed') ?? false;
  debugPrint('rating_completed: $isRatingCompleted');

  final showsCount = prefs.getInt('rating_dialog_shows_count') ?? 0;
  debugPrint('rating_dialog_shows_count: $showsCount');

  final lastRatingDateString = prefs.getString('last_rating_dialog_date');
  debugPrint('last_rating_dialog_date: $lastRatingDateString');

  final installDateString = prefs.getString('app_install_date');
  debugPrint('app_install_date: $installDateString');

  // Вычисляем время с установки
  if (installDateString != null) {
    final installDate = DateTime.parse(installDateString);
    final hoursSinceInstall = DateTime.now().difference(installDate).inHours;
    debugPrint('Hours since install: $hoursSinceInstall');
    debugPrint('Required hours: 24');
    debugPrint('Can show (hours check): ${hoursSinceInstall >= 24}');
  } else {
    debugPrint('⚠️ WARNING: app_install_date is NULL! This should not happen.');
  }

  // Вычисляем время с последнего показа
  if (showsCount > 0 && lastRatingDateString != null) {
    final lastShowDate = DateTime.parse(lastRatingDateString);
    final daysSinceLastShow = DateTime.now().difference(lastShowDate).inDays;
    debugPrint('Days since last show: $daysSinceLastShow');
    debugPrint('Required days: 3');
    debugPrint('Can show (days check): ${daysSinceLastShow >= 3}');
  }

  // Общая проверка
  debugPrint('\n--- Overall Check ---');
  debugPrint('✓ Rating NOT completed: ${!isRatingCompleted}');
  debugPrint('✓ Shows count OK ($showsCount < 3): ${showsCount < 3}');

  if (installDateString != null) {
    final installDate = DateTime.parse(installDateString);
    final hoursSinceInstall = DateTime.now().difference(installDate).inHours;
    debugPrint(
      '✓ Hours since install OK ($hoursSinceInstall >= 24): ${hoursSinceInstall >= 24}',
    );
  }

  if (showsCount > 0 && lastRatingDateString != null) {
    final lastShowDate = DateTime.parse(lastRatingDateString);
    final daysSinceLastShow = DateTime.now().difference(lastShowDate).inDays;
    debugPrint(
      '✓ Days since last show OK ($daysSinceLastShow >= 3): ${daysSinceLastShow >= 3}',
    );
  } else if (showsCount == 0) {
    debugPrint('✓ First show - no need to check interval');
  }

  debugPrint('\n=== END DEBUG ===');
}
