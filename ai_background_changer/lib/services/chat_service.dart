import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message.dart';
import '../models/dialogue.dart';
import 'local_data_service.dart';
import 'gemini_service.dart';

/// Service for managing chat interactions
class ChatService {
  final GeminiService _geminiService;
  final Uuid _uuid = const Uuid();

  ChatService(this._geminiService);

  /// Create a new dialogue
  Future<Dialogue> createDialogue({
    String? title,
    String? resultId,
  }) async {
    final dialogue = Dialogue(
      id: _uuid.v4(),
      title: title ?? 'New Conversation',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      resultId: resultId,
    );

    await LocalDataService.saveDialogue(dialogue);
    return dialogue;
  }

  /// Send message in a dialogue
  Future<ChatMessage> sendMessage({
    required String dialogueId,
    required String content,
    String languageCode = 'en',
  }) async {
    // Create user message
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      dialogueId: dialogueId,
      role: 'user',
      content: content,
      timestamp: DateTime.now(),
    );

    // Save user message
    await LocalDataService.saveMessage(userMessage);

    // Get AI response
    final responseText = await _geminiService.sendMessageWithHistory(
      content,
      languageCode: languageCode,
      systemPrompt: _getSystemPrompt(),
    );

    // Create AI message
    final aiMessage = ChatMessage(
      id: _uuid.v4(),
      dialogueId: dialogueId,
      role: 'model',
      content: responseText,
      timestamp: DateTime.now(),
    );

    // Save AI message
    await LocalDataService.saveMessage(aiMessage);

    // Update dialogue
    final dialogue = await _getDialogue(dialogueId);
    if (dialogue != null) {
      final messageCount = await _getMessageCount(dialogueId);
      final updatedDialogue = dialogue.copyWith(
        updatedAt: DateTime.now(),
        messageCount: messageCount,
        lastMessage: content.length > 50
            ? '${content.substring(0, 50)}...'
            : content,
      );
      await LocalDataService.updateDialogue(updatedDialogue);
    }

    return aiMessage;
  }

  /// Get messages for a dialogue
  Future<List<ChatMessage>> getMessages(String dialogueId) async {
    return await LocalDataService.getMessagesByDialogue(dialogueId);
  }

  /// Get all dialogues
  Future<List<Dialogue>> getAllDialogues() async {
    return await LocalDataService.getAllDialogues();
  }

  /// Delete dialogue
  Future<void> deleteDialogue(String dialogueId) async {
    await LocalDataService.deleteMessagesByDialogue(dialogueId);
    await LocalDataService.deleteDialogue(dialogueId);
    _geminiService.clearHistory();
  }

  /// Clear chat history in AI service
  void clearAIHistory() {
    _geminiService.clearHistory();
  }

  Future<Dialogue?> _getDialogue(String id) async {
    final dialogues = await LocalDataService.getAllDialogues();
    try {
      return dialogues.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<int> _getMessageCount(String dialogueId) async {
    final messages = await LocalDataService.getMessagesByDialogue(dialogueId);
    return messages.length;
  }

  String _getSystemPrompt() {
    return '''You are a helpful AI assistant specialized in photo editing and background replacement.
You can help users with:
- Choosing the right background style for their photos
- Providing creative suggestions for background themes
- Explaining how different backgrounds affect the mood and feel of photos
- General advice about photo composition and aesthetics

Be friendly, creative, and helpful. Provide specific, actionable suggestions.''';
  }
}
