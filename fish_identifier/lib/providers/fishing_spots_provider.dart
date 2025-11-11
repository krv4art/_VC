import 'package:flutter/foundation.dart';
import '../models/fishing_spot.dart';
import '../services/database_service.dart';

/// Provider for managing fishing spots
class FishingSpotsProvider with ChangeNotifier {
  List<FishingSpot> _fishingSpots = [];
  bool _isLoading = false;
  String? _error;

  List<FishingSpot> get fishingSpots => _fishingSpots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<FishingSpot> get favoriteSpots =>
      _fishingSpots.where((spot) => spot.isFavorite).toList();

  FishingSpotsProvider() {
    loadFishingSpots();
  }

  /// Load all fishing spots from database
  Future<void> loadFishingSpots() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _fishingSpots = await DatabaseService.instance.getAllFishingSpots();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading fishing spots: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add a new fishing spot
  Future<void> addFishingSpot(FishingSpot spot) async {
    try {
      final id = await DatabaseService.instance.addFishingSpot(spot);
      final newSpot = spot.copyWith(id: id);
      _fishingSpots.insert(0, newSpot);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding fishing spot: $e');
      rethrow;
    }
  }

  /// Update an existing fishing spot
  Future<void> updateFishingSpot(FishingSpot spot) async {
    try {
      await DatabaseService.instance.updateFishingSpot(spot);
      final index = _fishingSpots.indexWhere((s) => s.id == spot.id);
      if (index != -1) {
        _fishingSpots[index] = spot;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating fishing spot: $e');
      rethrow;
    }
  }

  /// Toggle favorite status of a fishing spot
  Future<void> toggleFavorite(int id) async {
    try {
      final spot = _fishingSpots.firstWhere((s) => s.id == id);
      final newFavoriteStatus = !spot.isFavorite;

      await DatabaseService.instance.toggleFishingSpotFavorite(
        id,
        newFavoriteStatus,
      );

      final index = _fishingSpots.indexWhere((s) => s.id == id);
      if (index != -1) {
        _fishingSpots[index] = spot.copyWith(isFavorite: newFavoriteStatus);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Delete a fishing spot
  Future<void> deleteFishingSpot(int id) async {
    try {
      await DatabaseService.instance.deleteFishingSpot(id);
      _fishingSpots.removeWhere((spot) => spot.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting fishing spot: $e');
      rethrow;
    }
  }

  /// Get nearby fishing spots based on current location
  Future<List<FishingSpot>> getNearbySpots(
    double latitude,
    double longitude, {
    double radiusInKm = 50,
  }) async {
    try {
      return await DatabaseService.instance.getNearbyFishingSpots(
        latitude,
        longitude,
        radiusInKm: radiusInKm,
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('Error getting nearby spots: $e');
      return [];
    }
  }

  /// Get fishing spot by ID
  FishingSpot? getFishingSpotById(int id) {
    try {
      return _fishingSpots.firstWhere((spot) => spot.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter spots by water type
  List<FishingSpot> filterByWaterType(String? waterType) {
    if (waterType == null || waterType.isEmpty) {
      return _fishingSpots;
    }
    return _fishingSpots
        .where((spot) =>
            spot.waterType?.toLowerCase() == waterType.toLowerCase())
        .toList();
  }

  /// Filter spots by rating
  List<FishingSpot> filterByMinRating(int minRating) {
    return _fishingSpots
        .where((spot) => (spot.rating ?? 0) >= minRating)
        .toList();
  }

  /// Search spots by name or description
  List<FishingSpot> search(String query) {
    if (query.isEmpty) {
      return _fishingSpots;
    }

    final lowercaseQuery = query.toLowerCase();
    return _fishingSpots.where((spot) {
      return spot.name.toLowerCase().contains(lowercaseQuery) ||
          (spot.description?.toLowerCase().contains(lowercaseQuery) ?? false) ||
          (spot.fishSpecies?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadFishingSpots();
  }
}
