import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/collection_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Экран настроек
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSection(
            context,
            'Appearance',
            [
              _buildThemeSwitcher(context),
            ],
          ),
          _buildSection(
            context,
            'Collection',
            [
              _buildExportTile(context),
              _buildClearDataTile(context),
            ],
          ),
          _buildSection(
            context,
            'About',
            [
              _buildAboutTile(context),
              _buildShareAppTile(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _buildThemeSwitcher(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SwitchListTile(
          title: const Text('Dark Mode'),
          subtitle: const Text('Switch between light and dark themes'),
          secondary: Icon(
            themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
          value: themeProvider.isDarkMode,
          onChanged: (value) {
            themeProvider.toggleTheme();
          },
        );
      },
    );
  }

  Widget _buildExportTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.file_download),
      title: const Text('Export Collection'),
      subtitle: const Text('Export as PDF or CSV'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showExportDialog(context),
    );
  }

  Widget _buildClearDataTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete_outline, color: Colors.red),
      title: const Text('Clear All Data', style: TextStyle(color: Colors.red)),
      subtitle: const Text('Delete all coins from collection and wishlist'),
      onTap: () => _showClearDataDialog(context),
    );
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('About'),
      subtitle: const Text('Version 1.0.0'),
      onTap: () => _showAboutDialog(context),
    );
  }

  Widget _buildShareAppTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.share),
      title: const Text('Share App'),
      subtitle: const Text('Tell your friends about Coin Identifier'),
      onTap: () {
        Share.share(
          'Check out Coin Identifier - the best AI-powered coin identification app!',
        );
      },
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                _exportAsPDF(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                _exportAsCSV(context);
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

  Future<void> _exportAsPDF(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting as PDF...')),
    );

    // TODO: Implement PDF export
    // This will be implemented in the export service

    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF export feature coming soon!')),
      );
    }
  }

  Future<void> _exportAsCSV(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting as CSV...')),
    );

    // TODO: Implement CSV export
    // This will be implemented in the export service

    await Future.delayed(const Duration(seconds: 1));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CSV export feature coming soon!')),
      );
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all coins from your collection and wishlist. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CollectionProvider>().clearAll();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Coin Identifier',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.monetization_on, size: 48),
      children: [
        const SizedBox(height: 16),
        const Text(
          'AI-powered coin and banknote identifier with detailed information, '
          'rarity assessment, and market valuation.',
        ),
        const SizedBox(height: 16),
        const Text('Features:'),
        const SizedBox(height: 8),
        const Text('• AI-powered identification'),
        const Text('• Rarity and value assessment'),
        const Text('• Collection management'),
        const Text('• Wishlist tracking'),
        const Text('• Statistics and analytics'),
        const Text('• Export to PDF/CSV'),
      ],
    );
  }
}
