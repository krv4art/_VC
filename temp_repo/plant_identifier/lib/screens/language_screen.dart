import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

/// Language selection screen
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.language),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.space16),
        children: localeProvider.supportedLocales.map((locale) {
          final isSelected = localeProvider.locale == locale;
          return Card(
            child: ListTile(
              leading: Icon(
                Icons.language,
                color: isSelected ? Theme.of(context).primaryColor : null,
              ),
              title: Text(
                localeProvider.getLocaleDisplayName(locale),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
              onTap: () {
                localeProvider.setLocale(locale);
                context.pop();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
