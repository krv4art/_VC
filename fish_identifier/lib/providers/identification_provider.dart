import 'package:flutter/foundation.dart';
import '../models/fish_identification.dart';
import '../services/database_service.dart';

/// Provider for managing fish identifications
class IdentificationProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<FishIdentification> _identifications = [];
  bool _isLoading = false;
  String? _error;

  List<FishIdentification> get identifications => _identifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  IdentificationProvider() {
    loadIdentifications();
  }

  Future<void> loadIdentifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _identifications = await _databaseService.getAllFishIdentifications();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIdentification(FishIdentification fish) async {
    try {
      final id = await _databaseService.insertFishIdentification(fish);
      final newFish = fish.copyWith(id: id);
      _identifications.insert(0, newFish);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteIdentification(int id) async {
    try {
      await _databaseService.deleteFishIdentification(id);
      _identifications.removeWhere((fish) => fish.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  FishIdentification? getIdentificationById(int id) {
    try {
      return _identifications.firstWhere((fish) => fish.id == id);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
