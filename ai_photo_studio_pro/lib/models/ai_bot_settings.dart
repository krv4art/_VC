class AiBotSettings {
  final String? id;
  final String name;
  final String description;
  final bool isCustomPromptEnabled;
  final String customPrompt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AiBotSettings({
    this.id,
    required this.name,
    required this.description,
    this.isCustomPromptEnabled = false,
    this.customPrompt = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // Создание копии с измененными полями
  AiBotSettings copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCustomPromptEnabled,
    String? customPrompt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AiBotSettings(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCustomPromptEnabled:
          isCustomPromptEnabled ?? this.isCustomPromptEnabled,
      customPrompt: customPrompt ?? this.customPrompt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Преобразование в Map для сохранения в базу данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_custom_prompt_enabled': isCustomPromptEnabled,
      'custom_prompt': customPrompt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Создание объекта из Map (из базы данных)
  factory AiBotSettings.fromMap(Map<String, dynamic> map) {
    return AiBotSettings(
      id: map['id'],
      name: map['name'] ?? 'ACS',
      description:
          map['description'] ??
          'Hi! I\'m ACS — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.',
      isCustomPromptEnabled: map['is_custom_prompt_enabled'] ?? false,
      customPrompt: map['custom_prompt'] ?? '',
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        map['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Преобразование в JSON для SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isCustomPromptEnabled': isCustomPromptEnabled,
      'customPrompt': customPrompt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Создание объекта из JSON (из SharedPreferences)
  factory AiBotSettings.fromJson(Map<String, dynamic> json) {
    return AiBotSettings(
      id: json['id'],
      name: json['name'] ?? 'ACS',
      description:
          json['description'] ??
          'Hi! I\'m ACS — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.',
      isCustomPromptEnabled: json['isCustomPromptEnabled'] ?? false,
      customPrompt: json['customPrompt'] ?? '',
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Создание настроек по умолчанию
  factory AiBotSettings.defaultSettings() {
    final now = DateTime.now();
    return AiBotSettings(
      name: 'ACS',
      description:
          'Hi! I\'m ACS — AI Cosmetic Scanner. I\'ll help you understand the composition of your cosmetics. I have a huge wealth of knowledge in cosmetology and care. I\'ll be happy to answer any of your questions.',
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  String toString() {
    return 'AiBotSettings(id: $id, name: $name, description: $description, isCustomPromptEnabled: $isCustomPromptEnabled, customPrompt: $customPrompt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiBotSettings &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.isCustomPromptEnabled == isCustomPromptEnabled &&
        other.customPrompt == customPrompt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        isCustomPromptEnabled.hashCode ^
        customPrompt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
