/// Предустановленные стили фона
class BackgroundStyle {
  final String id;
  final String name;
  final String description;
  final String prompt;
  final String? previewImage;
  final String category;
  final bool isPremium;

  const BackgroundStyle({
    required this.id,
    required this.name,
    required this.description,
    required this.prompt,
    this.previewImage,
    required this.category,
    this.isPremium = false,
  });

  /// Создание объекта из JSON
  factory BackgroundStyle.fromJson(Map<String, dynamic> json) {
    return BackgroundStyle(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      prompt: json['prompt'] as String,
      previewImage: json['preview_image'] as String?,
      category: json['category'] as String,
      isPremium: json['is_premium'] as bool? ?? false,
    );
  }

  /// Преобразование объекта в JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'prompt': prompt,
      'preview_image': previewImage,
      'category': category,
      'is_premium': isPremium,
    };
  }
}

/// Предустановленные стили
class BackgroundStyles {
  static const List<BackgroundStyle> predefined = [
    BackgroundStyle(
      id: 'nature_forest',
      name: 'Forest Scene',
      description: 'Beautiful green forest with sunlight',
      prompt: 'lush green forest, sunlight filtering through trees, peaceful nature scene, high quality, 4k',
      category: 'Nature',
    ),
    BackgroundStyle(
      id: 'nature_beach',
      name: 'Beach Paradise',
      description: 'Tropical beach with crystal clear water',
      prompt: 'tropical beach, crystal clear turquoise water, white sand, palm trees, sunny day, high quality, 4k',
      category: 'Nature',
    ),
    BackgroundStyle(
      id: 'nature_mountain',
      name: 'Mountain View',
      description: 'Majestic mountain landscape',
      prompt: 'majestic mountain peaks, clear blue sky, alpine landscape, high quality, 4k',
      category: 'Nature',
    ),
    BackgroundStyle(
      id: 'urban_city',
      name: 'City Skyline',
      description: 'Modern city skyline at sunset',
      prompt: 'modern city skyline, sunset, skyscrapers, urban landscape, high quality, 4k',
      category: 'Urban',
    ),
    BackgroundStyle(
      id: 'urban_street',
      name: 'City Street',
      description: 'Vibrant city street scene',
      prompt: 'vibrant city street, modern architecture, bokeh lights, urban photography, high quality, 4k',
      category: 'Urban',
    ),
    BackgroundStyle(
      id: 'studio_white',
      name: 'White Studio',
      description: 'Clean white studio background',
      prompt: 'professional white studio background, soft lighting, clean, minimal, high quality',
      category: 'Studio',
    ),
    BackgroundStyle(
      id: 'studio_gradient',
      name: 'Gradient Studio',
      description: 'Smooth gradient background',
      prompt: 'smooth gradient background, professional studio lighting, modern, elegant, high quality',
      category: 'Studio',
    ),
    BackgroundStyle(
      id: 'abstract_bokeh',
      name: 'Bokeh Lights',
      description: 'Beautiful bokeh light effect',
      prompt: 'beautiful bokeh lights, colorful, soft focus, dreamy atmosphere, high quality, 4k',
      category: 'Abstract',
    ),
    BackgroundStyle(
      id: 'abstract_colors',
      name: 'Color Splash',
      description: 'Vibrant abstract colors',
      prompt: 'vibrant abstract colors, artistic, modern, dynamic, high quality, 4k',
      category: 'Abstract',
    ),
    BackgroundStyle(
      id: 'office_modern',
      name: 'Modern Office',
      description: 'Contemporary office space',
      prompt: 'modern office interior, professional, clean, natural lighting, high quality, 4k',
      category: 'Professional',
      isPremium: true,
    ),
    BackgroundStyle(
      id: 'vintage_classic',
      name: 'Vintage Style',
      description: 'Classic vintage atmosphere',
      prompt: 'vintage style background, classic, warm tones, nostalgic atmosphere, high quality',
      category: 'Vintage',
      isPremium: true,
    ),
  ];

  /// Получение категорий
  static List<String> get categories {
    return predefined.map((style) => style.category).toSet().toList();
  }

  /// Получение стилей по категории
  static List<BackgroundStyle> getByCategory(String category) {
    return predefined.where((style) => style.category == category).toList();
  }

  /// Получение стиля по ID
  static BackgroundStyle? getById(String id) {
    try {
      return predefined.firstWhere((style) => style.id == id);
    } catch (e) {
      return null;
    }
  }
}
