import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../l10n/app_localizations.dart';
import '../models/plant_result.dart';
import '../providers/plant_history_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/plant_widgets.dart';
import '../animations/staggered_animation.dart';

/// Plant result details screen showing full identification results
class PlantResultScreen extends StatelessWidget {
  final PlantResult result;

  const PlantResultScreen({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(result.plantName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteResult(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: StaggeredListAnimation(
          children: [
            // Header with image and basic info
            _buildHeader(context, l10n, colors),
            const SizedBox(height: AppTheme.space24),

            // Confidence indicator
            ConfidenceIndicator(confidence: result.confidence),
            const SizedBox(height: AppTheme.space24),

            // Scientific name
            InfoCard(
              icon: Icons.science,
              title: l10n.scientificName,
              content: result.scientificName,
              iconColor: colors.primary,
            ),
            const SizedBox(height: AppTheme.space16),

            // Family
            if (result.family != null)
              InfoCard(
                icon: Icons.family_restroom,
                title: l10n.family,
                content: result.family!,
                iconColor: colors.secondary,
              ),
            if (result.family != null) const SizedBox(height: AppTheme.space16),

            // Origin
            if (result.origin != null)
              InfoCard(
                icon: Icons.public,
                title: l10n.origin,
                content: result.origin!,
                iconColor: colors.tertiary,
              ),
            if (result.origin != null) const SizedBox(height: AppTheme.space16),

            // Common names
            if (result.commonNames.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.commonNames,
                        style: AppTheme.h5.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space12),
                      CommonNamesChips(commonNames: result.commonNames),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space16),
            ],

            // Description
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description, color: colors.primary),
                        const SizedBox(width: AppTheme.space8),
                        Text(
                          l10n.description,
                          style: AppTheme.h5.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.space12),
                    Text(
                      result.description,
                      style: AppTheme.body.copyWith(color: colors.onSurface),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space16),

            // Uses and benefits
            if (result.usesAndBenefits != null && result.usesAndBenefits!.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.stars, color: colors.primary),
                          const SizedBox(width: AppTheme.space8),
                          Text(
                            l10n.usesAndBenefits,
                            style: AppTheme.h5.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: result.usesAndBenefits!.map((benefit) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.space8),
                            child: Text(
                              '• $benefit',
                              style: AppTheme.body.copyWith(color: colors.onSurface),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space16),
            ],

            // Care information
            if (result.careInfo != null) ...[
              CareInfoWidget(careInfo: result.careInfo!),
              const SizedBox(height: AppTheme.space16),
            ],

            // Common pests
            if (result.careInfo?.commonPests != null && result.careInfo!.commonPests!.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bug_report, color: Colors.orange),
                          const SizedBox(width: AppTheme.space8),
                          Text(
                            l10n.commonPests,
                            style: AppTheme.h5.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: result.careInfo!.commonPests!.map((pest) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.space8),
                            child: Text(
                              '• $pest',
                              style: AppTheme.body.copyWith(color: colors.onSurface),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space16),
            ],

            // Common diseases
            if (result.careInfo?.commonDiseases != null && result.careInfo!.commonDiseases!.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.healing, color: Colors.red),
                          const SizedBox(width: AppTheme.space8),
                          Text(
                            l10n.commonDiseases,
                            style: AppTheme.h5.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: result.careInfo!.commonDiseases!.map((disease) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.space8),
                            child: Text(
                              '• $disease',
                              style: AppTheme.body.copyWith(color: colors.onSurface),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.space24),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n, ColorScheme colors) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant image placeholder
            if (result.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                child: Image.network(
                  result.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                ),
              )
            else
              _buildPlaceholderImage(),
            const SizedBox(height: AppTheme.space16),

            // Plant name and type
            Row(
              children: [
                PlantTypeIcon(
                  type: result.type,
                  size: 32,
                  color: colors.primary,
                ),
                const SizedBox(width: AppTheme.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        result.plantName,
                        style: AppTheme.h3.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.space4),
                      Text(
                        result.type.toString().split('.').last.toUpperCase(),
                        style: AppTheme.labelMedium.copyWith(
                          color: colors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.space16),

            // Toxicity and edibility badges
            Wrap(
              spacing: AppTheme.space8,
              runSpacing: AppTheme.space8,
              children: [
                ToxicityBadge(
                  isToxic: result.isToxic,
                  isEdible: result.isEdible,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Icon(
        Icons.local_florist,
        size: 64,
        color: Colors.grey[400],
      ),
    );
  }

  void _shareResult(BuildContext context) {
    final text = '''
${result.plantName}
Scientific Name: ${result.scientificName}
${result.description}
    ''';

    Share.share(text, subject: result.plantName);
  }

  void _deleteResult(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Result'),
        content: const Text('Are you sure you want to delete this result?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final historyProvider = context.read<PlantHistoryProvider>();
              historyProvider.deleteResult(result.id);
              Navigator.pop(ctx);
              context.pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
