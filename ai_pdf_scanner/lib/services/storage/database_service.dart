import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/pdf_document.dart';
import '../../models/annotation.dart';

/// SQLite database service for local storage
/// Handles all database operations for the app
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'pdf_scanner.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE documents (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        file_path TEXT NOT NULL,
        thumbnail_path TEXT,
        document_type TEXT NOT NULL,
        page_count INTEGER DEFAULT 1,
        file_size INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        is_favorite INTEGER DEFAULT 0,
        tags TEXT,
        ai_metadata TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE annotations (
        id TEXT PRIMARY KEY,
        document_id TEXT NOT NULL,
        page_number INTEGER NOT NULL,
        type TEXT NOT NULL,
        content TEXT,
        position TEXT NOT NULL,
        color TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_analyses (
        id TEXT PRIMARY KEY,
        document_id TEXT NOT NULL,
        analysis_type TEXT NOT NULL,
        result TEXT NOT NULL,
        confidence REAL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE app_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute(
        'CREATE INDEX idx_documents_created_at ON documents(created_at DESC)');
    await db.execute(
        'CREATE INDEX idx_documents_type ON documents(document_type)');
    await db.execute(
        'CREATE INDEX idx_annotations_document ON annotations(document_id)');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future schema migrations
  }

  // ==================== DOCUMENT OPERATIONS ====================

  /// Insert a new document
  Future<void> insertDocument(PdfDocument document) async {
    final db = await database;
    await db.insert(
      'documents',
      document.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all documents
  Future<List<PdfDocument>> getAllDocuments() async {
    final db = await database;
    final maps = await db.query(
      'documents',
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PdfDocument.fromMap(map)).toList();
  }

  /// Get document by ID
  Future<PdfDocument?> getDocumentById(String id) async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return PdfDocument.fromMap(maps.first);
  }

  /// Get documents by type
  Future<List<PdfDocument>> getDocumentsByType(DocumentType type) async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'document_type = ?',
      whereArgs: [type.toString()],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PdfDocument.fromMap(map)).toList();
  }

  /// Get favorite documents
  Future<List<PdfDocument>> getFavoriteDocuments() async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'is_favorite = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PdfDocument.fromMap(map)).toList();
  }

  /// Search documents by title
  Future<List<PdfDocument>> searchDocuments(String query) async {
    final db = await database;
    final maps = await db.query(
      'documents',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => PdfDocument.fromMap(map)).toList();
  }

  /// Update document
  Future<void> updateDocument(PdfDocument document) async {
    final db = await database;
    await db.update(
      'documents',
      document.toMap(),
      where: 'id = ?',
      whereArgs: [document.id],
    );
  }

  /// Delete document
  Future<void> deleteDocument(String id) async {
    final db = await database;
    await db.delete(
      'documents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(String id) async {
    final db = await database;
    final doc = await getDocumentById(id);
    if (doc != null) {
      await db.update(
        'documents',
        {'is_favorite': doc.isFavorite ? 0 : 1, 'updated_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // ==================== ANNOTATION OPERATIONS ====================

  /// Insert annotation
  Future<void> insertAnnotation(Annotation annotation) async {
    final db = await database;
    await db.insert(
      'annotations',
      annotation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get annotations for a document
  Future<List<Annotation>> getAnnotationsForDocument(String documentId) async {
    final db = await database;
    final maps = await db.query(
      'annotations',
      where: 'document_id = ?',
      whereArgs: [documentId],
      orderBy: 'page_number ASC, created_at ASC',
    );
    return maps.map((map) => Annotation.fromMap(map)).toList();
  }

  /// Get annotations for a specific page
  Future<List<Annotation>> getAnnotationsForPage(
      String documentId, int pageNumber) async {
    final db = await database;
    final maps = await db.query(
      'annotations',
      where: 'document_id = ? AND page_number = ?',
      whereArgs: [documentId, pageNumber],
      orderBy: 'created_at ASC',
    );
    return maps.map((map) => Annotation.fromMap(map)).toList();
  }

  /// Delete annotation
  Future<void> deleteAnnotation(String id) async {
    final db = await database;
    await db.delete(
      'annotations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all annotations for a document
  Future<void> deleteAnnotationsForDocument(String documentId) async {
    final db = await database;
    await db.delete(
      'annotations',
      where: 'document_id = ?',
      whereArgs: [documentId],
    );
  }

  // ==================== SETTINGS OPERATIONS ====================

  /// Get setting value
  Future<String?> getSetting(String key) async {
    final db = await database;
    final maps = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  /// Set setting value
  Future<void> setSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'app_settings',
      {
        'key': key,
        'value': value,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ==================== UTILITY ====================

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'pdf_scanner.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
