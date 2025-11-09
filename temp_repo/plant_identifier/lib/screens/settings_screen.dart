import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../theme/app_theme.dart';

/// Settings screen - App configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final preferencesProvider = context.watch<UserPreferencesProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.space16),
        children: [
          // Appearance Section
          _buildSectionHeader(l10n.appearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: Text(l10n.theme),
                  subtitle: Text(themeProvider.colors.runtimeType.toString()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showThemeDialog(context, themeProvider, l10n);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.dark_mode),
                  title: Text(l10n.darkMode),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleDarkMode();
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.space24),

          // Language Section
          _buildSectionHeader(l10n.language),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: Text(l10n.language),
              subtitle: Text(
                localeProvider.getLocaleDisplayName(localeProvider.locale),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showLanguageDialog(context, localeProvider, l10n);
              },
            ),
          ),
          const SizedBox(height: AppTheme.space24),

          // Environmental Conditions Section
          _buildSectionHeader(l10n.environmentalConditions),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.thermostat),
                  title: Text(l10n.temperature),
                  subtitle: Text(
                    preferencesProvider.preferences.temperature != null
                        ? '${preferencesProvider.preferences.temperature}°C'
                        : l10n.notSet,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showTemperatureDialog(context, preferencesProvider, l10n);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.water_drop),
                  title: Text(l10n.humidity),
                  subtitle: Text(
                    preferencesProvider.preferences.humidity != null
                        ? '${preferencesProvider.preferences.humidity}%'
                        : l10n.notSet,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    _showHumidityDialog(context, preferencesProvider, l10n);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.space24),

          // Preferences Section
          _buildSectionHeader(l10n.preferences),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.warning_amber),
                  title: Text(l10n.showToxicWarnings),
                  trailing: Switch(
                    value: preferencesProvider.preferences.showToxicWarnings,
                    onChanged: (value) {
                      preferencesProvider.toggleToxicWarnings(value);
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(l10n.careReminders),
                  trailing: Switch(
                    value: preferencesProvider.preferences.careReminders,
                    onChanged: (value) {
                      preferencesProvider.toggleCareReminders(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.space24),

          // About Section
          _buildSectionHeader(l10n.about),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.version),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: Text(l10n.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Show privacy policy
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppTheme.space8,
        bottom: AppTheme.space8,
      ),
      child: Text(
        title,
        style: AppTheme.h4.copyWith(color: Colors.grey[700]),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseTheme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: themeProvider.availableThemes.map((theme) {
            return RadioListTile<String>(
              title: Text(_getThemeDisplayName(theme, l10n)),
              value: theme,
              groupValue: _getCurrentThemeName(themeProvider),
              onChanged: (value) {
                if (value != null) {
                  themeProvider.setTheme(value);
                  Navigator.pop(ctx);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chooseLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: localeProvider.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(localeProvider.getLocaleDisplayName(locale)),
              value: locale,
              groupValue: localeProvider.locale,
              onChanged: (value) {
                if (value != null) {
                  localeProvider.setLocale(value);
                  Navigator.pop(ctx);
                }
              },
            );
          }).toList(),
        ),
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

  void _showTemperatureDialog(
    BuildContext context,
    UserPreferencesProvider preferencesProvider,
    AppLocalizations l10n,
  ) {
    final TextEditingController controller = TextEditingController(
      text: preferencesProvider.preferences.temperature?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.setTemperature),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.setTemperatureDesc),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.temperatureLabel,
                hintText: l10n.temperatureHint,
                suffixText: '°C',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null) {
                preferencesProvider.updateTemperature(value);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showHumidityDialog(
    BuildContext context,
    UserPreferencesProvider preferencesProvider,
    AppLocalizations l10n,
  ) {
    final TextEditingController controller = TextEditingController(
      text: preferencesProvider.preferences.humidity?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.setHumidity),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.setHumidityDesc),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.humidityLabel,
                hintText: l10n.humidityHint,
                suffixText: '%',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              if (value != null && value >= 0 && value <= 100) {
                preferencesProvider.updateHumidity(value);
                Navigator.pop(ctx);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
