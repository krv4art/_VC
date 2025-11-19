import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';
import '../services/local_data_service.dart';

/// Провайдер для управления коллекцией монет
class CollectionProvider with ChangeNotifier {
  final LocalDataService _dataService = LocalDataService();

  List<AnalysisResult> _collection = [];
  List<AnalysisResult> _wishlist = [];
  List<AnalysisResult> _favorites = [];
  Map<String, dynamic> _stats = {};

  bool _isLoading = false;
  String? _error;

  List<AnalysisResult> get collection => _collection;
  List<AnalysisResult> get wishlist => _wishlist;
  List<AnalysisResult> get favorites => _favorites;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get collectionCount => _collection.length;
  int get wishlistCount => _wishlist.length;
  int get favoritesCount => _favorites.length;

  /// Загружает коллекцию
  Future<void> loadCollection() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _collection = await _dataService.getAllCoins();
      debugPrint('✓ Collection loaded: ${_collection.length} coins');
    } catch (e) {
      _error = 'Failed to load collection: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загружает wishlist
  Future<void> loadWishlist() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _wishlist = await _dataService.getWishlist();
      debugPrint('✓ Wishlist loaded: ${_wishlist.length} coins');
    } catch (e) {
      _error = 'Failed to load wishlist: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загружает избранное
  Future<void> loadFavorites() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _favorites = await _dataService.getFavorites();
      debugPrint('✓ Favorites loaded: ${_favorites.length} coins');
    } catch (e) {
      _error = 'Failed to load favorites: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загружает статистику
  Future<void> loadStats() async {
    try {
      _stats = await _dataService.getCollectionStats();
      debugPrint('✓ Stats loaded');
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load stats: $e';
      debugPrint(_error);
    }
  }

  /// Добавляет монету в коллекцию
  Future<String> addCoin(AnalysisResult coin, {String? imagePath}) async {
    try {
      final id = await _dataService.saveAnalysis(coin, imagePath: imagePath);
      await loadCollection();
      await loadStats();
      return id;
    } catch (e) {
      _error = 'Failed to add coin: $e';
      debugPrint(_error);
      rethrow;
    }
  }

  /// Обновляет монету
  Future<void> updateCoin(AnalysisResult coin) async {
    try {
      await _dataService.updateCoin(coin);

      // Обновляем локальные списки
      if (coin.isInWishlist) {
        final index = _wishlist.indexWhere((c) => c.id == coin.id);
        if (index != -1) {
          _wishlist[index] = coin;
        }
      } else {
        final index = _collection.indexWhere((c) => c.id == coin.id);
        if (index != -1) {
          _collection[index] = coin;
        }
      }

      if (coin.isFavorite) {
        final index = _favorites.indexWhere((c) => c.id == coin.id);
        if (index != -1) {
          _favorites[index] = coin;
        } else {
          _favorites.add(coin);
        }
      } else {
        _favorites.removeWhere((c) => c.id == coin.id);
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to update coin: $e';
      debugPrint(_error);
      rethrow;
    }
  }

  /// Переключает статус wishlist
  Future<void> toggleWishlist(String id) async {
    try {
      await _dataService.toggleWishlist(id);
      await loadCollection();
      await loadWishlist();
      await loadStats();
    } catch (e) {
      _error = 'Failed to toggle wishlist: $e';
      debugPrint(_error);
    }
  }

  /// Переключает избранное
  Future<void> toggleFavorite(String id) async {
    try {
      await _dataService.toggleFavorite(id);

      // Обновляем локально
      for (var coin in _collection) {
        if (coin.id == id) {
          final updated = coin.copyWith(isFavorite: !coin.isFavorite);
          final index = _collection.indexOf(coin);
          _collection[index] = updated;
          break;
        }
      }

      for (var coin in _wishlist) {
        if (coin.id == id) {
          final updated = coin.copyWith(isFavorite: !coin.isFavorite);
          final index = _wishlist.indexOf(coin);
          _wishlist[index] = updated;
          break;
        }
      }

      await loadFavorites();
    } catch (e) {
      _error = 'Failed to toggle favorite: $e';
      debugPrint(_error);
    }
  }

  /// Удаляет монету
  Future<void> deleteCoin(String id) async {
    try {
      await _dataService.deleteCoin(id);
      _collection.removeWhere((c) => c.id == id);
      _wishlist.removeWhere((c) => c.id == id);
      _favorites.removeWhere((c) => c.id == id);
      await loadStats();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete coin: $e';
      debugPrint(_error);
      rethrow;
    }
  }

  /// Поиск с фильтрами
  Future<List<AnalysisResult>> searchCoins({
    String? query,
    String? country,
    String? rarityLevel,
    bool? isInWishlist,
    bool? isFavorite,
    List<String>? tags,
  }) async {
    try {
      return await _dataService.searchCoins(
        query: query,
        country: country,
        rarityLevel: rarityLevel,
        isInWishlist: isInWishlist,
        isFavorite: isFavorite,
        tags: tags,
      );
    } catch (e) {
      _error = 'Failed to search coins: $e';
      debugPrint(_error);
      return [];
    }
  }

  /// Получает уникальные страны
  List<String> getCountries() {
    final countries = <String>{};
    for (var coin in _collection) {
      if (coin.country != null && coin.country!.isNotEmpty) {
        countries.add(coin.country!);
      }
    }
    for (var coin in _wishlist) {
      if (coin.country != null && coin.country!.isNotEmpty) {
        countries.add(coin.country!);
      }
    }
    return countries.toList()..sort();
  }

  /// Получает все уникальные теги
  List<String> getAllTags() {
    final tags = <String>{};
    for (var coin in _collection) {
      tags.addAll(coin.tags);
    }
    for (var coin in _wishlist) {
      tags.addAll(coin.tags);
    }
    return tags.toList()..sort();
  }

  /// Очищает все данные
  Future<void> clearAll() async {
    try {
      await _dataService.clearAllCoins();
      _collection.clear();
      _wishlist.clear();
      _favorites.clear();
      _stats.clear();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear collection: $e';
      debugPrint(_error);
      rethrow;
    }
  }
}
