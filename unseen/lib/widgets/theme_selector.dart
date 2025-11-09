import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider_v2.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Виджет для выбора темы из множества доступных
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviderV2>(context);

    return PopupMenuButton<AppThemeType>(
      icon: Icon(themeProvider.getThemeIcon(themeProvider.currentTheme)),
      onSelected: (AppThemeType theme) {
        themeProvider.setTheme(theme);
      },
      itemBuilder: (context) => AppThemeType.values.map((theme) {
        return PopupMenuItem<AppThemeType>(
          value: theme,
          child: Row(
            children: [
              Icon(
                themeProvider.getThemeIcon(theme),
                color: themeProvider.currentTheme == theme
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              AppSpacer.h12(),
              Text(themeProvider.getThemeName(theme)),
              if (themeProvider.currentTheme == theme)
                Padding(
                  padding: EdgeInsets.only(left: AppDimensions.space8),
                  child: Icon(
                    Icons.check,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Кнопка для циклического переключения тем (для тестирования)
class ThemeCycleButton extends StatelessWidget {
  const ThemeCycleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProviderV2>(context);

    return IconButton(
      icon: const Icon(Icons.loop),
      onPressed: () async {
        await themeProvider.cycleTheme();

        // Показываем снэкбар с названием текущей темы
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
      tooltip: 'Переключить тему',
    );
  }
}
