import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/resume_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final resumeProvider = context.watch<ResumeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Theme Settings
          _SectionHeader(title: 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Switch between light and dark theme'),
            value: themeProvider.isDarkMode,
            onChanged: (value) => themeProvider.toggleDarkMode(),
            secondary: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Color Theme'),
            subtitle: Text(themeProvider.currentTheme.toUpperCase()),
            onTap: () => _showThemeSelector(context, themeProvider),
          ),

          const Divider(),

          // Language Settings
          _SectionHeader(title: 'Language'),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('App Language'),
            subtitle: Text(_getLanguageName(localeProvider.locale)),
            onTap: () => _showLanguageSelector(context, localeProvider),
          ),

          const Divider(),

          // Resume Formatting
          if (resumeProvider.hasCurrentResume) ...[
            _SectionHeader(title: 'Resume Formatting'),
            ListTile(
              leading: const Icon(Icons.format_size),
              title: const Text('Font Size'),
              subtitle: Text('${resumeProvider.currentResume!.fontSize.toStringAsFixed(0)}pt'),
              trailing: SizedBox(
                width: 200,
                child: Slider(
                  value: resumeProvider.currentResume!.fontSize,
                  min: 8,
                  max: 16,
                  divisions: 8,
                  label: resumeProvider.currentResume!.fontSize.toStringAsFixed(0),
                  onChanged: (value) {
                    resumeProvider.updateFormatting(fontSize: value);
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.space_bar),
              title: const Text('Page Margins'),
              subtitle: Text('${resumeProvider.currentResume!.marginSize.toStringAsFixed(0)}pt'),
              trailing: SizedBox(
                width: 200,
                child: Slider(
                  value: resumeProvider.currentResume!.marginSize,
                  min: 10,
                  max: 40,
                  divisions: 6,
                  label: resumeProvider.currentResume!.marginSize.toStringAsFixed(0),
                  onChanged: (value) {
                    resumeProvider.updateFormatting(marginSize: value);
                  },
                ),
              ),
            ),
            const Divider(),
          ],

          // About
          _SectionHeader(title: 'About'),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('About CV Engineer'),
            subtitle: const Text('Professional Resume Builder'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(BuildContext context, ThemeProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: provider.availableThemes.map((theme) {
            return RadioListTile<String>(
              title: Text(theme['name']!),
              subtitle: Text(theme['description']!),
              value: theme['id']!,
              groupValue: provider.currentTheme,
              onChanged: (value) {
                if (value != null) {
                  provider.setTheme(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, LocaleProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: provider.availableLocales.map((locale) {
              return RadioListTile<Locale>(
                title: Text(locale['name'] as String),
                subtitle: Text(locale['nativeName'] as String),
                value: locale['locale'] as Locale,
                groupValue: provider.locale,
                onChanged: (value) {
                  if (value != null) {
                    provider.setLocale(value);
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    final languages = {
      'en': 'English',
      'es': 'Español',
      'de': 'Deutsch',
      'fr': 'Français',
      'it': 'Italiano',
      'pl': 'Polski',
      'pt': 'Português',
      'tr': 'Türkçe',
    };
    return languages[locale.languageCode] ?? locale.languageCode;
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'CV Engineer',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.description, size: 48),
      children: [
        const Text('Professional Resume Builder with AI Assistant'),
        const SizedBox(height: AppTheme.space16),
        const Text('Features:'),
        const Text('• Multiple professional templates'),
        const Text('• AI-powered content suggestions'),
        const Text('• PDF export and sharing'),
        const Text('• Multi-language support'),
        const Text('• Dark mode support'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.space16,
        AppTheme.space24,
        AppTheme.space16,
        AppTheme.space8,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
