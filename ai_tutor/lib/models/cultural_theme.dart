import 'package:flutter/material.dart';

/// Model representing a cultural theme with visual styling
class CulturalTheme {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final ThemeColors colors;
  final DialogStyle dialogStyle;
  final List<String> culturalKeywords;
  final AnimationStyle animationStyle;

  const CulturalTheme({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.colors,
    required this.dialogStyle,
    required this.culturalKeywords,
    required this.animationStyle,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'description': description,
        'colors': colors.toJson(),
        'dialogStyle': dialogStyle.name,
        'culturalKeywords': culturalKeywords,
        'animationStyle': animationStyle.name,
      };

  factory CulturalTheme.fromJson(Map<String, dynamic> json) => CulturalTheme(
        id: json['id'],
        name: json['name'],
        emoji: json['emoji'],
        description: json['description'],
        colors: ThemeColors.fromJson(json['colors']),
        dialogStyle: DialogStyle.values.byName(json['dialogStyle']),
        culturalKeywords: List<String>.from(json['culturalKeywords']),
        animationStyle: AnimationStyle.values.byName(json['animationStyle']),
      );
}

/// Theme colors for cultural personalization
class ThemeColors {
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  const ThemeColors({
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  Map<String, dynamic> toJson() => {
        'primary': primary.value,
        'secondary': secondary.value,
        'accent': accent.value,
        'background': background.value,
        'surface': surface.value,
        'textPrimary': textPrimary.value,
        'textSecondary': textSecondary.value,
      };

  factory ThemeColors.fromJson(Map<String, dynamic> json) => ThemeColors(
        primary: Color(json['primary']),
        secondary: Color(json['secondary']),
        accent: Color(json['accent']),
        background: Color(json['background']),
        surface: Color(json['surface']),
        textPrimary: Color(json['textPrimary']),
        textSecondary: Color(json['textSecondary']),
      );
}

/// Dialog style for cultural personalization
enum DialogStyle {
  casual, // Informal, friendly
  formal, // Polite, professional
  respectful, // Very polite, honorifics
  enthusiastic, // Energetic, motivating
}

/// Animation style preferences
enum AnimationStyle {
  minimal, // Simple fades
  moderate, // Smooth transitions
  expressive, // Rich animations
  cultural, // Theme-specific animations
}

/// Predefined cultural themes
class CulturalThemes {
  static const classic = CulturalTheme(
    id: 'classic',
    name: 'Classic',
    emoji: '📘',
    description: 'Traditional academic style',
    colors: ThemeColors(
      primary: Color(0xFF1976D2),
      secondary: Color(0xFF424242),
      accent: Color(0xFF00BCD4),
      background: Color(0xFFFAFAFA),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF212121),
      textSecondary: Color(0xFF757575),
    ),
    dialogStyle: DialogStyle.formal,
    culturalKeywords: ['student', 'study', 'learn', 'practice'],
    animationStyle: AnimationStyle.minimal,
  );

  static const japanese = CulturalTheme(
    id: 'japanese',
    name: 'Japanese',
    emoji: '🌸',
    description: 'Sakura, minimalism, and respect',
    colors: ThemeColors(
      primary: Color(0xFFFFB7C5), // Sakura pink
      secondary: Color(0xFF4A4E69), // Indigo
      accent: Color(0xFFFF6B9D),
      background: Color(0xFFFFF8F0),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF2D3142),
      textSecondary: Color(0xFF9094A0),
    ),
    dialogStyle: DialogStyle.respectful,
    culturalKeywords: ['sensei', 'practice', 'harmony', 'perseverance'],
    animationStyle: AnimationStyle.cultural,
  );

  static const eastern = CulturalTheme(
    id: 'eastern',
    name: 'Eastern',
    emoji: '🕌',
    description: 'Rich patterns and golden accents',
    colors: ThemeColors(
      primary: Color(0xFFD4AF37), // Gold
      secondary: Color(0xFF00695C), // Deep teal
      accent: Color(0xFFFF6F00),
      background: Color(0xFFFFF8E1),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1B5E20),
      textSecondary: Color(0xFF558B2F),
    ),
    dialogStyle: DialogStyle.respectful,
    culturalKeywords: ['wisdom', 'knowledge', 'patience', 'journey'],
    animationStyle: AnimationStyle.expressive,
  );

  static const cyberpunk = CulturalTheme(
    id: 'cyberpunk',
    name: 'Cyberpunk',
    emoji: '🤖',
    description: 'Neon, tech, and futuristic vibes',
    colors: ThemeColors(
      primary: Color(0xFF00F0FF), // Cyan neon
      secondary: Color(0xFFFF006E), // Magenta
      accent: Color(0xFF8338EC),
      background: Color(0xFF0A0E27),
      surface: Color(0xFF1A1F3A),
      textPrimary: Color(0xFF00F0FF),
      textSecondary: Color(0xFF7B8CDE),
    ),
    dialogStyle: DialogStyle.casual,
    culturalKeywords: ['hack', 'code', 'digital', 'virtual', 'system'],
    animationStyle: AnimationStyle.expressive,
  );

  static const scandinavian = CulturalTheme(
    id: 'scandinavian',
    name: 'Scandinavian',
    emoji: '🌲',
    description: 'Minimalist, natural, and calm',
    colors: ThemeColors(
      primary: Color(0xFF5E7C87), // Sage blue
      secondary: Color(0xFF8B7E74), // Warm grey
      accent: Color(0xFFD4A574),
      background: Color(0xFFF5F5F0),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF2E3338),
      textSecondary: Color(0xFF6B7280),
    ),
    dialogStyle: DialogStyle.casual,
    culturalKeywords: ['nature', 'simple', 'clear', 'focus'],
    animationStyle: AnimationStyle.minimal,
  );

  static const vibrant = CulturalTheme(
    id: 'vibrant',
    name: 'Vibrant',
    emoji: '🌈',
    description: 'Colorful, energetic, and fun',
    colors: ThemeColors(
      primary: Color(0xFFFF6B6B),
      secondary: Color(0xFF4ECDC4),
      accent: Color(0xFFFFE66D),
      background: Color(0xFFFFFBF0),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF2C3E50),
      textSecondary: Color(0xFF7F8C8D),
    ),
    dialogStyle: DialogStyle.enthusiastic,
    culturalKeywords: ['awesome', 'amazing', 'great', 'fantastic'],
    animationStyle: AnimationStyle.expressive,
  );

  static const african = CulturalTheme(
    id: 'african',
    name: 'African',
    emoji: '🦁',
    description: 'Earth tones and vibrant patterns',
    colors: ThemeColors(
      primary: Color(0xFFE67E22), // Warm orange
      secondary: Color(0xFF8B4513), // Earth brown
      accent: Color(0xFFF39C12),
      background: Color(0xFFFFF8DC),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF3E2723),
      textSecondary: Color(0xFF6D4C41),
    ),
    dialogStyle: DialogStyle.enthusiastic,
    culturalKeywords: ['wisdom', 'community', 'strength', 'heritage'],
    animationStyle: AnimationStyle.cultural,
  );

  static const latinAmerican = CulturalTheme(
    id: 'latin_american',
    name: 'Latin American',
    emoji: '🎉',
    description: 'Festive colors and warm spirit',
    colors: ThemeColors(
      primary: Color(0xFFE91E63), // Vibrant pink
      secondary: Color(0xFF009688), // Teal
      accent: Color(0xFFFFC107),
      background: Color(0xFFFFF9C4),
      surface: Color(0xFFFFFFFF),
      textPrimary: Color(0xFF1B5E20),
      textSecondary: Color(0xFF388E3C),
    ),
    dialogStyle: DialogStyle.enthusiastic,
    culturalKeywords: ['fiesta', 'passion', 'family', 'celebration'],
    animationStyle: AnimationStyle.expressive,
  );

  static List<CulturalTheme> get all => [
        classic,
        japanese,
        eastern,
        cyberpunk,
        scandinavian,
        vibrant,
        african,
        latinAmerican,
      ];

  static CulturalTheme? getById(String id) {
    try {
      return all.firstWhere((theme) => theme.id == id);
    } catch (e) {
      return null;
    }
  }
}
