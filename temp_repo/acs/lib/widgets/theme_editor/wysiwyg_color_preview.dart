import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_colors.dart';
import '../../theme/theme_extensions_v2.dart';
import 'quick_color_edit_dialog.dart';

/// WYSIWYG превью темы - кликай на элемент, редактируй цвет
class WysiwygColorPreview extends StatelessWidget {
  /// Цвета для превью
  final CustomColors colors;

  /// Callback при изменении цвета
  final Function(CustomColors) onColorsChanged;

  const WysiwygColorPreview({
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

  void _showGradientColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'Edit Gradient Color',
          style: AppTheme.h4.copyWith(color: context.colors.onBackground),
        ),
        backgroundColor: context.colors.surface,
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showColorEditor(
                context,
                'Primary Light',
                'Lighter shade for gradients',
                colors.primaryLight,
                (color) => onColorsChanged(colors.copyWith(primaryLight: color)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.colors.onSurface.withValues(alpha: 0.2)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Edit Primary Light',
                    style: AppTheme.body.copyWith(color: context.colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context);
              _showColorEditor(
                context,
                'Primary Pale',
                'Palest shade for gradients',
                colors.primaryPale,
                (color) => onColorsChanged(colors.copyWith(primaryPale: color)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primaryPale,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.colors.onSurface.withValues(alpha: 0.2)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Edit Primary Pale',
                    style: AppTheme.body.copyWith(color: context.colors.onSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Клик на любое свободное место = редактирование background
      onTap: () {
        _showColorEditor(
          context,
          'Background',
          'Main page background color',
          colors.background,
          (color) => onColorsChanged(colors.copyWith(background: color)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Main Content Area (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Instruction + Description (combined, clickable)
                      _buildInstructionSection(context),
                      const SizedBox(height: 16),

                      // Primary Gradient Card
                      _buildGradientCard(context),
                      const SizedBox(height: 16),

                      // Surface Card
                      _buildSurfaceCard(context),
                      const SizedBox(height: 16),

                      // Primary Button
                      _buildPrimaryButton(context),
                      const SizedBox(height: 16),

                      // Status Indicators Row
                      _buildStatusIndicators(context),
                      const SizedBox(height: 12),

                      // Info Indicator
                      _buildInfoIndicator(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// Инструкция и описание (объединенные, кликабельные)
  Widget _buildInstructionSection(BuildContext context) {
    return Stack(
      children: [
        // Фон (кликабельный для background color)
        GestureDetector(
          onTap: () {
            _showColorEditor(
              context,
              'Background',
              'Main page background color',
              colors.background,
              (color) => onColorsChanged(colors.copyWith(background: color)),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              border: Border.all(
                color: colors.onBackground.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _showColorEditor(
                      context,
                      'On Background',
                      'Text color on background',
                      colors.onBackground,
                      (color) => onColorsChanged(colors.copyWith(onBackground: color)),
                    );
                  },
                  child: Text(
                    '💡 Tap any element to edit its color',
                    style: AppTheme.body.copyWith(
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _showColorEditor(
                      context,
                      'On Background',
                      'Text color on background',
                      colors.onBackground,
                      (color) => onColorsChanged(colors.copyWith(onBackground: color)),
                    );
                  },
                  child: Text(
                    'This is page description. Click on text to edit text color, click on empty space to edit background.',
                    style: AppTheme.bodySmall.copyWith(
                      color: colors.onBackground.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Градиентная карта
  Widget _buildGradientCard(BuildContext context) {
    // Text on gradient is always white (for both light and dark modes)
    const textColor = Colors.white;

    return GestureDetector(
      // Клик на свободное место карточки → выбор цвета градиента
      onTap: () => _showGradientColorPicker(context),
      child: Container(
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
              style: AppTheme.h4.copyWith(color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap to edit gradient colors',
              style: AppTheme.bodySmall.copyWith(
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Surface карта (фон и текст кликабельны отдельно)
  Widget _buildSurfaceCard(BuildContext context) {
    return Stack(
      children: [
        // Фон карты
        GestureDetector(
          onTap: () {
            _showColorEditor(
              context,
              'Surface',
              'Card/surface background color',
              colors.surface,
              (color) => onColorsChanged(colors.copyWith(surface: color)),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.layers_outlined,
                  color: colors.onSurface,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showColorEditor(
                        context,
                        'On Surface',
                        'Text color on surface/cards',
                        colors.onSurface,
                        (color) => onColorsChanged(colors.copyWith(onSurface: color)),
                      );
                    },
                    child: Text(
                      'Surface Card - tap text to edit text color, tap empty space for background',
                      style: AppTheme.body.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Primary кнопка (имитация)
  Widget _buildPrimaryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showColorEditor(
          context,
          'Primary',
          'Main brand color for buttons and active icons',
          colors.primary,
          (color) => onColorsChanged(colors.copyWith(primary: color)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
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
          'Button',
          textAlign: TextAlign.center,
          style: AppTheme.body.copyWith(
            color: colors.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Индикаторы статуса в ряд
  Widget _buildStatusIndicators(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showColorEditor(
                context,
                'Success',
                'Success state color',
                colors.success,
                (color) => onColorsChanged(colors.copyWith(success: color)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: colors.success, width: 2),
              ),
              child: Text(
                '✓ Success',
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  color: colors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showColorEditor(
                context,
                'Warning',
                'Warning state color',
                colors.warning,
                (color) => onColorsChanged(colors.copyWith(warning: color)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: colors.warning, width: 2),
              ),
              child: Text(
                '⚠ Warning',
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  color: colors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () {
              _showColorEditor(
                context,
                'Error',
                'Error state color',
                colors.error,
                (color) => onColorsChanged(colors.copyWith(error: color)),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: colors.error, width: 2),
              ),
              child: Text(
                '✗ Error',
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info индикатор
  Widget _buildInfoIndicator(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showColorEditor(
          context,
          'Info',
          'Info state color',
          colors.info,
          (color) => onColorsChanged(colors.copyWith(info: color)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.info.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(color: colors.info, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }


}
