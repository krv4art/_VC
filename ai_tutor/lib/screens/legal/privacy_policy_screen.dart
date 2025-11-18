import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_profile_provider.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';

    return Scaffold(
      appBar: AppBar(
        title: Text(isRussian ? 'Политика конфиденциальности' : 'Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isRussian ? 'Политика конфиденциальности AI Репетитор' : 'AI Tutor Privacy Policy',
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
              isRussian ? '1. Собираемая информация' : '1. Information We Collect',
              isRussian
                  ? 'Мы собираем информацию, которую вы предоставляете при регистрации, включая имя, email и предпочтения обучения.'
                  : 'We collect information you provide during registration, including name, email, and learning preferences.',
            ),
            _buildSection(
              context,
              isRussian ? '2. Использование данных' : '2. Use of Data',
              isRussian
                  ? 'Ваши данные используются для персонализации обучения, отслеживания прогресса и улучшения сервиса.'
                  : 'Your data is used to personalize learning, track progress, and improve our service.',
            ),
            _buildSection(
              context,
              isRussian ? '3. Хранение данных' : '3. Data Storage',
              isRussian
                  ? 'Данные хранятся локально на вашем устройстве и опционально синхронизируются с облаком.'
                  : 'Data is stored locally on your device and optionally synced with the cloud.',
            ),
            _buildSection(
              context,
              isRussian ? '4. Защита данных' : '4. Data Protection',
              isRussian
                  ? 'Мы используем современные методы шифрования и безопасности для защиты ваших данных.'
                  : 'We use modern encryption and security methods to protect your data.',
            ),
            _buildSection(
              context,
              isRussian ? '5. Ваши права' : '5. Your Rights',
              isRussian
                  ? 'Вы можете в любое время запросить доступ, изменение или удаление ваших данных.'
                  : 'You can request access, modification, or deletion of your data at any time.',
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
