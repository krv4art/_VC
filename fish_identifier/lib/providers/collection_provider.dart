import 'package:flutter/foundation.dart';
import '../models/fish_collection.dart';
import '../services/database_service.dart';

/// Provider for managing user's fish collection
class CollectionProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;

  List<FishCollection> _collection = [];
  bool _isLoading = false;
  String? _error;

  List<FishCollection> get collection => _collection;
  List<FishCollection> get favorites =>
      _collection.where((item) => item.isFavorite).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalCatches => _collection.length;

  CollectionProvider() {
    loadCollection();
  }

  Future<void> loadCollection() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _collection = await _databaseService.getAllCollection();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addToCollection(FishCollection item) async {
    try {
      final id = await _databaseService.addToCollection(item);
      final newItem = item.copyWith(id: id);
      _collection.insert(0, newItem);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateCollection(FishCollection item) async {
    try {
      await _databaseService.updateCollection(item);
      final index = _collection.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        _collection[index] = item;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int id) async {
    try {
      final index = _collection.indexWhere((i) => i.id == id);
      if (index != -1) {
        final updatedItem = _collection[index].copyWith(
          isFavorite: !_collection[index].isFavorite,
        );
        await updateCollection(updatedItem);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteFromCollection(int id) async {
    try {
      await _databaseService.deleteFromCollection(id);
      _collection.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
