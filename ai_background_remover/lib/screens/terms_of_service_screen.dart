import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service',
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
              'Acceptance of Terms',
              'By accessing and using AI Background Remover, you accept and agree to be bound by the terms and provisions of this agreement. If you do not agree to these terms, please do not use our service.',
            ),
            _buildSection(
              'Use License',
              'Permission is granted to use AI Background Remover for personal and commercial purposes. This license shall automatically terminate if you violate any of these restrictions.',
            ),
            _buildSection(
              'Free and Premium Features',
              'Free tier users:\n'
                  '• Limited to 5 image processes per day\n'
                  '• Standard quality exports\n'
                  '• Ad-supported experience\n\n'
                  'Premium subscribers:\n'
                  '• Unlimited image processing\n'
                  '• High-quality exports\n'
                  '• Priority processing\n'
                  '• Ad-free experience\n'
                  '• Cloud storage integration',
            ),
            _buildSection(
              'Subscription Terms',
              'Premium subscriptions are billed monthly or annually. Your subscription will automatically renew unless cancelled at least 24 hours before the end of the current period. Refunds are not provided for partial subscription periods.',
            ),
            _buildSection(
              'User Content',
              'You retain all rights to images you upload. By using our service, you grant us permission to process your images solely for the purpose of providing our background removal service. We do not claim ownership of your content.',
            ),
            _buildSection(
              'Prohibited Uses',
              'You may not:\n\n'
                  '• Upload illegal, offensive, or copyrighted content\n'
                  '• Attempt to reverse-engineer our AI models\n'
                  '• Use the service for automated bulk processing beyond subscription limits\n'
                  '• Resell or redistribute processed images as a service\n'
                  '• Interfere with or disrupt the service',
            ),
            _buildSection(
              'Disclaimer',
              'This service is provided "as is" without warranties of any kind. We do not guarantee that the service will be uninterrupted or error-free. AI results may vary in quality.',
            ),
            _buildSection(
              'Limitation of Liability',
              'We shall not be liable for any damages arising from the use or inability to use our service, including but not limited to data loss, business interruption, or loss of profits.',
            ),
            _buildSection(
              'Data Privacy',
              'Your use of the service is also governed by our Privacy Policy. We process your data in accordance with applicable data protection laws.',
            ),
            _buildSection(
              'Modifications',
              'We reserve the right to modify these terms at any time. We will notify users of significant changes. Continued use of the service after changes constitutes acceptance of the new terms.',
            ),
            _buildSection(
              'Termination',
              'We may terminate or suspend your access to the service immediately, without prior notice, for conduct that we believe violates these terms or is harmful to other users.',
            ),
            _buildSection(
              'Governing Law',
              'These terms shall be governed by and construed in accordance with applicable laws, without regard to conflict of law provisions.',
            ),
            _buildSection(
              'Contact Information',
              'For questions about these Terms of Service, please contact us at:\n\n'
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
