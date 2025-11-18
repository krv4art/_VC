import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../models/dialogue.dart';
import '../services/chat_service.dart';

/// Provider for managing chat state
class ChatProvider with ChangeNotifier {
  final ChatService _chatService;

  Dialogue? _currentDialogue;
  List<ChatMessage> _messages = [];
  List<Dialogue> _dialogues = [];
  bool _isSending = false;

  ChatProvider(this._chatService) {
    _loadDialogues();
  }

  // Getters
  Dialogue? get currentDialogue => _currentDialogue;
  List<ChatMessage> get messages => _messages;
  List<Dialogue> get dialogues => _dialogues;
  bool get isSending => _isSending;

  /// Load all dialogues
  Future<void> _loadDialogues() async {
    try {
      _dialogues = await _chatService.getAllDialogues();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dialogues: $e');
    }
  }

  /// Create new dialogue
  Future<Dialogue> createDialogue({String? title, String? resultId}) async {
    try {
      final dialogue = await _chatService.createDialogue(
        title: title,
        resultId: resultId,
      );
      _dialogues.insert(0, dialogue);
      _currentDialogue = dialogue;
      _messages = [];
      notifyListeners();
      return dialogue;
    } catch (e) {
      debugPrint('Error creating dialogue: $e');
      rethrow;
    }
  }

  /// Load dialogue
  Future<void> loadDialogue(String dialogueId) async {
    try {
      final dialogue = _dialogues.firstWhere((d) => d.id == dialogueId);
      _currentDialogue = dialogue;
      _messages = await _chatService.getMessages(dialogueId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dialogue: $e');
    }
  }

  /// Send message
  Future<void> sendMessage(String content, {String languageCode = 'en'}) async {
    if (_currentDialogue == null) {
      await createDialogue();
    }

    _isSending = true;
    notifyListeners();

    try {
      // Add user message immediately
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        dialogueId: _currentDialogue!.id,
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
      );
      _messages.add(userMessage);
      notifyListeners();

      // Get AI response
      final aiMessage = await _chatService.sendMessage(
        dialogueId: _currentDialogue!.id,
        content: content,
        languageCode: languageCode,
      );

      // Add AI message
      _messages.add(aiMessage);
      _isSending = false;

      // Reload dialogues to update last message
      await _loadDialogues();
      notifyListeners();
    } catch (e) {
      debugPrint('Error sending message: $e');
      _isSending = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Delete dialogue
  Future<void> deleteDialogue(String dialogueId) async {
    try {
      await _chatService.deleteDialogue(dialogueId);
      _dialogues.removeWhere((d) => d.id == dialogueId);

      if (_currentDialogue?.id == dialogueId) {
        _currentDialogue = null;
        _messages = [];
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting dialogue: $e');
    }
  }

  /// Clear current dialogue
  void clearCurrentDialogue() {
    _currentDialogue = null;
    _messages = [];
    _chatService.clearAIHistory();
    notifyListeners();
  }

  /// Refresh dialogues
  Future<void> refreshDialogues() async {
    await _loadDialogues();
  }
}
