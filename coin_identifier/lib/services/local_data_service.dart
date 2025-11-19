import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/analysis_result.dart';
import 'package:uuid/uuid.dart';

/// Сервис для локального хранилища (SQLite) результатов анализа
class LocalDataService {
  static final LocalDataService _instance = LocalDataService._internal();
  static Database? _database;
  final _uuid = const Uuid();

  factory LocalDataService() {
    return _instance;
  }

  LocalDataService._internal();

  /// Инициализирует БД
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Инициализирует БД при первом запуске
  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), 'coin_identifier.db');
      debugPrint('Initializing database at: $path');

      return await openDatabase(
        path,
        version: 2,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  /// Создание таблиц при первом запуске
  Future<void> _onCreate(Database db, int version) async {
    try {
      // Обновленная таблица для результатов анализа монет
      await db.execute('''
        CREATE TABLE IF NOT EXISTS coins (
          id TEXT PRIMARY KEY,
          is_coin_or_banknote INTEGER,
          humorous_message TEXT,
          item_type TEXT,
          name TEXT NOT NULL,
          country TEXT,
          year_of_issue TEXT,
          mint_mark TEXT,
          denomination TEXT,
          description TEXT,
          obverse_description TEXT,
          reverse_description TEXT,
          materials TEXT,
          weight REAL,
          diameter REAL,
          edge TEXT,
          rarity_level TEXT,
          rarity_score INTEGER,
          market_value TEXT,
          collector_interest TEXT,
          historical_context TEXT,
          mintage_quantity TEXT,
          circulation_period TEXT,
          mint_errors TEXT,
          special_features TEXT,
          warnings TEXT,
          authenticity_notes TEXT,
          similar_coins TEXT,
          ai_summary TEXT,
          expert_advice TEXT,
          is_in_wishlist INTEGER DEFAULT 0,
          tags TEXT,
          user_notes TEXT,
          added_at TEXT,
          image_path TEXT,
          sheldon_grade INTEGER,
          condition_grade TEXT,
          is_favorite INTEGER DEFAULT 0,
          purchase_price REAL,
          purchase_date TEXT,
          location TEXT,
          synced_to_cloud INTEGER DEFAULT 0
        )
      ''');

      // Индексы для быстрого поиска
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_is_in_wishlist ON coins(is_in_wishlist)');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_is_favorite ON coins(is_favorite)');
      await db.execute('CREATE INDEX IF NOT EXISTS idx_country ON coins(country)');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_added_at ON coins(added_at)');

      // Таблица для диалогов (чатов)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dialogues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          coin_id TEXT,
          created_at TEXT,
          updated_at TEXT,
          synced_to_cloud INTEGER DEFAULT 0,
          FOREIGN KEY(coin_id) REFERENCES coins(id)
        )
      ''');

      // Таблица для сообщений чата
      await db.execute('''
        CREATE TABLE IF NOT EXISTS chat_messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dialogue_id INTEGER NOT NULL,
          text TEXT NOT NULL,
          is_user INTEGER,
          timestamp TEXT,
          synced_to_cloud INTEGER DEFAULT 0,
          FOREIGN KEY(dialogue_id) REFERENCES dialogues(id)
        )
      ''');

      debugPrint('✓ Database tables created successfully (v2)');
    } catch (e) {
      debugPrint('Error creating tables: $e');
      rethrow;
    }
  }

  /// Обновление БД при изменении версии
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from v$oldVersion to v$newVersion');

    if (oldVersion < 2) {
      // Миграция со старой схемы на новую
      try {
        // Создаем новую таблицу
        await _onCreate(db, newVersion);
        debugPrint('✓ Database upgraded to v$newVersion');
      } catch (e) {
        debugPrint('Error during migration: $e');
      }
    }
  }

  /// Сохраняет результат анализа локально
  Future<String> saveAnalysis(AnalysisResult analysis,
      {String? imagePath}) async {
    try {
      final db = await database;
      final id = analysis.id ?? _uuid.v4();

      final Map<String, dynamic> data = {
        'id': id,
        'is_coin_or_banknote': analysis.isCoinOrBanknote ? 1 : 0,
        'humorous_message': analysis.humorousMessage,
        'item_type': analysis.itemType,
        'name': analysis.name,
        'country': analysis.country,
        'year_of_issue': analysis.yearOfIssue,
        'mint_mark': analysis.mintMark,
        'denomination': analysis.denomination,
        'description': analysis.description,
        'obverse_description': analysis.obverseDescription,
        'reverse_description': analysis.reverseDescription,
        'materials': jsonEncode(
          analysis.materials.map((m) => m.toJson()).toList(),
        ),
        'weight': analysis.weight,
        'diameter': analysis.diameter,
        'edge': analysis.edge,
        'rarity_level': analysis.rarityLevel,
        'rarity_score': analysis.rarityScore,
        'market_value':
            analysis.marketValue != null ? jsonEncode(analysis.marketValue!.toJson()) : null,
        'collector_interest': analysis.collectorInterest,
        'historical_context': analysis.historicalContext,
        'mintage_quantity': analysis.mintageQuantity,
        'circulation_period': analysis.circulationPeriod,
        'mint_errors': jsonEncode(
          analysis.mintErrors.map((e) => e.toJson()).toList(),
        ),
        'special_features': jsonEncode(analysis.specialFeatures),
        'warnings': jsonEncode(analysis.warnings),
        'authenticity_notes': analysis.authenticityNotes,
        'similar_coins': jsonEncode(analysis.similarCoins),
        'ai_summary': analysis.aiSummary,
        'expert_advice': analysis.expertAdvice,
        'is_in_wishlist': analysis.isInWishlist ? 1 : 0,
        'tags': jsonEncode(analysis.tags),
        'user_notes': analysis.userNotes,
        'added_at': (analysis.addedAt ?? DateTime.now()).toIso8601String(),
        'image_path': imagePath ?? analysis.imagePath,
        'sheldon_grade': analysis.sheldonGrade,
        'condition_grade': analysis.conditionGrade,
        'is_favorite': analysis.isFavorite ? 1 : 0,
        'purchase_price': analysis.purchasePrice,
        'purchase_date': analysis.purchaseDate?.toIso8601String(),
        'location': analysis.location,
      };

      await db.insert(
        'coins',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✓ Coin saved to local database: $id');
      return id;
    } catch (e) {
      debugPrint('Error saving coin: $e');
      rethrow;
    }
  }

  /// Получает все монеты из коллекции (не wishlist)
  Future<List<AnalysisResult>> getAllCoins() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: 'is_in_wishlist = 0',
        orderBy: 'added_at DESC',
      );

      return List.generate(maps.length, (i) => _mapToCoin(maps[i]));
    } catch (e) {
      debugPrint('Error getting coins: $e');
      return [];
    }
  }

  /// Получает все монеты из wishlist
  Future<List<AnalysisResult>> getWishlist() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: 'is_in_wishlist = 1',
        orderBy: 'added_at DESC',
      );

      return List.generate(maps.length, (i) => _mapToCoin(maps[i]));
    } catch (e) {
      debugPrint('Error getting wishlist: $e');
      return [];
    }
  }

  /// Получает избранные монеты
  Future<List<AnalysisResult>> getFavorites() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: 'is_favorite = 1',
        orderBy: 'added_at DESC',
      );

      return List.generate(maps.length, (i) => _mapToCoin(maps[i]));
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  /// Поиск монет с фильтрами
  Future<List<AnalysisResult>> searchCoins({
    String? query,
    String? country,
    String? yearFrom,
    String? yearTo,
    String? rarityLevel,
    bool? isInWishlist,
    bool? isFavorite,
    List<String>? tags,
  }) async {
    try {
      final db = await database;
      String whereClause = '1=1';
      List<dynamic> whereArgs = [];

      if (query != null && query.isNotEmpty) {
        whereClause += ' AND (name LIKE ? OR description LIKE ?)';
        whereArgs.addAll(['%$query%', '%$query%']);
      }

      if (country != null && country.isNotEmpty) {
        whereClause += ' AND country = ?';
        whereArgs.add(country);
      }

      if (rarityLevel != null && rarityLevel.isNotEmpty) {
        whereClause += ' AND rarity_level = ?';
        whereArgs.add(rarityLevel);
      }

      if (isInWishlist != null) {
        whereClause += ' AND is_in_wishlist = ?';
        whereArgs.add(isInWishlist ? 1 : 0);
      }

      if (isFavorite != null) {
        whereClause += ' AND is_favorite = ?';
        whereArgs.add(isFavorite ? 1 : 0);
      }

      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'added_at DESC',
      );

      var results = List.generate(maps.length, (i) => _mapToCoin(maps[i]));

      // Фильтр по тегам (клиентская сторона, так как JSON)
      if (tags != null && tags.isNotEmpty) {
        results = results.where((coin) {
          return tags.any((tag) => coin.tags.contains(tag));
        }).toList();
      }

      return results;
    } catch (e) {
      debugPrint('Error searching coins: $e');
      return [];
    }
  }

  /// Получает монету по ID
  Future<AnalysisResult?> getCoinById(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return _mapToCoin(maps.first);
    } catch (e) {
      debugPrint('Error getting coin: $e');
      return null;
    }
  }

  /// Обновляет монету
  Future<void> updateCoin(AnalysisResult coin) async {
    try {
      final db = await database;
      final Map<String, dynamic> data = {
        'is_coin_or_banknote': coin.isCoinOrBanknote ? 1 : 0,
        'humorous_message': coin.humorousMessage,
        'item_type': coin.itemType,
        'name': coin.name,
        'country': coin.country,
        'year_of_issue': coin.yearOfIssue,
        'mint_mark': coin.mintMark,
        'denomination': coin.denomination,
        'description': coin.description,
        'obverse_description': coin.obverseDescription,
        'reverse_description': coin.reverseDescription,
        'materials': jsonEncode(
          coin.materials.map((m) => m.toJson()).toList(),
        ),
        'weight': coin.weight,
        'diameter': coin.diameter,
        'edge': coin.edge,
        'rarity_level': coin.rarityLevel,
        'rarity_score': coin.rarityScore,
        'market_value':
            coin.marketValue != null ? jsonEncode(coin.marketValue!.toJson()) : null,
        'collector_interest': coin.collectorInterest,
        'historical_context': coin.historicalContext,
        'mintage_quantity': coin.mintageQuantity,
        'circulation_period': coin.circulationPeriod,
        'mint_errors': jsonEncode(
          coin.mintErrors.map((e) => e.toJson()).toList(),
        ),
        'special_features': jsonEncode(coin.specialFeatures),
        'warnings': jsonEncode(coin.warnings),
        'authenticity_notes': coin.authenticityNotes,
        'similar_coins': jsonEncode(coin.similarCoins),
        'ai_summary': coin.aiSummary,
        'expert_advice': coin.expertAdvice,
        'is_in_wishlist': coin.isInWishlist ? 1 : 0,
        'tags': jsonEncode(coin.tags),
        'user_notes': coin.userNotes,
        'image_path': coin.imagePath,
        'sheldon_grade': coin.sheldonGrade,
        'condition_grade': coin.conditionGrade,
        'is_favorite': coin.isFavorite ? 1 : 0,
        'purchase_price': coin.purchasePrice,
        'purchase_date': coin.purchaseDate?.toIso8601String(),
        'location': coin.location,
      };

      await db.update(
        'coins',
        data,
        where: 'id = ?',
        whereArgs: [coin.id],
      );

      debugPrint('✓ Coin updated: ${coin.id}');
    } catch (e) {
      debugPrint('Error updating coin: $e');
      rethrow;
    }
  }

  /// Переключает статус wishlist
  Future<void> toggleWishlist(String id) async {
    try {
      final db = await database;
      final coin = await getCoinById(id);
      if (coin == null) return;

      await db.update(
        'coins',
        {'is_in_wishlist': coin.isInWishlist ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );

      debugPrint('✓ Wishlist toggled for: $id');
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
    }
  }

  /// Переключает избранное
  Future<void> toggleFavorite(String id) async {
    try {
      final db = await database;
      final coin = await getCoinById(id);
      if (coin == null) return;

      await db.update(
        'coins',
        {'is_favorite': coin.isFavorite ? 0 : 1},
        where: 'id = ?',
        whereArgs: [id],
      );

      debugPrint('✓ Favorite toggled for: $id');
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }

  /// Удаляет монету
  Future<void> deleteCoin(String id) async {
    try {
      final db = await database;
      await db.delete('coins', where: 'id = ?', whereArgs: [id]);
      debugPrint('✓ Coin deleted: $id');
    } catch (e) {
      debugPrint('Error deleting coin: $e');
      rethrow;
    }
  }

  /// Очищает все монеты
  Future<void> clearAllCoins() async {
    try {
      final db = await database;
      await db.delete('coins');
      debugPrint('✓ All coins cleared');
    } catch (e) {
      debugPrint('Error clearing coins: $e');
      rethrow;
    }
  }

  /// Получает статистику коллекции
  Future<Map<String, dynamic>> getCollectionStats() async {
    try {
      final db = await database;

      // Общее количество
      final totalCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM coins WHERE is_in_wishlist = 0'),
          ) ??
          0;

      final wishlistCount = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM coins WHERE is_in_wishlist = 1'),
          ) ??
          0;

      // Количество по странам
      final countriesResult = await db.rawQuery('''
        SELECT country, COUNT(*) as count
        FROM coins
        WHERE is_in_wishlist = 0 AND country IS NOT NULL
        GROUP BY country
        ORDER BY count DESC
      ''');

      // Распределение по редкости
      final rarityResult = await db.rawQuery('''
        SELECT rarity_level, COUNT(*) as count
        FROM coins
        WHERE is_in_wishlist = 0
        GROUP BY rarity_level
      ''');

      // Общая стоимость (примерная)
      final valueResult = await db.rawQuery('''
        SELECT SUM(purchase_price) as total_value
        FROM coins
        WHERE is_in_wishlist = 0 AND purchase_price IS NOT NULL
      ''');

      return {
        'total_count': totalCount,
        'wishlist_count': wishlistCount,
        'countries': countriesResult,
        'rarity_distribution': rarityResult,
        'total_value': valueResult.first['total_value'] ?? 0.0,
      };
    } catch (e) {
      debugPrint('Error getting stats: $e');
      return {
        'total_count': 0,
        'wishlist_count': 0,
        'countries': [],
        'rarity_distribution': [],
        'total_value': 0.0,
      };
    }
  }

  /// Получает несинхронизированные монеты (для Supabase sync)
  Future<List<AnalysisResult>> getUnsyncedCoins() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'coins',
        where: 'synced_to_cloud = 0',
      );

      return List.generate(maps.length, (i) => _mapToCoin(maps[i]));
    } catch (e) {
      debugPrint('Error getting unsynced coins: $e');
      return [];
    }
  }

  /// Отмечает монету как синхронизированную
  Future<void> markAsSynced(String id) async {
    try {
      final db = await database;
      await db.update(
        'coins',
        {'synced_to_cloud': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error marking as synced: $e');
    }
  }

  /// Конвертирует Map в AnalysisResult
  AnalysisResult _mapToCoin(Map<String, dynamic> map) {
    return AnalysisResult(
      id: map['id'] as String?,
      isCoinOrBanknote: (map['is_coin_or_banknote'] as int?) == 1,
      humorousMessage: map['humorous_message'] as String?,
      itemType: map['item_type'] as String? ?? 'coin',
      name: map['name'] as String? ?? 'Unknown',
      country: map['country'] as String?,
      yearOfIssue: map['year_of_issue'] as String?,
      mintMark: map['mint_mark'] as String?,
      denomination: map['denomination'] as String?,
      description: map['description'] as String? ?? '',
      obverseDescription: map['obverse_description'] as String?,
      reverseDescription: map['reverse_description'] as String?,
      materials: map['materials'] != null
          ? (jsonDecode(map['materials'] as String) as List)
              .map((m) => CoinMaterial.fromJson(m as Map<String, dynamic>))
              .toList()
          : [],
      weight: (map['weight'] as num?)?.toDouble(),
      diameter: (map['diameter'] as num?)?.toDouble(),
      edge: map['edge'] as String?,
      rarityLevel: map['rarity_level'] as String? ?? 'Common',
      rarityScore: map['rarity_score'] as int? ?? 1,
      marketValue: map['market_value'] != null
          ? MarketValue.fromJson(
              jsonDecode(map['market_value'] as String) as Map<String, dynamic>,
            )
          : null,
      collectorInterest: map['collector_interest'] as String?,
      historicalContext: map['historical_context'] as String? ?? '',
      mintageQuantity: map['mintage_quantity'] as String?,
      circulationPeriod: map['circulation_period'] as String?,
      mintErrors: map['mint_errors'] != null
          ? (jsonDecode(map['mint_errors'] as String) as List)
              .map((e) => MintError.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      specialFeatures: map['special_features'] != null
          ? (jsonDecode(map['special_features'] as String) as List)
              .map((s) => s.toString())
              .toList()
          : [],
      warnings: map['warnings'] != null
          ? (jsonDecode(map['warnings'] as String) as List)
              .map((w) => w.toString())
              .toList()
          : [],
      authenticityNotes: map['authenticity_notes'] as String?,
      similarCoins: map['similar_coins'] != null
          ? (jsonDecode(map['similar_coins'] as String) as List)
              .map((s) => s.toString())
              .toList()
          : [],
      aiSummary: map['ai_summary'] as String?,
      expertAdvice: map['expert_advice'] as String?,
      isInWishlist: (map['is_in_wishlist'] as int?) == 1,
      tags: map['tags'] != null
          ? (jsonDecode(map['tags'] as String) as List)
              .map((t) => t.toString())
              .toList()
          : [],
      userNotes: map['user_notes'] as String?,
      addedAt: map['added_at'] != null
          ? DateTime.parse(map['added_at'] as String)
          : null,
      imagePath: map['image_path'] as String?,
      sheldonGrade: map['sheldon_grade'] as int?,
      conditionGrade: map['condition_grade'] as String?,
      isFavorite: (map['is_favorite'] as int?) == 1,
      purchasePrice: (map['purchase_price'] as num?)?.toDouble(),
      purchaseDate: map['purchase_date'] != null
          ? DateTime.parse(map['purchase_date'] as String)
          : null,
      location: map['location'] as String?,
    );
  }

  /// Закрывает БД
  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
