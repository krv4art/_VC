import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/scan_result.dart';
import '../models/chat_message.dart';
import '../models/ai_bot_settings.dart';

class LocalDataService {
  static final LocalDataService instance = LocalDataService._internal();

  // Stream controller для уведомления об изменениях в диалогах
  static final _dialogueChangeController = StreamController<void>.broadcast();
  static Stream<void> get dialogueChanges => _dialogueChangeController.stream;

  factory LocalDataService() {
    return instance;
  }

  LocalDataService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'skin_analysis.db');

    return await openDatabase(
      path,
      version: 8,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE scan_results(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagePath TEXT,
            images TEXT,
            analysisResult TEXT,
            scanDate TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE dialogues(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            created_at TEXT,
            scan_result_id INTEGER,
            FOREIGN KEY (scan_result_id) REFERENCES scan_results (id) ON DELETE SET NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            dialogueId INTEGER,
            text TEXT,
            isUser INTEGER,
            timestamp TEXT,
            scanImagePath TEXT,
            FOREIGN KEY (dialogueId) REFERENCES dialogues (id) ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE user_settings(
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE ai_bot_settings(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            avatar_path TEXT NOT NULL,
            description TEXT NOT NULL,
            is_custom_prompt_enabled INTEGER NOT NULL DEFAULT 0,
            custom_prompt TEXT NOT NULL DEFAULT '',
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Drop old table and recreate with new schema
          await db.execute('DROP TABLE IF EXISTS scan_results');
          await db.execute('''
            CREATE TABLE scan_results(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              imagePath TEXT,
              analysisResult TEXT,
              scanDate TEXT
            )
          ''');
        }
        if (oldVersion < 3) {
          // Add user_settings table
          await db.execute('''
            CREATE TABLE user_settings(
              key TEXT PRIMARY KEY,
              value TEXT
            )
          ''');
        }
        if (oldVersion < 4) {
          // Add scan_result_id column to dialogues table
          await db.execute('''
            ALTER TABLE dialogues ADD COLUMN scan_result_id INTEGER
          ''');
        }
        if (oldVersion < 5) {
          // Add scanImagePath column to messages table
          await db.execute('''
            ALTER TABLE messages ADD COLUMN scanImagePath TEXT
          ''');
        }
        if (oldVersion < 6) {
          // Add ai_bot_settings table
          await db.execute('''
            CREATE TABLE ai_bot_settings(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              avatar_path TEXT NOT NULL,
              description TEXT NOT NULL,
              created_at TEXT NOT NULL,
              updated_at TEXT NOT NULL
            )
          ''');
        }
        if (oldVersion < 7) {
          // Add new columns to ai_bot_settings table for custom prompt
          await db.execute('''
            ALTER TABLE ai_bot_settings ADD COLUMN is_custom_prompt_enabled INTEGER NOT NULL DEFAULT 0
          ''');
          await db.execute('''
            ALTER TABLE ai_bot_settings ADD COLUMN custom_prompt TEXT NOT NULL DEFAULT ''
          ''');
        }
        if (oldVersion < 8) {
          // Add images column to scan_results table for multi-photo support
          await db.execute('''
            ALTER TABLE scan_results ADD COLUMN images TEXT
          ''');
        }
      },
    );
  }

  // Scan Results operations
  Future<int> insertScanResult(ScanResult result) async {
    final db = await database;
    return await db.insert('scan_results', result.toMap());
  }

  /// Найти существующий ScanResult по imagePath или создать новый
  Future<int> findOrCreateScanResult(ScanResult result) async {
    final db = await database;

    // Для нового формата (с несколькими изображениями) всегда создаем новую запись
    if (result.images.isNotEmpty) {
      debugPrint('=== DB DEBUG: Creating new multi-image scan result ===');
      return await db.insert('scan_results', result.toMap());
    }

    // Для старого формата (обратная совместимость) ищем по imagePath
    final imagePath = result.firstImagePath;
    if (imagePath == null || imagePath.isEmpty) {
      debugPrint('=== DB DEBUG: Creating new scan result (no images) ===');
      return await db.insert('scan_results', result.toMap());
    }

    final existing = await db.query(
      'scan_results',
      where: 'imagePath = ?',
      whereArgs: [imagePath],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      // Запись уже существует, возвращаем её ID
      final existingId = existing.first['id'] as int;
      debugPrint(
        '=== DB DEBUG: Found existing scan result with ID: $existingId ===',
      );
      return existingId;
    }

    // Записи нет, создаем новую
    debugPrint('=== DB DEBUG: Creating new scan result ===');
    return await db.insert('scan_results', result.toMap());
  }

  Future<List<ScanResult>> getAllScanResults() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_results',
      orderBy: 'scanDate DESC',
    );
    return List.generate(maps.length, (i) => ScanResult.fromMap(maps[i]));
  }

  Future<int> deleteScanResult(int id) async {
    final db = await database;
    return await db.delete('scan_results', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearAllData({
    bool clearScans = true,
    bool clearChats = true,
    bool clearPersonalData = true,
  }) async {
    debugPrint('LocalDataService.clearAllData() вызван');
    debugPrint(
      'clearScans: $clearScans, clearChats: $clearChats, clearPersonalData: $clearPersonalData',
    );
    final db = await database;

    // Если ничего не выбрано, не делаем ничего
    if (!clearScans && !clearChats && !clearPersonalData) {
      debugPrint('Нечего очищать - все флаги false');
      return;
    }

    // Очистка сканирований
    if (clearScans) {
      final scanResultsCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM scan_results'),
          ) ??
          0;
      debugPrint('Очистка сканирований: $scanResultsCount записей');
      await db.delete('scan_results');
    }

    // Очистка чатов (диалоги и сообщения)
    if (clearChats) {
      final dialoguesCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM dialogues'),
          ) ??
          0;
      final messagesCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM messages'),
          ) ??
          0;
      debugPrint(
        'Очистка чатов: dialogues=$dialoguesCount, messages=$messagesCount',
      );
      await db.delete('dialogues');
      await db.delete('messages');
    }

    // Очистка личных данных (настройки пользователя)
    if (clearPersonalData) {
      final settingsCount =
          Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM user_settings'),
          ) ??
          0;
      debugPrint('Очистка личных данных: $settingsCount записей');
      await db.delete('user_settings');
    }

    debugPrint('База данных очищена');
  }

  // Dialogue operations
  Future<int> createDialogue(String title, {int? scanResultId}) async {
    final db = await database;
    final result = await db.insert('dialogues', {
      'title': title,
      'created_at': DateTime.now().toIso8601String(),
      'scan_result_id': scanResultId,
    });

    // Уведомляем об изменении в диалогах
    _dialogueChangeController.add(null);

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllDialogues() async {
    final db = await database;
    return await db.query('dialogues', orderBy: 'created_at DESC');
  }

  Future<int> deleteDialogue(int id) async {
    final db = await database;
    final result = await db.delete(
      'dialogues',
      where: 'id = ?',
      whereArgs: [id],
    );

    // Уведомляем об изменении в диалогах
    _dialogueChangeController.add(null);

    return result;
  }

  // Message operations
  Future<int> insertMessage(ChatMessage message) async {
    final db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<void> deleteMessage(int messageId) async {
    final db = await database;
    await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
  }

  Future<List<ChatMessage>> getMessagesForDialogue(int dialogueId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'dialogueId = ?',
      whereArgs: [dialogueId],
      orderBy: 'timestamp ASC',
    );
    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }

  /// Получить последнее сообщение пользователя для диалога
  Future<String?> getLastUserMessageForDialogue(int dialogueId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'dialogueId = ? AND isUser = 1',
      whereArgs: [dialogueId],
      orderBy: 'timestamp DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return maps.first['text'] as String?;
  }

  // User settings operations
  Future<bool> getDisclaimerStatus() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: ['disclaimer_dismissed'],
    );
    if (maps.isNotEmpty) {
      return maps.first['value'] == 'true';
    }
    return false; // Default value if not found
  }

  Future<void> setDisclaimerStatus(bool dismissed) async {
    final db = await database;
    await db.insert('user_settings', {
      'key': 'disclaimer_dismissed',
      'value': dismissed.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Проверить, отправлял ли пользователь уже запрос на создание кастомной темы
  Future<bool> getCustomThemeRequestSent() async {
    debugPrint('📝 getCustomThemeRequestSent() called');
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: ['custom_theme_request_sent'],
    );
    debugPrint('📝 Database query result: ${maps.length} records found');
    if (maps.isNotEmpty) {
      final result = maps.first['value'] == 'true';
      debugPrint('📝 getCustomThemeRequestSent() result: $result');
      return result;
    }
    debugPrint('📝 getCustomThemeRequestSent() result: false (default)');
    return false; // Default value if not found
  }

  /// Установить флаг о том, что пользователь отправил запрос на создание кастомной темы
  Future<void> setCustomThemeRequestSent(bool sent) async {
    debugPrint('📝 setCustomThemeRequestSent($sent) called');
    final db = await database;
    await db.insert('user_settings', {
      'key': 'custom_theme_request_sent',
      'value': sent.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    debugPrint('📝 Flag saved to database');
  }

  /// Получить ScanResult, связанный с диалогом
  Future<ScanResult?> getScanResultForDialogue(int dialogueId) async {
    final db = await database;

    // Получаем dialogue
    final dialogues = await db.query(
      'dialogues',
      where: 'id = ?',
      whereArgs: [dialogueId],
    );

    if (dialogues.isEmpty) return null;

    final scanResultId = dialogues.first['scan_result_id'] as int?;
    if (scanResultId == null) return null;

    // Получаем scan result
    final scanResults = await db.query(
      'scan_results',
      where: 'id = ?',
      whereArgs: [scanResultId],
    );

    if (scanResults.isEmpty) return null;

    return ScanResult.fromMap(scanResults.first);
  }

  // AI Bot Settings operations
  Future<AiBotSettings?> getAiBotSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ai_bot_settings',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (maps.isEmpty) {
      return null;
    }

    return AiBotSettings.fromMap(maps.first);
  }

  Future<int> saveAiBotSettings(AiBotSettings settings) async {
    final db = await database;
    return await db.insert('ai_bot_settings', settings.toMap());
  }

  Future<int> updateAiBotSettings(AiBotSettings settings) async {
    final db = await database;
    if (settings.id == null) {
      // Если нет ID, создаем новую запись
      return await saveAiBotSettings(settings);
    }

    return await db.update(
      'ai_bot_settings',
      settings.toMap(),
      where: 'id = ?',
      whereArgs: [settings.id],
    );
  }

  Future<int> deleteAiBotSettings(int id) async {
    final db = await database;
    return await db.delete('ai_bot_settings', where: 'id = ?', whereArgs: [id]);
  }

  // Метод для получения или создания настроек по умолчанию
  Future<AiBotSettings> getOrCreateAiBotSettings() async {
    AiBotSettings? settings = await getAiBotSettings();

    if (settings == null) {
      // Создаем настройки по умолчанию
      settings = AiBotSettings.defaultSettings();
      final id = await saveAiBotSettings(settings);
      settings = settings.copyWith(id: id.toString());
    }

    return settings;
  }

  // Метод для освобождения ресурсов
  void dispose() {
    _dialogueChangeController.close();
  }
}
