import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

import '../../models/math_solution.dart';
import '../../models/validation_result.dart';

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
      version: 1,
      onCreate: _createDB,
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

    return {
      'solutions': solutionsCount,
      'validations': validationsCount,
      'sessions': sessionsCount,
    };
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
