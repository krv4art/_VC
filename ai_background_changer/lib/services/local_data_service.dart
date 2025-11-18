import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/background_result.dart';
import '../models/dialogue.dart';
import '../models/chat_message.dart';

/// Service for local database operations
class LocalDataService {
  static Database? _database;

  /// Initialize database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'background_changer.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create results table
    await db.execute('''
      CREATE TABLE results(
        id TEXT PRIMARY KEY,
        original_image_path TEXT NOT NULL,
        processed_image_path TEXT,
        removed_bg_image_path TEXT,
        timestamp TEXT NOT NULL,
        style_id TEXT,
        style_name TEXT,
        style_description TEXT,
        user_prompt TEXT,
        is_favorite INTEGER DEFAULT 0,
        status TEXT DEFAULT 'pending',
        error_message TEXT,
        metadata TEXT
      )
    ''');

    // Create dialogues table
    await db.execute('''
      CREATE TABLE dialogues(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        message_count INTEGER DEFAULT 0,
        last_message TEXT,
        result_id TEXT
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE messages(
        id TEXT PRIMARY KEY,
        dialogue_id TEXT NOT NULL,
        role TEXT NOT NULL,
        content TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        image_path TEXT,
        metadata TEXT,
        FOREIGN KEY (dialogue_id) REFERENCES dialogues (id) ON DELETE CASCADE
      )
    ''');

    // Create indices
    await db.execute('CREATE INDEX idx_results_timestamp ON results(timestamp DESC)');
    await db.execute('CREATE INDEX idx_results_favorite ON results(is_favorite)');
    await db.execute('CREATE INDEX idx_messages_dialogue ON messages(dialogue_id)');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // === Results Operations ===

  /// Save result to database
  static Future<void> saveResult(BackgroundResult result) async {
    final db = await database;
    await db.insert(
      'results',
      {
        ...result.toJson(),
        'is_favorite': result.isFavorite ? 1 : 0,
        'metadata': result.metadata != null ? result.metadata.toString() : null,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Result saved: ${result.id}');
  }

  /// Update result
  static Future<void> updateResult(BackgroundResult result) async {
    final db = await database;
    await db.update(
      'results',
      {
        ...result.toJson(),
        'is_favorite': result.isFavorite ? 1 : 0,
        'metadata': result.metadata != null ? result.metadata.toString() : null,
      },
      where: 'id = ?',
      whereArgs: [result.id],
    );
    debugPrint('Result updated: ${result.id}');
  }

  /// Get all results
  static Future<List<BackgroundResult>> getAllResults() async {
    final db = await database;
    final maps = await db.query('results', orderBy: 'timestamp DESC');
    return maps.map((map) {
      final jsonMap = Map<String, dynamic>.from(map);
      jsonMap['is_favorite'] = jsonMap['is_favorite'] == 1;
      return BackgroundResult.fromJson(jsonMap);
    }).toList();
  }

  /// Get result by ID
  static Future<BackgroundResult?> getResultById(String id) async {
    final db = await database;
    final maps = await db.query('results', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;

    final jsonMap = Map<String, dynamic>.from(maps.first);
    jsonMap['is_favorite'] = jsonMap['is_favorite'] == 1;
    return BackgroundResult.fromJson(jsonMap);
  }

  /// Delete result
  static Future<void> deleteResult(String id) async {
    final db = await database;
    await db.delete('results', where: 'id = ?', whereArgs: [id]);
    debugPrint('Result deleted: $id');
  }

  // === Dialogues Operations ===

  /// Save dialogue
  static Future<void> saveDialogue(Dialogue dialogue) async {
    final db = await database;
    await db.insert(
      'dialogues',
      dialogue.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    debugPrint('Dialogue saved: ${dialogue.id}');
  }

  /// Update dialogue
  static Future<void> updateDialogue(Dialogue dialogue) async {
    final db = await database;
    await db.update(
      'dialogues',
      dialogue.toJson(),
      where: 'id = ?',
      whereArgs: [dialogue.id],
    );
  }

  /// Get all dialogues
  static Future<List<Dialogue>> getAllDialogues() async {
    final db = await database;
    final maps = await db.query('dialogues', orderBy: 'updated_at DESC');
    return maps.map((map) => Dialogue.fromJson(map)).toList();
  }

  /// Delete dialogue
  static Future<void> deleteDialogue(String id) async {
    final db = await database;
    await db.delete('dialogues', where: 'id = ?', whereArgs: [id]);
    debugPrint('Dialogue deleted: $id');
  }

  // === Messages Operations ===

  /// Save message
  static Future<void> saveMessage(ChatMessage message) async {
    final db = await database;
    await db.insert(
      'messages',
      {
        ...message.toJson(),
        'metadata': message.metadata?.toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get messages by dialogue ID
  static Future<List<ChatMessage>> getMessagesByDialogue(String dialogueId) async {
    final db = await database;
    final maps = await db.query(
      'messages',
      where: 'dialogue_id = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp ASC',
    );
    return maps.map((map) => ChatMessage.fromJson(map)).toList();
  }

  /// Delete all messages in a dialogue
  static Future<void> deleteMessagesByDialogue(String dialogueId) async {
    final db = await database;
    await db.delete('messages', where: 'dialogue_id = ?', whereArgs: [dialogueId]);
  }

  /// Clear all data
  static Future<void> clearAllData() async {
    final db = await database;
    await db.delete('results');
    await db.delete('dialogues');
    await db.delete('messages');
    debugPrint('All data cleared');
  }
}
