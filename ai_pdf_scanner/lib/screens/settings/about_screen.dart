import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_dimensions.dart';

/// About Screen - App information and credits
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.space16),
        children: [
          // App icon and name
          Center(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppDimensions.radius24),
                  ),
                  child: Icon(
                    Icons.document_scanner,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: AppDimensions.space16),
                Text(
                  'AI PDF Scanner',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  'Version 1.0.0',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space32),

          // Description
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About the App',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  Text(
                    'AI PDF Scanner is a powerful document scanning and management app with AI-powered features. Scan, edit, convert, and organize your PDFs with ease.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Features
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Features',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  _buildFeature(
                    context,
                    Icons.camera_alt,
                    'AI-Powered Scanning',
                    'Automatic edge detection and image enhancement',
                  ),
                  _buildFeature(
                    context,
                    Icons.text_fields,
                    'OCR Technology',
                    '95%+ accuracy text recognition',
                  ),
                  _buildFeature(
                    context,
                    Icons.edit,
                    'Advanced Editing',
                    'Annotations, signatures, and more',
                  ),
                  _buildFeature(
                    context,
                    Icons.transform,
                    'File Conversion',
                    'Convert between PDF, images, and Office formats',
                  ),
                  _buildFeature(
                    context,
                    Icons.compress,
                    'PDF Tools',
                    'Merge, split, compress, and optimize PDFs',
                  ),
                  _buildFeature(
                    context,
                    Icons.security,
                    'Privacy First',
                    'All processing done locally on your device',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          // Links
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _launchURL(context, 'https://example.com/privacy'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _launchURL(context, 'https://example.com/terms'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Open Source Licenses'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showLicenses(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Report a Bug'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _launchURL(
                    context,
                    'https://github.com/your-repo/issues',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star),
                  title: const Text('Rate Us'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _rateApp(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space32),

          // Credits
          Center(
            child: Column(
              children: [
                Text(
                  'Made with ❤️ using Flutter',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Text(
                  '© 2024 AI PDF Scanner. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space32),
        ],
      ),
    );
  }

  Widget _buildFeature(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppDimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withOpacity(0.6),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'AI PDF Scanner',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.document_scanner, size: 48),
    );
  }

  void _rateApp(BuildContext context) {
    // TODO: Implement app rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your interest!')),
    );
  }
}
