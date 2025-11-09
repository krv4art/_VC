import 'package:flutter/material.dart';
import '../models/plant_result.dart';
import '../services/database_service.dart';

/// Provider for managing plant identification history
class PlantHistoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  List<PlantResult> _history = [];
  bool _isLoading = false;

  List<PlantResult> get history => _history;
  bool get isLoading => _isLoading;

  PlantHistoryProvider() {
    _loadHistory();
  }

  /// Load identification history
  Future<void> _loadHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      _history = await _databaseService.getPlantHistory();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading history: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new identification result
  Future<void> addResult(PlantResult result) async {
    try {
      await _databaseService.savePlantResult(result);
      _history.insert(0, result);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding result: $e');
    }
  }

  /// Delete result from history
  Future<void> deleteResult(String id) async {
    try {
      await _databaseService.deletePlantResult(id);
      _history.removeWhere((result) => result.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting result: $e');
    }
  }

  /// Clear all history
  Future<void> clearHistory() async {
    try {
      await _databaseService.clearPlantHistory();
      _history.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing history: $e');
    }
  }

  /// Get result by ID
  PlantResult? getResultById(String id) {
    try {
      return _history.firstWhere((result) => result.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter history by type
  List<PlantResult> filterByType(PlantType type) {
    return _history.where((result) => result.type == type).toList();
  }

  /// Search history
  List<PlantResult> search(String query) {
    final lowerQuery = query.toLowerCase();
    return _history.where((result) {
      return result.plantName.toLowerCase().contains(lowerQuery) ||
          result.scientificName.toLowerCase().contains(lowerQuery) ||
          result.commonNames.any(
            (name) => name.toLowerCase().contains(lowerQuery),
          );
    }).toList();
  }
}
