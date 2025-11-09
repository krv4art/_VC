import 'package:flutter/foundation.dart';

// ========================================
// LEGACY COSMETICS MODEL
// This file is kept for backward compatibility
// New insect identification code should use BugAnalysis from bug_analysis.dart
// ========================================

class IngredientInfo {
  final String name;
  final String hint; // Подсказка о риске/безопасности
  final String? originalName; // Оригинальное название на языке этикетки

  IngredientInfo({
    required this.name,
    required this.hint,
    this.originalName,
  });

  factory IngredientInfo.fromJson(Map<String, dynamic> json) {
    return IngredientInfo(
      name: json['name'] as String? ?? '',
      hint: json['hint'] as String? ?? '',
      originalName: json['original_name'] as String?,
    );
  }

  factory IngredientInfo.fromDynamic(dynamic data) {
    // Если это строка - проверяем, не является ли она "Instance of..."
    if (data is String) {
      // Фильтруем испорченные данные
      if (data.startsWith('Instance of')) {
        debugPrint('=== WARNING: Found corrupted data: $data ===');
        return IngredientInfo(
          name: '',
          hint: '',
        ); // Возвращаем пустой объект для испорченных данных
      }
      return IngredientInfo(name: data, hint: '');
    }
    // Если это Map - новый формат
    else if (data is Map<String, dynamic>) {
      return IngredientInfo.fromJson(data);
    }
    // Если это Map<dynamic, dynamic> - преобразуем в Map<String, dynamic>
    else if (data is Map) {
      final converted = Map<String, dynamic>.from(data);
      return IngredientInfo.fromJson(converted);
    }
    // Если null или пустое - возвращаем пустой объект
    else if (data == null) {
      return IngredientInfo(name: '', hint: '');
    }
    // Любой другой тип - пытаемся преобразовать в строку
    else {
      debugPrint(
        '=== WARNING: Unexpected data type: ${data.runtimeType}, value: $data ===',
      );
      return IngredientInfo(name: data.toString(), hint: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hint': hint,
      'original_name': originalName,
    };
  }
}

class AnalysisResult {
  final bool isCosmeticLabel;
  final String? humorousMessage;
  final List<String> ingredients;
  final double overallSafetyScore;
  final List<IngredientInfo> highRiskIngredients;
  final List<IngredientInfo> moderateRiskIngredients;
  final List<IngredientInfo> lowRiskIngredients;
  final List<String> personalizedWarnings;
  final String benefitsAnalysis;
  final List<RecommendedAlternative> recommendedAlternatives;
  // New fields for enhanced analysis
  final String? aiSummary; // Emotional verdict from AI
  final String? productType; // Type of product (cream, shampoo, etc.)
  final String? brandName; // Brand name if recognized
  final PremiumInsights? premiumInsights; // Premium-only insights

  AnalysisResult({
    required this.isCosmeticLabel,
    this.humorousMessage,
    required this.ingredients,
    required this.overallSafetyScore,
    required this.highRiskIngredients,
    required this.moderateRiskIngredients,
    required this.lowRiskIngredients,
    required this.personalizedWarnings,
    required this.benefitsAnalysis,
    required this.recommendedAlternatives,
    this.aiSummary,
    this.productType,
    this.brandName,
    this.premiumInsights,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      isCosmeticLabel: json['is_cosmetic_label'] as bool? ?? false,
      humorousMessage: json['humorous_message'] as String?,
      ingredients:
          (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      overallSafetyScore:
          (json['overall_safety_score'] as num?)?.toDouble() ?? 0.0,
      highRiskIngredients:
          (json['high_risk_ingredients'] as List<dynamic>?)
              ?.map((item) => IngredientInfo.fromDynamic(item))
              .toList() ??
          [],
      moderateRiskIngredients:
          (json['moderate_risk_ingredients'] as List<dynamic>?)
              ?.map((item) => IngredientInfo.fromDynamic(item))
              .toList() ??
          [],
      lowRiskIngredients:
          (json['low_risk_ingredients'] as List<dynamic>?)
              ?.map((item) => IngredientInfo.fromDynamic(item))
              .toList() ??
          [],
      personalizedWarnings:
          (json['personalized_warnings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      benefitsAnalysis: json['benefits_analysis'] as String? ?? '',
      recommendedAlternatives:
          (json['recommended_alternatives'] as List<dynamic>?)
              ?.map(
                (e) =>
                    RecommendedAlternative.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      aiSummary: json['ai_summary'] as String?,
      productType: json['product_type'] as String?,
      brandName: json['brand_name'] as String?,
      premiumInsights: json['premium_insights'] != null
          ? PremiumInsights.fromJson(
              json['premium_insights'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_cosmetic_label': isCosmeticLabel,
      'humorous_message': humorousMessage,
      'ingredients': ingredients,
      'overall_safety_score': overallSafetyScore,
      'high_risk_ingredients': highRiskIngredients
          .map((e) => e.toJson())
          .toList(),
      'moderate_risk_ingredients': moderateRiskIngredients
          .map((e) => e.toJson())
          .toList(),
      'low_risk_ingredients': lowRiskIngredients
          .map((e) => e.toJson())
          .toList(),
      'personalized_warnings': personalizedWarnings,
      'benefits_analysis': benefitsAnalysis,
      'recommended_alternatives': recommendedAlternatives
          .map((e) => e.toJson())
          .toList(),
      'ai_summary': aiSummary,
      'product_type': productType,
      'brand_name': brandName,
      'premium_insights': premiumInsights?.toJson(),
    };
  }
}

class RecommendedAlternative {
  final String name;
  final String description;
  final String reason;

  RecommendedAlternative({
    required this.name,
    required this.description,
    required this.reason,
  });

  factory RecommendedAlternative.fromJson(Map<String, dynamic> json) {
    return RecommendedAlternative(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'reason': reason};
  }
}

/// Premium insights data for enhanced analysis
class PremiumInsights {
  final int? researchArticlesCount; // Number of scientific research articles
  final String? categoryRank; // Ranking among similar products
  final String? safetyTrend; // Safety trend information

  PremiumInsights({
    this.researchArticlesCount,
    this.categoryRank,
    this.safetyTrend,
  });

  factory PremiumInsights.fromJson(Map<String, dynamic> json) {
    return PremiumInsights(
      researchArticlesCount: json['research_articles_count'] as int?,
      categoryRank: json['category_rank'] as String?,
      safetyTrend: json['safety_trend'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'research_articles_count': researchArticlesCount,
      'category_rank': categoryRank,
      'safety_trend': safetyTrend,
    };
  }
}
