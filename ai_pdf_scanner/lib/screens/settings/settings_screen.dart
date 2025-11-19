import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dimensions.dart';
import '../../providers/app_state_provider.dart';

/// Settings screen - App configuration and preferences
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'AI PDF Scanner Privacy Policy\n\n'
            '1. Data Collection: We do not collect or store your personal data. '
            'All document processing is done locally on your device.\n\n'
            '2. AI Processing: When using AI features, document images are sent to '
            'Google Gemini API via secure Supabase Edge Functions. Images are not stored.\n\n'
            '3. Local Storage: All PDFs and scans are stored locally on your device. '
            'You have full control over your data.\n\n'
            '4. No Third-Party Tracking: We do not use analytics or tracking services.\n\n'
            '5. Your Rights: You can delete all data at any time by uninstalling the app.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'AI PDF Scanner Terms of Service\n\n'
            '1. License: This app is provided as-is for personal and commercial use.\n\n'
            '2. Disclaimer: We are not responsible for any data loss or corruption. '
            'Please backup important documents.\n\n'
            '3. AI Features: AI analysis results are not guaranteed to be 100% accurate. '
            'Please verify important information.\n\n'
            '4. Usage: You agree not to use this app for illegal purposes.\n\n'
            '5. Changes: We reserve the right to update these terms at any time.\n\n'
            'Last updated: November 2025',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          // Appearance section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: appState.isDarkMode,
            onChanged: (value) => appState.toggleTheme(),
          ),
          const Divider(),

          // AI Features section
          _buildSectionHeader(context, 'AI Features'),
          SwitchListTile(
            title: const Text('Enable AI'),
            subtitle: const Text('Use AI for document analysis'),
            value: appState.isAIEnabled,
            onChanged: (value) => appState.toggleAI(),
          ),
          const Divider(),

          // About section
          _buildSectionHeader(context, 'About'),
          ListTile(
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showPrivacyPolicy(context),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showTerms(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.space8,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
