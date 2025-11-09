import 'package:flutter/material.dart';
import 'lib/models/custom_theme_data.dart';
import 'lib/theme/custom_colors.dart';
import 'lib/services/theme_storage_service.dart';

/// Тестовый скрипт для проверки работы кастомных тем
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('\n=== TESTING CUSTOM THEMES SYSTEM ===\n');

  final storage = ThemeStorageService();

  // Очистим все темы перед тестом
  debugPrint('1. Clearing all themes...');
  await storage.clearAllThemes();
  final countAfterClear = await storage.getThemesCount();
  debugPrint('   ✓ Themes count after clear: $countAfterClear');

  // Создадим тестовую тему
  debugPrint('\n2. Creating test theme...');
  final testColors = CustomColors(
    primary: const Color(0xFF4CAF50),
    primaryLight: const Color(0xFF81C784),
    primaryPale: const Color(0xFFC8E6C9),
    primaryDark: const Color(0xFF388E3C),
    neutral: const Color(0xFFBDBDBD),
    background: const Color(0xFFF5F5DC),
    surface: Colors.white,
    onBackground: const Color(0xFF6D4C41),
    onSurface: const Color(0xFF212121),
    success: const Color(0xFF4CAF50),
    warning: const Color(0xFFFF9800),
    error: const Color(0xFFF44336),
    info: const Color(0xFF2196F3),
    brightness: Brightness.light,
  );

  final testTheme = CustomThemeData.create(
    name: 'Test Theme 1',
    colors: testColors,
    isDark: false,
  );
  debugPrint('   ✓ Created theme: ${testTheme.name} (id: ${testTheme.id})');

  // Тест сериализации
  debugPrint('\n3. Testing JSON serialization...');
  final json = testTheme.toJson();
  debugPrint('   ✓ Serialized to JSON (${json.keys.length} keys)');
  final deserialized = CustomThemeData.fromJson(json);
  debugPrint('   ✓ Deserialized from JSON: ${deserialized.name}');
  assert(testTheme.id == deserialized.id, 'IDs should match');
  assert(testTheme.name == deserialized.name, 'Names should match');
  debugPrint('   ✓ Serialization test passed!');

  // Тест сохранения
  debugPrint('\n4. Testing save...');
  final saved = await storage.saveCustomTheme(testTheme);
  debugPrint('   ✓ Save result: $saved');
  assert(saved == true, 'Save should succeed');

  // Тест загрузки
  debugPrint('\n5. Testing load...');
  final themes = await storage.loadCustomThemes();
  debugPrint('   ✓ Loaded ${themes.length} theme(s)');
  assert(themes.length == 1, 'Should have 1 theme');
  assert(themes[0].id == testTheme.id, 'Loaded theme should match saved');
  debugPrint('   ✓ Theme loaded correctly: ${themes[0].name}');

  // Тест получения одной темы
  debugPrint('\n6. Testing get single theme...');
  final singleTheme = await storage.getCustomTheme(testTheme.id);
  debugPrint('   ✓ Got theme: ${singleTheme?.name}');
  assert(singleTheme != null, 'Theme should be found');
  assert(singleTheme!.id == testTheme.id, 'IDs should match');

  // Создадим еще несколько тем
  debugPrint('\n7. Testing multiple themes...');
  for (int i = 2; i <= 5; i++) {
    final theme = CustomThemeData.create(
      name: 'Test Theme $i',
      colors: testColors,
      isDark: i % 2 == 0,
    );
    await storage.saveCustomTheme(theme);
    await Future.delayed(
      const Duration(milliseconds: 10),
    ); // Чтобы timestamp отличался
  }
  final allThemes = await storage.loadCustomThemes();
  debugPrint('   ✓ Total themes: ${allThemes.length}');
  assert(allThemes.length == 5, 'Should have 5 themes');

  // Тест лимита
  debugPrint('\n8. Testing max themes limit...');
  final isMaxReached = await storage.isMaxThemesReached();
  debugPrint(
    '   ✓ Max limit reached: $isMaxReached (current: ${allThemes.length}/10)',
  );

  // Добавим еще 5 тем, чтобы достичь лимита
  for (int i = 6; i <= 10; i++) {
    final theme = CustomThemeData.create(
      name: 'Test Theme $i',
      colors: testColors,
      isDark: false,
    );
    await storage.saveCustomTheme(theme);
    await Future.delayed(const Duration(milliseconds: 10));
  }
  final isMaxNow = await storage.isMaxThemesReached();
  debugPrint('   ✓ Max limit reached now: $isMaxNow');
  assert(isMaxNow == true, 'Should have reached max limit');

  // Попытка добавить 11-ю тему
  debugPrint('\n9. Testing limit enforcement...');
  final eleventhTheme = CustomThemeData.create(
    name: 'Test Theme 11',
    colors: testColors,
    isDark: false,
  );
  final savedEleven = await storage.saveCustomTheme(eleventhTheme);
  debugPrint('   ✓ Tried to save 11th theme: $savedEleven');
  assert(savedEleven == false, 'Should not allow 11th theme');

  // Тест обновления темы
  debugPrint('\n10. Testing theme update...');
  final firstTheme = allThemes.first;
  final updatedTheme = firstTheme.copyWith(name: 'Updated Theme Name');
  final updateResult = await storage.saveCustomTheme(updatedTheme);
  debugPrint('   ✓ Update result: $updateResult');
  final loadedAfterUpdate = await storage.getCustomTheme(firstTheme.id);
  debugPrint('   ✓ Updated theme name: ${loadedAfterUpdate?.name}');
  assert(
    loadedAfterUpdate?.name == 'Updated Theme Name',
    'Name should be updated',
  );

  // Тест удаления
  debugPrint('\n11. Testing delete...');
  final themeToDelete = allThemes[1];
  final deleteResult = await storage.deleteCustomTheme(themeToDelete.id);
  debugPrint('   ✓ Delete result: $deleteResult');
  assert(deleteResult == true, 'Delete should succeed');
  final afterDelete = await storage.loadCustomThemes();
  debugPrint('   ✓ Themes after delete: ${afterDelete.length}');
  assert(afterDelete.length == 9, 'Should have 9 themes');

  // Тест экспорта/импорта
  debugPrint('\n12. Testing export/import...');
  final exported = storage.exportTheme(afterDelete.first);
  debugPrint('   ✓ Exported theme (${exported.length} chars)');
  final imported = storage.importTheme(exported);
  debugPrint('   ✓ Imported theme: ${imported?.name}');
  assert(imported != null, 'Import should succeed');
  assert(imported!.id == afterDelete.first.id, 'IDs should match');

  // Тест цветов
  debugPrint('\n13. Testing color conversion...');
  final colorJson = testColors.toJson();
  debugPrint('   ✓ Colors serialized (${colorJson.keys.length} colors)');
  debugPrint('   ✓ Sample: primary = ${colorJson['primary']}');
  final colorFromJson = CustomColors.fromJson(colorJson);
  debugPrint('   ✓ Colors deserialized');
  assert(colorFromJson.primary == testColors.primary, 'Colors should match');

  // Финальная очистка
  debugPrint('\n14. Final cleanup...');
  await storage.clearAllThemes();
  final finalCount = await storage.getThemesCount();
  debugPrint('   ✓ Final count: $finalCount');

  debugPrint('\n=== ALL TESTS PASSED! ✓ ===\n');
}
