import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_app_bar.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.createAccount, showBackButton: true),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.iconMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.signUpToGetStarted,
                style: AppTheme.h2.copyWith(color: context.colors.onBackground),
              ),
              AppSpacer.v32(),
              Text(
                'Sign up screen placeholder',
                style: AppTheme.body.copyWith(
                  color: context.colors.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
