import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import '../models/plant_result.dart';

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
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
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
}
