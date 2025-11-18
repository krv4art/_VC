import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/processed_image.dart';
import '../constants/app_constants.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, AppConstants.dbName);

    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE processed_images (
        id TEXT PRIMARY KEY,
        originalPath TEXT NOT NULL,
        processedPath TEXT NOT NULL,
        processingMode TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isPremium INTEGER NOT NULL DEFAULT 0,
        metadata TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_created_at ON processed_images(createdAt DESC)
    ''');
  }

  Future<void> saveProcessedImage(ProcessedImage image) async {
    final db = await database;
    await db.insert(
      'processed_images',
      image.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ProcessedImage>> getProcessedImages({int? limit}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'processed_images',
      orderBy: 'createdAt DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) => ProcessedImage.fromMap(maps[i]));
  }

  Future<ProcessedImage?> getProcessedImage(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'processed_images',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return ProcessedImage.fromMap(maps.first);
  }

  Future<void> deleteProcessedImage(String id) async {
    final db = await database;
    await db.delete(
      'processed_images',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllProcessedImages() async {
    final db = await database;
    await db.delete('processed_images');
  }

  Future<int> getProcessedImagesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM processed_images');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
