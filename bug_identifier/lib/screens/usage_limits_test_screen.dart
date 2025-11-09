import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';
import '../services/usage_tracking_service.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/scaffold_with_drawer.dart';
import '../widgets/bottom_navigation_wrapper.dart';

/// Тестовый экран для проверки статуса подписки и лимитов
class UsageLimitsTestScreen extends StatefulWidget {
  const UsageLimitsTestScreen({super.key});

  @override
  State<UsageLimitsTestScreen> createState() => _UsageLimitsTestScreenState();
}

class _UsageLimitsTestScreenState extends State<UsageLimitsTestScreen> {
  int _scansCount = 0;
  int _messagesCount = 0;
  int _scansRemaining = 0;
  int _messagesRemaining = 0;

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    final scans = await UsageTrackingService().getWeeklyScansCount();
    final messages = await UsageTrackingService().getDailyMessagesCount();
    final scansRem = await UsageTrackingService().getRemainingScanCount();
    final messagesRem = await UsageTrackingService().getRemainingMessageCount();

    setState(() {
      _scansCount = scans;
      _messagesCount = messages;
      _scansRemaining = scansRem;
      _messagesRemaining = messagesRem;
    });
  }

  Future<void> _incrementScans() async {
    await UsageTrackingService().incrementScansCount();
    await _loadCounts();
  }

  Future<void> _incrementMessages() async {
    await UsageTrackingService().incrementMessagesCount();
    await _loadCounts();
  }

  Future<void> _resetScans() async {
    await UsageTrackingService().resetWeeklyScansCount();
    await _loadCounts();
  }

  Future<void> _resetMessages() async {
    await UsageTrackingService().resetDailyMessagesCount();
    await _loadCounts();
  }

  Future<void> _resetAll() async {
    await UsageTrackingService().resetAllCounters();
    await _loadCounts();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationWrapper(
      currentIndex: -1,
      child: ScaffoldWithDrawer(
        appBar: CustomAppBar(
          title: 'Subscription Test',
          showBackButton: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<SubscriptionProvider>(
            builder: (context, subscriptionProvider, _) {
              final isPremium = subscriptionProvider.isPremium;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Статус подписки
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Icon(
                            isPremium ? Icons.star : Icons.star_border,
                            size: 60,
                            color: isPremium ? Colors.amber : context.colors.neutral,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Premium Status',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colors.onBackground.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isPremium ? 'ACTIVE' : 'INACTIVE',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isPremium ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Счетчик сканов
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.qr_code_scanner, color: context.colors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Weekly Scans',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.onBackground,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Used: $_scansCount / 5',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remaining: $_scansRemaining',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.colors.onBackground.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _incrementScans,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Scan'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _resetScans,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Reset'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Счетчик сообщений
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.chat_bubble_outline, color: context.colors.primary),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Messages',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: context.colors.onBackground,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Used: $_messagesCount / 5',
                            style: TextStyle(
                              fontSize: 16,
                              color: context.colors.onBackground,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Remaining: $_messagesRemaining',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.colors.onBackground.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: _incrementMessages,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add Message'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _resetMessages,
                                  icon: const Icon(Icons.refresh, size: 18),
                                  label: const Text('Reset'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Кнопка сброса всего
                  OutlinedButton.icon(
                    onPressed: _resetAll,
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset All Counters'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: context.colors.error),
                      foregroundColor: context.colors.error,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Кнопка перехода на Paywall
                  ElevatedButton(
                    onPressed: () => context.push('/modern-paywall'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      isPremium ? 'View Subscription Details' : 'Upgrade to Premium',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
