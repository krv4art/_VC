import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions_v2.dart';
import 'custom_color_picker_dialog.dart';

/// Плитка для отображения и выбора цвета
class ColorPickerTile extends StatelessWidget {
  /// Название цвета (например, "Primary Color")
  final String label;

  /// Текущий выбранный цвет
  final Color color;

  /// Callback при выборе нового цвета
  final ValueChanged<Color> onColorChanged;

  /// Описание цвета (опционально)
  final String? description;

  /// Показывать ли hex код
  final bool showHex;

  const ColorPickerTile({
    super.key,
    required this.label,
    required this.color,
    required this.onColorChanged,
    this.description,
    this.showHex = true,
  });

  @override
  Widget build(BuildContext context) {
    final hexColor = _colorToHex(color);

    return InkWell(
      onTap: () => _openColorPicker(context),
      borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          border: Border.all(
            color: context.colors.onBackground.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            // Color preview box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                  color: context.colors.onBackground.withValues(alpha: 0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Label and hex
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTheme.bodyLarge.copyWith(
                      color: context.colors.onBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      description!,
                      style: AppTheme.bodySmall.copyWith(
                        color: context.colors.onSecondary,
                      ),
                    ),
                  ],
                  if (showHex) ...[
                    const SizedBox(height: 4),
                    Text(
                      hexColor,
                      style: AppTheme.bodySmall.copyWith(
                        color: context.colors.onSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Edit icon
            Icon(
              Icons.edit,
              color: context.colors.onSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Открыть диалог выбора цвета
  Future<void> _openColorPicker(BuildContext context) async {
    final newColor = await showDialog<Color>(
      context: context,
      builder: (context) => CustomColorPickerDialog(
        initialColor: color,
        title: label,
      ),
    );

    if (newColor != null) {
      onColorChanged(newColor);
    }
  }

  /// Конвертировать Color в hex string
  String _colorToHex(Color color) {
    final r = ((color.r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((color.g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((color.b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }
}
