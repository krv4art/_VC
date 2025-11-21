import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import 'common/app_spacer.dart';

/// Soft paywall dialog - показывается после 3-го использования
/// Можно закрыть и продолжить использовать приложение
class SoftPaywallDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String type, // 'scan' or 'message'
    required int remaining, // сколько осталось попыток
  }) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        final colors = dialogContext.colors;

        return Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radius24),
          ),
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.space24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      icon: Icon(
                        Icons.close,
                        color: colors.onSecondary,
                        size: AppDimensions.iconMedium,
                      ),
                    ),
                  ],
                ),

                // Icon with gradient background
                Container(
                  width: AppDimensions.space64 + AppDimensions.space16,
                  height: AppDimensions.space64 + AppDimensions.space16,
                  decoration: BoxDecoration(
                    gradient: colors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    type == 'scan' ? Icons.camera_alt : Icons.chat_bubble,
                    size: AppDimensions.iconLarge,
                    color: Colors.white,
                  ),
                ),
                AppSpacer.v24(),

                // Title
                Text(
                  type == 'scan'
                      ? l10n.enjoyingScanning
                      : l10n.enjoyingChat,
                  style: TextStyle(
                    fontSize: AppDimensions.space16 + AppDimensions.space8,
                    fontWeight: FontWeight.bold,
                    color: colors.onBackground,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacer.v12(),

                // Description
                Text(
                  type == 'scan'
                      ? l10n.softPaywallScanMessage(remaining)
                      : l10n.softPaywallMessageMessage(remaining),
                  style: TextStyle(
                    fontSize: AppDimensions.iconSmall,
                    color: colors.onSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacer.v24(),

                // Benefits list
                Container(
                  padding: EdgeInsets.all(AppDimensions.space16),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radius12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBenefit(
                        context,
                        Icons.all_inclusive,
                        l10n.unlimitedScansAndChat,
                        colors,
                      ),
                      AppSpacer.v8(),
                      _buildBenefit(
                        context,
                        Icons.history,
                        l10n.fullScanHistory,
                        colors,
                      ),
                      AppSpacer.v8(),
                      _buildBenefit(
                        context,
                        Icons.block,
                        l10n.adFreeExperience,
                        colors,
                      ),
                    ],
                  ),
                ),
                AppSpacer.v24(),

                // Upgrade button
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonLarge,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(true);
                      context.push('/modern-paywall');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radius12,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      l10n.tryPremium,
                      style: TextStyle(
                        fontSize: AppDimensions.space16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                AppSpacer.v12(),

                // Continue with free button
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(
                    l10n.continueWithFree,
                    style: TextStyle(
                      color: colors.onSecondary,
                      fontSize: AppDimensions.iconSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildBenefit(
    BuildContext context,
    IconData icon,
    String text,
    ThemeColors colors,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppDimensions.space16 + AppDimensions.space4,
          color: colors.primary,
        ),
        AppSpacer.h12(),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: colors.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
