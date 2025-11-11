/// Model for a photo style
class StyleModel {
  final String id;
  final String name;
  final String description;
  final String previewUrl; // URL to preview image
  final StyleCategory category;
  final Map<String, String> localizedNames; // Localized names {locale: name}
  final Map<String, String> localizedDescriptions; // Localized descriptions
  final String? promptTemplate; // AI prompt template for this style
  final bool isPremium; // Requires premium subscription
  final int sortOrder; // Display order in catalog

  StyleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.previewUrl,
    required this.category,
    this.localizedNames = const {},
    this.localizedDescriptions = const {},
    this.promptTemplate,
    this.isPremium = false,
    this.sortOrder = 0,
  });

  /// Create from database map
  factory StyleModel.fromMap(Map<String, dynamic> map) {
    return StyleModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      previewUrl: map['preview_url'] as String,
      category: StyleCategory.values.firstWhere(
        (e) => e.toString() == 'StyleCategory.${map['category']}',
        orElse: () => StyleCategory.professional,
      ),
      localizedNames: map['localized_names'] != null
          ? Map<String, String>.from(map['localized_names'] as Map)
          : {},
      localizedDescriptions: map['localized_descriptions'] != null
          ? Map<String, String>.from(map['localized_descriptions'] as Map)
          : {},
      promptTemplate: map['prompt_template'] as String?,
      isPremium: map['is_premium'] == 1 || map['is_premium'] == true,
      sortOrder: map['sort_order'] as int? ?? 0,
    );
  }

  /// Convert to database map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'preview_url': previewUrl,
      'category': category.toString().split('.').last,
      'localized_names': localizedNames,
      'localized_descriptions': localizedDescriptions,
      'prompt_template': promptTemplate,
      'is_premium': isPremium ? 1 : 0,
      'sort_order': sortOrder,
    };
  }

  /// Get localized name or fallback to default
  String getLocalizedName(String locale) {
    return localizedNames[locale] ?? name;
  }

  /// Get localized description or fallback to default
  String getLocalizedDescription(String locale) {
    return localizedDescriptions[locale] ?? description;
  }

  /// Create copy with updated fields
  StyleModel copyWith({
    String? id,
    String? name,
    String? description,
    String? previewUrl,
    StyleCategory? category,
    Map<String, String>? localizedNames,
    Map<String, String>? localizedDescriptions,
    String? promptTemplate,
    bool? isPremium,
    int? sortOrder,
  }) {
    return StyleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      previewUrl: previewUrl ?? this.previewUrl,
      category: category ?? this.category,
      localizedNames: localizedNames ?? this.localizedNames,
      localizedDescriptions: localizedDescriptions ?? this.localizedDescriptions,
      promptTemplate: promptTemplate ?? this.promptTemplate,
      isPremium: isPremium ?? this.isPremium,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  String toString() {
    return 'StyleModel(id: $id, name: $name, category: $category, isPremium: $isPremium)';
  }
}

/// Categories of photo styles
enum StyleCategory {
  professional,  // Business headshots, LinkedIn
  casual,        // Casual everyday style
  creative,      // Artistic, creative styles
  formal,        // Formal attire
  outdoor,       // Outdoor backgrounds
  studio,        // Studio backgrounds
}
