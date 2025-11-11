import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/premium_provider.dart';
import '../services/database_service.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';
import '../widgets/rating_dialog.dart';
import '../widgets/survey_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Features',
            Column(
              children: [
                Consumer<PremiumProvider>(
                  builder: (context, premium, child) {
                    return ListTile(
                      leading: Icon(
                        Icons.workspace_premium,
                        color: premium.isPremium ? Colors.amber : null,
                      ),
                      title: Text(l10n.premiumTitle),
                      subtitle: premium.isPremium
                          ? const Text('Active')
                          : Text(l10n.premiumPrice),
                      trailing: premium.isPremium
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () => context.push('/premium'),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map),
                  title: const Text('Fishing Spots Map'),
                  subtitle: const Text('Find and share fishing locations'),
                  onTap: () => context.push('/fishing-map'),
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            l10n.settingsLanguage,
            _buildLanguageTile(context),
          ),
          _buildSection(
            context,
            l10n.settingsTheme,
            Column(
              children: [
                _buildThemeTile(context),
                _buildDarkModeTile(context),
              ],
            ),
          ),
          _buildSection(
            context,
            l10n.feedback,
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.star),
                  title: Text(l10n.settingsRate),
                  onTap: () => _showRatingDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.poll),
                  title: Text(l10n.surveyTitle),
                  onTap: () => _showSurveyDialog(context),
                ),
              ],
            ),
          ),
          _buildSection(
            context,
            l10n.settingsAbout,
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: Text(l10n.settingsShare),
                  onTap: () => _shareApp(context),
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: Text(l10n.settingsClearData),
                  onTap: () => _confirmClearData(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.space16,
            AppDimensions.space24,
            AppDimensions.space16,
            AppDimensions.space8,
          ),
          child: Text(
            title,
            style: AppTheme.h4.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        child,
        const Divider(),
      ],
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final currentLanguage = localeProvider.locale.languageCode;

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(LocaleProvider.languageNames[currentLanguage]!),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(AppLocalizations.of(context)!.settingsLanguage),
            children: LocaleProvider.languageNames.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    context.read<LocaleProvider>().setLocaleFromCode(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildThemeTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();

    final themes = {
      'ocean_blue': l10n.settingsThemeOcean,
      'deep_sea': l10n.settingsThemeDeep,
      'tropical': l10n.settingsThemeTropical,
      'khaki_camo': l10n.settingsThemeKhaki,
    };

    return ListTile(
      leading: const Icon(Icons.palette),
      title: Text(themes[themeProvider.currentTheme]!),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(l10n.settingsTheme),
            children: themes.entries.map((entry) {
              return RadioListTile<String>(
                title: Text(entry.value),
                value: entry.key,
                groupValue: themeProvider.currentTheme,
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeProvider>().setTheme(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildDarkModeTile(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = context.watch<ThemeProvider>();

    return SwitchListTile(
      secondary: const Icon(Icons.dark_mode),
      title: Text(l10n.settingsDarkMode),
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        context.read<ThemeProvider>().setDarkMode(value);
      },
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RatingDialog(),
    );
  }

  void _showSurveyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SurveyDialog(),
    );
  }

  void _shareApp(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.shareComingSoon)),
    );
  }

  void _confirmClearData(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmClearData),
        content: Text(l10n.confirmClearDataMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseService.instance.clearAllData();
              if (context.mounted) {
                final l10n = AppLocalizations.of(context)!;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dataCleared)),
                );
              }
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
