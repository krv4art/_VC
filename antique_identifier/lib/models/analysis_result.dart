import 'package:flutter/foundation.dart';
import 'similar_item.dart';

/// Информация о материале антикварного предмета
class MaterialInfo {
  final String name;
  final String description;
  final String? era;

  MaterialInfo({
    required this.name,
    required this.description,
    this.era,
  });

  factory MaterialInfo.fromJson(Map<String, dynamic> json) {
    return MaterialInfo(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      era: json['era'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'era': era,
    };
  }
}

/// Оценка стоимости антикварного предмета
class PriceEstimate {
  final double minPrice;
  final double maxPrice;
  final String currency;
  final String confidence; // low, medium, high
  final String basedOn;

  PriceEstimate({
    required this.minPrice,
    required this.maxPrice,
    required this.currency,
    required this.confidence,
    required this.basedOn,
  });

  factory PriceEstimate.fromJson(Map<String, dynamic> json) {
    return PriceEstimate(
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      confidence: json['confidence'] as String? ?? 'low',
      basedOn: json['based_on'] as String? ?? 'Market research',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'currency': currency,
      'confidence': confidence,
      'based_on': basedOn,
    };
  }

  String getFormattedRange() {
    return '$currency ${minPrice.toStringAsFixed(0)} - ${maxPrice.toStringAsFixed(0)}';
  }
}

/// Результат анализа антикварного предмета
class AnalysisResult {
  final bool isAntique;
  final String? humorousMessage;
  final String itemName;
  final String? category;
  final String description;
  final List<MaterialInfo> materials;
  final String historicalContext;
  final String? estimatedPeriod;
  final String? estimatedOrigin;
  final PriceEstimate? priceEstimate;
  final List<String> warnings;
  final String? authenticityNotes;
  final List<String> similarItems;
  final String? aiSummary;
  final List<SimilarItem> visualMatches; // Visual matches from online marketplaces
  final bool? isFavorite; // User favorite flag
  final List<String> tags; // User-defined tags
  final String? notes; // User notes

  AnalysisResult({
    required this.isAntique,
    this.humorousMessage,
    required this.itemName,
    this.category,
    required this.description,
    required this.materials,
    required this.historicalContext,
    this.estimatedPeriod,
    this.estimatedOrigin,
    this.priceEstimate,
    required this.warnings,
    this.authenticityNotes,
    required this.similarItems,
    this.aiSummary,
    this.visualMatches = const [],
    this.isFavorite = false,
    this.tags = const [],
    this.notes,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      isAntique: json['is_antique'] as bool? ?? false,
      humorousMessage: json['humorous_message'] as String?,
      itemName: json['item_name'] as String? ?? '',
      category: json['category'] as String?,
      description: json['description'] as String? ?? '',
      materials: (json['materials'] as List<dynamic>?)
              ?.map((item) => MaterialInfo.fromJson(
                  item is Map ? item.cast<String, dynamic>() : {}))
              .toList() ??
          [],
      historicalContext: json['historical_context'] as String? ?? '',
      estimatedPeriod: json['estimated_period'] as String?,
      estimatedOrigin: json['estimated_origin'] as String?,
      priceEstimate: json['price_estimate'] != null
          ? PriceEstimate.fromJson(
              json['price_estimate'] as Map<String, dynamic>,
            )
          : null,
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      authenticityNotes: json['authenticity_notes'] as String?,
      similarItems: (json['similar_items'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      aiSummary: json['ai_summary'] as String?,
      visualMatches: (json['visual_matches'] as List<dynamic>?)
              ?.map((item) => SimilarItem.fromJson(
                  item is Map ? item.cast<String, dynamic>() : {}))
              .toList() ??
          [],
      isFavorite: json['is_favorite'] as bool?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_antique': isAntique,
      'humorous_message': humorousMessage,
      'item_name': itemName,
      'category': category,
      'description': description,
      'materials': materials.map((e) => e.toJson()).toList(),
      'historical_context': historicalContext,
      'estimated_period': estimatedPeriod,
      'estimated_origin': estimatedOrigin,
      'price_estimate': priceEstimate?.toJson(),
      'warnings': warnings,
      'authenticity_notes': authenticityNotes,
      'similar_items': similarItems,
      'ai_summary': aiSummary,
      'visual_matches': visualMatches.map((e) => e.toJson()).toList(),
      'is_favorite': isFavorite,
      'tags': tags,
      'notes': notes,
    };
  }

  /// Creates a copy with updated fields
  AnalysisResult copyWith({
    bool? isAntique,
    String? humorousMessage,
    String? itemName,
    String? category,
    String? description,
    List<MaterialInfo>? materials,
    String? historicalContext,
    String? estimatedPeriod,
    String? estimatedOrigin,
    PriceEstimate? priceEstimate,
    List<String>? warnings,
    String? authenticityNotes,
    List<String>? similarItems,
    String? aiSummary,
    List<SimilarItem>? visualMatches,
    bool? isFavorite,
    List<String>? tags,
    String? notes,
  }) {
    return AnalysisResult(
      isAntique: isAntique ?? this.isAntique,
      humorousMessage: humorousMessage ?? this.humorousMessage,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      description: description ?? this.description,
      materials: materials ?? this.materials,
      historicalContext: historicalContext ?? this.historicalContext,
      estimatedPeriod: estimatedPeriod ?? this.estimatedPeriod,
      estimatedOrigin: estimatedOrigin ?? this.estimatedOrigin,
      priceEstimate: priceEstimate ?? this.priceEstimate,
      warnings: warnings ?? this.warnings,
      authenticityNotes: authenticityNotes ?? this.authenticityNotes,
      similarItems: similarItems ?? this.similarItems,
      aiSummary: aiSummary ?? this.aiSummary,
      visualMatches: visualMatches ?? this.visualMatches,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }
}
