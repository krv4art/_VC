import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/plant_result.dart';
import '../models/dialogue.dart';
import '../models/chat_message.dart';

/// Service for managing local database operations
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'plant_identifier.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create plant_results table
    await db.execute('''
      CREATE TABLE plant_results(
        id TEXT PRIMARY KEY,
        plantName TEXT NOT NULL,
        scientificName TEXT NOT NULL,
        description TEXT NOT NULL,
        type TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        identifiedAt TEXT NOT NULL,
        careInfo TEXT,
        commonNames TEXT,
        family TEXT,
        origin TEXT,
        isToxic INTEGER NOT NULL,
        isEdible INTEGER NOT NULL,
        usesAndBenefits TEXT,
        confidence REAL NOT NULL
      )
    ''');

    // Create dialogues table
    await db.execute('''
      CREATE TABLE dialogues(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        created_at TEXT NOT NULL,
        plant_image_path TEXT,
        identification_result_id TEXT
      )
    ''');

    // Create chat_messages table
    await db.execute('''
      CREATE TABLE chat_messages(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dialogueId INTEGER NOT NULL,
        text TEXT NOT NULL,
        isUser INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        plantImagePath TEXT,
        FOREIGN KEY (dialogueId) REFERENCES dialogues(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create dialogues table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS dialogues(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          created_at TEXT NOT NULL,
          plant_image_path TEXT,
          identification_result_id TEXT
        )
      ''');

      // Create chat_messages table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS chat_messages(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dialogueId INTEGER NOT NULL,
          text TEXT NOT NULL,
          isUser INTEGER NOT NULL,
          timestamp TEXT NOT NULL,
          plantImagePath TEXT,
          FOREIGN KEY (dialogueId) REFERENCES dialogues(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  /// Save plant identification result
  Future<void> savePlantResult(PlantResult result) async {
    final db = await database;

    await db.insert(
      'plant_results',
      {
        'id': result.id,
        'plantName': result.plantName,
        'scientificName': result.scientificName,
        'description': result.description,
        'type': result.type.toString().split('.').last,
        'imageUrl': result.imageUrl,
        'identifiedAt': result.identifiedAt.toIso8601String(),
        'careInfo': result.careInfo != null
            ? json.encode(result.careInfo!.toJson())
            : null,
        'commonNames': json.encode(result.commonNames),
        'family': result.family,
        'origin': result.origin,
        'isToxic': result.isToxic ? 1 : 0,
        'isEdible': result.isEdible ? 1 : 0,
        'usesAndBenefits': json.encode(result.usesAndBenefits),
        'confidence': result.confidence,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all plant identification history
  Future<List<PlantResult>> getPlantHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'plant_results',
      orderBy: 'identifiedAt DESC',
    );

    return List.generate(maps.length, (i) {
      return PlantResult(
        id: maps[i]['id'] as String,
        plantName: maps[i]['plantName'] as String,
        scientificName: maps[i]['scientificName'] as String,
        description: maps[i]['description'] as String,
        type: PlantType.values.firstWhere(
          (e) => e.toString().split('.').last == maps[i]['type'],
          orElse: () => PlantType.plant,
        ),
        imageUrl: maps[i]['imageUrl'] as String,
        identifiedAt: DateTime.parse(maps[i]['identifiedAt'] as String),
        careInfo: maps[i]['careInfo'] != null
            ? PlantCareInfo.fromJson(
                json.decode(maps[i]['careInfo'] as String)
                    as Map<String, dynamic>,
              )
            : null,
        commonNames:
            (json.decode(maps[i]['commonNames'] as String) as List<dynamic>)
                .cast<String>(),
        family: maps[i]['family'] as String?,
        origin: maps[i]['origin'] as String?,
        isToxic: maps[i]['isToxic'] == 1,
        isEdible: maps[i]['isEdible'] == 1,
        usesAndBenefits:
            (json.decode(maps[i]['usesAndBenefits'] as String) as List<dynamic>)
                .cast<String>(),
        confidence: maps[i]['confidence'] as double,
      );
    });
  }

  /// Delete a specific plant result
  Future<void> deletePlantResult(String id) async {
    final db = await database;
    await db.delete(
      'plant_results',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Clear all plant history
  Future<void> clearPlantHistory() async {
    final db = await database;
    await db.delete('plant_results');
  }

  // ============= Dialogue Methods =============

  /// Create a new dialogue
  Future<int> createDialogue(
    String title, {
    String? identificationResultId,
  }) async {
    final db = await database;

    final dialogueId = await db.insert(
      'dialogues',
      {
        'title': title,
        'created_at': DateTime.now().toIso8601String(),
        'plant_image_path': null,
        'identification_result_id': identificationResultId,
      },
    );

    return dialogueId;
  }

  /// Get all dialogues
  Future<List<Dialogue>> getAllDialogues() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dialogues',
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) => Dialogue.fromMap(maps[i]));
  }

  /// Get a specific dialogue by ID
  Future<Dialogue?> getDialogueById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dialogues',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Dialogue.fromMap(maps.first);
  }

  /// Delete a dialogue
  Future<void> deleteDialogue(int id) async {
    final db = await database;
    await db.delete(
      'dialogues',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get plant result linked to a dialogue
  Future<PlantResult?> getPlantResultForDialogue(int dialogueId) async {
    final db = await database;

    // Get the dialogue first
    final dialogue = await getDialogueById(dialogueId);
    if (dialogue == null || dialogue.identificationResultId == null) {
      return null;
    }

    // Get the plant result
    final List<Map<String, dynamic>> maps = await db.query(
      'plant_results',
      where: 'id = ?',
      whereArgs: [dialogue.identificationResultId],
    );

    if (maps.isEmpty) return null;

    return PlantResult(
      id: maps[0]['id'] as String,
      plantName: maps[0]['plantName'] as String,
      scientificName: maps[0]['scientificName'] as String,
      description: maps[0]['description'] as String,
      type: PlantType.values.firstWhere(
        (e) => e.toString().split('.').last == maps[0]['type'],
        orElse: () => PlantType.plant,
      ),
      imageUrl: maps[0]['imageUrl'] as String,
      identifiedAt: DateTime.parse(maps[0]['identifiedAt'] as String),
      careInfo: maps[0]['careInfo'] != null
          ? PlantCareInfo.fromJson(
              json.decode(maps[0]['careInfo'] as String)
                  as Map<String, dynamic>,
            )
          : null,
      commonNames:
          (json.decode(maps[0]['commonNames'] as String) as List<dynamic>)
              .cast<String>(),
      family: maps[0]['family'] as String?,
      origin: maps[0]['origin'] as String?,
      isToxic: maps[0]['isToxic'] == 1,
      isEdible: maps[0]['isEdible'] == 1,
      usesAndBenefits:
          (json.decode(maps[0]['usesAndBenefits'] as String) as List<dynamic>)
              .cast<String>(),
      confidence: maps[0]['confidence'] as double,
    );
  }

  // ============= Chat Message Methods =============

  /// Save a chat message
  Future<int> saveChatMessage(ChatMessage message) async {
    final db = await database;

    final messageId = await db.insert(
      'chat_messages',
      message.toMap(),
    );

    return messageId;
  }

  /// Get all messages for a dialogue
  Future<List<ChatMessage>> getMessagesForDialogue(int dialogueId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'chat_messages',
      where: 'dialogueId = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  /// Delete all messages for a dialogue
  Future<void> deleteMessagesForDialogue(int dialogueId) async {
    final db = await database;
    await db.delete(
      'chat_messages',
      where: 'dialogueId = ?',
      whereArgs: [dialogueId],
    );
  }

  /// Update a chat message
  Future<void> updateChatMessage(ChatMessage message) async {
    final db = await database;
    await db.update(
      'chat_messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }
}
