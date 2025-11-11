import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Кастомная цветовая схема с возможностью полной настройки
class CustomColors extends AppColors {
  @override
  final Color primary;

  @override
  final Color primaryLight;

  @override
  final Color primaryPale;

  @override
  final Color primaryDark;

  @override
  final Color neutral;

  @override
  final Color background;

  @override
  final Color surface;

  @override
  final Color onBackground;

  @override
  final Color onSurface;

  @override
  final Color success;

  @override
  final Color warning;

  @override
  final Color error;

  @override
  final Color info;

  @override
  final Brightness brightness;

  CustomColors({
    required this.primary,
    required this.primaryLight,
    required this.primaryPale,
    required this.primaryDark,
    required this.neutral,
    required this.background,
    required this.surface,
    required this.onBackground,
    required this.onSurface,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.brightness,
  });

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Создать CustomColors из существующей темы (preset)
  factory CustomColors.fromAppColors(AppColors colors) {
    return CustomColors(
      primary: colors.primary,
      primaryLight: colors.primaryLight,
      primaryPale: colors.primaryPale,
      primaryDark: colors.primaryDark,
      neutral: colors.neutral,
      background: colors.background,
      surface: colors.surface,
      onBackground: colors.onBackground,
      onSurface: colors.onSurface,
      success: colors.success,
      warning: colors.warning,
      error: colors.error,
      info: colors.info,
      brightness: colors.brightness,
    );
  }

  /// Создать копию с изменениями
  CustomColors copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryPale,
    Color? primaryDark,
    Color? neutral,
    Color? background,
    Color? surface,
    Color? onBackground,
    Color? onSurface,
    Color? success,
    Color? warning,
    Color? error,
    Color? info,
    Brightness? brightness,
  }) {
    return CustomColors(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryPale: primaryPale ?? this.primaryPale,
      primaryDark: primaryDark ?? this.primaryDark,
      neutral: neutral ?? this.neutral,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      onBackground: onBackground ?? this.onBackground,
      onSurface: onSurface ?? this.onSurface,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      info: info ?? this.info,
      brightness: brightness ?? this.brightness,
    );
  }

  /// Сериализация в JSON
  Map<String, dynamic> toJson() {
    return {
      'primary': _colorToHex(primary),
      'primaryLight': _colorToHex(primaryLight),
      'primaryPale': _colorToHex(primaryPale),
      'primaryDark': _colorToHex(primaryDark),
      'neutral': _colorToHex(neutral),
      'background': _colorToHex(background),
      'surface': _colorToHex(surface),
      'onBackground': _colorToHex(onBackground),
      'onSurface': _colorToHex(onSurface),
      'success': _colorToHex(success),
      'warning': _colorToHex(warning),
      'error': _colorToHex(error),
      'info': _colorToHex(info),
      'brightness': brightness == Brightness.light ? 'light' : 'dark',
    };
  }

  /// Десериализация из JSON
  factory CustomColors.fromJson(Map<String, dynamic> json) {
    return CustomColors(
      primary: _hexToColor(json['primary'] as String),
      primaryLight: _hexToColor(json['primaryLight'] as String),
      primaryPale: _hexToColor(json['primaryPale'] as String),
      primaryDark: _hexToColor(json['primaryDark'] as String),
      neutral: _hexToColor(json['neutral'] as String),
      background: _hexToColor(json['background'] as String),
      surface: _hexToColor(json['surface'] as String),
      onBackground: _hexToColor(json['onBackground'] as String),
      onSurface: _hexToColor(json['onSurface'] as String),
      success: _hexToColor(json['success'] as String),
      warning: _hexToColor(json['warning'] as String),
      error: _hexToColor(json['error'] as String),
      info: _hexToColor(json['info'] as String),
      brightness: json['brightness'] == 'light'
          ? Brightness.light
          : Brightness.dark,
    );
  }

  /// Конвертировать Color в hex string
  static String _colorToHex(Color color) {
    final r = ((color.red).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final g = ((color.green).round() & 0xff).toRadixString(16).padLeft(2, '0');
    final b = ((color.blue).round() & 0xff).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  /// Конвертировать hex string в Color
  static Color _hexToColor(String hex) {
    final hexCode = hex.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }
}
