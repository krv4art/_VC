import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../theme/app_theme.dart';

/// Theme selection screen
class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.theme),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.space16),
        children: [
          // Dark Mode Toggle
          Card(
            child: SwitchListTile(
              title: Text(l10n.darkMode),
              subtitle: const Text('Enable dark theme'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleDarkMode(),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
          ),
          const SizedBox(height: AppTheme.space16),

          // Theme Selection Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.space8,
              vertical: AppTheme.space8,
            ),
            child: Text(
              'Color Theme',
              style: AppTheme.h5.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),

          // Available Themes
          ...themeProvider.availableThemes.map((themeName) {
            final isSelected = _getCurrentThemeName(themeProvider) == themeName;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getThemeColor(themeName),
                ),
                title: Text(
                  _getThemeDisplayName(themeName, l10n),
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                        Icons.check_circle,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
                onTap: () {
                  themeProvider.setTheme(themeName);
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _getCurrentThemeName(ThemeProvider themeProvider) {
    final type = themeProvider.colors.runtimeType.toString();
    if (type.contains('GreenNature')) return 'green_nature';
    if (type.contains('Forest')) return 'forest';
    if (type.contains('Botanical')) return 'botanical';
    if (type.contains('Mushroom')) return 'mushroom';
    if (type.contains('DarkGreen')) return 'dark_green';
    return 'green_nature';
  }

  String _getThemeDisplayName(String theme, AppLocalizations l10n) {
    switch (theme) {
      case 'green_nature':
        return l10n.themeGreenNature;
      case 'forest':
        return l10n.themeForest;
      case 'botanical':
        return l10n.themeBotanical;
      case 'mushroom':
        return l10n.themeMushroom;
      case 'dark_green':
        return l10n.themeDarkGreen;
      default:
        return theme;
    }
  }

  Color _getThemeColor(String theme) {
    switch (theme) {
      case 'green_nature':
        return const Color(0xFF4CAF50);
      case 'forest':
        return const Color(0xFF2E7D32);
      case 'botanical':
        return const Color(0xFF66BB6A);
      case 'mushroom':
        return const Color(0xFF8D6E63);
      case 'dark_green':
        return const Color(0xFF1B5E20);
      default:
        return const Color(0xFF4CAF50);
    }
  }
}
