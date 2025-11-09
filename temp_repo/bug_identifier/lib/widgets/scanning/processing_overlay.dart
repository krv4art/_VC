import 'package:flutter/material.dart';
import '../../../constants/app_dimensions.dart';
import '../../../theme/theme_extensions_v2.dart';
import '../../../widgets/animated/animated_card.dart';
import '../../../widgets/common/app_spacer.dart';
import '../../../l10n/app_localizations.dart';

/// Overlay widget displayed during image processing
class ProcessingOverlay extends StatelessWidget {
  final bool showSlowInternetMessage;

  const ProcessingOverlay({super.key, required this.showSlowInternetMessage});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FadeTransition(
      opacity: const AlwaysStoppedAnimation<double>(1.0),
      child: Center(
        child: AnimatedCard(
          elevation: 4,
          backgroundColor: context.colors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radius16),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: context.colors.primary),
                AppSpacer.v16(),
                Text(
                  l10n.analyzingPleaseWait,
                  style: TextStyle(
                    color: context.colors.onBackground,
                    fontSize: AppDimensions.space16,
                  ),
                ),
                if (showSlowInternetMessage) ...[
                  AppSpacer.v16(),
                  Container(
                    padding: EdgeInsets.all(AppDimensions.space12),
                    decoration: BoxDecoration(
                      color: context.colors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radius8,
                      ),
                      border: Border.all(
                        color: context.colors.warning.withValues(alpha: 0.3),
                        width: AppDimensions.space4 / 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: context.colors.warning,
                          size: AppDimensions.iconMedium,
                        ),
                        AppSpacer.h8(),
                        Flexible(
                          child: Text(
                            l10n.slowInternetMessage,
                            style: TextStyle(
                              color: context.colors.warning,
                              fontSize:
                                  AppDimensions.space8 +
                                  AppDimensions.space8 -
                                  2.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
