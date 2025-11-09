import 'package:flutter/material.dart';

/// Интерфейс для всех цветовых палитр тем
abstract class AppColors {
  // === PRIMARY COLORS (Main accent - buttons, active states) ===
  Color get primary; // Main brand color (was naturalGreen)
  Color get primaryLight; // Lighter shade for gradients (was lightGreen)
  Color get primaryPale; // Palest shade for gradients (was paleGreen)
  Color get primaryDark; // Darker shade (was saddleBrown)

  // === SECONDARY COLORS (Supporting accent) - COMPUTED ===
  /// Secondary brand color computed from primary (hue shift -20°)
  Color get secondary {
    final hslColor = HSLColor.fromColor(primary);
    return hslColor
        .withHue((hslColor.hue - 20) % 360)
        .withSaturation((hslColor.saturation * 0.9).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darker secondary color (secondary with reduced lightness)
  Color get secondaryDark {
    final hslColor = HSLColor.fromColor(secondary);
    return hslColor
        .withLightness((hslColor.lightness * 0.7).clamp(0.0, 1.0))
        .toColor();
  }

  // === NEUTRAL COLORS (Gray scale) ===
  Color get neutral; // Mid-gray for borders, disabled (was mediumGrey)

  // === BACKGROUND COLORS ===
  Color get background; // Main background
  Color get surface; // Card/surface background

  // === TEXT COLORS (On various backgrounds) ===
  Color get onBackground; // Text on background
  Color get onSurface; // Text on surface

  // === SEMANTIC COLORS ===
  Color get success; // Green for success
  Color get warning; // Orange/yellow for warnings
  Color get error; // Red for errors
  Color get info; // Blue for info

  // === COMPUTED PROPERTIES (derived from other colors) ===

  /// Text color on primary colored backgrounds
  /// Light themes: white, Dark themes: dark gray
  Color get onPrimary =>
      brightness == Brightness.light ? Colors.white : const Color(0xFF212121);

  /// Text color on secondary colored elements
  /// Computed from secondary color for consistency
  Color get onSecondary => secondary;

  /// Cards use the same color as surface
  Color get cardBackground => surface;

  /// Shadow color derived from primary
  Color get shadowColor => primaryLight;

  /// AppBar uses surface color
  Color get appBarColor => surface;

  /// Navigation bar uses surface color
  Color get navBarColor => surface;

  // === GRADIENT ===
  LinearGradient get primaryGradient;

  // === BRIGHTNESS ===
  Brightness get brightness;

  // === BACKWARD COMPATIBILITY (deprecated - will be removed) ===
  @Deprecated('Use primaryDark instead')
  Color get saddleBrown => primaryDark;

  @Deprecated('Use primary instead')
  Color get naturalGreen => primary;

  @Deprecated('Use primaryLight instead')
  Color get lightGreen => primaryLight;

  @Deprecated('Use primaryPale instead')
  Color get paleGreen => primaryPale;

  @Deprecated('Use secondaryDark instead')
  Color get deepBrown => secondaryDark;

  @Deprecated('Use secondary instead')
  Color get mediumBrown => secondary;

  @Deprecated('Use neutral instead')
  Color get mediumGrey => neutral;
}

/// Natural тема (по умолчанию)
class NaturalColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF4CAF50); // Green

  @override
  final Color primaryLight = const Color(0xFF81C784); // Light Green

  @override
  final Color primaryPale = const Color(0xFFC8E6C9); // Pale Green

  @override
  final Color primaryDark = const Color(0xFF8D6E63); // Brown

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBDBDBD); // Medium Grey

  @override
  final Color background = const Color(0xFFF5F5DC); // Beige

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF6D4C41); // Brown

  @override
  final Color onSurface = const Color(0xFF212121); // Dark Gray

  @override
  final Color success = const Color(0xFF4CAF50);

  @override
  final Color warning = const Color(0xFFFF9800);

  @override
  final Color error = const Color(0xFFF44336);

  @override
  final Color info = const Color(0xFF2196F3);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;

  // Deprecated getters are inherited from AppColors interface
}

/// Темная тема
class DarkColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF81C784); // Light Green

  @override
  final Color primaryLight = const Color(0xFFA5D6A7); // Very Light Green

  @override
  final Color primaryPale = const Color(0xFFC8E6C9); // Pale Green

  @override
  final Color primaryDark = const Color(0xFFBCAAA4); // Light Brown

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1E1E1E); // Dark Gray

  @override
  final Color surface = const Color(0xFF2D2D2D); // Darker Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF42A5F5);

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;

  // Deprecated getters are inherited from AppColors interface
}

/// Ocean Theme (пример кастомной темы)
class OceanColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF00ACC1); // Cyan

  @override
  final Color primaryLight = const Color(0xFF4DD0E1); // Light Cyan

  @override
  final Color primaryPale = const Color(0xFFB2EBF2); // Very Light Cyan

  @override
  final Color primaryDark = const Color(0xFF01579B); // Deep Blue

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFB0BEC5);

  @override
  final Color background = const Color(0xFFE0F7FA); // Light Cyan

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF01579B); // Deep Blue

  @override
  final Color onSurface = const Color(0xFF01579B); // Deep Blue

  @override
  final Color success = const Color(0xFF00ACC1); // Cyan

  @override
  final Color warning = const Color(0xFF00ACC1); // Cyan

  @override
  final Color error = const Color(0xFF01579B); // Deep Blue

  @override
  final Color info = const Color(0xFF0288D1); // Light Blue

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;

  // Deprecated getters are inherited from AppColors interface
}

/// Forest Theme
class ForestColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF558B2F); // Forest Green

  @override
  final Color primaryLight = const Color(0xFF7CB342); // Light Forest Green

  @override
  final Color primaryPale = const Color(0xFFC5E1A5); // Pale Forest Green

  @override
  final Color primaryDark = const Color(0xFF33691E); // Dark Green

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFA1887F);

  @override
  final Color background = const Color(0xFFF1F8E9); // Light Green

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF33691E); // Dark Green

  @override
  final Color onSurface = const Color(0xFF33691E); // Dark Green

  @override
  final Color success = const Color(0xFF4CAF50); // Green

  @override
  final Color warning = const Color(0xFF8D6E63); // Brown

  @override
  final Color error = const Color(0xFFD32F2F); // Red

  @override
  final Color info = const Color(0xFF1976D2); // Blue

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;

  // Deprecated getters are inherited from AppColors interface
}

/// Sunset Theme
class SunsetColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFFFF9800); // Orange

  @override
  final Color primaryLight = const Color(0xFFFFB74D); // Light Orange

  @override
  final Color primaryPale = const Color(0xFFFFE0B2); // Pale Orange

  @override
  final Color primaryDark = const Color(0xFFBF6B4E); // Мягкий коричнево-оранжевый

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBCAAA4); // Теплый серо-бежевый

  @override
  final Color background = const Color(0xFFFFF3E0); // Light Orange

  @override
  final Color surface = const Color(0xFFFFEEE0); // Светло-персиковый, гармонирует с темой заката

  @override
  final Color onBackground = const Color(0xFF6D4C41); // Теплый коричневый

  @override
  final Color onSurface = const Color(0xFF6D4C41); // Теплый коричневый

  @override
  final Color success = const Color(0xFF4CAF50); // Green

  @override
  final Color warning = const Color(0xFFFF9800); // Orange

  @override
  final Color error = const Color(0xFFF44336); // Red

  @override
  final Color info = const Color(0xFF2196F3); // Blue

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;

  // Deprecated getters are inherited from AppColors interface
}

/// Темная Ocean тема (с голубыми акцентами)
class DarkOceanColors extends AppColors {
  // === PRIMARY COLORS ===
  // ИЗМЕНЕНО: Голубой primary
  @override
  final Color primary = const Color(0xFF4DD0E1); // Light Cyan

  // ИЗМЕНЕНО: Голубые оттенки вместо зеленых
  @override
  final Color primaryLight = const Color(0xFF4DD0E1); // Light Cyan 300

  @override
  final Color primaryPale = const Color(0xFF80DEEA); // Pale Cyan 200

  @override
  final Color primaryDark = const Color(0xFFBCAAA4); // Light Brown

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1E1E1E); // Dark Gray

  @override
  final Color surface = const Color(0xFF2D2D2D); // Darker Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF42A5F5);

  // ИЗМЕНЕНО: Голубой градиент
  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale], // Голубой градиент
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;

  // Deprecated getters are inherited from AppColors interface
}

/// Темная Forest тема (с лаймово-зелеными акцентами)
class DarkForestColors extends AppColors {
  // === PRIMARY COLORS ===
  // ИЗМЕНЕНО: Лаймовый primary
  @override
  final Color primary = const Color(0xFF9CCC65); // Light Lime

  // ИЗМЕНЕНО: Лаймово-зеленые оттенки
  @override
  final Color primaryLight = const Color(0xFF9CCC65); // Light Lime 400

  @override
  final Color primaryPale = const Color(0xFFC5E1A5); // Pale Lime 300

  @override
  final Color primaryDark = const Color(0xFFBCAAA4); // Light Brown

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1E1E1E); // Dark Gray

  @override
  final Color surface = const Color(0xFF2D2D2D); // Darker Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF42A5F5);

  // ИЗМЕНЕНО: Лаймовый градиент
  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale], // Лаймовый градиент
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;

  // Deprecated getters are inherited from AppColors interface
}

/// Темная Sunset тема (с оранжевыми акцентами)
class DarkSunsetColors extends AppColors {
  // === PRIMARY COLORS ===
  // ИЗМЕНЕНО: Оранжевый primary
  @override
  final Color primary = const Color(0xFFFFB74D); // Light Orange

  // ИЗМЕНЕНО: Оранжевые оттенки
  @override
  final Color primaryLight = const Color(0xFFFFB74D); // Light Orange 300

  @override
  final Color primaryPale = const Color(0xFFFFCC80); // Pale Orange 200

  @override
  final Color primaryDark = const Color(0xFF8D6E63); // Warm Brown (лучше сочетается с оранжевой темой)

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1E1E1E); // Dark Gray

  @override
  final Color surface = const Color(0xFF2D2D2D); // Darker Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

  @override
  final Color success = const Color(0xFF66BB6A);

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF42A5F5);

  // ИЗМЕНЕНО: Оранжевый градиент
  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [primaryLight, primaryPale], // Оранжевый градиент
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;

  // Deprecated getters are inherited from AppColors interface
}

/// Vibrant Theme (розово-фиолетовая тема)
class VibrantColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFFFF69B4); // Hot Pink

  @override
  final Color primaryLight = const Color(0xFFEE82EE); // Violet (вместо зеленого)

  @override
  final Color primaryPale = const Color(0xFFFFC0E3); // Light Pink (вместо зеленого)

  @override
  final Color primaryDark = const Color(0xFF8E24AA); // Яркий пурпурный (Purple 600)

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBCAAA4); // Теплый серо-бежевый

  @override
  final Color background = const Color(0xFFFFF0F5); // Lavender Blush

  @override
  final Color surface = Colors.white;

  @override
  final Color onBackground = const Color(0xFF6D4C41); // Теплый коричневый

  @override
  final Color onSurface = const Color(0xFF6D4C41); // Теплый коричневый

  @override
  final Color success = const Color(0xFF4CAF50); // Зеленый (стандартный)

  @override
  final Color warning = const Color(0xFFFF9800); // Оранжевый (стандартный)

  @override
  final Color error = const Color(0xFFF44336); // Red

  @override
  final Color info = const Color(0xFF9370DB); // Medium Purple

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [
      const Color(0xFFFF69B4), // Розовый
      const Color(0xFFDA70D6), // Орхидея
      const Color(0xFF9370DB), // Фиолетовый
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;

  // Deprecated getters are inherited from AppColors interface
}

/// Dark Vibrant Theme (темная версия розово-фиолетовой темы)
class DarkVibrantColors extends AppColors {
  // === PRIMARY COLORS ===
  // Яркий розово-фиолетовый primary (как в светлой версии)
  @override
  final Color primary = const Color(0xFFFF69B4); // Hot Pink

  // Сохраняем те же яркие акцентные цвета что и в светлой версии
  @override
  final Color primaryLight = const Color(0xFFEE82EE); // Violet (вместо зеленого)

  @override
  final Color primaryPale = const Color(0xFFFFC0E3); // Light Pink (вместо зеленого)

  @override
  final Color primaryDark = const Color(0xFFBCAAA4); // Light Brown

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF9E9E9E);

  @override
  final Color background = const Color(0xFF1E1E1E); // Dark Gray

  @override
  final Color surface = const Color(0xFF2D2D2D); // Darker Gray

  @override
  final Color onBackground = Colors.white;

  @override
  final Color onSurface = Colors.white;

  @override
  final Color success = const Color(0xFFDA70D6); // Orchid (вместо зеленого)

  @override
  final Color warning = const Color(0xFFFFB74D);

  @override
  final Color error = const Color(0xFFEF5350);

  @override
  final Color info = const Color(0xFF9370DB); // Medium Purple

  // Градиент без зеленого
  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [
      const Color(0xFFFF69B4), // Розовый
      const Color(0xFFDA70D6), // Орхидея
      const Color(0xFF9370DB), // Фиолетовый
    ],
    stops: const [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;

  // Deprecated getters are inherited from AppColors interface
}

/// Privacy Theme (приватный синий цвет для unseen приложения)
class PrivacyColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF1E88E5); // Синий (приватность)

  @override
  final Color primaryLight = const Color(0xFF42A5F5); // Светлый синий

  @override
  final Color primaryPale = const Color(0xFFBBDEFB); // Очень светлый синий

  @override
  final Color primaryDark = const Color(0xFF1565C0); // Темный синий

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFFBDBDBD); // Mid-gray

  // === BACKGROUND COLORS ===
  @override
  final Color background = const Color(0xFFFAFAFA); // Очень светлый фон

  @override
  final Color surface = Colors.white; // Белая поверхность

  // === TEXT COLORS ===
  @override
  final Color onBackground = const Color(0xFF212121); // Темный текст

  @override
  final Color onSurface = const Color(0xFF212121); // Темный текст

  // === SEMANTIC COLORS ===
  @override
  final Color success = const Color(0xFF4CAF50); // Зеленый

  @override
  final Color warning = const Color(0xFFFF9800); // Оранжевый

  @override
  final Color error = const Color(0xFFF44336); // Красный

  @override
  final Color info = const Color(0xFF1E88E5); // Синий

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [
      const Color(0xFF1E88E5), // Синий
      const Color(0xFF1565C0), // Темный синий
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.light;
}

/// Dark Privacy Theme (темная версия приватной темы)
class DarkPrivacyColors extends AppColors {
  // === PRIMARY COLORS ===
  @override
  final Color primary = const Color(0xFF42A5F5); // Светлый синий для темного фона

  @override
  final Color primaryLight = const Color(0xFF64B5F6); // Еще светлее синий

  @override
  final Color primaryPale = const Color(0xFFBBDEFB); // Бледный синий

  @override
  final Color primaryDark = const Color(0xFF1565C0); // Темный синий

  // === NEUTRAL COLORS ===
  @override
  final Color neutral = const Color(0xFF757575); // Светлый серый для темного фона

  // === BACKGROUND COLORS ===
  @override
  final Color background = const Color(0xFF121212); // Темный фон

  @override
  final Color surface = const Color(0xFF1E1E1E); // Темная поверхность

  // === TEXT COLORS ===
  @override
  final Color onBackground = const Color(0xFFFFFFFF); // Белый текст

  @override
  final Color onSurface = const Color(0xFFFFFFFF); // Белый текст

  // === SEMANTIC COLORS ===
  @override
  final Color success = const Color(0xFF81C784); // Светлый зеленый

  @override
  final Color warning = const Color(0xFFFFB74D); // Светлый оранжевый

  @override
  final Color error = const Color(0xFFEF5350); // Светлый красный

  @override
  final Color info = const Color(0xFF42A5F5); // Светлый синий

  @override
  LinearGradient get primaryGradient => LinearGradient(
    colors: [
      const Color(0xFF42A5F5), // Светлый синий
      const Color(0xFF1E88E5), // Синий
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Brightness get brightness => Brightness.dark;
}
