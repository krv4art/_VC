import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_colors.dart';
import '../../theme/theme_extensions_v2.dart';
import 'quick_color_edit_dialog.dart';

/// Интерактивное превью темы с возможностью редактирования цветов
class InteractiveColorPreview extends StatelessWidget {
  /// Цвета для превью
  final CustomColors colors;

  /// Callback при изменении цвета
  final Function(CustomColors) onColorsChanged;

  const InteractiveColorPreview({
    super.key,
    required this.colors,
    required this.onColorsChanged,
  });

  void _showColorEditor(
    BuildContext context,
    String colorName,
    String description,
    Color currentColor,
    Function(Color) onColorChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) => QuickColorEditDialog(
        colorName: colorName,
        colorDescription: description,
        currentColor: currentColor,
        onColorChanged: onColorChanged,
      ),
    );
  }

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mini AppBar Section
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colors.brightness == Brightness.dark
                    ? colors.surface
                    : colors.primaryDark,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Row(
                children: [
                  Icon(Icons.menu, color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'App Bar',
                    style: AppTheme.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            onEditPressed: () {
              if (colors.brightness == Brightness.dark) {
                _showColorEditor(
                  context,
                  'Surface',
                  'Used for AppBar in dark mode',
                  colors.surface,
                  (color) => onColorsChanged(colors.copyWith(surface: color)),
                );
              } else {
                _showColorEditor(
                  context,
                  'Primary Dark',
                  'Used for AppBar in light mode',
                  colors.primaryDark,
                  (color) =>
                      onColorsChanged(colors.copyWith(primaryDark: color)),
                );
              }
            },
          ),
          const SizedBox(height: 16),

          // Primary Gradient Card (full width, not editable)
          Container(
            width: double.infinity,
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
                  'Primary Gradient Card',
                  style: AppTheme.h4.copyWith(
                    color: colors.brightness == Brightness.dark
                        ? const Color(
                            0xFF1A1A1A,
                          ) // Very dark gray for dark theme
                        : Colors.white, // White for light theme
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Light → Pale (edit colors below)',
                  style: AppTheme.bodySmall.copyWith(
                    color:
                        (colors.brightness == Brightness.dark
                                ? const Color(
                                    0xFF1A1A1A,
                                  ) // Very dark gray for dark theme
                                : Colors.white) // White for light theme
                            .withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Primary Light and Pale in one row
          Row(
            children: [
              // Primary Light Card
              Expanded(
                child: _buildEditableSection(
                  context,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.primaryLight,
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                    child: Text(
                      'Primary Light',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onEditPressed: () {
                    _showColorEditor(
                      context,
                      'Primary Light',
                      'Lighter shade for gradients',
                      colors.primaryLight,
                      (color) =>
                          onColorsChanged(colors.copyWith(primaryLight: color)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // Primary Pale Card
              Expanded(
                child: _buildEditableSection(
                  context,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.primaryPale,
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                    child: Text(
                      'Primary Pale',
                      textAlign: TextAlign.center,
                      style: AppTheme.bodySmall.copyWith(
                        color: colors.onBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onEditPressed: () {
                    _showColorEditor(
                      context,
                      'Primary Pale',
                      'Palest shade for gradients',
                      colors.primaryPale,
                      (color) =>
                          onColorsChanged(colors.copyWith(primaryPale: color)),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Background Section
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: colors.onBackground.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'Background with text',
                style: AppTheme.body.copyWith(color: colors.onBackground),
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'Background',
                'Main background color',
                colors.background,
                (color) => onColorsChanged(colors.copyWith(background: color)),
              );
            },
          ),
          const SizedBox(height: 12),

          // On Background Text Color
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: colors.onBackground.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                'On Background Text Color',
                style: AppTheme.body.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'On Background',
                'Text color on background',
                colors.onBackground,
                (color) =>
                    onColorsChanged(colors.copyWith(onBackground: color)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Surface Card
          _buildEditableSection(
            context,
            child: Container(
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
                  Icon(
                    Icons.layers_outlined,
                    color: colors.onSurface,
                    size: 20,
                  ),
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
            onEditPressed: () {
              _showColorEditor(
                context,
                'Surface',
                'Card/surface background',
                colors.surface,
                (color) => onColorsChanged(colors.copyWith(surface: color)),
              );
            },
          ),
          const SizedBox(height: 12),

          // On Surface Text Color
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: colors.onSurface.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'On Surface Text Color',
                style: AppTheme.body.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'On Surface',
                'Text color on surface',
                colors.onSurface,
                (color) => onColorsChanged(colors.copyWith(onSurface: color)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Neutral Color
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.neutral,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              ),
              child: Text(
                'Neutral (borders, disabled)',
                style: AppTheme.body.copyWith(
                  color: colors.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'Neutral',
                'For borders and disabled states',
                colors.neutral,
                (color) => onColorsChanged(colors.copyWith(neutral: color)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Status colors row
          Row(
            children: [
              Expanded(
                child: _buildEditableSection(
                  context,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.success.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      border: Border.all(color: colors.success, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Success',
                        style: AppTheme.bodySmall.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  onEditPressed: () {
                    _showColorEditor(
                      context,
                      'Success',
                      'Success state color',
                      colors.success,
                      (color) =>
                          onColorsChanged(colors.copyWith(success: color)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableSection(
                  context,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.warning.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      border: Border.all(color: colors.warning, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Warning',
                        style: AppTheme.bodySmall.copyWith(
                          color: colors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  onEditPressed: () {
                    _showColorEditor(
                      context,
                      'Warning',
                      'Warning state color',
                      colors.warning,
                      (color) =>
                          onColorsChanged(colors.copyWith(warning: color)),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableSection(
                  context,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: colors.error.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                      border: Border.all(color: colors.error, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        'Error',
                        style: AppTheme.bodySmall.copyWith(
                          color: colors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  onEditPressed: () {
                    _showColorEditor(
                      context,
                      'Error',
                      'Error state color',
                      colors.error,
                      (color) => onColorsChanged(colors.copyWith(error: color)),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Info Color
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.info.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: colors.info, width: 2),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.info, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Info',
                    style: AppTheme.body.copyWith(
                      color: colors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'Info',
                'Info state color',
                colors.info,
                (color) => onColorsChanged(colors.copyWith(info: color)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Primary Button (shows primary color used in buttons and active nav icons)
          _buildEditableSection(
            context,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Primary Button',
                textAlign: TextAlign.center,
                style: AppTheme.body.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'Primary',
                'Main brand color for buttons and active icons',
                colors.primary,
                (color) => onColorsChanged(colors.copyWith(primary: color)),
              );
            },
          ),
          const SizedBox(height: 16),

          // Mini Navigation Bar
          _buildEditableSection(
            context,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadowColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home, color: colors.primary, size: 24),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: colors.onSurface.withValues(alpha: 0.5),
                    size: 24,
                  ),
                  Icon(
                    Icons.chat_bubble_outline,
                    color: colors.onSurface.withValues(alpha: 0.5),
                    size: 24,
                  ),
                  Icon(
                    Icons.person_outline,
                    color: colors.onSurface.withValues(alpha: 0.5),
                    size: 24,
                  ),
                ],
              ),
            ),
            onEditPressed: () {
              _showColorEditor(
                context,
                'Surface',
                'Used for Navigation Bar background',
                colors.surface,
                (color) => onColorsChanged(colors.copyWith(surface: color)),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Создает секцию с кнопкой редактирования
  Widget _buildEditableSection(
    BuildContext context, {
    required Widget child,
    required VoidCallback onEditPressed,
  }) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            child: InkWell(
              onTap: onEditPressed,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: Container(
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
