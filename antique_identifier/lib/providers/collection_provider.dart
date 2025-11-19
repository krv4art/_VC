import 'package:flutter/foundation.dart';
import '../models/analysis_result.dart';
import '../services/collection_service.dart';

/// Provider для управления коллекцией антикварных предметов
class CollectionProvider extends ChangeNotifier {
  final CollectionService _collectionService = CollectionService();

  List<AnalysisResult> _collection = [];
  List<String> _availableTags = [];
  List<String> _availableCategories = [];
  CollectionStats? _stats;
  bool _isLoading = false;
  String? _error;

  // Фильтры
  String? _selectedCategory;
  String? _selectedTag;
  bool _showOnlyFavorites = false;
  String _searchQuery = '';

  // Getters
  List<AnalysisResult> get collection => _filteredCollection;
  List<AnalysisResult> get allItems => _collection;
  List<String> get availableTags => _availableTags;
  List<String> get availableCategories => _availableCategories;
  CollectionStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  String? get selectedTag => _selectedTag;
  bool get showOnlyFavorites => _showOnlyFavorites;
  String get searchQuery => _searchQuery;

  List<AnalysisResult> get _filteredCollection {
    var filtered = List<AnalysisResult>.from(_collection);

    // Фильтр по избранному
    if (_showOnlyFavorites) {
      filtered = filtered.where((item) => item.isFavorite == true).toList();
    }

    // Фильтр по категории
    if (_selectedCategory != null) {
      filtered = filtered.where((item) => item.category == _selectedCategory).toList();
    }

    // Фильтр по тегу
    if (_selectedTag != null) {
      filtered = filtered.where((item) => item.tags.contains(_selectedTag)).toList();
    }

    // Поиск
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((item) {
        return item.itemName.toLowerCase().contains(query) ||
            (item.category?.toLowerCase().contains(query) ?? false) ||
            item.description.toLowerCase().contains(query) ||
            item.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  /// Загружает коллекцию
  Future<void> loadCollection() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _collection = await _collectionService.getCollection();
      _availableTags = await _collectionService.getAllTags();
      _availableCategories = await _collectionService.getAllCategories();
      _stats = await _collectionService.getStats();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Добавляет предмет в коллекцию
  Future<bool> addToCollection(AnalysisResult analysis) async {
    try {
      final success = await _collectionService.saveToCollection(analysis);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Удаляет предмет из коллекции
  Future<bool> removeFromCollection(String itemName) async {
    try {
      final success = await _collectionService.removeFromCollection(itemName);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Переключает избранное
  Future<bool> toggleFavorite(String itemName) async {
    try {
      final success = await _collectionService.toggleFavorite(itemName);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Добавляет тег
  Future<bool> addTag(String itemName, String tag) async {
    try {
      final success = await _collectionService.addTag(itemName, tag);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Удаляет тег
  Future<bool> removeTag(String itemName, String tag) async {
    try {
      final success = await _collectionService.removeTag(itemName, tag);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Добавляет заметку
  Future<bool> addNote(String itemName, String note) async {
    try {
      final success = await _collectionService.addNote(itemName, note);
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Устанавливает фильтр по категории
  void setCategoryFilter(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Устанавливает фильтр по тегу
  void setTagFilter(String? tag) {
    _selectedTag = tag;
    notifyListeners();
  }

  /// Переключает отображение только избранного
  void toggleFavoritesFilter() {
    _showOnlyFavorites = !_showOnlyFavorites;
    notifyListeners();
  }

  /// Устанавливает поисковый запрос
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Сбрасывает все фильтры
  void clearFilters() {
    _selectedCategory = null;
    _selectedTag = null;
    _showOnlyFavorites = false;
    _searchQuery = '';
    notifyListeners();
  }

  /// Очищает всю коллекцию
  Future<bool> clearCollection() async {
    try {
      final success = await _collectionService.clearCollection();
      if (success) {
        await loadCollection();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Получает предмет по имени
  AnalysisResult? getItemByName(String itemName) {
    try {
      return _collection.firstWhere((item) => item.itemName == itemName);
    } catch (e) {
      return null;
    }
  }
}
