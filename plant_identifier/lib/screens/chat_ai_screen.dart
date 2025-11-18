import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/chat_provider.dart';
import '../services/gemini_service.dart';
import '../services/typing_animation_service.dart';
import '../services/greeting_service.dart';
import '../services/chat_context_service.dart';
import '../services/local_data_service.dart';
import '../services/database_service.dart';
import '../services/image_picker_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/chat/disclaimer_banner.dart';
import '../widgets/animated/animated_ai_avatar.dart';
import '../theme/app_theme.dart';
import '../config/prompts_manager.dart';

class ChatAIScreen extends StatefulWidget {
  final int? dialogueId;
  final String? plantContext;
  final String? plantImagePath;
  final String? plantResultId;

  const ChatAIScreen({
    super.key,
    this.dialogueId,
    this.plantContext,
    this.plantImagePath,
    this.plantResultId,
  });

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen>
    with TickerProviderStateMixin {
  late final GeminiService _geminiService;
  late final TypingAnimationService _typingAnimationService;
  late final TextEditingController _textController;
  late final ScrollController _scrollController;

  late AnimationController _inputAnimationController;
  late AnimationController _disclaimerAnimationController;
  final Map<int, AnimationController> _messageAnimationControllers = {};
  static const int _maxCachedAnimationControllers = 50;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeAnimationControllers();
    _loadInitialData();
  }

  final ImagePickerService _imagePickerService = ImagePickerService();

  void _initializeServices() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _typingAnimationService = TypingAnimationService();

    try {
      _geminiService = GeminiService(
        useProxy: true,
        supabaseClient: Supabase.instance.client,
      );
    } catch (e) {
      _geminiService = GeminiService(useProxy: false);
    }
  }

  void _initializeAnimationControllers() {
    _inputAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _disclaimerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inputAnimationController.forward();
      _disclaimerAnimationController.forward();
    });
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatProvider = context.read<ChatProvider>();

      // Reset state before loading new data
      chatProvider.reset();

      // Check disclaimer status from database
      final disclaimerDismissed = await LocalDataService.instance.getDisclaimerStatus();
      if (disclaimerDismissed) {
        chatProvider.dismissDisclaimer();
      }

      if (widget.dialogueId != null && widget.dialogueId! > 0) {
        chatProvider.initializeDialogue(widget.dialogueId!);
      } else if (widget.plantResultId != null) {
        chatProvider.loadPlantResultById(widget.plantResultId!);
        // Add welcome message
        _addWelcomeMessage();
      } else {
        // Add welcome message
        _addWelcomeMessage();
      }
    });
  }

  Future<void> _addWelcomeMessage() async {
    final chatProvider = context.read<ChatProvider>();
    final l10n = AppLocalizations.of(context)!;
    final languageCode = l10n.localeName;

    debugPrint('🎯 Starting welcome message loading...');
    chatProvider.setLoading(true);
    chatProvider.setAvatarState(AvatarAnimationState.thinking);

    try {
      await Future.delayed(const Duration(milliseconds: 1500));

      String welcomeMessage;
      if (widget.plantResultId != null) {
        // For plant results, use PromptsManager context message
        welcomeMessage = PromptsManager.getPlantContextMessage(languageCode) ??
            'I can see your plant identification result. Feel free to ask me any questions about the plant, care tips, or anything else!';
      } else {
        // Use random localized greeting
        welcomeMessage = await GreetingService.getRandomGreeting(languageCode);
        debugPrint('📢 Greeting: $welcomeMessage');
      }

      if (mounted) {
        chatProvider.addBotMessage(welcomeMessage);
        chatProvider.setLoading(false);
        chatProvider.setAvatarState(AvatarAnimationState.speaking);
        debugPrint('🎭 Avatar state set to: speaking');
        _scrollToBottom();

        // Start typing animation for greeting
        final messageIndex = chatProvider.messages.length - 1;
        _startTypingAnimation(messageIndex, welcomeMessage);

        debugPrint('✅ Welcome message added');
      }
    } catch (e) {
      if (mounted) {
        chatProvider.setLoading(false);
        chatProvider.setAvatarState(AvatarAnimationState.idle);
        debugPrint('❌ Error loading welcome message: $e');
      }
    }
  }

  Future<void> _handleMessageSubmitted(String text, File? image) async {
    // Validate that we have at least text or image
    if (text.trim().isEmpty && image == null) return;

    final chatProvider = context.read<ChatProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (!chatProvider.operationsNotifier.canSendMessage()) {
      chatProvider.setError('Please wait before sending another message');
      return;
    }

    _textController.clear();

    // Create dialogue on first message
    if (chatProvider.currentDialogueId == null) {
      await chatProvider.ensureDialogueExists(
        text.isEmpty ? 'Image message' : text,
        plantResultId: widget.plantResultId,
      );
    }

    // Convert image to base64 if present
    String? imageBase64;
    String? imagePath;
    if (image != null) {
      try {
        imageBase64 = await _imagePickerService.imageToBase64(image);
        imagePath = image.path;
        debugPrint('📷 Image converted to base64 for API');
      } catch (e) {
        debugPrint('❌ Error converting image to base64: $e');
        if (mounted) {
          chatProvider.setError('Failed to process image');
        }
        return;
      }
    }

    // Add user message with image path (store path, not base64)
    chatProvider.addUserMessage(
      text.isEmpty ? '' : text,
      plantImagePath: imagePath,
    );
    chatProvider.setSendingMessage(true);
    chatProvider.setLoading(true);
    chatProvider.setAvatarState(AvatarAnimationState.thinking);

    // Save user message to DB
    if (chatProvider.messages.isNotEmpty) {
      final userMessage = chatProvider.messages.last;
      await chatProvider.saveMessage(userMessage);
    }

    try {
      final response = await _geminiService.sendMessageWithHistory(
        text.isEmpty ? 'What can you tell me about this plant?' : text,
        languageCode: l10n.localeName,
        imageBase64: imageBase64,
      );

      if (mounted) {
        chatProvider.addBotMessage(response);
        chatProvider.setLoading(false);
        chatProvider.setAvatarState(AvatarAnimationState.speaking);
        chatProvider.recordMessageSent();

        // Save bot response to DB
        if (chatProvider.messages.isNotEmpty) {
          final botMessage = chatProvider.messages.last;
          await chatProvider.saveMessage(botMessage);
        }

        // Start typing animation for bot response
        final messageIndex = chatProvider.messages.length - 1;
        _startTypingAnimation(messageIndex, response);
      }
    } catch (e) {
      if (mounted) {
        chatProvider.setError('Failed to get response: ${e.toString()}');
        chatProvider.addBotMessage('Sorry, I encountered an error.');
        chatProvider.setSendingMessage(false);
        chatProvider.setAvatarState(AvatarAnimationState.idle);
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

    final chatProvider = context.read<ChatProvider>();
    debugPrint('⌨️ Starting typing animation for message $messageIndex');
    debugPrint('🎭 Current avatar state: ${chatProvider.avatarState}');

    bool animationCompleted = false;

    // Start typing animation through the service
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
        // Animation complete - update message with full text and set avatar to idle
        if (messageIndex < chatProvider.messages.length) {
          chatProvider.updateMessageText(messageIndex, fullText);
        }
        debugPrint('✅ Typing animation complete, setting avatar to idle');
        chatProvider.setAvatarState(AvatarAnimationState.idle);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        // Get theme colors
    final colors = context.colors;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBackNavigation();
          },
          child: Scaffold(
            backgroundColor: context.colors.surface,
            appBar: _buildAppBar(context, chatProvider, colors),
            body: Column(
              children: [
                // Plant result card (if available)
                if (chatProvider.linkedPlantResult != null)
                  _buildPlantResultCard(chatProvider, colors),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.only(
                      left: 4,
                      right: 4,
                      top: 4,
                      bottom: 16,
                    ),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      // Invert index for reverse ListView
                      final reversedIndex =
                          chatProvider.messages.length - 1 - index;
                      final message = chatProvider.messages[reversedIndex];
                      final animation =
                          _getOrCreateMessageAnimation(reversedIndex);
                      final displayText = _typingAnimationService
                          .getDisplayText(reversedIndex, message.text);
                      // Check if this message is currently being typed
                      final isTyping =
                          _typingAnimationService.isTypingInProgress(reversedIndex);

                      return ChatMessageBubble(
                        message: message,
                        displayText: displayText,
                        messageIndex: reversedIndex,
                        animation: animation,
                        avatarState: chatProvider.avatarState,
                        isTyping: isTyping,
                        fullText: message.text,
                        onCopy: _copyToClipboard,
                        onShare: _shareMessage,
                      );
                    },
                  ),
                ),
                // Loading indicator when bot is thinking
                if (chatProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 4,
                      top: 4,
                      bottom: 4,
                    ),
                    child: Row(
                      children: [
                        // Animated avatar in thinking state
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: AnimatedAiAvatar(
                            size: 40,
                            state: AvatarAnimationState.thinking,
                            colors: colors.currentColors,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (chatProvider.showDisclaimer)
                  DisclaimerBanner(
                    animation: _disclaimerAnimationController,
                    onDismissed: () async {
                      await chatProvider.dismissDisclaimer();
                    },
                  ),
                ChatInputField(
                  controller: _textController,
                  animation: _inputAnimationController,
                  onSubmitted: (text) => _handleMessageSubmitted(text, null),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantResultCard(ChatProvider chatProvider, ThemeColors colors) {
    final plantResult = chatProvider.linkedPlantResult!;

    return Container(
      margin: const EdgeInsets.all(AppTheme.space16),
      padding: const EdgeInsets.all(AppTheme.space16),
      decoration: BoxDecoration(
        color: context.colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
      ),
      child: Row(
        children: [
          if (plantResult.imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: Image.file(
                plantResult.imagePath!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(width: AppTheme.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plantResult.commonName ?? 'Unknown Plant',
                  style: AppTheme.h4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onPrimary,
                  ),
                ),
                if (plantResult.scientificName != null)
                  Text(
                    plantResult.scientificName!,
                    style: AppTheme.bodySmall.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colors.onPrimary.withOpacity(0.8),
                    ),
                  ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colors.onPrimary,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    ChatProvider chatProvider,
    ThemeColors colors,
  ) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: context.colors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: _handleBackNavigation,
      ),
      title: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: AnimatedAiAvatar(
              size: 40,
              state: chatProvider.avatarState,
              colors: colors.currentColors,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plant Expert',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                l10n.online ?? 'Online',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleBackNavigation() {
    if (widget.dialogueId != null) {
      context.go('/chat-history');
    } else {
      context.go('/');
    }
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.copiedToClipboard ?? 'Copied to clipboard')),
      );
    }
  }

  Future<void> _shareMessage(String text) async {
    try {
      await Share.share(text);
    } catch (e) {
      debugPrint('Error sharing message: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _inputAnimationController.dispose();
    _disclaimerAnimationController.dispose();
    for (final controller in _messageAnimationControllers.values) {
      controller.dispose();
    }
    _messageAnimationControllers.clear();
    _typingAnimationService.dispose();
    super.dispose();
  }
}
