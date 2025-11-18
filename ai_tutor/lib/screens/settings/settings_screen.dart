import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../providers/user_profile_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/achievement_provider.dart';
import '../../providers/challenge_provider.dart';
import '../../services/notification_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Account Section
          _SectionHeader(title: 'Account'),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            subtitle: const Text('Manage your profile and preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          Consumer<UserProfileProvider>(
            builder: (context, profileProvider, _) {
              final currentLanguage = profileProvider.profile.preferredLanguage;
              final languageName = currentLanguage == 'ru' ? 'Русский' : 'English';

              return ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: Text(languageName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context, profileProvider),
              );
            },
          ),
          const Divider(),

          // Notifications Section
          _SectionHeader(title: 'Notifications'),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Daily Reminders'),
            subtitle: Text(
              notificationService.remindersEnabled
                  ? 'Enabled at ${notificationService.reminderTime}'
                  : 'Disabled',
            ),
            trailing: Switch(
              value: notificationService.remindersEnabled,
              onChanged: (value) {
                notificationService.setRemindersEnabled(value);
              },
            ),
          ),
          if (notificationService.remindersEnabled)
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Reminder Time'),
              subtitle: Text('${notificationService.reminderTime}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _selectReminderTime(context),
            ),
          ListTile(
            leading: const Icon(Icons.local_fire_department),
            title: const Text('Streak Reminders'),
            subtitle: const Text('Get reminded to maintain your streak'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Implement streak reminders toggle
              },
            ),
          ),
          const Divider(),

          // Progress & Goals Section
          _SectionHeader(title: 'Progress & Goals'),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Challenges & Goals'),
            subtitle: const Text('View daily challenges and study goals'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/challenges'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Weekly Report'),
            subtitle: const Text('View your weekly progress'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/weekly-report'),
          ),
          const Divider(),

          // Data Section
          _SectionHeader(title: 'Data'),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share Progress'),
            subtitle: const Text('Share your achievements'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _shareProgress(context),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Export Data'),
            subtitle: const Text('Export your learning data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export feature coming soon!'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.orange),
            title: const Text('Reset Progress'),
            subtitle: const Text('Clear all progress data'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showResetConfirmation(context),
          ),
          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show terms
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Report Issue'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Report issue
            },
          ),
          const SizedBox(height: 32),

          // Danger Zone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: OutlinedButton.icon(
              onPressed: () => _showResetConfirmation(context),
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              label: const Text(
                'Reset All Data',
                style: TextStyle(color: Colors.red),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _selectReminderTime(BuildContext context) async {
    final notificationService = NotificationService();
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: notificationService.reminderTime.hour,
        minute: notificationService.reminderTime.minute,
      ),
    );

    if (time != null) {
      notificationService.setReminderTime(
        TimeOfDay(hour: time.hour, minute: time.minute),
      );
    }
  }

  void _shareProgress(BuildContext context) {
    final progressProvider = context.read<ProgressProvider>();
    final achievementProvider = context.read<AchievementProvider>();
    final stats = progressProvider.getOverallStats();

    final text = '''
🎓 My AI Tutor Progress

📊 Problems Solved: ${stats['total_problems']}
✅ Accuracy: ${stats['accuracy'].toStringAsFixed(0)}%
🔥 Streak: ${stats['max_streak']} days
⏱️ Study Time: ${stats['total_minutes']} minutes
🏆 Achievements: ${achievementProvider.unlockedAchievements.length}/${achievementProvider.achievements.length}

Join me in AI Tutor - Personalized learning! 🚀
''';

    Share.share(text);
  }

  void _showLanguageDialog(BuildContext context, UserProfileProvider profileProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 32)),
              title: const Text('English'),
              trailing: profileProvider.profile.preferredLanguage == 'en'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await profileProvider.updateLanguage('en');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              leading: const Text('🇷🇺', style: TextStyle(fontSize: 32)),
              title: const Text('Русский'),
              trailing: profileProvider.profile.preferredLanguage == 'ru'
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () async {
                await profileProvider.updateLanguage('ru');
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Data?'),
        content: const Text(
          'This will permanently delete:\n'
          '• All progress\n'
          '• All achievements\n'
          '• All goals and challenges\n'
          '\nThis action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Reset all data
              await context.read<ProgressProvider>().resetProgress();
              await context.read<AchievementProvider>().resetAchievements();
              await context.read<ChallengeProvider>().reset();

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data has been reset'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset All'),
          ),
        ],
      ),
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
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
