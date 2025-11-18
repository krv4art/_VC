import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/analysis_result.dart';

/// Сервис для локального хранилища (SQLite) результатов анализа
class LocalDataService {
  static final LocalDataService _instance = LocalDataService._internal();
  static Database? _database;

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
      final String path = join(await getDatabasesPath(), 'antique_identifier.db');
      debugPrint('Initializing database at: $path');

      return await openDatabase(
        path,
        version: 1,
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
      // Таблица для результатов анализа
      await db.execute('''
        CREATE TABLE IF NOT EXISTS analyses (
          id TEXT PRIMARY KEY,
          item_name TEXT NOT NULL,
          category TEXT,
          description TEXT,
          materials TEXT,
          historical_context TEXT,
          estimated_period TEXT,
          estimated_origin TEXT,
          price_estimate TEXT,
          warnings TEXT,
          authenticity_notes TEXT,
          similar_items TEXT,
          ai_summary TEXT,
          is_antique INTEGER,
          created_at TEXT,
          image_path TEXT,
          synced_to_cloud INTEGER DEFAULT 0
        )
      ''');

      // Таблица для диалогов (чатов)
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dialogues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          analysis_id TEXT,
          created_at TEXT,
          updated_at TEXT,
          synced_to_cloud INTEGER DEFAULT 0,
          FOREIGN KEY(analysis_id) REFERENCES analyses(id)
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

      debugPrint('✓ Database tables created successfully');
    } catch (e) {
      debugPrint('Error creating tables: $e');
      rethrow;
    }
  }

  /// Обновление БД при изменении версии
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Upgrading database from v$oldVersion to v$newVersion');
    // В будущем здесь будут миграции
  }

  /// Сохраняет результат анализа локально
  Future<void> saveAnalysis(AnalysisResult analysis, {String? imagePath}) async {
    try {
      final db = await database;
      final id = '${analysis.itemName}_${DateTime.now().millisecondsSinceEpoch}';

      await db.insert(
        'analyses',
        {
          'id': id,
          'item_name': analysis.itemName,
          'category': analysis.category,
          'description': analysis.description,
          'materials': jsonEncode(
            analysis.materials.map((m) => m.toJson()).toList(),
          ),
          'historical_context': analysis.historicalContext,
          'estimated_period': analysis.estimatedPeriod,
          'estimated_origin': analysis.estimatedOrigin,
          'price_estimate':
              analysis.priceEstimate != null
                  ? jsonEncode(analysis.priceEstimate!.toJson())
                  : null,
          'warnings': jsonEncode(analysis.warnings),
          'authenticity_notes': analysis.authenticityNotes,
          'similar_items': jsonEncode(analysis.similarItems),
          'ai_summary': analysis.aiSummary,
          'is_antique': analysis.isAntique ? 1 : 0,
          'created_at': DateTime.now().toIso8601String(),
          'image_path': imagePath,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('✓ Analysis saved to local database: $id');
    } catch (e) {
      debugPrint('Error saving analysis: $e');
      rethrow;
    }
  }

  /// Получает все анализы из локальной БД
  Future<List<AnalysisResult>> getAllAnalyses() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'analyses',
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) => _mapToAnalysis(maps[i]));
    } catch (e) {
      debugPrint('Error getting analyses: $e');
      return [];
    }
  }

  /// Получает анализ по ID
  Future<AnalysisResult?> getAnalysisById(String id) async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'analyses',
        where: 'id = ?',
        whereArgs: [id],
      );

      if (maps.isEmpty) return null;
      return _mapToAnalysis(maps.first);
    } catch (e) {
      debugPrint('Error getting analysis: $e');
      return null;
    }
  }

  /// Удаляет анализ
  Future<void> deleteAnalysis(String id) async {
    try {
      final db = await database;
      await db.delete('analyses', where: 'id = ?', whereArgs: [id]);
      debugPrint('✓ Analysis deleted: $id');
    } catch (e) {
      debugPrint('Error deleting analysis: $e');
      rethrow;
    }
  }

  /// Очищает все анализы
  Future<void> clearAllAnalyses() async {
    try {
      final db = await database;
      await db.delete('analyses');
      debugPrint('✓ All analyses cleared');
    } catch (e) {
      debugPrint('Error clearing analyses: $e');
      rethrow;
    }
  }

  /// Получает несинхронизированные анализы (для Supabase sync)
  Future<List<AnalysisResult>> getUnsyncedAnalyses() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'analyses',
        where: 'synced_to_cloud = 0',
      );

      return List.generate(maps.length, (i) => _mapToAnalysis(maps[i]));
    } catch (e) {
      debugPrint('Error getting unsynced analyses: $e');
      return [];
    }
  }

  /// Отмечает анализ как синхронизированный
  Future<void> markAsSynced(String id) async {
    try {
      final db = await database;
      await db.update(
        'analyses',
        {'synced_to_cloud': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error marking as synced: $e');
    }
  }

  /// Конвертирует Map в AnalysisResult
  AnalysisResult _mapToAnalysis(Map<String, dynamic> map) {
    return AnalysisResult(
      isAntique: map['is_antique'] == 1,
      itemName: map['item_name'] ?? '',
      category: map['category'],
      description: map['description'] ?? '',
      materials: map['materials'] != null
          ? (jsonDecode(map['materials']) as List)
              .map((m) => MaterialInfo.fromJson(m as Map<String, dynamic>))
              .toList()
          : [],
      historicalContext: map['historical_context'] ?? '',
      estimatedPeriod: map['estimated_period'],
      estimatedOrigin: map['estimated_origin'],
      priceEstimate: map['price_estimate'] != null
          ? PriceEstimate.fromJson(
              jsonDecode(map['price_estimate']) as Map<String, dynamic>,
            )
          : null,
      warnings: map['warnings'] != null
          ? (jsonDecode(map['warnings']) as List)
              .map((w) => w.toString())
              .toList()
          : [],
      authenticityNotes: map['authenticity_notes'],
      similarItems: map['similar_items'] != null
          ? (jsonDecode(map['similar_items']) as List)
              .map((s) => s.toString())
              .toList()
          : [],
      aiSummary: map['ai_summary'],
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
