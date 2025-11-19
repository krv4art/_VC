import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Introduction',
              'AI Background Remover ("we", "our", or "us") respects your privacy and is committed to protecting your personal data. This privacy policy will inform you about how we handle your personal data when you use our application.',
            ),
            _buildSection(
              'Information We Collect',
              'We collect the following types of information:\n\n'
                  '• Images you upload for processing\n'
                  '• Device information (OS version, device model)\n'
                  '• Usage analytics (features used, processing time)\n'
                  '• Crash reports and error logs\n'
                  '• Premium subscription information',
            ),
            _buildSection(
              'How We Use Your Information',
              'We use your information to:\n\n'
                  '• Process your images for background removal\n'
                  '• Improve our AI algorithms and services\n'
                  '• Provide customer support\n'
                  '• Send service updates and notifications\n'
                  '• Process payments for premium features',
            ),
            _buildSection(
              'Data Storage and Security',
              'Your processed images are stored temporarily on your device. We implement appropriate security measures to protect your data. Images uploaded for AI processing are deleted from our servers within 24 hours.',
            ),
            _buildSection(
              'Third-Party Services',
              'We use the following third-party services:\n\n'
                  '• Firebase Analytics - Usage analytics\n'
                  '• Firebase Crashlytics - Error reporting\n'
                  '• RevenueCat - Subscription management\n'
                  '• Google AdMob - Advertising (free tier)\n'
                  '• Remove.bg API - Background removal (optional)',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
                  '• Access your personal data\n'
                  '• Request deletion of your data\n'
                  '• Opt-out of analytics\n'
                  '• Withdraw consent at any time',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Our app is not intended for children under 13. We do not knowingly collect data from children under 13.',
            ),
            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy in the app.',
            ),
            _buildSection(
              'Contact Us',
              'If you have questions about this privacy policy, please contact us at:\n\n'
                  'Email: support@aibackgroundremover.com',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
