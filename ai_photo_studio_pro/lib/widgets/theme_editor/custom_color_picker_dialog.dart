import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions_v2.dart';

/// Диалог выбора цвета с поддержкой hex input
class CustomColorPickerDialog extends StatefulWidget {
  /// Начальный цвет
  final Color initialColor;

  /// Заголовок диалога
  final String title;

  const CustomColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.title,
  });

  @override
  State<CustomColorPickerDialog> createState() =>
      _CustomColorPickerDialogState();
}

class _CustomColorPickerDialogState extends State<CustomColorPickerDialog> {
  late Color _currentColor;
  late TextEditingController _hexController;
  String? _hexError;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _hexController = TextEditingController(text: _colorToHex(_currentColor));
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTheme.h3.copyWith(
                    color: context.colors.onBackground,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: context.colors.onSecondary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Color Picker
            ColorPicker(
              pickerColor: _currentColor,
              onColorChanged: (color) {
                setState(() {
                  _currentColor = color;
                  _hexController.text = _colorToHex(color);
                  _hexError = null;
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
              labelTypes: const [],
            ),
            const SizedBox(height: 24),

            // Hex Input
            TextField(
              controller: _hexController,
              decoration: InputDecoration(
                labelText: 'HEX Color',
                hintText: '#RRGGBB',
                prefixText: '#',
                errorText: _hexError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                ),
                filled: true,
                fillColor: context.colors.surface,
              ),
              style: TextStyle(
                color: context.colors.onBackground,
                fontFamily: 'monospace',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f]')),
                LengthLimitingTextInputFormatter(6),
                UpperCaseTextFormatter(),
              ],
              onChanged: _onHexChanged,
            ),
            const SizedBox(height: 24),

            // Preview
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusStandard),
                border: Border.all(
                  color: context.colors.onBackground.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  'Preview',
                  style: AppTheme.h4.copyWith(
                    color: _getContrastColor(_currentColor),
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: context.colors.onSecondary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusStandard,
                        ),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: AppTheme.buttonText.copyWith(
                        color: context.colors.onBackground,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hexError == null
                        ? () => Navigator.of(context).pop(_currentColor)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: context.colors.primary,
                      foregroundColor: context.colors.isDark
                          ? const Color(
                              0xFF1A1A1A,
                            ) // Very dark gray for dark theme
                          : Colors.white, // White for light theme
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusStandard,
                        ),
                      ),
                    ),
                    child: Text(
                      'Select',
                      style: AppTheme.buttonText.copyWith(
                        color: context.colors.isDark
                            ? const Color(
                                0xFF1A1A1A,
                              ) // Very dark gray for dark theme
                            : Colors.white, // White for light theme
                      ),
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

  /// Обработка изменения hex input
  void _onHexChanged(String value) {
    if (value.length != 6) {
      setState(() {
        _hexError = 'Must be 6 characters';
      });
      return;
    }

    try {
      final color = _hexToColor(value);
      setState(() {
        _currentColor = color;
        _hexError = null;
      });
    } catch (e) {
      setState(() {
        _hexError = 'Invalid hex color';
      });
    }
  }

  /// Конвертировать Color в hex string (без #)
  String _colorToHex(Color color) {
    final r = ((color.r * 255.0).round() & 0xff)
        .toRadixString(16)
        .padLeft(2, '0');
    final g = ((color.g * 255.0).round() & 0xff)
        .toRadixString(16)
        .padLeft(2, '0');
    final b = ((color.b * 255.0).round() & 0xff)
        .toRadixString(16)
        .padLeft(2, '0');
    return '$r$g$b'.toUpperCase();
  }

  /// Конвертировать hex string в Color
  Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  /// Получить контрастный цвет для текста
  Color _getContrastColor(Color background) {
    // Вычисляем относительную яркость
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Formatter для автоматического преобразования в uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
