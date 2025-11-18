import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(isRussian ? 'Условия использования' : 'Terms of Service'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRussian ? 'Условия использования AI Репетитор' : 'AI Tutor Terms of Service',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              isRussian ? 'Последнее обновление: Ноябрь 2024' : 'Last updated: November 2024',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              isRussian ? '1. Принятие условий' : '1. Acceptance of Terms',
              isRussian
                  ? 'Используя AI Репетитор, вы соглашаетесь с этими условиями использования.'
                  : 'By using AI Tutor, you agree to these terms of service.',
            ),
            _buildSection(
              context,
              isRussian ? '2. Использование сервиса' : '2. Use of Service',
              isRussian
                  ? 'Вы соглашаетесь использовать AI Репетитор только в образовательных целях.'
                  : 'You agree to use AI Tutor for educational purposes only.',
            ),
            _buildSection(
              context,
              isRussian ? '3. Учетная запись' : '3. Account',
              isRussian
                  ? 'Вы несете ответственность за сохранность вашей учетной записи и пароля.'
                  : 'You are responsible for maintaining your account and password security.',
            ),
            _buildSection(
              context,
              isRussian ? '4. Подписки' : '4. Subscriptions',
              isRussian
                  ? 'Подписки оплачиваются через магазин приложений и могут быть отменены в любое время.'
                  : 'Subscriptions are billed through the app store and can be cancelled at any time.',
            ),
            _buildSection(
              context,
              isRussian ? '5. Ограничение ответственности' : '5. Limitation of Liability',
              isRussian
                  ? 'AI Репетитор предоставляется "как есть" без каких-либо гарантий.'
                  : 'AI Tutor is provided "as is" without any warranties.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
