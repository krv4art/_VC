import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import '../models/generated_photo.dart';
import '../models/generation_job.dart';
import '../models/style_model.dart';

/// Local database service for AI Photo Studio Pro
/// Manages generated photos, styles, and generation jobs
import 'database_service.dart';

class LocalPhotoDatabase implements DatabaseService {
  static final LocalPhotoDatabase instance = LocalPhotoDatabase._internal();
  static Database? _database;

  factory LocalPhotoDatabase() {
    return instance;
  }

  LocalPhotoDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ai_photo_studio.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Generated Photos table
    await db.execute('''
      CREATE TABLE generated_photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        original_path TEXT NOT NULL,
        generated_path TEXT,
        style_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        status TEXT NOT NULL,
        metadata TEXT
      )
    ''');

    // Styles table
    await db.execute('''
      CREATE TABLE styles (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        preview_url TEXT NOT NULL,
        category TEXT NOT NULL,
        localized_names TEXT,
        localized_descriptions TEXT,
        prompt_template TEXT,
        is_premium INTEGER NOT NULL DEFAULT 0,
        sort_order INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Generation Jobs table
    await db.execute('''
      CREATE TABLE generation_jobs (
        id TEXT PRIMARY KEY,
        photo_id INTEGER NOT NULL,
        style_id TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        started_at TEXT,
        completed_at TEXT,
        result_url TEXT,
        error_message TEXT,
        metadata TEXT,
        FOREIGN KEY (photo_id) REFERENCES generated_photos (id) ON DELETE CASCADE
      )
    ''');

    // Indexes for better performance
    await db.execute(
      'CREATE INDEX idx_photos_created_at ON generated_photos(created_at DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_photos_style_id ON generated_photos(style_id)',
    );
    await db.execute(
      'CREATE INDEX idx_jobs_photo_id ON generation_jobs(photo_id)',
    );
    await db.execute('CREATE INDEX idx_styles_category ON styles(category)');

    // Insert default styles
    await _insertDefaultStyles(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  /// Insert default styles
  Future<void> _insertDefaultStyles(Database db) async {
    final defaultStyles = [
      StyleModel(
        id: 'professional_business',
        name: 'Professional Business',
        description: 'Classic business headshot with professional attire',
        previewUrl: 'assets/images/styles/professional_business.jpg',
        category: StyleCategory.professional,
        isPremium: false,
        sortOrder: 1,
      ),
      StyleModel(
        id: 'casual_outdoor',
        name: 'Casual Outdoor',
        description: 'Relaxed outdoor portrait with natural lighting',
        previewUrl: 'assets/images/styles/casual_outdoor.jpg',
        category: StyleCategory.casual,
        isPremium: false,
        sortOrder: 2,
      ),
      StyleModel(
        id: 'creative_artistic',
        name: 'Creative Artistic',
        description: 'Artistic portrait with creative styling',
        previewUrl: 'assets/images/styles/creative_artistic.jpg',
        category: StyleCategory.creative,
        isPremium: true,
        sortOrder: 3,
      ),
    ];

    for (final style in defaultStyles) {
      await db.insert('styles', style.toMap());
    }
  }

  // ==================== Generated Photos ====================

  Future<int> insertGeneratedPhoto(dynamic photo) async {
    final db = await database;
    return await db.insert(
      'generated_photos',
      (photo as GeneratedPhoto).toMap(),
    );
  }

  Future<void> updateGeneratedPhoto(dynamic photo) async {
    final db = await database;
    await db.update(
      'generated_photos',
      (photo as GeneratedPhoto).toMap(),
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  Future<void> deleteGeneratedPhoto(int id) async {
    final db = await database;
    await db.delete('generated_photos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<GeneratedPhoto>> getAllGeneratedPhotos() async {
    final db = await database;
    final maps = await db.query('generated_photos', orderBy: 'created_at DESC');

    return maps.map((map) => GeneratedPhoto.fromMap(map)).toList();
  }

  Future<List<GeneratedPhoto>> getPhotosByStyle(String styleId) async {
    final db = await database;
    final maps = await db.query(
      'generated_photos',
      where: 'style_id = ?',
      whereArgs: [styleId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => GeneratedPhoto.fromMap(map)).toList();
  }

  Future<GeneratedPhoto?> getPhotoById(int id) async {
    final db = await database;
    final maps = await db.query(
      'generated_photos',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return GeneratedPhoto.fromMap(maps.first);
  }

  // ==================== Styles ====================

  Future<void> insertStyle(StyleModel style) async {
    final db = await database;
    await db.insert('styles', style.toMap());
  }

  Future<void> updateStyle(StyleModel style) async {
    final db = await database;
    await db.update(
      'styles',
      style.toMap(),
      where: 'id = ?',
      whereArgs: [style.id],
    );
  }

  Future<List<StyleModel>> getAllStyles() async {
    final db = await database;
    final maps = await db.query('styles', orderBy: 'sort_order ASC');

    return maps.map((map) => StyleModel.fromMap(map)).toList();
  }

  Future<List<StyleModel>> getStylesByCategory(StyleCategory category) async {
    final db = await database;
    final maps = await db.query(
      'styles',
      where: 'category = ?',
      whereArgs: [category.toString().split('.').last],
      orderBy: 'sort_order ASC',
    );

    return maps.map((map) => StyleModel.fromMap(map)).toList();
  }

  Future<List<StyleModel>> getFreeStyles() async {
    final db = await database;
    final maps = await db.query(
      'styles',
      where: 'is_premium = ?',
      whereArgs: [0],
      orderBy: 'sort_order ASC',
    );

    return maps.map((map) => StyleModel.fromMap(map)).toList();
  }

  Future<StyleModel?> getStyleById(String id) async {
    final db = await database;
    final maps = await db.query(
      'styles',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return StyleModel.fromMap(maps.first);
  }

  // ==================== Generation Jobs ====================

  Future<void> insertGenerationJob(dynamic job) async {
    final db = await database;
    await db.insert('generation_jobs', (job as GenerationJob).toMap());
  }

  Future<void> updateGenerationJob(dynamic job) async {
    final db = await database;
    await db.update(
      'generation_jobs',
      (job as GenerationJob).toMap(),
      where: 'id = ?',
      whereArgs: [job.id],
    );
  }

  Future<GenerationJob?> getJobById(String id) async {
    final db = await database;
    final maps = await db.query(
      'generation_jobs',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return GenerationJob.fromMap(maps.first);
  }

  Future<List<GenerationJob>> getJobsForPhoto(int photoId) async {
    final db = await database;
    final maps = await db.query(
      'generation_jobs',
      where: 'photo_id = ?',
      whereArgs: [photoId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) => GenerationJob.fromMap(map)).toList();
  }

  // ==================== Stats ====================

  Future<Map<String, dynamic>> getStats() async {
    final db = await database;

    // Total generations
    final totalCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM generated_photos'),
    );

    // Completed generations
    final completedCount = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM generated_photos WHERE status = ?',
        ['completed'],
      ),
    );

    // Favorite style (most used)
    final favoriteStyleResult = await db.rawQuery('''
      SELECT style_id, COUNT(*) as count
      FROM generated_photos
      WHERE status = 'completed'
      GROUP BY style_id
      ORDER BY count DESC
      LIMIT 1
    ''');

    String? favoriteStyleId;
    if (favoriteStyleResult.isNotEmpty) {
      favoriteStyleId = favoriteStyleResult.first['style_id'] as String?;
    }

    return {
      'total_generations': totalCount ?? 0,
      'completed_generations': completedCount ?? 0,
      'favorite_style_id': favoriteStyleId,
    };
  }

  /// Clear all data
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('generation_jobs');
    await db.delete('generated_photos');
    // Keep styles
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
