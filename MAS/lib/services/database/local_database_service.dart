import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../../models/math_solution.dart';
import '../../models/validation_result.dart';
import '../../models/chat_message.dart';
import '../../models/dialogue.dart';

/// Local SQLite database service for storing solutions and history
class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._init();
  static Database? _database;

  LocalDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mas_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE solutions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        problem_latex TEXT NOT NULL,
        problem_type TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        final_answer TEXT NOT NULL,
        steps TEXT NOT NULL,
        explanation TEXT,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE validations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        is_correct INTEGER NOT NULL,
        accuracy REAL NOT NULL,
        step_validations TEXT NOT NULL,
        hints TEXT,
        final_verdict TEXT NOT NULL,
        image_path TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE training_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        difficulty TEXT NOT NULL,
        type TEXT NOT NULL,
        correct_count INTEGER NOT NULL,
        total_count INTEGER NOT NULL,
        accuracy REAL NOT NULL,
        duration INTEGER NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Cache table for storing solutions by image hash
    await db.execute('''
      CREATE TABLE solution_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_hash TEXT NOT NULL UNIQUE,
        solution_json TEXT,
        validation_json TEXT,
        training_json TEXT,
        cache_type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_accessed TEXT NOT NULL,
        access_count INTEGER DEFAULT 1
      )
    ''');

    // Create index on image_hash for fast lookups
    await db.execute('''
      CREATE INDEX idx_image_hash ON solution_cache(image_hash)
    ''');

    // Chat tables for AI assistant conversations
    await db.execute('''
      CREATE TABLE dialogues (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL,
        last_message_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dialogue_id INTEGER NOT NULL,
        text TEXT NOT NULL,
        is_user INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        FOREIGN KEY (dialogue_id) REFERENCES dialogues (id) ON DELETE CASCADE
      )
    ''');

    // Create index on dialogue_id for fast message lookups
    await db.execute('''
      CREATE INDEX idx_dialogue_id ON messages(dialogue_id)
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add solution_cache table for v2
      await db.execute('''
        CREATE TABLE solution_cache (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          image_hash TEXT NOT NULL UNIQUE,
          solution_json TEXT,
          validation_json TEXT,
          training_json TEXT,
          cache_type TEXT NOT NULL,
          created_at TEXT NOT NULL,
          last_accessed TEXT NOT NULL,
          access_count INTEGER DEFAULT 1
        )
      ''');

      await db.execute('''
        CREATE INDEX idx_image_hash ON solution_cache(image_hash)
      ''');

      debugPrint('✅ Database upgraded to version 2: added solution_cache table');
    }

    if (oldVersion < 3) {
      // Add chat tables for v3
      await db.execute('''
        CREATE TABLE dialogues (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          created_at TEXT NOT NULL,
          last_message_at TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dialogue_id INTEGER NOT NULL,
          text TEXT NOT NULL,
          is_user INTEGER NOT NULL,
          timestamp TEXT NOT NULL,
          FOREIGN KEY (dialogue_id) REFERENCES dialogues (id) ON DELETE CASCADE
        )
      ''');

      await db.execute('''
        CREATE INDEX idx_dialogue_id ON messages(dialogue_id)
      ''');

      debugPrint('✅ Database upgraded to version 3: added chat tables (dialogues, messages)');
    }
  }

  /// Save math solution to database
  Future<int> saveSolution(MathSolution solution, String imagePath) async {
    final db = await database;

    return await db.insert('solutions', {
      'problem_latex': solution.problem.latexFormula,
      'problem_type': solution.problem.type.toString(),
      'difficulty': solution.difficulty.toString(),
      'final_answer': solution.finalAnswer,
      'steps': jsonEncode(solution.steps.map((s) => {
        'stepNumber': s.stepNumber,
        'description': s.description,
        'formula': s.formula,
        'explanation': s.explanation,
      }).toList()),
      'explanation': solution.explanation,
      'image_path': imagePath,
      'created_at': solution.createdAt.toIso8601String(),
    });
  }

  /// Save validation result to database
  Future<int> saveValidation(ValidationResult validation, String imagePath) async {
    final db = await database;

    return await db.insert('validations', {
      'is_correct': validation.isCorrect ? 1 : 0,
      'accuracy': validation.accuracy,
      'step_validations': jsonEncode(validation.stepValidations.map((sv) => {
        'stepNumber': sv.stepNumber,
        'isCorrect': sv.isCorrect,
        'errorType': sv.errorType?.toString(),
        'hint': sv.hint,
      }).toList()),
      'hints': jsonEncode(validation.hints),
      'final_verdict': validation.finalVerdict,
      'image_path': imagePath,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Get all solutions ordered by date
  Future<List<Map<String, dynamic>>> getAllSolutions() async {
    final db = await database;
    return await db.query('solutions', orderBy: 'created_at DESC');
  }

  /// Get solutions by difficulty
  Future<List<Map<String, dynamic>>> getSolutionsByDifficulty(String difficulty) async {
    final db = await database;
    return await db.query(
      'solutions',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
      orderBy: 'created_at DESC',
    );
  }

  /// Delete solution by ID
  Future<int> deleteSolution(int id) async {
    final db = await database;
    return await db.delete('solutions', where: 'id = ?', whereArgs: [id]);
  }

  /// Get database statistics
  Future<Map<String, int>> getStatistics() async {
    final db = await database;

    final solutionsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM solutions'),
    ) ?? 0;

    final validationsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM validations'),
    ) ?? 0;

    final sessionsCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM training_sessions'),
    ) ?? 0;

    final cacheCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM solution_cache'),
    ) ?? 0;

    return {
      'solutions': solutionsCount,
      'validations': validationsCount,
      'sessions': sessionsCount,
      'cached': cacheCount,
    };
  }

  // ========== CACHING METHODS ==========

  /// Calculate SHA-256 hash of image bytes for cache key
  String _calculateImageHash(Uint8List imageBytes) {
    final digest = sha256.convert(imageBytes);
    return digest.toString();
  }

  /// Get cached solution by image hash
  Future<MathSolution?> getCachedSolution(Uint8List imageBytes) async {
    try {
      final db = await database;
      final imageHash = _calculateImageHash(imageBytes);

      final List<Map<String, dynamic>> results = await db.query(
        'solution_cache',
        where: 'image_hash = ? AND cache_type = ?',
        whereArgs: [imageHash, 'solution'],
      );

      if (results.isEmpty) {
        debugPrint('❌ Cache miss for solution (hash: ${imageHash.substring(0, 8)}...)');
        return null;
      }

      // Update access statistics
      await db.update(
        'solution_cache',
        {
          'last_accessed': DateTime.now().toIso8601String(),
          'access_count': results.first['access_count'] + 1,
        },
        where: 'id = ?',
        whereArgs: [results.first['id']],
      );

      final solutionJson = jsonDecode(results.first['solution_json']) as Map<String, dynamic>;
      debugPrint('✅ Cache HIT for solution (hash: ${imageHash.substring(0, 8)}..., accessed ${results.first['access_count']} times)');

      return MathSolution.fromJson(solutionJson);
    } catch (e) {
      debugPrint('❌ Error getting cached solution: $e');
      return null;
    }
  }

  /// Cache a solution with image hash
  Future<void> cacheSolution(Uint8List imageBytes, MathSolution solution) async {
    try {
      final db = await database;
      final imageHash = _calculateImageHash(imageBytes);
      final now = DateTime.now().toIso8601String();

      await db.insert(
        'solution_cache',
        {
          'image_hash': imageHash,
          'solution_json': jsonEncode(solution.toJson()),
          'cache_type': 'solution',
          'created_at': now,
          'last_accessed': now,
          'access_count': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('💾 Solution cached (hash: ${imageHash.substring(0, 8)}...)');
    } catch (e) {
      debugPrint('❌ Error caching solution: $e');
    }
  }

  /// Get cached validation by image hash
  Future<ValidationResult?> getCachedValidation(Uint8List imageBytes) async {
    try {
      final db = await database;
      final imageHash = _calculateImageHash(imageBytes);

      final List<Map<String, dynamic>> results = await db.query(
        'solution_cache',
        where: 'image_hash = ? AND cache_type = ?',
        whereArgs: [imageHash, 'validation'],
      );

      if (results.isEmpty) {
        debugPrint('❌ Cache miss for validation (hash: ${imageHash.substring(0, 8)}...)');
        return null;
      }

      // Update access statistics
      await db.update(
        'solution_cache',
        {
          'last_accessed': DateTime.now().toIso8601String(),
          'access_count': results.first['access_count'] + 1,
        },
        where: 'id = ?',
        whereArgs: [results.first['id']],
      );

      final validationJson = jsonDecode(results.first['validation_json']) as Map<String, dynamic>;
      debugPrint('✅ Cache HIT for validation (hash: ${imageHash.substring(0, 8)}..., accessed ${results.first['access_count']} times)');

      return ValidationResult.fromJson(validationJson);
    } catch (e) {
      debugPrint('❌ Error getting cached validation: $e');
      return null;
    }
  }

  /// Cache a validation with image hash
  Future<void> cacheValidation(Uint8List imageBytes, ValidationResult validation) async {
    try {
      final db = await database;
      final imageHash = _calculateImageHash(imageBytes);
      final now = DateTime.now().toIso8601String();

      await db.insert(
        'solution_cache',
        {
          'image_hash': imageHash,
          'validation_json': jsonEncode(validation.toJson()),
          'cache_type': 'validation',
          'created_at': now,
          'last_accessed': now,
          'access_count': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      debugPrint('💾 Validation cached (hash: ${imageHash.substring(0, 8)}...)');
    } catch (e) {
      debugPrint('❌ Error caching validation: $e');
    }
  }

  /// Clear old cache entries (older than 30 days)
  Future<int> clearOldCache({int daysOld = 30}) async {
    try {
      final db = await database;
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));

      final deletedCount = await db.delete(
        'solution_cache',
        where: 'last_accessed < ?',
        whereArgs: [cutoffDate.toIso8601String()],
      );

      debugPrint('🗑️ Cleared $deletedCount old cache entries (>$daysOld days)');
      return deletedCount;
    } catch (e) {
      debugPrint('❌ Error clearing old cache: $e');
      return 0;
    }
  }

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final db = await database;

      final totalCached = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM solution_cache'),
      ) ?? 0;

      final solutionsCached = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM solution_cache WHERE cache_type = ?', ['solution']),
      ) ?? 0;

      final validationsCached = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM solution_cache WHERE cache_type = ?', ['validation']),
      ) ?? 0;

      final totalAccesses = Sqflite.firstIntValue(
        await db.rawQuery('SELECT SUM(access_count) FROM solution_cache'),
      ) ?? 0;

      return {
        'total': totalCached,
        'solutions': solutionsCached,
        'validations': validationsCached,
        'total_hits': totalAccesses,
      };
    } catch (e) {
      debugPrint('❌ Error getting cache statistics: $e');
      return {'total': 0, 'solutions': 0, 'validations': 0, 'total_hits': 0};
    }
  }

  // ========== CHAT METHODS ==========

  /// Create a new dialogue and return its ID
  Future<int> createDialogue(String title) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final id = await db.insert('dialogues', {
      'title': title,
      'created_at': now,
      'last_message_at': now,
    });

    debugPrint('💬 Created new dialogue: $id with title "$title"');
    return id;
  }

  /// Get all dialogues ordered by last message
  Future<List<Dialogue>> getAllDialogues() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dialogues',
      orderBy: 'last_message_at DESC',
    );

    return List.generate(maps.length, (i) => Dialogue.fromMap(maps[i]));
  }

  /// Get dialogue by ID
  Future<Dialogue?> getDialogue(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dialogues',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Dialogue.fromMap(maps.first);
  }

  /// Update dialogue last message time
  Future<void> updateDialogueTime(int dialogueId) async {
    final db = await database;
    await db.update(
      'dialogues',
      {'last_message_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [dialogueId],
    );
  }

  /// Delete dialogue (messages will be deleted automatically via CASCADE)
  Future<int> deleteDialogue(int id) async {
    final db = await database;
    final deletedCount = await db.delete('dialogues', where: 'id = ?', whereArgs: [id]);
    debugPrint('🗑️ Deleted dialogue: $id');
    return deletedCount;
  }

  /// Insert a message into a dialogue
  Future<int> insertMessage(ChatMessage message) async {
    final db = await database;
    final id = await db.insert('messages', message.toMap());

    // Update dialogue's last_message_at
    await updateDialogueTime(message.dialogueId);

    debugPrint('💬 Inserted message: $id (${message.isUser ? "user" : "bot"}) in dialogue ${message.dialogueId}');
    return id;
  }

  /// Get all messages for a dialogue
  Future<List<ChatMessage>> getMessages(int dialogueId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'dialogue_id = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  /// Get last N messages for a dialogue
  Future<List<ChatMessage>> getLastMessages(int dialogueId, int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'dialogue_id = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    // Reverse to get chronological order
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i])).reversed.toList();
  }

  /// Get message count for a dialogue
  Future<int> getMessageCount(int dialogueId) async {
    final db = await database;
    return Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM messages WHERE dialogue_id = ?',
        [dialogueId],
      ),
    ) ?? 0;
  }

  /// Clear all messages in a dialogue
  Future<int> clearDialogueMessages(int dialogueId) async {
    final db = await database;
    final deletedCount = await db.delete(
      'messages',
      where: 'dialogue_id = ?',
      whereArgs: [dialogueId],
    );
    debugPrint('🗑️ Cleared $deletedCount messages from dialogue $dialogueId');
    return deletedCount;
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
