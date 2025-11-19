import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/price_history.dart';
import '../models/analysis_result.dart';

/// Сервис отслеживания цен на предметы в коллекции
class PriceTrackingService {
  static const String _historyKey = 'price_history';
  static const String _alertsKey = 'price_alerts';
  final Uuid _uuid = const Uuid();

  /// Добавляет новую точку данных о цене
  Future<bool> addPricePoint({
    required String itemName,
    required double minPrice,
    required double maxPrice,
    String source = 'user_analysis',
    String? notes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getPriceHistory(itemName);

      final newPoint = PricePoint(
        date: DateTime.now(),
        minPrice: minPrice,
        maxPrice: maxPrice,
        source: source,
        notes: notes,
      );

      history.pricePoints.add(newPoint);

      // Пересчитываем тренд
      final updatedHistory = _calculateTrend(history);

      // Сохраняем
      await _savePriceHistory(itemName, updatedHistory);

      // Проверяем alerts
      await _checkAlerts(itemName, newPoint.averagePrice);

      developer.log('Price point added for $itemName', name: 'PriceTrackingService');
      return true;
    } catch (e) {
      developer.log('Error adding price point: $e', name: 'PriceTrackingService');
      return false;
    }
  }

  /// Получает историю цен для предмета
  Future<PriceHistory> getPriceHistory(String itemName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('$_historyKey\_$itemName');

      if (jsonString == null) {
        return PriceHistory(itemName: itemName, pricePoints: []);
      }

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PriceHistory.fromJson(json);
    } catch (e) {
      developer.log('Error loading price history: $e', name: 'PriceTrackingService');
      return PriceHistory(itemName: itemName, pricePoints: []);
    }
  }

  /// Сохраняет историю цен
  Future<bool> _savePriceHistory(String itemName, PriceHistory history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_historyKey\_$itemName', jsonEncode(history.toJson()));
      return true;
    } catch (e) {
      developer.log('Error saving price history: $e', name: 'PriceTrackingService');
      return false;
    }
  }

  /// Вычисляет тренд на основе истории цен
  PriceHistory _calculateTrend(PriceHistory history) {
    if (history.pricePoints.length < 2) {
      return history;
    }

    // Берем последние две точки
    final latest = history.pricePoints.last;
    final previous = history.pricePoints[history.pricePoints.length - 2];

    final latestAvg = latest.averagePrice;
    final previousAvg = previous.averagePrice;

    final changePercentage = ((latestAvg - previousAvg) / previousAvg) * 100;

    PriceTrend trend;
    if (changePercentage > 5) {
      trend = PriceTrend.rising;
    } else if (changePercentage < -5) {
      trend = PriceTrend.falling;
    } else {
      trend = PriceTrend.stable;
    }

    return PriceHistory(
      itemName: history.itemName,
      pricePoints: history.pricePoints,
      currentEstimatedValue: latestAvg,
      changePercentage: changePercentage,
      trend: trend,
    );
  }

  /// Создает price alert
  Future<bool> createAlert({
    required String itemName,
    required double targetPrice,
    required PriceAlertCondition condition,
  }) async {
    try {
      final alert = PriceAlert(
        id: _uuid.v4(),
        itemName: itemName,
        targetPrice: targetPrice,
        condition: condition,
        createdAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      final alerts = await _loadAlerts();
      alerts.add(alert);

      await prefs.setString(_alertsKey, jsonEncode(alerts.map((a) => a.toJson()).toList()));

      developer.log('Price alert created for $itemName', name: 'PriceTrackingService');
      return true;
    } catch (e) {
      developer.log('Error creating alert: $e', name: 'PriceTrackingService');
      return false;
    }
  }

  /// Получает все активные alerts
  Future<List<PriceAlert>> getActiveAlerts() async {
    final alerts = await _loadAlerts();
    return alerts.where((a) => a.isActive).toList();
  }

  /// Получает alerts для конкретного предмета
  Future<List<PriceAlert>> getAlertsForItem(String itemName) async {
    final alerts = await _loadAlerts();
    return alerts.where((a) => a.itemName == itemName && a.isActive).toList();
  }

  /// Загружает все alerts
  Future<List<PriceAlert>> _loadAlerts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_alertsKey);

      if (jsonString == null) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => PriceAlert.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Error loading alerts: $e', name: 'PriceTrackingService');
      return [];
    }
  }

  /// Проверяет и триггерит alerts
  Future<List<PriceAlert>> _checkAlerts(String itemName, double currentPrice) async {
    final alerts = await getAlertsForItem(itemName);
    final triggeredAlerts = <PriceAlert>[];

    for (final alert in alerts) {
      bool shouldTrigger = false;

      switch (alert.condition) {
        case PriceAlertCondition.above:
          shouldTrigger = currentPrice > alert.targetPrice;
          break;
        case PriceAlertCondition.below:
          shouldTrigger = currentPrice < alert.targetPrice;
          break;
        case PriceAlertCondition.changePercentage:
          // Для этого условия targetPrice = процент изменения
          final history = await getPriceHistory(itemName);
          if (history.changePercentage != null &&
              history.changePercentage!.abs() >= alert.targetPrice) {
            shouldTrigger = true;
          }
          break;
      }

      if (shouldTrigger) {
        // Деактивируем alert
        final triggeredAlert = PriceAlert(
          id: alert.id,
          itemName: alert.itemName,
          targetPrice: alert.targetPrice,
          condition: alert.condition,
          isActive: false,
          createdAt: alert.createdAt,
          triggeredAt: DateTime.now(),
        );

        await _updateAlert(triggeredAlert);
        triggeredAlerts.add(triggeredAlert);

        developer.log('Alert triggered for $itemName', name: 'PriceTrackingService');
      }
    }

    return triggeredAlerts;
  }

  /// Обновляет alert
  Future<bool> _updateAlert(PriceAlert alert) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alerts = await _loadAlerts();

      final index = alerts.indexWhere((a) => a.id == alert.id);
      if (index != -1) {
        alerts[index] = alert;
        await prefs.setString(_alertsKey, jsonEncode(alerts.map((a) => a.toJson()).toList()));
        return true;
      }

      return false;
    } catch (e) {
      developer.log('Error updating alert: $e', name: 'PriceTrackingService');
      return false;
    }
  }

  /// Удаляет alert
  Future<bool> deleteAlert(String alertId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final alerts = await _loadAlerts();

      alerts.removeWhere((a) => a.id == alertId);
      await prefs.setString(_alertsKey, jsonEncode(alerts.map((a) => a.toJson()).toList()));

      developer.log('Alert deleted: $alertId', name: 'PriceTrackingService');
      return true;
    } catch (e) {
      developer.log('Error deleting alert: $e', name: 'PriceTrackingService');
      return false;
    }
  }

  /// Автоматически добавляет price point из analysis result
  Future<bool> trackFromAnalysis(AnalysisResult analysis) async {
    if (analysis.priceEstimate == null) {
      return false;
    }

    return await addPricePoint(
      itemName: analysis.itemName,
      minPrice: analysis.priceEstimate!.minPrice,
      maxPrice: analysis.priceEstimate!.maxPrice,
      source: 'user_analysis',
      notes: 'From AI analysis',
    );
  }

  /// Получает статистику по всем отслеживаемым предметам
  Future<PriceTrackingStats> getStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((k) => k.startsWith(_historyKey));

      int totalItems = keys.length;
      int risingItems = 0;
      int fallingItems = 0;
      double totalValue = 0;

      for (final key in keys) {
        final itemName = key.replaceFirst('$_historyKey\_', '');
        final history = await getPriceHistory(itemName);

        if (history.currentEstimatedValue != null) {
          totalValue += history.currentEstimatedValue!;
        }

        if (history.trend == PriceTrend.rising) risingItems++;
        if (history.trend == PriceTrend.falling) fallingItems++;
      }

      return PriceTrackingStats(
        totalItems: totalItems,
        risingItems: risingItems,
        fallingItems: fallingItems,
        totalEstimatedValue: totalValue,
      );
    } catch (e) {
      developer.log('Error getting stats: $e', name: 'PriceTrackingService');
      return PriceTrackingStats(
        totalItems: 0,
        risingItems: 0,
        fallingItems: 0,
        totalEstimatedValue: 0,
      );
    }
  }
}

/// Статистика price tracking
class PriceTrackingStats {
  final int totalItems;
  final int risingItems;
  final int fallingItems;
  final double totalEstimatedValue;

  PriceTrackingStats({
    required this.totalItems,
    required this.risingItems,
    required this.fallingItems,
    required this.totalEstimatedValue,
  });

  int get stableItems => totalItems - risingItems - fallingItems;
}
