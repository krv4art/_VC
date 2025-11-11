import 'package:flutter/material.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';

class SurveyDialog extends StatefulWidget {
  const SurveyDialog({super.key});

  @override
  State<SurveyDialog> createState() => _SurveyDialogState();
}

class _SurveyDialogState extends State<SurveyDialog> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final options = [
      l10n.surveyOption1,
      l10n.surveyOption2,
      l10n.surveyOption3,
      l10n.surveyOption4,
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.poll, size: 32),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Text(
                    l10n.surveyTitle,
                    style: AppTheme.h3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.space16),
            Text(
              l10n.surveyQuestion,
              style: AppTheme.body,
            ),
            const SizedBox(height: AppDimensions.space16),
            ...options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              return RadioListTile<int>(
                contentPadding: EdgeInsets.zero,
                title: Text(option),
                value: index,
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
              );
            }),
            const SizedBox(height: AppDimensions.space16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedOption == null
                    ? null
                    : () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.surveyThankYou)),
                        );
                      },
                child: Text(l10n.surveySubmit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
