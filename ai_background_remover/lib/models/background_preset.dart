import 'package:flutter/material.dart';

/// Background preset model
class BackgroundPreset {
  final String id;
  final String name;
  final BackgroundType type;
  final Color? color;
  final List<Color>? gradientColors;
  final GradientType? gradientType;
  final String? imageUrl;
  final String? imageAssetPath;
  final String? category;
  final bool isPremium;

  const BackgroundPreset({
    required this.id,
    required this.name,
    required this.type,
    this.color,
    this.gradientColors,
    this.gradientType,
    this.imageUrl,
    this.imageAssetPath,
    this.category,
    this.isPremium = false,
  });

  BackgroundPreset copyWith({
    String? id,
    String? name,
    BackgroundType? type,
    Color? color,
    List<Color>? gradientColors,
    GradientType? gradientType,
    String? imageUrl,
    String? imageAssetPath,
    String? category,
    bool? isPremium,
  }) {
    return BackgroundPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      color: color ?? this.color,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientType: gradientType ?? this.gradientType,
      imageUrl: imageUrl ?? this.imageUrl,
      imageAssetPath: imageAssetPath ?? this.imageAssetPath,
      category: category ?? this.category,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}

enum BackgroundType {
  solid,
  gradient,
  image,
  transparent,
  blur,
}

enum GradientType {
  linear,
  radial,
  sweep,
}

/// Predefined background categories
class BackgroundCategory {
  static const String solid = 'Solid Colors';
  static const String gradient = 'Gradients';
  static const String nature = 'Nature';
  static const String abstract = 'Abstract';
  static const String professional = 'Professional';
  static const String seasonal = 'Seasonal';
  static const String texture = 'Textures';
}

/// Built-in background presets
class BackgroundPresets {
  // Solid Colors
  static const transparent = BackgroundPreset(
    id: 'transparent',
    name: 'Transparent',
    type: BackgroundType.transparent,
    category: BackgroundCategory.solid,
  );

  static const white = BackgroundPreset(
    id: 'white',
    name: 'White',
    type: BackgroundType.solid,
    color: Colors.white,
    category: BackgroundCategory.solid,
  );

  static const black = BackgroundPreset(
    id: 'black',
    name: 'Black',
    type: BackgroundType.solid,
    color: Colors.black,
    category: BackgroundCategory.solid,
  );

  static const grey = BackgroundPreset(
    id: 'grey',
    name: 'Grey',
    type: BackgroundType.solid,
    color: Color(0xFF9E9E9E),
    category: BackgroundCategory.solid,
  );

  static const lightGrey = BackgroundPreset(
    id: 'light_grey',
    name: 'Light Grey',
    type: BackgroundType.solid,
    color: Color(0xFFE0E0E0),
    category: BackgroundCategory.solid,
  );

  static const blue = BackgroundPreset(
    id: 'blue',
    name: 'Blue',
    type: BackgroundType.solid,
    color: Color(0xFF2196F3),
    category: BackgroundCategory.solid,
  );

  static const red = BackgroundPreset(
    id: 'red',
    name: 'Red',
    type: BackgroundType.solid,
    color: Color(0xFFF44336),
    category: BackgroundCategory.solid,
  );

  static const green = BackgroundPreset(
    id: 'green',
    name: 'Green',
    type: BackgroundType.solid,
    color: Color(0xFF4CAF50),
    category: BackgroundCategory.solid,
  );

  static const yellow = BackgroundPreset(
    id: 'yellow',
    name: 'Yellow',
    type: BackgroundType.solid,
    color: Color(0xFFFFEB3B),
    category: BackgroundCategory.solid,
  );

  static const purple = BackgroundPreset(
    id: 'purple',
    name: 'Purple',
    type: BackgroundType.solid,
    color: Color(0xFF9C27B0),
    category: BackgroundCategory.solid,
  );

  static const pink = BackgroundPreset(
    id: 'pink',
    name: 'Pink',
    type: BackgroundType.solid,
    color: Color(0xFFE91E63),
    category: BackgroundCategory.solid,
  );

  static const orange = BackgroundPreset(
    id: 'orange',
    name: 'Orange',
    type: BackgroundType.solid,
    color: Color(0xFFFF9800),
    category: BackgroundCategory.solid,
  );

  // Gradients
  static const sunsetGradient = BackgroundPreset(
    id: 'sunset',
    name: 'Sunset',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFFFF6B6B),
      Color(0xFFFFE66D),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
  );

  static const oceanGradient = BackgroundPreset(
    id: 'ocean',
    name: 'Ocean',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF0077BE),
      Color(0xFF00B4D8),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
  );

  static const forestGradient = BackgroundPreset(
    id: 'forest',
    name: 'Forest',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF2D6A4F),
      Color(0xFF52B788),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
  );

  static const purpleHazeGradient = BackgroundPreset(
    id: 'purple_haze',
    name: 'Purple Haze',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF6A0572),
      Color(0xFFAB83A1),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
    isPremium: true,
  );

  static const midnightGradient = BackgroundPreset(
    id: 'midnight',
    name: 'Midnight',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF191970),
      Color(0xFF000080),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
  );

  static const peachGradient = BackgroundPreset(
    id: 'peach',
    name: 'Peach',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFFFFBE0B),
      Color(0xFFFB5607),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
  );

  static const auroraGradient = BackgroundPreset(
    id: 'aurora',
    name: 'Aurora',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF4ECDC4),
      Color(0xFF44A08D),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.gradient,
    isPremium: true,
  );

  static const cosmicGradient = BackgroundPreset(
    id: 'cosmic',
    name: 'Cosmic',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF8E2DE2),
      Color(0xFF4A00E0),
    ],
    gradientType: GradientType.radial,
    category: BackgroundCategory.gradient,
    isPremium: true,
  );

  // Professional backgrounds
  static const professionalBlue = BackgroundPreset(
    id: 'prof_blue',
    name: 'Professional Blue',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF0F2027),
      Color(0xFF203A43),
      Color(0xFF2C5364),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.professional,
  );

  static const professionalGrey = BackgroundPreset(
    id: 'prof_grey',
    name: 'Professional Grey',
    type: BackgroundType.gradient,
    gradientColors: [
      Color(0xFF434343),
      Color(0xFF000000),
    ],
    gradientType: GradientType.linear,
    category: BackgroundCategory.professional,
  );

  static const corporateBlue = BackgroundPreset(
    id: 'corporate_blue',
    name: 'Corporate Blue',
    type: BackgroundType.solid,
    color: Color(0xFF1E3A8A),
    category: BackgroundCategory.professional,
  );

  static const List<BackgroundPreset> allPresets = [
    // Solid colors
    transparent,
    white,
    black,
    grey,
    lightGrey,
    blue,
    red,
    green,
    yellow,
    purple,
    pink,
    orange,

    // Gradients
    sunsetGradient,
    oceanGradient,
    forestGradient,
    purpleHazeGradient,
    midnightGradient,
    peachGradient,
    auroraGradient,
    cosmicGradient,

    // Professional
    professionalBlue,
    professionalGrey,
    corporateBlue,
  ];

  static List<BackgroundPreset> getByCategory(String category) {
    return allPresets.where((preset) => preset.category == category).toList();
  }

  static List<BackgroundPreset> getFreePresets() {
    return allPresets.where((preset) => !preset.isPremium).toList();
  }

  static List<BackgroundPreset> getPremiumPresets() {
    return allPresets.where((preset) => preset.isPremium).toList();
  }

  static BackgroundPreset? getById(String id) {
    try {
      return allPresets.firstWhere((preset) => preset.id == id);
    } catch (e) {
      return null;
    }
  }
}
