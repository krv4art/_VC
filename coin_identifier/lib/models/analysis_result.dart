import 'package:flutter/foundation.dart';

/// Информация о металле/материале монеты
class CoinMaterial {
  final String name;
  final double percentage;
  final String description;

  CoinMaterial({
    required this.name,
    required this.percentage,
    required this.description,
  });

  factory CoinMaterial.fromJson(Map<String, dynamic> json) {
    return CoinMaterial(
      name: json['name'] as String? ?? '',
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'percentage': percentage,
      'description': description,
    };
  }
}

/// Оценка рыночной стоимости монеты
class MarketValue {
  final double minPrice;
  final double maxPrice;
  final String currency;
  final String condition; // Poor, Fair, Good, Very Good, Excellent, Uncirculated
  final String confidence; // low, medium, high
  final String source;

  MarketValue({
    required this.minPrice,
    required this.maxPrice,
    required this.currency,
    required this.condition,
    required this.confidence,
    required this.source,
  });

  factory MarketValue.fromJson(Map<String, dynamic> json) {
    return MarketValue(
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      condition: json['condition'] as String? ?? 'Good',
      confidence: json['confidence'] as String? ?? 'medium',
      source: json['source'] as String? ?? 'Market research',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'min_price': minPrice,
      'max_price': maxPrice,
      'currency': currency,
      'condition': condition,
      'confidence': confidence,
      'source': source,
    };
  }

  String getFormattedRange() {
    return '$currency ${minPrice.toStringAsFixed(0)} - ${maxPrice.toStringAsFixed(0)}';
  }
}

/// Информация об ошибках чеканки
class MintError {
  final String errorType;
  final String description;
  final String rarityImpact;
  final String? estimatedValueIncrease;

  MintError({
    required this.errorType,
    required this.description,
    required this.rarityImpact,
    this.estimatedValueIncrease,
  });

  factory MintError.fromJson(Map<String, dynamic> json) {
    return MintError(
      errorType: json['error_type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rarityImpact: json['rarity_impact'] as String? ?? '',
      estimatedValueIncrease: json['estimated_value_increase'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error_type': errorType,
      'description': description,
      'rarity_impact': rarityImpact,
      'estimated_value_increase': estimatedValueIncrease,
    };
  }
}

/// Результат анализа монеты или банкноты
class AnalysisResult {
  // Тип объекта
  final bool isCoinOrBanknote;
  final String? humorousMessage; // Если не монета/банкнота
  final String itemType; // "coin" или "banknote"

  // Основная информация
  final String name;
  final String? country;
  final String? yearOfIssue;
  final String? mintMark; // Знак монетного двора
  final String? denomination; // Номинал

  // Детальное описание
  final String description;
  final String? obverseDescription; // Описание аверса (лицевая сторона)
  final String? reverseDescription; // Описание реверса (обратная сторона)

  // Физические характеристики
  final List<CoinMaterial> materials;
  final double? weight; // в граммах
  final double? diameter; // в мм
  final String? edge; // Тип гурта (гладкий, рифленый, надпись)

  // Редкость и ценность
  final String rarityLevel; // Common, Uncommon, Rare, Very Rare, Extremely Rare
  final int rarityScore; // 1-10
  final MarketValue? marketValue;
  final String? collectorInterest;

  // Историческая информация
  final String historicalContext;
  final String? mintageQuantity; // Тираж
  final String? circulationPeriod;

  // Ошибки и особенности
  final List<MintError> mintErrors;
  final List<String> specialFeatures;
  final List<String> warnings; // Предупреждения (подделка, износ и т.д.)

  // Рекомендации
  final String? authenticityNotes;
  final List<String> similarCoins;
  final String? aiSummary;
  final String? expertAdvice;

  AnalysisResult({
    required this.isCoinOrBanknote,
    this.humorousMessage,
    required this.itemType,
    required this.name,
    this.country,
    this.yearOfIssue,
    this.mintMark,
    this.denomination,
    required this.description,
    this.obverseDescription,
    this.reverseDescription,
    required this.materials,
    this.weight,
    this.diameter,
    this.edge,
    required this.rarityLevel,
    required this.rarityScore,
    this.marketValue,
    this.collectorInterest,
    required this.historicalContext,
    this.mintageQuantity,
    this.circulationPeriod,
    required this.mintErrors,
    required this.specialFeatures,
    required this.warnings,
    this.authenticityNotes,
    required this.similarCoins,
    this.aiSummary,
    this.expertAdvice,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      isCoinOrBanknote: json['is_coin_or_banknote'] as bool? ?? false,
      humorousMessage: json['humorous_message'] as String?,
      itemType: json['item_type'] as String? ?? 'coin',
      name: json['name'] as String? ?? '',
      country: json['country'] as String?,
      yearOfIssue: json['year_of_issue'] as String?,
      mintMark: json['mint_mark'] as String?,
      denomination: json['denomination'] as String?,
      description: json['description'] as String? ?? '',
      obverseDescription: json['obverse_description'] as String?,
      reverseDescription: json['reverse_description'] as String?,
      materials: (json['materials'] as List<dynamic>?)
              ?.map((item) => CoinMaterial.fromJson(
                  item is Map ? item.cast<String, dynamic>() : {}))
              .toList() ??
          [],
      weight: (json['weight'] as num?)?.toDouble(),
      diameter: (json['diameter'] as num?)?.toDouble(),
      edge: json['edge'] as String?,
      rarityLevel: json['rarity_level'] as String? ?? 'Common',
      rarityScore: json['rarity_score'] as int? ?? 1,
      marketValue: json['market_value'] != null
          ? MarketValue.fromJson(
              json['market_value'] as Map<String, dynamic>,
            )
          : null,
      collectorInterest: json['collector_interest'] as String?,
      historicalContext: json['historical_context'] as String? ?? '',
      mintageQuantity: json['mintage_quantity'] as String?,
      circulationPeriod: json['circulation_period'] as String?,
      mintErrors: (json['mint_errors'] as List<dynamic>?)
              ?.map((item) => MintError.fromJson(
                  item is Map ? item.cast<String, dynamic>() : {}))
              .toList() ??
          [],
      specialFeatures: (json['special_features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      authenticityNotes: json['authenticity_notes'] as String?,
      similarCoins: (json['similar_coins'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      aiSummary: json['ai_summary'] as String?,
      expertAdvice: json['expert_advice'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_coin_or_banknote': isCoinOrBanknote,
      'humorous_message': humorousMessage,
      'item_type': itemType,
      'name': name,
      'country': country,
      'year_of_issue': yearOfIssue,
      'mint_mark': mintMark,
      'denomination': denomination,
      'description': description,
      'obverse_description': obverseDescription,
      'reverse_description': reverseDescription,
      'materials': materials.map((e) => e.toJson()).toList(),
      'weight': weight,
      'diameter': diameter,
      'edge': edge,
      'rarity_level': rarityLevel,
      'rarity_score': rarityScore,
      'market_value': marketValue?.toJson(),
      'collector_interest': collectorInterest,
      'historical_context': historicalContext,
      'mintage_quantity': mintageQuantity,
      'circulation_period': circulationPeriod,
      'mint_errors': mintErrors.map((e) => e.toJson()).toList(),
      'special_features': specialFeatures,
      'warnings': warnings,
      'authenticity_notes': authenticityNotes,
      'similar_coins': similarCoins,
      'ai_summary': aiSummary,
      'expert_advice': expertAdvice,
    };
  }
}
