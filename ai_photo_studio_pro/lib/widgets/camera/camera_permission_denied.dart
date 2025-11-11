import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants/app_dimensions.dart';
import '../../../theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/theme_extensions_v2.dart';
import '../../../widgets/common/app_spacer.dart';

/// Widget displayed when camera permission is denied
class CameraPermissionDenied extends StatelessWidget {
  final VoidCallback onRetry;

  const CameraPermissionDenied({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: context.colors.background,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Warning icon
                Container(
                  width: AppDimensions.space64 + AppDimensions.space16,
                  height: AppDimensions.space64 + AppDimensions.space16,
                  decoration: BoxDecoration(
                    color: context.colors.warning.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    size: AppDimensions.iconLarge,
                    color: context.colors.warning,
                  ),
                ),
                AppSpacer.v32(),

                // Title
                Text(
                  l10n.cameraNotReady,
                  style: AppTheme.h2.copyWith(
                    color: context.colors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacer.v16(),

                // Instructions
                Text(
                  l10n.cameraPermissionInstructions,
                  style: AppTheme.body.copyWith(
                    color: context.colors.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacer.v32(),

                // Open Settings button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await openAppSettings();
                    },
                    icon: Icon(Icons.settings, color: Colors.white),
                    label: Text(
                      l10n.openSettingsAndGrantAccess,
                      style: AppTheme.buttonText.copyWith(
                        fontSize: AppDimensions.space16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.space24,
                        vertical: AppDimensions.space16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius24,
                        ),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                AppSpacer.v16(),

                // Retry button
                TextButton(
                  onPressed: onRetry,
                  child: Text(
                    l10n.retryCamera,
                    style: AppTheme.body.copyWith(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
