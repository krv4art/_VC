import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../providers/premium_provider.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool _isYearly = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final premiumProvider = context.watch<PremiumProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.premiumTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.close,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
      body: premiumProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(l10n),
                  _buildFeaturesList(l10n),
                  _buildPricingSection(context, l10n, premiumProvider),
                  _buildActionButtons(context, l10n, premiumProvider),
                  const SizedBox(height: AppDimensions.space24),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.workspace_premium,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: AppDimensions.space16),
          Text(
            l10n.premiumTitle,
            style: AppTheme.h2.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            l10n.appTagline,
            style: AppTheme.body.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(AppLocalizations l10n) {
    final features = [
      (Icons.camera_alt, l10n.premiumFeature1),
      (Icons.chat, l10n.premiumFeature2),
      (Icons.location_on, l10n.premiumFeature3),
      (Icons.bar_chart, l10n.premiumFeature4),
      (Icons.cloud_upload, l10n.premiumFeature5),
      (Icons.block, l10n.premiumFeature6),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Premium Features',
            style: AppTheme.h3,
          ),
          const SizedBox(height: AppDimensions.space16),
          ...features.map((feature) => _buildFeatureItem(
                icon: feature.$1,
                text: feature.$2,
              )),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.space8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radius8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          Expanded(
            child: Text(text, style: AppTheme.body),
          ),
          const Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildPricingSection(
    BuildContext context,
    AppLocalizations l10n,
    PremiumProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space24),
      child: Column(
        children: [
          const SizedBox(height: AppDimensions.space16),
          _buildPlanToggle(l10n),
          const SizedBox(height: AppDimensions.space16),
          _buildPlanCard(context, l10n, provider),
        ],
      ),
    );
  }

  Widget _buildPlanToggle(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppDimensions.radius12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleOption(
              'Monthly',
              !_isYearly,
              () => setState(() => _isYearly = false),
            ),
          ),
          Expanded(
            child: _buildToggleOption(
              'Yearly (Save 40%)',
              _isYearly,
              () => setState(() => _isYearly = true),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radius12),
        ),
        child: Text(
          text,
          style: AppTheme.bodySmall.copyWith(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    AppLocalizations l10n,
    PremiumProvider provider,
  ) {
    final package = _isYearly ? provider.yearlyPackage : provider.monthlyPackage;

    if (package == null) {
      return Text(l10n.errorGeneral);
    }

    final price = package.storeProduct.priceString;
    final period = _isYearly ? '/year' : '/month';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radius16),
        side: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: AppTheme.h1.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  period,
                  style: AppTheme.bodySmall.copyWith(color: Colors.grey),
                ),
              ],
            ),
            if (_isYearly && provider.yearlySavingsPercentage > 0) ...[
              const SizedBox(height: AppDimensions.space8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.space12,
                  vertical: AppDimensions.space4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(AppDimensions.radius8),
                ),
                child: Text(
                  'Save ${provider.yearlySavingsPercentage.toStringAsFixed(0)}%',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.green[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppLocalizations l10n,
    PremiumProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.space24),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      final package = _isYearly
                          ? provider.yearlyPackage
                          : provider.monthlyPackage;
                      if (package != null) {
                        final success = await provider.purchasePackage(package);
                        if (success && context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Welcome to Premium!'),
                            ),
                          );
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.space16,
                ),
              ),
              child: provider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.premiumUpgrade),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          TextButton(
            onPressed: provider.isLoading
                ? null
                : () async {
                    final success = await provider.restorePurchases();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Purchase restored successfully!'
                                : 'No previous purchases found',
                          ),
                        ),
                      );
                      if (success) {
                        Navigator.pop(context);
                      }
                    }
                  },
            child: Text(l10n.premiumRestore),
          ),
        ],
      ),
    );
  }
}
