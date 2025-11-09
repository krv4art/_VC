import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/plant_result.dart';
import '../theme/app_theme.dart';

/// Badge showing toxicity status
class ToxicityBadge extends StatelessWidget {
  final bool isToxic;
  final bool isEdible;

  const ToxicityBadge({
    super.key,
    required this.isToxic,
    required this.isEdible,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (isToxic) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space12,
          vertical: AppTheme.space4,
        ),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: Colors.red[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, size: 16, color: Colors.red[700]),
            const SizedBox(width: AppTheme.space4),
            Text(
              l10n.toxic,
              style: AppTheme.labelMedium.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    } else if (isEdible) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.space12,
          vertical: AppTheme.space4,
        ),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: Colors.green[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 16, color: Colors.green[700]),
            const SizedBox(width: AppTheme.space4),
            Text(
              l10n.edible,
              style: AppTheme.labelMedium.copyWith(
                color: Colors.green[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Icon representing plant type
class PlantTypeIcon extends StatelessWidget {
  final PlantType type;
  final double size;
  final Color? color;

  const PlantTypeIcon({
    super.key,
    required this.type,
    this.size = 24,
    this.color,
  });

  IconData _getIconForType(PlantType type) {
    switch (type) {
      case PlantType.mushroom:
        return Icons.park;
      case PlantType.tree:
        return Icons.forest;
      case PlantType.flower:
        return Icons.local_florist;
      case PlantType.herb:
        return Icons.spa;
      case PlantType.succulent:
        return Icons.yard;
      case PlantType.vegetable:
        return Icons.eco;
      case PlantType.fruit:
        return Icons.agriculture;
      case PlantType.plant:
      default:
        return Icons.eco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconForType(type),
      size: size,
      color: color,
    );
  }
}

/// Care information widget showing watering, sunlight, etc.
class CareInfoWidget extends StatelessWidget {
  final PlantCareInfo careInfo;

  const CareInfoWidget({
    super.key,
    required this.careInfo,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.careInformation,
              style: AppTheme.h4.copyWith(color: colors.onSurface),
            ),
            const SizedBox(height: AppTheme.space16),
            _buildCareItem(
              icon: Icons.water_drop,
              label: l10n.watering,
              value: careInfo.wateringFrequency,
              color: Colors.blue,
            ),
            const SizedBox(height: AppTheme.space12),
            _buildCareItem(
              icon: Icons.wb_sunny,
              label: l10n.sunlight,
              value: careInfo.sunlightRequirement,
              color: Colors.orange,
            ),
            const SizedBox(height: AppTheme.space12),
            _buildCareItem(
              icon: Icons.terrain,
              label: l10n.soilType,
              value: careInfo.soilType,
              color: Colors.brown,
            ),
            if (careInfo.temperature != null) ...[
              const SizedBox(height: AppTheme.space12),
              _buildCareItem(
                icon: Icons.thermostat,
                label: l10n.temperature,
                value: careInfo.temperature!,
                color: Colors.red,
              ),
            ],
            if (careInfo.humidity != null) ...[
              const SizedBox(height: AppTheme.space12),
              _buildCareItem(
                icon: Icons.cloud,
                label: l10n.humidity,
                value: careInfo.humidity!,
                color: Colors.cyan,
              ),
            ],
            if (careInfo.fertilizer != null) ...[
              const SizedBox(height: AppTheme.space12),
              _buildCareItem(
                icon: Icons.spa,
                label: l10n.fertilizer,
                value: careInfo.fertilizer!,
                color: Colors.green,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCareItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: AppTheme.space8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.labelMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.space4),
              Text(
                value,
                style: AppTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Info card with icon and text
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color? iconColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.space16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 32,
              color: iconColor ?? colors.primary,
            ),
            const SizedBox(width: AppTheme.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.h5.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.space8),
                  Text(
                    content,
                    style: AppTheme.body.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Confidence level indicator
class ConfidenceIndicator extends StatelessWidget {
  final double confidence;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
  });

  Color _getColorForConfidence(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForConfidence(confidence);
    final percentage = (confidence * 100).toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space12,
        vertical: AppTheme.space8,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 16, color: color),
          const SizedBox(width: AppTheme.space8),
          Text(
            '$percentage% confidence',
            style: AppTheme.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Common names chip list
class CommonNamesChips extends StatelessWidget {
  final List<String> commonNames;

  const CommonNamesChips({
    super.key,
    required this.commonNames,
  });

  @override
  Widget build(BuildContext context) {
    if (commonNames.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppTheme.space8,
      runSpacing: AppTheme.space8,
      children: commonNames.map((name) {
        return Chip(
          label: Text(name),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: AppTheme.labelMedium.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        );
      }).toList(),
    );
  }
}
