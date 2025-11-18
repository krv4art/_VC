import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../providers/user_profile_provider.dart';
import '../../providers/theme_provider.dart';
import '../../config/app_config.dart';
import '../../models/cultural_theme.dart';
import '../../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final profileProvider = context.watch<UserProfileProvider>();
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: colorScheme.primary,
                    child: Text(
                      profileProvider.culturalTheme.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Learning Profile',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Current theme
            _SectionTitle(title: 'Cultural Theme'),
            Card(
              child: ListTile(
                leading: Text(
                  profileProvider.culturalTheme.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(profileProvider.culturalTheme.name),
                subtitle: Text(profileProvider.culturalTheme.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _showThemeSelector(context, profileProvider, themeProvider);
                },
              ),
            ),
            const SizedBox(height: 24),

            // Interests
            _SectionTitle(title: 'Your Interests'),
            if (profileProvider.selectedInterests.isEmpty)
              Card(
                child: ListTile(
                  title: const Text('No interests selected'),
                  trailing: TextButton(
                    onPressed: () => context.go('/onboarding/interests'),
                    child: const Text('Add'),
                  ),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: profileProvider.selectedInterests
                    .map((interest) => Chip(
                          avatar: Text(interest.emoji),
                          label: Text(interest.name),
                          onDeleted: () {
                            profileProvider.removeInterest(interest.id);
                          },
                        ))
                    .toList(),
              ),
            const SizedBox(height: 24),

            // Learning style
            _SectionTitle(title: 'Learning Style'),
            Card(
              child: ListTile(
                leading: Text(
                  profileProvider.learningStyle.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(profileProvider.learningStyle.displayName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/onboarding/style'),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            _SectionTitle(title: 'Actions'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.restart_alt),
                    title: const Text('Restart Onboarding'),
                    subtitle: const Text('Reconfigure your preferences'),
                    onTap: () async {
                      final confirmed = await _showConfirmDialog(
                        context,
                        'Restart Onboarding?',
                        'This will reset your profile and take you through the setup again.',
                      );
                      if (confirmed == true && context.mounted) {
                        await profileProvider.resetProfile();
                        await AppConfig().resetOnboarding();
                        context.go('/onboarding/welcome');
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Version info
            Center(
              child: Text(
                'AI Tutor v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onBackground.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(
    BuildContext context,
    UserProfileProvider profileProvider,
    ThemeProvider themeProvider,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...CulturalThemes.all.map((theme) {
              final isSelected = profileProvider.culturalTheme.id == theme.id;
              return ListTile(
                leading: Text(theme.emoji, style: const TextStyle(fontSize: 32)),
                title: Text(theme.name),
                subtitle: Text(theme.description),
                trailing: isSelected ? const Icon(Icons.check_circle) : null,
                onTap: () async {
                  await profileProvider.updateCulturalTheme(theme.id);
                  themeProvider.setTheme(theme);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
              );
            }).toList(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
