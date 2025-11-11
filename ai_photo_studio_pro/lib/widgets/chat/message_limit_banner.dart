import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../services/usage_tracking_service.dart';
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

        return ChatBanner(
          icon: remaining <= 1
              ? Icons.warning_amber_rounded
              : Icons.chat_bubble_outline,
          title: '$remaining ${l10n.messagesLeftToday}',
          actionLabel: remaining <= 2 ? l10n.upgradeToPremium : null,
          onActionPressed: remaining <= 2 ? onUpgradePressed : null,
          bannerType: remaining <= 1 ? BannerType.warning : BannerType.info,
        );
      },
    );
  }
}
