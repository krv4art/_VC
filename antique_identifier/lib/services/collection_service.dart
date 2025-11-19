import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';

/// Сервис для управления коллекцией антикварных предметов
class CollectionService {
  static const String _collectionKey = 'user_collection';
  static const String _favoritesKey = 'user_favorites';
  static const String _categoriesKey = 'user_categories';
  static const String _tagsKey = 'user_tags';

  /// Сохраняет анализ в коллекцию
  Future<bool> saveToCollection(AnalysisResult analysis) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collection = await getCollection();

      // Добавляем новый анализ в начало списка
      collection.insert(0, analysis);

      // Сохраняем обновленную коллекцию
      final jsonList = collection.map((a) => a.toJson()).toList();
      await prefs.setString(_collectionKey, jsonEncode(jsonList));

      developer.log('Saved to collection: ${analysis.itemName}', name: 'CollectionService');
      return true;
    } catch (e) {
      developer.log('Error saving to collection: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Получает всю коллекцию
  Future<List<AnalysisResult>> getCollection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_collectionKey);

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((json) => AnalysisResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      developer.log('Error loading collection: $e', name: 'CollectionService');
      return [];
    }
  }

  /// Удаляет предмет из коллекции
  Future<bool> removeFromCollection(String itemName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collection = await getCollection();

      collection.removeWhere((item) => item.itemName == itemName);

      final jsonList = collection.map((a) => a.toJson()).toList();
      await prefs.setString(_collectionKey, jsonEncode(jsonList));

      developer.log('Removed from collection: $itemName', name: 'CollectionService');
      return true;
    } catch (e) {
      developer.log('Error removing from collection: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Обновляет предмет в коллекции
  Future<bool> updateInCollection(AnalysisResult updatedAnalysis) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final collection = await getCollection();

      final index = collection.indexWhere((item) => item.itemName == updatedAnalysis.itemName);

      if (index != -1) {
        collection[index] = updatedAnalysis;

        final jsonList = collection.map((a) => a.toJson()).toList();
        await prefs.setString(_collectionKey, jsonEncode(jsonList));

        developer.log('Updated in collection: ${updatedAnalysis.itemName}', name: 'CollectionService');
        return true;
      }

      return false;
    } catch (e) {
      developer.log('Error updating in collection: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Переключает статус избранного для предмета
  Future<bool> toggleFavorite(String itemName) async {
    try {
      final collection = await getCollection();
      final item = collection.firstWhere((i) => i.itemName == itemName);

      final updatedItem = item.copyWith(isFavorite: !(item.isFavorite ?? false));
      return await updateInCollection(updatedItem);
    } catch (e) {
      developer.log('Error toggling favorite: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Получает список избранных предметов
  Future<List<AnalysisResult>> getFavorites() async {
    final collection = await getCollection();
    return collection.where((item) => item.isFavorite == true).toList();
  }

  /// Добавляет тег к предмету
  Future<bool> addTag(String itemName, String tag) async {
    try {
      final collection = await getCollection();
      final item = collection.firstWhere((i) => i.itemName == itemName);

      final currentTags = List<String>.from(item.tags);
      if (!currentTags.contains(tag)) {
        currentTags.add(tag);

        final updatedItem = item.copyWith(tags: currentTags);
        return await updateInCollection(updatedItem);
      }

      return true;
    } catch (e) {
      developer.log('Error adding tag: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Удаляет тег у предмета
  Future<bool> removeTag(String itemName, String tag) async {
    try {
      final collection = await getCollection();
      final item = collection.firstWhere((i) => i.itemName == itemName);

      final currentTags = List<String>.from(item.tags);
      currentTags.remove(tag);

      final updatedItem = item.copyWith(tags: currentTags);
      return await updateInCollection(updatedItem);
    } catch (e) {
      developer.log('Error removing tag: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Добавляет заметку к предмету
  Future<bool> addNote(String itemName, String note) async {
    try {
      final collection = await getCollection();
      final item = collection.firstWhere((i) => i.itemName == itemName);

      final updatedItem = item.copyWith(notes: note);
      return await updateInCollection(updatedItem);
    } catch (e) {
      developer.log('Error adding note: $e', name: 'CollectionService');
      return false;
    }
  }

  /// Получает все уникальные теги в коллекции
  Future<List<String>> getAllTags() async {
    final collection = await getCollection();
    final allTags = <String>{};

    for (final item in collection) {
      allTags.addAll(item.tags);
    }

    return allTags.toList()..sort();
  }

  /// Получает все уникальные категории в коллекции
  Future<List<String>> getAllCategories() async {
    final collection = await getCollection();
    final allCategories = <String>{};

    for (final item in collection) {
      if (item.category != null && item.category!.isNotEmpty) {
        allCategories.add(item.category!);
      }
    }

    return allCategories.toList()..sort();
  }

  /// Фильтрует коллекцию по категории
  Future<List<AnalysisResult>> getByCategory(String category) async {
    final collection = await getCollection();
    return collection.where((item) => item.category == category).toList();
  }

  /// Фильтрует коллекцию по тегу
  Future<List<AnalysisResult>> getByTag(String tag) async {
    final collection = await getCollection();
    return collection.where((item) => item.tags.contains(tag)).toList();
  }

  /// Поиск в коллекции
  Future<List<AnalysisResult>> search(String query) async {
    if (query.isEmpty) return await getCollection();

    final collection = await getCollection();
    final lowerQuery = query.toLowerCase();

    return collection.where((item) {
      return item.itemName.toLowerCase().contains(lowerQuery) ||
          (item.category?.toLowerCase().contains(lowerQuery) ?? false) ||
          item.description.toLowerCase().contains(lowerQuery) ||
          item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Получает статистику коллекции
  Future<CollectionStats> getStats() async {
    final collection = await getCollection();
    final favorites = collection.where((item) => item.isFavorite == true).length;

    double totalValue = 0;
    int itemsWithPrice = 0;

    for (final item in collection) {
      if (item.priceEstimate != null) {
        totalValue += (item.priceEstimate!.minPrice + item.priceEstimate!.maxPrice) / 2;
        itemsWithPrice++;
      }
    }

    return CollectionStats(
      totalItems: collection.length,
      favorites: favorites,
      categories: (await getAllCategories()).length,
      tags: (await getAllTags()).length,
      estimatedTotalValue: totalValue,
      itemsWithPrice: itemsWithPrice,
    );
  }

  /// Очищает всю коллекцию
  Future<bool> clearCollection() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_collectionKey);
      developer.log('Collection cleared', name: 'CollectionService');
      return true;
    } catch (e) {
      developer.log('Error clearing collection: $e', name: 'CollectionService');
      return false;
    }
  }
}

/// Статистика коллекции
class CollectionStats {
  final int totalItems;
  final int favorites;
  final int categories;
  final int tags;
  final double estimatedTotalValue;
  final int itemsWithPrice;

  CollectionStats({
    required this.totalItems,
    required this.favorites,
    required this.categories,
    required this.tags,
    required this.estimatedTotalValue,
    required this.itemsWithPrice,
  });

  double get averageValue =>
      itemsWithPrice > 0 ? estimatedTotalValue / itemsWithPrice : 0;
}
