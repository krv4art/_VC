import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../l10n/app_localizations.dart';
import '../../constants/app_dimensions.dart';

/// Dialog showing scanning tips and instructions with visual guide
class ScanningHintDialog extends StatelessWidget {
  const ScanningHintDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.space16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.colors.primary,
                    size: AppDimensions.iconLarge,
                  ),
                  SizedBox(width: AppDimensions.space12),
                  Expanded(
                    child: Text(
                      l10n.scanningHintTitle,
                      style: TextStyle(
                        fontSize: AppDimensions.space16 + 2,
                        fontWeight: FontWeight.bold,
                        color: context.colors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppDimensions.space16),

              // Tip image
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.space12),
                child: Image.asset(
                  'assets/images/tip_for_scanning.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              SizedBox(height: AppDimensions.space16),

              // Instructions text
              Container(
                padding: EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.space8),
                  border: Border.all(
                    color: context.colors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  l10n.positionTheLabelWithinTheFrame,
                  style: TextStyle(
                    fontSize: AppDimensions.space12 + 2,
                    color: context.colors.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.space16 + AppDimensions.space4),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.close,
                        style: TextStyle(
                          color: context.colors.primary,
                          fontSize: AppDimensions.space12 + 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows the scanning hint dialog
  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const ScanningHintDialog(),
    );
  }
}
