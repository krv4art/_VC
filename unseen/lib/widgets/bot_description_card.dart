import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ai_bot_provider.dart';
import '../widgets/animated/animated_card.dart';
import '../l10n/app_localizations.dart';
import '../constants/app_dimensions.dart';

class BotDescriptionCard extends StatelessWidget {
  const BotDescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<AiBotProvider>(
      builder: (context, provider, child) {
        // Используем локализованное описание с подстановкой имени бота
        final localizedDescription = l10n.defaultBotDescription(
          provider.botName,
        );

        return AnimatedCard(
          margin: EdgeInsets.symmetric(vertical: AppDimensions.space8),
          padding: EdgeInsets.all(AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        );
      },
    );
  }
}
