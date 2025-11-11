import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions_v2.dart';

/// Диалог для быстрого редактирования цвета
class QuickColorEditDialog extends StatefulWidget {
  /// Название цвета (например, "Primary", "Surface")
  final String colorName;

  /// Описание цвета
  final String colorDescription;

  /// Текущий цвет
  final Color currentColor;

  /// Callback при применении нового цвета
  final Function(Color) onColorChanged;

  const QuickColorEditDialog({
    super.key,
    required this.colorName,
    required this.colorDescription,
    required this.currentColor,
    required this.onColorChanged,
  });

  @override
  State<QuickColorEditDialog> createState() => _QuickColorEditDialogState();
}

class _QuickColorEditDialogState extends State<QuickColorEditDialog> {
  late TextEditingController _hexController;
  late Color _selectedColor;
  bool _isValidHex = true;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.currentColor;
    _hexController = TextEditingController(
      text: _colorToHex(_selectedColor),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  Color? _hexToColor(String hex) {
    try {
      String cleanHex = hex.replaceAll('#', '').trim();
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _onHexChanged(String value) {
    // Remove # if user added it
    String cleanValue = value.replaceAll('#', '');

    if (cleanValue.length != 6) {
      setState(() {
        _isValidHex = false;
      });
      return;
    }

    final color = _hexToColor(cleanValue);
    setState(() {
      _isValidHex = color != null;
      if (color != null) {
        _selectedColor = color;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    border: Border.all(
                      color: context.colors.onSurface.withValues(alpha: 0.2),
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.colorName,
                        style: AppTheme.h4.copyWith(
                          color: context.colors.onSurface,
                        ),
                      ),
                      Text(
                        widget.colorDescription,
                        style: AppTheme.bodySmall.copyWith(
                          color: context.colors.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Hex Input
            Text(
              'Hex Color',
              style: AppTheme.body.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _hexController,
              onChanged: _onHexChanged,
              decoration: InputDecoration(
                hintText: '#RRGGBB',
                hintStyle: TextStyle(
                  color: context.colors.onSurface.withValues(alpha: 0.4),
                ),
                errorText: !_isValidHex ? 'Invalid hex color' : null,
                filled: true,
                fillColor: context.colors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                  borderSide: BorderSide(
                    color: context.colors.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                  borderSide: BorderSide(
                    color: context.colors.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                  borderSide: BorderSide(
                    color: context.colors.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                  borderSide: BorderSide(
                    color: context.colors.error,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                  borderSide: BorderSide(
                    color: context.colors.error,
                    width: 2,
                  ),
                ),
              ),
              style: AppTheme.body.copyWith(
                color: context.colors.onSurface,
                fontFamily: 'monospace',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[#0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(7),
              ],
            ),
            const SizedBox(height: 24),

            // Color Picker with clipping to prevent crosshair overflow
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: context.colors.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                      _hexController.text = _colorToHex(color);
                      _isValidHex = true;
                    });
                  },
                  pickerAreaHeightPercent: 0.7,
                  enableAlpha: false,
                  displayThumbColor: true,
                  labelTypes: const [],
                  pickerAreaBorderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTheme.body.copyWith(
                      color: context.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isValidHex
                      ? () {
                          widget.onColorChanged(_selectedColor);
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.colors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Apply',
                    style: AppTheme.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
