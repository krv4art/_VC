import 'dart:async';
import 'dart:convert';
import 'dart:math' show sin, cos, asin, sqrt;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/fish_identification.dart';
import '../models/chat_message.dart';
import '../models/fish_collection.dart';
import '../models/fishing_spot.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();

  // Stream controller for database changes
  static final _databaseChangeController = StreamController<void>.broadcast();
  static Stream<void> get databaseChanges => _databaseChangeController.stream;

  factory DatabaseService() {
    return instance;
  }

  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'fish_identifier.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        // Fish identifications table
        await db.execute('''
          CREATE TABLE fish_identifications(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT NOT NULL,
            fishData TEXT NOT NULL,
            identifyDate TEXT NOT NULL
          )
        ''');

        // User's fish collection table
        await db.execute('''
          CREATE TABLE collection(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fishIdentificationId INTEGER NOT NULL,
            catchDate TEXT NOT NULL,
            location TEXT,
            latitude REAL,
            longitude REAL,
            notes TEXT,
            isFavorite INTEGER DEFAULT 0,
            weight REAL,
            length REAL,
            weatherConditions TEXT,
            baitUsed TEXT,
            FOREIGN KEY (fishIdentificationId) REFERENCES fish_identifications (id) ON DELETE CASCADE
          )
        ''');

        // Chat dialogues table
        await db.execute('''
          CREATE TABLE dialogues(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            created_at TEXT NOT NULL,
            fish_id INTEGER,
            FOREIGN KEY (fish_id) REFERENCES fish_identifications (id) ON DELETE SET NULL
          )
        ''');

        // Chat messages table
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dialogueId INTEGER NOT NULL,
            text TEXT NOT NULL,
            isUser INTEGER NOT NULL,
            timestamp TEXT NOT NULL,
            fishImagePath TEXT,
            FOREIGN KEY (dialogueId) REFERENCES dialogues (id) ON DELETE CASCADE
          )
        ''');

        // User settings table
        await db.execute('''
          CREATE TABLE user_settings(
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');

        // Fishing spots table
        await db.execute('''
          CREATE TABLE fishing_spots(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            fishSpecies TEXT,
            dateAdded TEXT NOT NULL,
            isPublic INTEGER DEFAULT 1,
            addedBy TEXT,
            rating INTEGER,
            imagePath TEXT,
            waterType TEXT,
            accessInfo TEXT,
            bestTimeToFish TEXT,
            isFavorite INTEGER DEFAULT 0
          )
        ''');

        // NEW TABLES FOR ENHANCED FEATURES

        // Fishing regulations table
        await db.execute('''
          CREATE TABLE regulations(
            id TEXT PRIMARY KEY,
            species_name TEXT NOT NULL,
            scientific_name TEXT,
            region TEXT NOT NULL,
            sub_region TEXT,
            min_size REAL,
            max_size REAL,
            bag_limit INTEGER,
            possession_limit INTEGER,
            allowed_gear TEXT,
            seasons TEXT,
            license_required INTEGER DEFAULT 1,
            license_type TEXT,
            special_restrictions TEXT,
            last_updated TEXT NOT NULL,
            offline_available INTEGER DEFAULT 0,
            source_url TEXT
          )
        ''');

        // Fish measurements table
        await db.execute('''
          CREATE TABLE fish_measurements(
            id TEXT PRIMARY KEY,
            fish_identification_id INTEGER NOT NULL,
            length REAL NOT NULL,
            estimated_weight REAL,
            weight_estimation_method TEXT,
            method TEXT NOT NULL,
            confidence REAL NOT NULL,
            image_path TEXT,
            measured_at TEXT NOT NULL,
            meets_regulation INTEGER DEFAULT 0,
            regulation_id TEXT,
            FOREIGN KEY (fish_identification_id) REFERENCES fish_identifications (id) ON DELETE CASCADE
          )
        ''');

        // Weather cache table
        await db.execute('''
          CREATE TABLE weather_cache(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            location TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            forecast_data TEXT NOT NULL,
            cached_at TEXT NOT NULL,
            expires_at TEXT NOT NULL
          )
        ''');

        // Social posts table
        await db.execute('''
          CREATE TABLE social_posts(
            id TEXT PRIMARY KEY,
            user_id TEXT NOT NULL,
            fish_identification_id INTEGER,
            caption TEXT NOT NULL,
            location TEXT,
            latitude REAL,
            longitude REAL,
            fish_length REAL,
            fish_weight REAL,
            hashtags TEXT,
            likes_count INTEGER DEFAULT 0,
            comments_count INTEGER DEFAULT 0,
            shares_count INTEGER DEFAULT 0,
            is_public INTEGER DEFAULT 1,
            is_liked_by_current_user INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            updated_at TEXT,
            FOREIGN KEY (fish_identification_id) REFERENCES fish_identifications (id) ON DELETE SET NULL
          )
        ''');

        // Comments table
        await db.execute('''
          CREATE TABLE comments(
            id TEXT PRIMARY KEY,
            post_id TEXT NOT NULL,
            user_id TEXT NOT NULL,
            comment TEXT NOT NULL,
            likes_count INTEGER DEFAULT 0,
            is_liked_by_current_user INTEGER DEFAULT 0,
            created_at TEXT NOT NULL,
            FOREIGN KEY (post_id) REFERENCES social_posts (id) ON DELETE CASCADE
          )
        ''');

        // User achievements table
        await db.execute('''
          CREATE TABLE user_achievements(
            id TEXT PRIMARY KEY,
            achievement_id TEXT NOT NULL,
            unlocked_at TEXT,
            current_progress INTEGER DEFAULT 0,
            total_required INTEGER NOT NULL,
            UNIQUE(achievement_id)
          )
        ''');

        // Fish encyclopedia table
        await db.execute('''
          CREATE TABLE fish_encyclopedia(
            id TEXT PRIMARY KEY,
            common_name TEXT NOT NULL,
            scientific_name TEXT NOT NULL,
            alternative_names TEXT,
            taxonomy TEXT NOT NULL,
            description TEXT NOT NULL,
            habitat TEXT NOT NULL,
            diet TEXT NOT NULL,
            size_data TEXT NOT NULL,
            lifespan TEXT NOT NULL,
            behavior TEXT NOT NULL,
            conservation_status TEXT NOT NULL,
            fishing_info TEXT NOT NULL,
            cooking_info TEXT NOT NULL,
            image_urls TEXT,
            distribution TEXT NOT NULL,
            is_premium INTEGER DEFAULT 0,
            last_updated TEXT NOT NULL
          )
        ''');

        // Solunar cache table
        await db.execute('''
          CREATE TABLE solunar_cache(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            latitude REAL NOT NULL,
            longitude REAL NOT NULL,
            solunar_data TEXT NOT NULL,
            created_at TEXT NOT NULL,
            UNIQUE(date, latitude, longitude)
          )
        ''');

        // User statistics cache table
        await db.execute('''
          CREATE TABLE statistics_cache(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id TEXT NOT NULL,
            period_start TEXT NOT NULL,
            period_end TEXT NOT NULL,
            statistics_data TEXT NOT NULL,
            generated_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add fishing_spots table for version 2
          await db.execute('''
            CREATE TABLE fishing_spots(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              description TEXT,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL,
              fishSpecies TEXT,
              dateAdded TEXT NOT NULL,
              isPublic INTEGER DEFAULT 1,
              addedBy TEXT,
              rating INTEGER,
              imagePath TEXT,
              waterType TEXT,
              accessInfo TEXT,
              bestTimeToFish TEXT,
              isFavorite INTEGER DEFAULT 0
            )
          ''');
        }

        if (oldVersion < 3) {
          // Add new tables for version 3 (enhanced features)
          await db.execute('''
            CREATE TABLE IF NOT EXISTS regulations(
              id TEXT PRIMARY KEY,
              species_name TEXT NOT NULL,
              scientific_name TEXT,
              region TEXT NOT NULL,
              sub_region TEXT,
              min_size REAL,
              max_size REAL,
              bag_limit INTEGER,
              possession_limit INTEGER,
              allowed_gear TEXT,
              seasons TEXT,
              license_required INTEGER DEFAULT 1,
              license_type TEXT,
              special_restrictions TEXT,
              last_updated TEXT NOT NULL,
              offline_available INTEGER DEFAULT 0,
              source_url TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS fish_measurements(
              id TEXT PRIMARY KEY,
              fish_identification_id INTEGER NOT NULL,
              length REAL NOT NULL,
              estimated_weight REAL,
              weight_estimation_method TEXT,
              method TEXT NOT NULL,
              confidence REAL NOT NULL,
              image_path TEXT,
              measured_at TEXT NOT NULL,
              meets_regulation INTEGER DEFAULT 0,
              regulation_id TEXT,
              FOREIGN KEY (fish_identification_id) REFERENCES fish_identifications (id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS weather_cache(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              location TEXT NOT NULL,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL,
              forecast_data TEXT NOT NULL,
              cached_at TEXT NOT NULL,
              expires_at TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS social_posts(
              id TEXT PRIMARY KEY,
              user_id TEXT NOT NULL,
              fish_identification_id INTEGER,
              caption TEXT NOT NULL,
              location TEXT,
              latitude REAL,
              longitude REAL,
              fish_length REAL,
              fish_weight REAL,
              hashtags TEXT,
              likes_count INTEGER DEFAULT 0,
              comments_count INTEGER DEFAULT 0,
              shares_count INTEGER DEFAULT 0,
              is_public INTEGER DEFAULT 1,
              is_liked_by_current_user INTEGER DEFAULT 0,
              created_at TEXT NOT NULL,
              updated_at TEXT,
              FOREIGN KEY (fish_identification_id) REFERENCES fish_identifications (id) ON DELETE SET NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS comments(
              id TEXT PRIMARY KEY,
              post_id TEXT NOT NULL,
              user_id TEXT NOT NULL,
              comment TEXT NOT NULL,
              likes_count INTEGER DEFAULT 0,
              is_liked_by_current_user INTEGER DEFAULT 0,
              created_at TEXT NOT NULL,
              FOREIGN KEY (post_id) REFERENCES social_posts (id) ON DELETE CASCADE
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS user_achievements(
              id TEXT PRIMARY KEY,
              achievement_id TEXT NOT NULL,
              unlocked_at TEXT,
              current_progress INTEGER DEFAULT 0,
              total_required INTEGER NOT NULL,
              UNIQUE(achievement_id)
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS fish_encyclopedia(
              id TEXT PRIMARY KEY,
              common_name TEXT NOT NULL,
              scientific_name TEXT NOT NULL,
              alternative_names TEXT,
              taxonomy TEXT NOT NULL,
              description TEXT NOT NULL,
              habitat TEXT NOT NULL,
              diet TEXT NOT NULL,
              size_data TEXT NOT NULL,
              lifespan TEXT NOT NULL,
              behavior TEXT NOT NULL,
              conservation_status TEXT NOT NULL,
              fishing_info TEXT NOT NULL,
              cooking_info TEXT NOT NULL,
              image_urls TEXT,
              distribution TEXT NOT NULL,
              is_premium INTEGER DEFAULT 0,
              last_updated TEXT NOT NULL
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS solunar_cache(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              date TEXT NOT NULL,
              latitude REAL NOT NULL,
              longitude REAL NOT NULL,
              solunar_data TEXT NOT NULL,
              created_at TEXT NOT NULL,
              UNIQUE(date, latitude, longitude)
            )
          ''');

          await db.execute('''
            CREATE TABLE IF NOT EXISTS statistics_cache(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              user_id TEXT NOT NULL,
              period_start TEXT NOT NULL,
              period_end TEXT NOT NULL,
              statistics_data TEXT NOT NULL,
              generated_at TEXT NOT NULL
            )
          ''');
        }
      },
    );
  }

  // ==================== FISH IDENTIFICATIONS ====================

  Future<int> insertFishIdentification(FishIdentification fish) async {
    final db = await database;
    final map = {
      'imagePath': fish.imagePath,
      'fishData': jsonEncode(fish.toJson()),
      'identifyDate': fish.identifyDate.toIso8601String(),
    };
    final id = await db.insert('fish_identifications', map);
    _databaseChangeController.add(null);
    return id;
  }

  Future<List<FishIdentification>> getAllFishIdentifications() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fish_identifications',
      orderBy: 'identifyDate DESC',
    );
    return List.generate(maps.length, (i) {
      final fishData = jsonDecode(maps[i]['fishData'] as String);
      return FishIdentification.fromJson(fishData).copyWith(
        id: maps[i]['id'] as int,
        imagePath: maps[i]['imagePath'] as String,
        identifyDate: DateTime.parse(maps[i]['identifyDate'] as String),
      );
    });
  }

  Future<FishIdentification?> getFishIdentificationById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fish_identifications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;

    final fishData = jsonDecode(maps.first['fishData'] as String);
    return FishIdentification.fromJson(fishData).copyWith(
      id: maps.first['id'] as int,
      imagePath: maps.first['imagePath'] as String,
      identifyDate: DateTime.parse(maps.first['identifyDate'] as String),
    );
  }

  Future<int> deleteFishIdentification(int id) async {
    final db = await database;
    final result = await db.delete(
      'fish_identifications',
      where: 'id = ?',
      whereArgs: [id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  // ==================== FISH COLLECTION ====================

  Future<int> addToCollection(FishCollection collection) async {
    final db = await database;
    final id = await db.insert('collection', collection.toMap());
    _databaseChangeController.add(null);
    return id;
  }

  Future<List<FishCollection>> getAllCollection() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'collection',
      orderBy: 'catchDate DESC',
    );
    return List.generate(maps.length, (i) => FishCollection.fromMap(maps[i]));
  }

  Future<List<FishCollection>> getFavoriteCollection() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'collection',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'catchDate DESC',
    );
    return List.generate(maps.length, (i) => FishCollection.fromMap(maps[i]));
  }

  Future<int> updateCollection(FishCollection collection) async {
    final db = await database;
    final result = await db.update(
      'collection',
      collection.toMap(),
      where: 'id = ?',
      whereArgs: [collection.id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  Future<int> deleteFromCollection(int id) async {
    final db = await database;
    final result = await db.delete(
      'collection',
      where: 'id = ?',
      whereArgs: [id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  // ==================== CHAT DIALOGUES ====================

  Future<int> createDialogue(String title, {int? fishId}) async {
    final db = await database;
    final result = await db.insert('dialogues', {
      'title': title,
      'created_at': DateTime.now().toIso8601String(),
      'fish_id': fishId,
    });
    _databaseChangeController.add(null);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllDialogues() async {
    final db = await database;
    return await db.query('dialogues', orderBy: 'created_at DESC');
  }

  Future<int> deleteDialogue(int id) async {
    final db = await database;
    final result = await db.delete(
      'dialogues',
      where: 'id = ?',
      whereArgs: [id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  // ==================== CHAT MESSAGES ====================

  Future<int> insertMessage(ChatMessage message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<ChatMessage>> getMessagesForDialogue(int dialogueId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'dialogueId = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  Future<void> deleteMessage(int messageId) async {
    final db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  // ==================== USER SETTINGS ====================

  Future<String?> getSetting(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==================== FISHING SPOTS ====================

  Future<int> addFishingSpot(FishingSpot spot) async {
    final db = await database;
    final id = await db.insert('fishing_spots', spot.toMap());
    _databaseChangeController.add(null);
    return id;
  }

  Future<List<FishingSpot>> getAllFishingSpots() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fishing_spots',
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => FishingSpot.fromMap(maps[i]));
  }

  Future<List<FishingSpot>> getFavoriteFishingSpots() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'fishing_spots',
      where: 'isFavorite = ?',
      whereArgs: [1],
      orderBy: 'dateAdded DESC',
    );
    return List.generate(maps.length, (i) => FishingSpot.fromMap(maps[i]));
  }

  Future<List<FishingSpot>> getNearbyFishingSpots(
    double latitude,
    double longitude, {
    double radiusInKm = 50,
  }) async {
    // Simple distance calculation (not precise for large distances)
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('fishing_spots');

    return maps
        .map((map) => FishingSpot.fromMap(map))
        .where((spot) {
          final distance = _calculateDistance(
            latitude,
            longitude,
            spot.latitude,
            spot.longitude,
          );
          return distance <= radiusInKm;
        })
        .toList()
      ..sort((a, b) {
        final distA = _calculateDistance(latitude, longitude, a.latitude, a.longitude);
        final distB = _calculateDistance(latitude, longitude, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Haversine formula for distance calculation
    const earthRadius = 6371.0; // km
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }

  Future<int> updateFishingSpot(FishingSpot spot) async {
    final db = await database;
    final result = await db.update(
      'fishing_spots',
      spot.toMap(),
      where: 'id = ?',
      whereArgs: [spot.id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  Future<int> toggleFishingSpotFavorite(int id, bool isFavorite) async {
    final db = await database;
    final result = await db.update(
      'fishing_spots',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  Future<int> deleteFishingSpot(int id) async {
    final db = await database;
    final result = await db.delete(
      'fishing_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
    _databaseChangeController.add(null);
    return result;
  }

  // ==================== DATA MANAGEMENT ====================

  Future<void> clearAllData() async {
    debugPrint('Clearing all database data');
    final db = await database;

    await db.delete('fish_identifications');
    await db.delete('collection');
    await db.delete('dialogues');
    await db.delete('messages');
    await db.delete('user_settings');
    await db.delete('fishing_spots');

    _databaseChangeController.add(null);
    debugPrint('All database data cleared');
  }

  // Clean up resources
  void dispose() {
    _databaseChangeController.close();
  }
}
