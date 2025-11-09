import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'uk';
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Налаштування'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  value: _darkMode,
                  onChanged: (value) => setState(() => _darkMode = value),
                  title: const Text('Темна тема'),
                  subtitle: const Text('Автоматична зміна'),
                  secondary: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
                  activeColor: AppTheme.primaryPurple,
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Мова'),
                  subtitle: Text(_language == 'uk' ? 'Українська' : _language == 'ru' ? 'Русский' : 'English'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Виберіть мову'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile(
                              value: 'uk',
                              groupValue: _language,
                              title: const Text('Українська'),
                              onChanged: (value) {
                                setState(() => _language = value!);
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              value: 'ru',
                              groupValue: _language,
                              title: const Text('Русский'),
                              onChanged: (value) {
                                setState(() => _language = value!);
                                Navigator.pop(context);
                              },
                            ),
                            RadioListTile(
                              value: 'en',
                              groupValue: _language,
                              title: const Text('English'),
                              onChanged: (value) {
                                setState(() => _language = value!);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.card_membership, color: AppTheme.primaryPurple),
                  title: const Text('Підписка'),
                  subtitle: const Text('Free · 5 задач на день'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Оформлення підписки скоро буде доступне')),
                    );
                  },
                ),
              ],
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Про додаток'),
                  subtitle: const Text('MAS v1.0.0'),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'MAS',
                      applicationVersion: '1.0.0',
                      applicationLegalese: '© 2025 Math AI Solver Team',
                      children: [
                        const SizedBox(height: 16),
                        const Text('Математичний AI-асистент для розв\'язування задач'),
                      ],
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Політика конфіденційності'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Умови використання'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
