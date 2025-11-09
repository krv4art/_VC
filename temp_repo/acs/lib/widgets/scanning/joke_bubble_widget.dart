import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';
import '../../../theme/theme_extensions_v2.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/animated/animated_ai_avatar.dart';
import '../../../widgets/common/app_spacer.dart';

/// Widget that displays a joke bubble with bot avatar
class JokeBubbleWidget extends StatelessWidget {
  final String jokeText;
  final String botName;
  final VoidCallback onDismiss;

  const JokeBubbleWidget({
    super.key,
    required this.jokeText,
    required this.botName,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimensions.space16,
      left: AppDimensions.space16,
      right: AppDimensions.space16,
      child: Dismissible(
        key: const Key('joke_bubble'),
        direction: DismissDirection.horizontal,
        onDismissed: (direction) {
          onDismiss();
        },
        child: Container(
          padding: EdgeInsets.all(AppDimensions.space16),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radius16),
            boxShadow: [AppTheme.softShadow],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок с анимированным аватаром
              Row(
                children: [
                  AnimatedAiAvatar(
                    size: AppDimensions.space40,
                    state: AvatarAnimationState.idle,
                    colors: context.colors.currentColors,
                  ),
                  AppSpacer.h12(),
                  // Имя бота
                  Expanded(
                    child: Text(
                      botName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  AppSpacer.h12(),
                  GestureDetector(
                    onTap: onDismiss,
                    child: Icon(
                      Icons.close,
                      size: AppDimensions.iconSmall + 4.0,
                      color: context.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
              AppSpacer.v12(),
              // Текст шутки
              Text(
                jokeText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurface,
                  height: 1.5,
                ),
              ),
              AppSpacer.v12(),
              // Иконка свайпа по центру
              Center(
                child: Icon(
                  Icons.swipe_left,
                  size: AppDimensions.iconMedium,
                  color: context.colors.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
