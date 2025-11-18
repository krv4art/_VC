import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/gemini_service.dart';
import '../services/typing_animation_service.dart';
import '../providers/locale_provider.dart';
import '../providers/identification_provider.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_theme.dart';
import '../config/fish_prompts_manager.dart';
import '../models/chat_message.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/animated/animated_fish_avatar.dart';

class ChatScreen extends StatefulWidget {
  final int? fishId;

  const ChatScreen({super.key, this.fishId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late final GeminiService _geminiService;
  late final TypingAnimationService _typingAnimationService;

  bool _isLoading = false;
  String? _fishContext;
  AvatarAnimationState _avatarState = AvatarAnimationState.idle;

  late AnimationController _inputAnimationController;
  final Map<int, AnimationController> _messageAnimationControllers = {};
  static const int _maxCachedAnimationControllers = 50;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimationControllers();
    _loadFishContext();
  }

  void _initializeServices() {
    _typingAnimationService = TypingAnimationService();
    _geminiService = GeminiService(
      useProxy: true,
      supabaseClient: Supabase.instance.client,
    );
  }

  void _initializeAnimationControllers() {
    _inputAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inputAnimationController.forward();
    });
  }

  void _loadFishContext() {
    if (widget.fishId != null) {
      final identificationProvider = context.read<IdentificationProvider>();
      final fish = identificationProvider.getIdentificationById(widget.fishId!);
      if (fish != null) {
        _fishContext = '''
Fish: ${fish.fishName} (${fish.scientificName})
Habitat: ${fish.habitat}
Diet: ${fish.diet}
''';
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputAnimationController.dispose();
    for (final controller in _messageAnimationControllers.values) {
      controller.dispose();
    }
    _messageAnimationControllers.clear();
    _typingAnimationService.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        dialogueId: 0,
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
      _avatarState = AvatarAnimationState.thinking;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final localeProvider = context.read<LocaleProvider>();
      final response = await _geminiService.sendMessageWithHistory(
        message,
        languageCode: localeProvider.locale.languageCode,
        fishContext: _fishContext,
      );

      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            dialogueId: 0,
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
          _avatarState = AvatarAnimationState.speaking;
        });

        // Start typing animation for bot response
        final messageIndex = _messages.length - 1;
        _startTypingAnimation(messageIndex, response);
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            dialogueId: 0,
            text: 'Error: ${e.toString()}',
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
          _avatarState = AvatarAnimationState.idle;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Start typing animation for a message
  void _startTypingAnimation(int messageIndex, String fullText) {
    if (!mounted) return;

    bool animationCompleted = false;

    _typingAnimationService.startTyping(messageIndex, fullText, () {
      if (!mounted) return;

      // Always update UI to show typing progress
      if (mounted) {
        setState(() {});
      }

      // Check if animation is complete (only once)
      if (!_typingAnimationService.isTypingInProgress(messageIndex) &&
          !animationCompleted) {
        animationCompleted = true;
        // Animation complete - set avatar to idle
        setState(() {
          _avatarState = AvatarAnimationState.idle;
        });
      }
    });
  }

  AnimationController _getOrCreateMessageAnimation(int index) {
    if (!_messageAnimationControllers.containsKey(index)) {
      _messageAnimationControllers[index] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _messageAnimationControllers[index]!.forward();
      _cleanupOldAnimations();
    }
    return _messageAnimationControllers[index]!;
  }

  void _cleanupOldAnimations() {
    if (_messageAnimationControllers.length > _maxCachedAnimationControllers) {
      final keysToRemove = _messageAnimationControllers.keys.toList().sublist(
        0,
        _messageAnimationControllers.length - 50,
      );
      for (final key in keysToRemove) {
        _messageAnimationControllers[key]?.dispose();
        _messageAnimationControllers.remove(key);
      }
    }
  }

  Future<void> _copyToClipboard(String text) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  Future<void> _shareMessage(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      debugPrint('Error sharing message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _messages.clear();
                _geminiService.clearHistory();
                _avatarState = AvatarAnimationState.idle;
              });
            },
            tooltip: l10n.chatClear,
          ),
        ],
      ),
      body: Column(
        children: [
          // Sample questions chip list
          if (_messages.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.chatSampleQuestions, style: AppTheme.h4),
                  const SizedBox(height: AppDimensions.space8),
                  Wrap(
                    spacing: AppDimensions.space8,
                    runSpacing: AppDimensions.space8,
                    children: FishPromptsManager.getSampleQuestions(
                      localeProvider.locale.languageCode,
                    ).map((question) {
                      return ActionChip(
                        label: Text(question),
                        onPressed: () {
                          _messageController.text = question;
                          _sendMessage();
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Messages list
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Text(
                      l10n.chatHint,
                      style: AppTheme.body.copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.all(AppDimensions.space16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      // Инвертируем индекс для reverse ListView
                      final reversedIndex = _messages.length - 1 - index;
                      final message = _messages[reversedIndex];
                      final animation = _getOrCreateMessageAnimation(reversedIndex);
                      final displayText = _typingAnimationService.getDisplayText(
                        reversedIndex,
                        message.text,
                      );
                      final isTyping = _typingAnimationService.isTypingInProgress(reversedIndex);

                      return ChatMessageBubble(
                        message: message,
                        displayText: displayText,
                        messageIndex: reversedIndex,
                        animation: animation,
                        avatarState: _avatarState,
                        isTyping: isTyping,
                        fullText: message.text,
                        onCopy: _copyToClipboard,
                        onShare: _shareMessage,
                      );
                    },
                  ),
          ),

          // Loading indicator when bot is thinking
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                right: 4,
                top: 4,
                bottom: 4,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: AnimatedFishAvatar(
                      size: 40,
                      state: AvatarAnimationState.thinking,
                      primaryColor: Theme.of(context).primaryColor,
                      secondaryColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

          // Input field
          ChatInputField(
            controller: _messageController,
            animation: _inputAnimationController,
            onSubmitted: (_) => _sendMessage(),
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
