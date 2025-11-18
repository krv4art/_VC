import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/subscription_service.dart';
import '../../providers/user_profile_provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRussian = context.watch<UserProfileProvider>().profile.preferredLanguage == 'ru';
    final subscriptionService = SubscriptionService();

    return Scaffold(
      appBar: AppBar(
        title: Text(isRussian ? 'AI Туtor Premium' : 'AI Tutor Premium'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Banner
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple[700]!,
                    Colors.blue[700]!,
                  ],
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium, size: 80, color: Colors.white),
                  const SizedBox(height: 16),
                  Text(
                    isRussian ? 'Станьте Premium!' : 'Go Premium!',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isRussian
                        ? 'Получите неограниченный доступ ко всем функциям'
                        : 'Get unlimited access to all features',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Features List
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isRussian ? 'Что включено:' : "What's included:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildFeature(context, '🤖', isRussian ? 'Безлимитные AI запросы' : 'Unlimited AI Requests'),
                  _buildFeature(context, '📊', isRussian ? 'Продвинутая аналитика' : 'Advanced Analytics'),
                  _buildFeature(context, '🎨', isRussian ? 'Кастомные темы' : 'Custom Themes'),
                  _buildFeature(context, '📴', isRussian ? 'Офлайн режим' : 'Offline Mode'),
                  _buildFeature(context, '🚫', isRussian ? 'Без рекламы' : 'No Ads'),
                  _buildFeature(context, '⚡', isRussian ? 'Приоритетная поддержка' : 'Priority Support'),
                  _buildFeature(context, '🎓', isRussian ? 'Эксклюзивный контент' : 'Exclusive Content'),
                  _buildFeature(context, '🏆', isRussian ? 'Специальные достижения' : 'Special Achievements'),
                ],
              ),
            ),

            // Pricing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildPricingCard(
                    context,
                    isRussian ? 'Месячная' : 'Monthly',
                    '\$4.99',
                    isRussian ? 'в месяц' : 'per month',
                    false,
                  ),
                  const SizedBox(height: 12),
                  _buildPricingCard(
                    context,
                    isRussian ? 'Годовая' : 'Annual',
                    '\$39.99',
                    isRussian ? 'в год (экономия 33%)' : 'per year (save 33%)',
                    true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // CTA Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Show offerings and purchase
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[700],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: Text(
                  isRussian ? 'Начать 7-дневную пробную версию' : 'Start 7-Day Free Trial',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Restore Purchases
            TextButton(
              onPressed: () async {
                await subscriptionService.restorePurchases();
              },
              child: Text(
                isRussian ? 'Восстановить покупки' : 'Restore Purchases',
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(BuildContext context, String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    BuildContext context,
    String title,
    String price,
    String period,
    bool isRecommended,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: isRecommended ? Colors.purple[700]! : Colors.grey[300]!,
          width: isRecommended ? 3 : 1,
        ),
        borderRadius: BorderRadius.circular(16),
        color: isRecommended ? Colors.purple[50] : null,
      ),
      child: Column(
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.purple[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'BEST VALUE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          if (isRecommended) const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
          Text(
            period,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
