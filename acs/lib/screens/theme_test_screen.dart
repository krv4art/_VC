import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider_v2.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/theme_selector.dart';

/// Экран для тестирования множественных тем
class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тестирование тем'),
        actions: const [ThemeSelector(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Информация о текущей теме
            Consumer<ThemeProviderV2>(
              builder: (context, themeProvider, child) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              themeProvider.getThemeIcon(
                                themeProvider.currentTheme,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Текущая тема: ${themeProvider.getThemeName(themeProvider.currentTheme)}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Яркость: ${themeProvider.isDarkTheme ? "Темная" : "Светлая"}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Демонстрация цветов
            Text(
              'Палитра цветов',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _buildColorPalette(context),
            const SizedBox(height: 16),

            // Демонстрация градиента
            Text('Градиент', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: context.colors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Пример градиента',
                  style: TextStyle(
                    color: context.colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Демонстрация кнопок
            Text('Кнопки', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Elevated Button'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Text Button'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Outlined'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Демонстрация полей ввода
            Text('Поля ввода', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Пример поля ввода',
                hintText: 'Введите текст...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Демонстрация семантических цветов
            Text(
              'Семантические цвета',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSemanticColorCard(
                    context,
                    'Success',
                    context.colors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSemanticColorCard(
                    context,
                    'Warning',
                    context.colors.warning,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSemanticColorCard(
                    context,
                    'Error',
                    context.colors.error,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSemanticColorCard(
                    context,
                    'Info',
                    context.colors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Кнопка для циклического переключения тем
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final themeProvider = Provider.of<ThemeProviderV2>(
                    context,
                    listen: false,
                  );
                  await themeProvider.cycleTheme();

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: context.colors.surface,
                        content: Text(
                          'Тема изменена на: ${themeProvider.getThemeName(themeProvider.currentTheme)}',
                          style: TextStyle(color: context.colors.onSurface),
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.loop),
                label: const Text('Переключить тему'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorPalette(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildColorRow('Saddle Brown', colors.primaryDark),
            _buildColorRow('Natural Green', colors.primary),
            _buildColorRow('Light Green', colors.primaryLight),
            _buildColorRow('Pale Green', colors.primaryPale),
            _buildColorRow('Secondary (computed)', colors.secondary),
            _buildColorRow('Medium Brown', colors.secondary),
            _buildColorRow('Background', colors.background),
            _buildColorRow('Surface', colors.surface),
            _buildColorRow('Card Background', colors.cardBackground),
            _buildColorRow('On Background', colors.onBackground),
            _buildColorRow('On Surface', colors.onSurface),
            _buildColorRow('On Secondary', colors.onSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildColorRow(String name, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name)),
          Text(
            '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildSemanticColorCard(
    BuildContext context,
    String name,
    Color color,
  ) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(
              _getIconForColor(name),
              color: _getTextColorForBackground(color),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                color: _getTextColorForBackground(color),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForColor(String name) {
    switch (name) {
      case 'Success':
        return Icons.check_circle;
      case 'Warning':
        return Icons.warning;
      case 'Error':
        return Icons.error;
      case 'Info':
        return Icons.info;
      default:
        return Icons.circle;
    }
  }

  Color _getTextColorForBackground(Color backgroundColor) {
    // Вычисляем контрастный цвет для текста
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
