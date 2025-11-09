import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../models/messenger_type.dart';

/// Database service for Unseen app
/// Manages conversations and messages storage
class UnseenDatabaseService {
  static final UnseenDatabaseService _instance = UnseenDatabaseService._internal();
  static Database? _database;

  factory UnseenDatabaseService() => _instance;

  UnseenDatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'unseen.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create conversations table
    await db.execute('''
      CREATE TABLE conversations (
        id TEXT PRIMARY KEY,
        contact_name TEXT NOT NULL,
        avatar TEXT,
        messenger INTEGER NOT NULL,
        last_message_time INTEGER NOT NULL,
        last_message_text TEXT,
        unread_count INTEGER DEFAULT 0
      )
    ''');

    // Create messages table
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        conversation_id TEXT NOT NULL,
        text TEXT,
        media_url TEXT,
        timestamp INTEGER NOT NULL,
        sender_id TEXT NOT NULL,
        sender_name TEXT NOT NULL,
        messenger INTEGER NOT NULL,
        is_deleted INTEGER DEFAULT 0,
        is_read INTEGER DEFAULT 0,
        FOREIGN KEY (conversation_id) REFERENCES conversations(id)
      )
    ''');

    // Create indexes
    await db.execute(
      'CREATE INDEX idx_messages_conversation ON messages(conversation_id)',
    );
    await db.execute(
      'CREATE INDEX idx_messages_timestamp ON messages(timestamp DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_conversations_time ON conversations(last_message_time DESC)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
  }

  // ==================== CONVERSATIONS ====================

  /// Get all conversations ordered by last message time
  Future<List<Conversation>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      orderBy: 'last_message_time DESC',
    );

    return maps.map((map) => Conversation.fromMap(map)).toList();
  }

  /// Get conversation by ID
  Future<Conversation?> getConversation(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Conversation.fromMap(maps.first);
  }

  /// Insert or update conversation
  Future<void> upsertConversation(Conversation conversation) async {
    final db = await database;
    await db.insert(
      'conversations',
      conversation.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Delete conversation and all its messages
  Future<void> deleteConversation(String id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('messages', where: 'conversation_id = ?', whereArgs: [id]);
      await txn.delete('conversations', where: 'id = ?', whereArgs: [id]);
    });
  }

  /// Update conversation's unread count
  Future<void> updateUnreadCount(String conversationId, int count) async {
    final db = await database;
    await db.update(
      'conversations',
      {'unread_count': count},
      where: 'id = ?',
      whereArgs: [conversationId],
    );
  }

  /// Mark all messages in conversation as read
  Future<void> markConversationAsRead(String conversationId) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.update(
        'messages',
        {'is_read': 1},
        where: 'conversation_id = ? AND is_read = 0',
        whereArgs: [conversationId],
      );
      await txn.update(
        'conversations',
        {'unread_count': 0},
        where: 'id = ?',
        whereArgs: [conversationId],
      );
    });
  }

  // ==================== MESSAGES ====================

  /// Get all messages for a conversation
  Future<List<Message>> getMessages(String conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => Message.fromMap(map)).toList();
  }

  /// Get recent messages (limit)
  Future<List<Message>> getRecentMessages(String conversationId, int limit) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) => Message.fromMap(map)).toList();
  }

  /// Insert new message
  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update conversation's last message
    await _updateConversationLastMessage(message);
  }

  /// Update conversation with last message info
  Future<void> _updateConversationLastMessage(Message message) async {
    final db = await database;

    // Get current conversation
    final conversation = await getConversation(message.conversationId);

    if (conversation != null) {
      // Update with new message
      final updatedConversation = conversation.copyWith(
        lastMessageTime: message.timestamp,
        lastMessageText: message.text,
        unreadCount: conversation.unreadCount + 1,
      );

      await upsertConversation(updatedConversation);
    } else {
      // Create new conversation
      final newConversation = Conversation(
        id: message.conversationId,
        contactName: message.senderName,
        messenger: message.messenger,
        lastMessageTime: message.timestamp,
        lastMessageText: message.text,
        unreadCount: 1,
      );

      await upsertConversation(newConversation);
    }
  }

  /// Get deleted messages for a conversation
  Future<List<Message>> getDeletedMessages(String conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversation_id = ? AND is_deleted = 1',
      whereArgs: [conversationId],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) => Message.fromMap(map)).toList();
  }

  /// Mark message as deleted
  Future<void> markMessageAsDeleted(String messageId) async {
    final db = await database;
    await db.update(
      'messages',
      {'is_deleted': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  /// Get total messages count
  Future<int> getTotalMessagesCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM messages');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get messages count by messenger
  Future<Map<MessengerType, int>> getMessagesCountByMessenger() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT messenger, COUNT(*) as count
      FROM messages
      GROUP BY messenger
    ''');

    final Map<MessengerType, int> counts = {};
    for (final row in result) {
      final messengerIndex = row['messenger'] as int;
      final count = row['count'] as int;
      counts[MessengerType.values[messengerIndex]] = count;
    }

    return counts;
  }

  /// Delete all data (for testing or user data wipe)
  Future<void> deleteAllData() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('messages');
      await txn.delete('conversations');
    });
  }

  /// Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
