import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/generated_photo.dart';

/// Service for managing favorite photos
class FavoritesService {
  final Database _database;

  FavoritesService(this._database);

  /// Initialize favorites table
  static Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        photo_id INTEGER NOT NULL,
        added_at TEXT NOT NULL,
        FOREIGN KEY (photo_id) REFERENCES generated_photos(id) ON DELETE CASCADE,
        UNIQUE(photo_id)
      )
    ''');
  }

  /// Add photo to favorites
  Future<bool> addToFavorites(int photoId) async {
    try {
      await _database.insert(
        'favorites',
        {
          'photo_id': photoId,
          'added_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      debugPrint('Photo $photoId added to favorites');
      return true;
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      return false;
    }
  }

  /// Remove photo from favorites
  Future<bool> removeFromFavorites(int photoId) async {
    try {
      final count = await _database.delete(
        'favorites',
        where: 'photo_id = ?',
        whereArgs: [photoId],
      );
      debugPrint('Photo $photoId removed from favorites');
      return count > 0;
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(int photoId) async {
    final isFavorite = await isInFavorites(photoId);
    if (isFavorite) {
      return await removeFromFavorites(photoId);
    } else {
      return await addToFavorites(photoId);
    }
  }

  /// Check if photo is in favorites
  Future<bool> isInFavorites(int photoId) async {
    try {
      final result = await _database.query(
        'favorites',
        where: 'photo_id = ?',
        whereArgs: [photoId],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      debugPrint('Error checking if photo is in favorites: $e');
      return false;
    }
  }

  /// Get all favorite photo IDs
  Future<List<int>> getFavoritePhotoIds() async {
    try {
      final result = await _database.query(
        'favorites',
        columns: ['photo_id'],
        orderBy: 'added_at DESC',
      );

      return result.map((row) => row['photo_id'] as int).toList();
    } catch (e) {
      debugPrint('Error getting favorite photo IDs: $e');
      return [];
    }
  }

  /// Get all favorite photos with full details
  Future<List<GeneratedPhoto>> getFavoritePhotos() async {
    try {
      final result = await _database.rawQuery('''
        SELECT p.*, f.added_at as favorite_added_at
        FROM generated_photos p
        INNER JOIN favorites f ON p.id = f.photo_id
        ORDER BY f.added_at DESC
      ''');

      return result.map((row) => GeneratedPhoto.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting favorite photos: $e');
      return [];
    }
  }

  /// Get favorites count
  Future<int> getFavoritesCount() async {
    try {
      final result = await _database.rawQuery('SELECT COUNT(*) as count FROM favorites');
      return result.first['count'] as int;
    } catch (e) {
      debugPrint('Error getting favorites count: $e');
      return 0;
    }
  }

  /// Clear all favorites
  Future<bool> clearAllFavorites() async {
    try {
      await _database.delete('favorites');
      debugPrint('All favorites cleared');
      return true;
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
      return false;
    }
  }

  /// Get favorite photos by style
  Future<List<GeneratedPhoto>> getFavoritePhotosByStyle(String styleId) async {
    try {
      final result = await _database.rawQuery('''
        SELECT p.*, f.added_at as favorite_added_at
        FROM generated_photos p
        INNER JOIN favorites f ON p.id = f.photo_id
        WHERE p.style_id = ?
        ORDER BY f.added_at DESC
      ''', [styleId]);

      return result.map((row) => GeneratedPhoto.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting favorite photos by style: $e');
      return [];
    }
  }

  /// Get recently added favorites (last N days)
  Future<List<GeneratedPhoto>> getRecentFavorites({int days = 7}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));

      final result = await _database.rawQuery('''
        SELECT p.*, f.added_at as favorite_added_at
        FROM generated_photos p
        INNER JOIN favorites f ON p.id = f.photo_id
        WHERE f.added_at >= ?
        ORDER BY f.added_at DESC
      ''', [cutoffDate.toIso8601String()]);

      return result.map((row) => GeneratedPhoto.fromMap(row)).toList();
    } catch (e) {
      debugPrint('Error getting recent favorites: $e');
      return [];
    }
  }

  /// Export favorites IDs for backup
  Future<List<int>> exportFavoritesForBackup() async {
    return await getFavoritePhotoIds();
  }

  /// Import favorites from backup
  Future<bool> importFavoritesFromBackup(List<int> photoIds) async {
    try {
      final batch = _database.batch();

      for (final photoId in photoIds) {
        batch.insert(
          'favorites',
          {
            'photo_id': photoId,
            'added_at': DateTime.now().toIso8601String(),
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      await batch.commit(noResult: true);
      debugPrint('Imported ${photoIds.length} favorites from backup');
      return true;
    } catch (e) {
      debugPrint('Error importing favorites: $e');
      return false;
    }
  }
}
