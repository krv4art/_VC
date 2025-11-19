/// История изменения цен на предмет
class PriceHistory {
  final String itemName;
  final List<PricePoint> pricePoints;
  final double? currentEstimatedValue;
  final double? changePercentage;
  final PriceTrend trend; // rising, falling, stable

  PriceHistory({
    required this.itemName,
    required this.pricePoints,
    this.currentEstimatedValue,
    this.changePercentage,
    this.trend = PriceTrend.stable,
  });

  factory PriceHistory.fromJson(Map<String, dynamic> json) {
    return PriceHistory(
      itemName: json['itemName'] as String? ?? '',
      pricePoints: (json['pricePoints'] as List<dynamic>?)
              ?.map((e) => PricePoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentEstimatedValue: (json['currentEstimatedValue'] as num?)?.toDouble(),
      changePercentage: (json['changePercentage'] as num?)?.toDouble(),
      trend: PriceTrend.values.firstWhere(
        (t) => t.toString() == json['trend'],
        orElse: () => PriceTrend.stable,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'pricePoints': pricePoints.map((p) => p.toJson()).toList(),
      'currentEstimatedValue': currentEstimatedValue,
      'changePercentage': changePercentage,
      'trend': trend.toString(),
    };
  }
}

/// Точка данных о цене в определенный момент времени
class PricePoint {
  final DateTime date;
  final double minPrice;
  final double maxPrice;
  final String source; // 'user_analysis', 'market_data', 'manual'
  final String? notes;

  PricePoint({
    required this.date,
    required this.minPrice,
    required this.maxPrice,
    required this.source,
    this.notes,
  });

  double get averagePrice => (minPrice + maxPrice) / 2;

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      date: DateTime.parse(json['date'] as String),
      minPrice: (json['minPrice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxPrice'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? 'user_analysis',
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'source': source,
      'notes': notes,
    };
  }
}

/// Тренд изменения цены
enum PriceTrend {
  rising,
  falling,
  stable,
}

/// Уведомление об изменении цены
class PriceAlert {
  final String id;
  final String itemName;
  final double targetPrice;
  final PriceAlertCondition condition; // above, below, change_percentage
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  PriceAlert({
    required this.id,
    required this.itemName,
    required this.targetPrice,
    required this.condition,
    this.isActive = true,
    required this.createdAt,
    this.triggeredAt,
  });

  factory PriceAlert.fromJson(Map<String, dynamic> json) {
    return PriceAlert(
      id: json['id'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      targetPrice: (json['targetPrice'] as num?)?.toDouble() ?? 0.0,
      condition: PriceAlertCondition.values.firstWhere(
        (c) => c.toString() == json['condition'],
        orElse: () => PriceAlertCondition.above,
      ),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      triggeredAt: json['triggeredAt'] != null
          ? DateTime.parse(json['triggeredAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'targetPrice': targetPrice,
      'condition': condition.toString(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'triggeredAt': triggeredAt?.toIso8601String(),
    };
  }
}

/// Условие для price alert
enum PriceAlertCondition {
  above, // Цена выше целевой
  below, // Цена ниже целевой
  changePercentage, // Изменение на X%
}
