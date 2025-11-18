import 'dart:convert';

/// Custom section model for flexible resume sections
class CustomSection {
  final String id;
  final String title;
  final List<CustomSectionItem> items;
  final int order; // For sorting sections

  CustomSection({
    required this.id,
    required this.title,
    required this.items,
    this.order = 0,
  });

  CustomSection copyWith({
    String? id,
    String? title,
    List<CustomSectionItem>? items,
    int? order,
  }) {
    return CustomSection(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
      'order': order,
    };
  }

  factory CustomSection.fromJson(Map<String, dynamic> json) {
    return CustomSection(
      id: json['id'],
      title: json['title'],
      items: (json['items'] as List)
          .map((item) => CustomSectionItem.fromJson(item))
          .toList(),
      order: json['order'] ?? 0,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory CustomSection.fromJsonString(String jsonString) {
    return CustomSection.fromJson(jsonDecode(jsonString));
  }
}

/// Custom section item
class CustomSectionItem {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final List<String> bulletPoints;

  CustomSectionItem({
    required this.id,
    required this.title,
    this.subtitle,
    this.description,
    this.bulletPoints = const [],
  });

  CustomSectionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    List<String>? bulletPoints,
  }) {
    return CustomSectionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      bulletPoints: bulletPoints ?? this.bulletPoints,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'bulletPoints': bulletPoints,
    };
  }

  factory CustomSectionItem.fromJson(Map<String, dynamic> json) {
    return CustomSectionItem(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      bulletPoints: List<String>.from(json['bulletPoints'] ?? []),
    );
  }
}
