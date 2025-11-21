import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/subscription_provider.dart';
import '../services/usage_tracking_service.dart';
import '../theme/theme_extensions_v2.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

/// Виджет для отображения индикатора использования для бесплатных пользователей
class UsageIndicatorWidget extends StatelessWidget {
  const UsageIndicatorWidget({
    super.key,
    this.showScans = true,
    this.showMessages = true,
    this.compact = false,
  });

  final bool showScans;
  final bool showMessages;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        // Не показываем для премиум пользователей
        if (subscriptionProvider.isPremium) {
          return const SizedBox.shrink();
        }

        return FutureBuilder(
          future: Future.wait([
            UsageTrackingService().getWeeklyScansCount(),
            UsageTrackingService().getDailyMessagesCount(),
            UsageTrackingService().getRemainingScanCount(),
            UsageTrackingService().getRemainingMessageCount(),
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            final scansCount = snapshot.data![0];
            final messagesCount = snapshot.data![1];
            final remainingScans = snapshot.data![2];
            final remainingMessages = snapshot.data![3];

            if (compact) {
              return _buildCompactIndicator(
                context,
                remainingScans,
                remainingMessages,
              );
            }

            return _buildFullIndicator(
              context,
              scansCount,
              messagesCount,
              remainingScans,
              remainingMessages,
            );
          },
        );
      },
    );
  }

  Widget _buildCompactIndicator(
    BuildContext context,
    int remainingScans,
    int remainingMessages,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final scansUsed = 5 - remainingScans;
    final messagesUsed = 5 - remainingMessages;

    return Center(
      child: GestureDetector(
        onTap: () => _showSubscriptionBenefitsModal(context),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.space12),
          decoration: BoxDecoration(
            color: context.colors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
            border: Border.all(
              color: context.colors.onSecondary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Заголовок
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: context.colors.onBackground.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: AppDimensions.space4),
                  Flexible(
                    child: Text(
                      l10n.usageLimitsBadge,
                      style: TextStyle(
                        fontSize: 11,
                        color: context.colors.onBackground.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.space8),

              // Прогресс-бары
              _buildCompactUsageItem(
                context,
                l10n.scansThisWeek,
                scansUsed,
                5,
                Icons.camera_alt_outlined,
                remainingScans <= 0,
              ),
              SizedBox(height: AppDimensions.space4),
              _buildCompactUsageItem(
                context,
                l10n.messagesToday,
                messagesUsed,
                5,
                Icons.chat_outlined,
                remainingMessages <= 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactUsageItem(
    BuildContext context,
    String title,
    int used,
    int limit,
    IconData icon,
    bool isLimitReached,
  ) {
    final progress = (used / limit).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: context.colors.onBackground.withValues(alpha: 0.7),
            ),
            SizedBox(width: AppDimensions.space4),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: context.colors.onBackground.withValues(alpha: 0.7),
                  height: 1.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '$used/$limit',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isLimitReached
                    ? context.colors.error
                    : context.colors.onBackground,
              ),
            ),
          ],
        ),
        SizedBox(height: 3),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.colors.onSecondary.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isLimitReached
                    ? context.colors.error
                    : progress > 0.7
                    ? context.colors.warning
                    : context.colors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFullIndicator(
    BuildContext context,
    int scansCount,
    int messagesCount,
    int remainingScans,
    int remainingMessages,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: EdgeInsets.all(AppDimensions.space16),
      padding: EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: context.colors.primary,
                size: AppDimensions.space16 + AppDimensions.space4,
              ),
              AppSpacer.h8(),
              Text(
                l10n.freePlanUsage,
                style: TextStyle(
                  fontSize: AppDimensions.iconSmall,
                  fontWeight: FontWeight.bold,
                  color: context.colors.onBackground,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showUpgradeDialog(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.radius12),
                  backgroundColor: context.colors.primary.withValues(
                    alpha: 0.1,
                  ),
                  foregroundColor: context.colors.primary,
                ),
                child: Text(l10n.upgradeToPremium),
              ),
            ],
          ),
          AppSpacer.v12(),

          // Сканирования
          if (showScans) ...[
            _buildUsageItem(
              context,
              l10n.scansThisWeek,
              scansCount,
              5,
              Icons.camera_alt_outlined,
              remainingScans <= 0,
            ),
            AppSpacer.v8(),
          ],

          // Сообщения в чате
          if (showMessages) ...[
            _buildUsageItem(
              context,
              l10n.messagesToday,
              messagesCount,
              5,
              Icons.chat_outlined,
              remainingMessages <= 0,
            ),
          ],

          // Информация об истории
          Container(
            margin: EdgeInsets.only(top: AppDimensions.radius12),
            padding: EdgeInsets.all(AppDimensions.radius12),
            decoration: BoxDecoration(
              color: context.colors.surface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.space8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.history_outlined,
                  size: AppDimensions.iconSmall,
                  color: context.colors.primary,
                ),
                AppSpacer.h8(),
                Expanded(
                  child: Text(
                    l10n.scanHistoryLimit,
                    style: TextStyle(
                      fontSize: AppDimensions.radius12,
                      color: context.colors.onBackground.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(
    BuildContext context,
    String title,
    int used,
    int limit,
    IconData icon,
    bool isLimitReached,
  ) {
    final progress = (used / limit).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: AppDimensions.iconSmall,
              color: context.colors.onBackground.withValues(alpha: 0.7),
            ),
            AppSpacer.h8(),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: context.colors.onBackground.withValues(alpha: 0.7),
              ),
            ),
            const Spacer(),
            Text(
              '$used/$limit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isLimitReached
                    ? context.colors.error
                    : context.colors.onBackground,
              ),
            ),
          ],
        ),
        AppSpacer.v4(),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: context.colors.onSecondary.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            isLimitReached
                ? context.colors.error
                : progress > 0.7
                ? context.colors.warning
                : context.colors.primary,
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(l10n.upgradeToPremium),
        content: Text(
          l10n.upgradeToPremiumDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              GoRouter.of(context).push('/modern-paywall');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colors.primary,
            ),
            child: Text(l10n.upgradeNow),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionBenefitsModal(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.only(
          top: AppDimensions.space24,
          left: AppDimensions.space24,
          right: AppDimensions.space24,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + AppDimensions.space24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              l10n.subscriptionBenefitsTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: context.colors.onBackground,
              ),
            ),
            AppSpacer.v8(),

            // Description
            Text(
              l10n.subscriptionBenefitsDescription,
              style: TextStyle(
                fontSize: 14,
                color: context.colors.onBackground.withValues(alpha: 0.7),
              ),
            ),
            AppSpacer.v24(),

            // Benefits list
            _buildBenefitItem(context, Icons.camera_alt, l10n.unlimitedScans, l10n.unlimitedScansDesc),
            AppSpacer.v16(),
            _buildBenefitItem(context, Icons.chat_bubble, l10n.unlimitedChats, l10n.unlimitedChatsDesc),
            AppSpacer.v16(),
            _buildBenefitItem(context, Icons.history, l10n.fullHistory, l10n.fullHistoryDesc),
            AppSpacer.v16(),
            _buildBenefitItem(context, Icons.memory, l10n.rememberContext, l10n.rememberContextDesc),
            AppSpacer.v16(),
            _buildBenefitItem(context, Icons.info_outline, l10n.allIngredientsInfo, l10n.allIngredientsInfoDesc),
            AppSpacer.v16(),
            _buildBenefitItem(context, Icons.block, l10n.noAds, l10n.noAdsDesc),
            AppSpacer.v24(),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.space16),
                    ),
                    child: Text(l10n.maybeLater),
                  ),
                ),
                AppSpacer.h16(),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(sheetContext).pop();
                      GoRouter.of(context).push('/modern-paywall');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      padding: EdgeInsets.symmetric(vertical: AppDimensions.space16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radius12),
                      ),
                    ),
                    child: Text(
                      l10n.getSubscription,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.space12),
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radius12),
          ),
          child: Icon(
            icon,
            color: context.colors.primary,
            size: AppDimensions.iconMedium,
          ),
        ),
        AppSpacer.h16(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.colors.onBackground,
                ),
              ),
              AppSpacer.v4(),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: context.colors.onBackground.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
