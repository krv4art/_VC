import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';
import '../../widgets/animated/animated_card.dart';
import '../../l10n/app_localizations.dart';

/// Callback when disclaimer is dismissed
typedef OnDisclaimerDismissed = Future<void> Function();

/// A reusable AI disclaimer banner widget with animations
class DisclaimerBanner extends StatelessWidget {
  final Animation<double> animation;
  final OnDisclaimerDismissed onDismissed;

  const DisclaimerBanner({
    Key? key,
    required this.animation,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Dismissible(
              key: const Key('ai_disclaimer'),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                await onDismissed();
              },
              background: Container(
                color: Colors.transparent,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(
                  right: AppDimensions.space24,
                ),
                child: Icon(
                  Icons.swipe_left,
                  color:
                      context.colors.onSecondary.withValues(alpha: 0.5),
                ),
              ),
              child: AnimatedCard(
                elevation: 1,
                margin: EdgeInsets.symmetric(
                  horizontal: AppDimensions.space4,
                  vertical: AppDimensions.space4,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    AppDimensions.space12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.aiDisclaimer,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppDimensions.radius12,
                            color: context.colors.onSecondary,
                          ),
                        ),
                      ),
                      AppSpacer.h8(),
                      Icon(
                        Icons.swipe_left,
                        size: AppDimensions.iconSmall,
                        color: context.colors.onSecondary
                            .withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
