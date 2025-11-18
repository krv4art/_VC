import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/user_profile_provider.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  Offerings? _offerings;
  bool _isLoading = true;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _loadOfferings();
  }

  Future<void> _loadOfferings() async {
    setState(() => _isLoading = true);

    final subscriptionProvider = context.read<SubscriptionProvider>();
    final offerings = await subscriptionProvider.getOfferings();

    setState(() {
      _offerings = offerings;
      _isLoading = false;
    });
  }

  Future<void> _purchasePackage(Package package) async {
    setState(() => _isPurchasing = true);

    final subscriptionProvider = context.read<SubscriptionProvider>();
    final success = await subscriptionProvider.purchase(package);

    setState(() => _isPurchasing = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRussian ? 'Подписка успешно оформлена!' : 'Subscription successful!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRussian ? 'Ошибка оформления подписки' : 'Purchase failed',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _restorePurchases() async {
    setState(() => _isPurchasing = true);

    final subscriptionProvider = context.read<SubscriptionProvider>();
    final success = await subscriptionProvider.restorePurchases();

    setState(() => _isPurchasing = false);

    if (!mounted) return;

    if (success && subscriptionProvider.isPremium) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRussian ? 'Покупки восстановлены!' : 'Purchases restored!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isRussian ? 'Нет покупок для восстановления' : 'No purchases to restore',
          ),
        ),
      );
    }
  }

  bool get _isRussian =>
      context.read<UserProfileProvider>().profile.preferredLanguage == 'ru';

  @override
  Widget build(BuildContext context) {
    final subscriptionProvider = context.watch<SubscriptionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isRussian ? 'AI Репетитор Premium' : 'AI Tutor Premium'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                        const Icon(Icons.workspace_premium,
                            size: 80, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          _isRussian ? 'Станьте Premium!' : 'Go Premium!',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isRussian
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
                          _isRussian ? 'Что включено:' : "What's included:",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildFeature(context, '🤖',
                            _isRussian ? 'Безлимитные AI запросы' : 'Unlimited AI Requests'),
                        _buildFeature(context, '✨',
                            _isRussian ? 'Безлимитные трансформации задач' : 'Unlimited Problem Transformations'),
                        _buildFeature(context, '🧠',
                            _isRussian ? 'Неограниченные тренировки мозга' : 'Unlimited Brain Training'),
                        _buildFeature(context, '📊',
                            _isRussian ? 'Продвинутая аналитика' : 'Advanced Analytics'),
                        _buildFeature(context, '👥',
                            _isRussian ? 'Социальные функции' : 'Social Features'),
                        _buildFeature(context, '🎨',
                            _isRussian ? 'Кастомные темы' : 'Custom Themes'),
                        _buildFeature(context, '📴',
                            _isRussian ? 'Офлайн режим' : 'Offline Mode'),
                        _buildFeature(context, '🚫',
                            _isRussian ? 'Без рекламы' : 'No Ads'),
                        _buildFeature(context, '⚡',
                            _isRussian ? 'Приоритетная поддержка' : 'Priority Support'),
                        _buildFeature(context, '🎓',
                            _isRussian ? 'Эксклюзивный контент' : 'Exclusive Content'),
                      ],
                    ),
                  ),

                  // Offerings
                  if (_offerings != null &&
                      _offerings!.current != null &&
                      _offerings!.current!.availablePackages.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: _offerings!.current!.availablePackages
                            .map((package) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _buildPackageCard(package),
                                ))
                            .toList(),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _isRussian
                            ? 'Не удалось загрузить предложения'
                            : 'Failed to load offerings',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Restore Purchases
                  TextButton(
                    onPressed: _isPurchasing ? null : _restorePurchases,
                    child: Text(
                      _isRussian ? 'Восстановить покупки' : 'Restore Purchases',
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Loading indicator during purchase
                  if (_isPurchasing)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
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

  Widget _buildPackageCard(Package package) {
    final isAnnual = package.packageType == PackageType.annual;
    final isMonthly = package.packageType == PackageType.monthly;

    return InkWell(
      onTap: _isPurchasing ? null : () => _purchasePackage(package),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isAnnual ? Colors.purple[700]! : Colors.grey[300]!,
            width: isAnnual ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: isAnnual ? Colors.purple[50] : null,
        ),
        child: Column(
          children: [
            if (isAnnual)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple[700],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isRussian ? 'ЛУЧШЕЕ ПРЕДЛОЖЕНИЕ' : 'BEST VALUE',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            if (isAnnual) const SizedBox(height: 12),
            Text(
              package.storeProduct.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              package.storeProduct.priceString,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            if (package.storeProduct.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                package.storeProduct.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isPurchasing ? null : () => _purchasePackage(package),
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnnual ? Colors.purple[700] : null,
                foregroundColor: isAnnual ? Colors.white : null,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                _isRussian ? 'Выбрать' : 'Select',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
