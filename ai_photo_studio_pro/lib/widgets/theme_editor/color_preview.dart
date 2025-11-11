import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_colors.dart';

/// Виджет для предварительного просмотра темы
class ColorPreview extends StatelessWidget {
  /// Цвета для превью
  final CustomColors colors;

  const ColorPreview({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        border: Border.all(color: colors.onBackground.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Theme Preview',
            style: AppTheme.h4.copyWith(color: colors.onBackground),
          ),
          const SizedBox(height: 16),

          // Sample Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Card',
                  style: AppTheme.h4.copyWith(
                    color: colors.brightness == Brightness.dark
                        ? const Color(
                            0xFF1A1A1A,
                          ) // Very dark gray for dark theme
                        : Colors.white, // White for light theme
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This is how your theme will look',
                  style: AppTheme.body.copyWith(
                    color:
                        (colors.brightness == Brightness.dark
                                ? const Color(
                                    0xFF1A1A1A,
                                  ) // Very dark gray for dark theme
                                : Colors.white) // White for light theme
                            .withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sample Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
            ),
            child: Center(
              child: Text(
                'Primary Button',
                style: AppTheme.buttonText.copyWith(color: colors.onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Surface Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(
                color: colors.onBackground.withValues(alpha: 0.1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.onSurface, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Surface with text',
                    style: AppTheme.body.copyWith(color: colors.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status colors row
          Row(
            children: [
              Expanded(
                child: _StatusIndicator(
                  label: 'Success',
                  color: colors.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusIndicator(
                  label: 'Warning',
                  color: colors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StatusIndicator(label: 'Error', color: colors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Индикатор статуса
class _StatusIndicator extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusIndicator({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Center(
        child: Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
