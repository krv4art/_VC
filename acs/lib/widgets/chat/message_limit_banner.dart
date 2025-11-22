import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../services/usage_tracking_service.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../common/app_spacer.dart';
import 'chat_banner.dart';

/// Баннер с информацией об оставшихся бесплатных сообщениях
/// Показывается только для не-Premium пользователей
class MessageLimitBanner extends StatelessWidget {
  final VoidCallback onUpgradePressed;

  const MessageLimitBanner({
    super.key,
    required this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<int>(
      future: UsageTrackingService().getDailyMessagesCount(),
      builder: (context, snapshot) {
        // Не показываем баннер пока загружаются данные
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final count = snapshot.data!;
        final remaining = UsageTrackingService.freeMessagesPerDay - count;

        return GestureDetector(
          onTap: () => _showSubscriptionBenefitsModal(context),
          child: ChatBanner(
            icon: remaining <= 1
                ? Icons.warning_amber_rounded
                : Icons.chat_bubble_outline,
            title: '$remaining ${l10n.messagesLeftToday}',
            actionLabel: remaining <= 2 ? l10n.upgradeToPremium : null,
            onActionPressed: remaining <= 2 ? () => _showSubscriptionBenefitsModal(context) : null,
            bannerType: remaining <= 1 ? BannerType.warning : BannerType.info,
          ),
        );
      },
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
