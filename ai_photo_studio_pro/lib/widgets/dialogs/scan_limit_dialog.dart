import 'package:flutter/material.dart';
import '../../../theme/theme_extensions_v2.dart';
import '../../../l10n/app_localizations.dart';

/// Dialog shown when user reaches scan limit
class ScanLimitDialog extends StatelessWidget {
  const ScanLimitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lock, color: context.colors.warning),
          const SizedBox(width: 12),
          Text(l10n.scanLimitReached),
        ],
      ),
      content: Text(l10n.scanLimitReachedMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colors.primary,
          ),
          child: Text(l10n.upgradeToPremium),
        ),
      ],
    );
  }

  /// Shows the scan limit dialog and returns whether user wants to upgrade
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ScanLimitDialog(),
    );
  }
}
