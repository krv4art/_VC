import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/chat_provider.dart';
import '../providers/ai_bot_provider.dart';
import '../providers/subscription_provider.dart';
import '../providers/user_state.dart';
import '../services/gemini_service.dart';
import '../services/typing_animation_service.dart';
import '../services/greeting_service.dart';
import '../services/usage_tracking_service.dart';
import '../services/chat_context_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/theme_extensions_v2.dart';
import '../widgets/bottom_navigation_wrapper.dart';
import '../widgets/scan_analysis_card.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_field.dart';
import '../widgets/chat/disclaimer_banner.dart';
import '../widgets/chat/message_limit_banner.dart';
import '../widgets/animated/animated_ai_avatar.dart';
import '../constants/app_dimensions.dart';
import '../widgets/common/app_spacer.dart';
import '../config/prompts_manager.dart';
import '../services/local_data_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatAIScreen extends StatefulWidget {
  final int? dialogueId;
  final String? scanContext;
  final String? scanImagePath;
  final int? scanResultId;

  const ChatAIScreen({
    super.key,
    this.dialogueId,
    this.scanContext,
    this.scanImagePath,
    this.scanResultId,
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

      // Сбрасываем состояние перед загрузкой новых данных
      chatProvider.reset();

      // Проверяем статус баннера из базы данных
      final disclaimerDismissed = await LocalDataService.instance
          .getDisclaimerStatus();
      if (disclaimerDismissed) {
        chatProvider.dismissDisclaimer();
      }

      if (widget.dialogueId != null && widget.dialogueId! > 0) {
        chatProvider.initializeDialogue(widget.dialogueId!);
      } else if (widget.scanResultId != null) {
        chatProvider.loadScanResultById(widget.scanResultId!);
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
      if (widget.scanResultId != null) {
        // For scan results, use PromptsManager context message
        welcomeMessage =
            PromptsManager.getScanContextMessage(languageCode) ??
            l10n.iCanSeeYourScanResultsFeelFreeToAskMeAnyQuestionsAboutTheIngredientsSafetyConcernsOrRecommendations;
      } else {
        // Use random localized greeting
        welcomeMessage = await GreetingService.getRandomGreeting(l10n);
        debugPrint('📢 Greeting: $welcomeMessage');
      }

      if (mounted) {
        chatProvider.addBotMessage(welcomeMessage);
        chatProvider.setLoading(false);
        chatProvider.setAvatarState(AvatarAnimationState.speaking);
        debugPrint('🎭 Avatar state set to: speaking');
        _scrollToBottom();

        // Запускаем анимацию печати для приветствия
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

  Future<void> _handleMessageSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    final l10n = AppLocalizations.of(context)!;
    final userState = context.read<UserState>();

    if (!chatProvider.operationsNotifier.canSendMessage()) {
      chatProvider.setError('Please wait before sending another message');
      return;
    }

    // Проверка лимита сообщений для бесплатных пользователей
    final subscriptionProvider = context.read<SubscriptionProvider>();
    final usageService = UsageTrackingService();

    if (!subscriptionProvider.isPremium) {
      final canSend = await usageService.canUserSendMessage();

      if (!canSend) {
        if (!mounted) return;

        // Показываем диалог с предложением оформить подписку
        final shouldUpgrade = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.lock, color: context.colors.warning),
                const SizedBox(width: 12),
                Text(l10n.dailyMessageLimitReached),
              ],
            ),
            content: Text(l10n.dailyMessageLimitReachedMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.success,
                ),
                child: Text(l10n.upgradeToPremium),
              ),
            ],
          ),
        );

        if (shouldUpgrade == true && mounted) {
          context.push('/modern-paywall');
        }

        return; // Блокируем отправку сообщения
      }
    }

    _textController.clear();

    // Создаем диалог при первом сообщении
    if (chatProvider.currentDialogueId == null) {
      await chatProvider.ensureDialogueExists(
        text,
        scanResultId: widget.scanResultId,
      );
    }

    chatProvider.addUserMessage(text);
    chatProvider.setSendingMessage(true);
    chatProvider.setLoading(true);
    chatProvider.setAvatarState(AvatarAnimationState.thinking);

    // Сохраняем сообщение пользователя в БД
    if (chatProvider.messages.isNotEmpty) {
      final userMessage = chatProvider.messages.last;
      await chatProvider.saveMessage(userMessage);
    }

    try {
      final userProfileContext = ChatContextService.generateUserProfileContext(
        userState,
      );
      final aiBotProvider = context.read<AiBotProvider>();

      final response = await _geminiService.sendMessageWithHistory(
        text,
        languageCode: l10n.localeName,
        userProfileContext: userProfileContext,
        customPrompt: aiBotProvider.customPrompt,
        isCustomPromptEnabled: aiBotProvider.isCustomPromptEnabled,
      );
      if (mounted) {
        chatProvider.addBotMessage(response);
        chatProvider.setLoading(false);
        chatProvider.setAvatarState(AvatarAnimationState.speaking);
        chatProvider.recordMessageSent();

        // Сохраняем ответ бота в БД
        if (chatProvider.messages.isNotEmpty) {
          final botMessage = chatProvider.messages.last;
          await chatProvider.saveMessage(botMessage);
        }

        // Увеличиваем счетчик сообщений только для бесплатных пользователей
        if (!subscriptionProvider.isPremium) {
          await usageService.incrementMessagesCount();
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
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            _handleBackNavigation();
          },
          child: BottomNavigationWrapper(
            currentIndex: 2,
            child: Scaffold(
              backgroundColor: context.colors.background,
              appBar: _buildAppBar(context, chatProvider),
              body: Column(
                children: [
                  if (chatProvider.linkedScanResult != null &&
                      chatProvider.linkedAnalysisResult != null)
                    ScanAnalysisCard(
                      imagePath: chatProvider.linkedScanResult!.imagePath,
                      analysisResult: chatProvider.linkedAnalysisResult!,
                      onTap: () {
                        context.push(
                          '/analysis',
                          extra: {
                            'result': chatProvider.linkedAnalysisResult,
                            'imagePath':
                                chatProvider.linkedScanResult!.imagePath,
                          },
                        );
                      },
                    ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.only(
                        left: 4,
                        right: 4,
                        top: 4,
                        bottom: 16,
                      ),
                      itemCount: chatProvider.messages.length,
                      itemBuilder: (context, index) {
                        // Инвертируем индекс для reverse ListView
                        final reversedIndex =
                            chatProvider.messages.length - 1 - index;
                        final message = chatProvider.messages[reversedIndex];
                        final animation = _getOrCreateMessageAnimation(
                          reversedIndex,
                        );
                        final displayText = _typingAnimationService
                            .getDisplayText(reversedIndex, message.text);
                        // Check if this message is currently being typed
                        final isTyping = _typingAnimationService.isTypingInProgress(reversedIndex);

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
                  // Индикатор загрузки когда бот думает
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
                          // Анимированный аватар в состоянии thinking
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: AnimatedAiAvatar(
                              size: 40,
                              state: AvatarAnimationState.thinking,
                              colors: context.colors.currentColors,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Индикатор лимита сообщений
                  Consumer<SubscriptionProvider>(
                    builder: (context, subProvider, _) {
                      if (subProvider.isPremium) {
                        return const SizedBox.shrink();
                      }
                      return MessageLimitBanner(
                        onUpgradePressed: () => context.push('/modern-paywall'),
                      );
                    },
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
                    onSubmitted: _handleMessageSubmitted,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, ChatProvider chatProvider) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: context.colors.isDark
          ? context.colors.surface
          : context.colors.primaryDark,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: _handleBackNavigation,
      ),
      title: Consumer<AiBotProvider>(
        builder: (context, botProvider, child) {
          return GestureDetector(
            onTap: () => context.push('/ai-bot-settings'),
            child: Row(
              children: [
                SizedBox(
                  width: AppDimensions.space40,
                  height: AppDimensions.space40,
                  child: AnimatedAiAvatar(
                    size: AppDimensions.space40,
                    state: chatProvider.avatarState,
                    colors: context.colors.currentColors,
                  ),
                ),
                AppSpacer.h12(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      botProvider.botName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize:
                            AppDimensions.iconSmall + AppDimensions.space4,
                      ),
                    ),
                    Text(
                      l10n.online,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: AppDimensions.radius12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleBackNavigation() {
    if (widget.dialogueId != null) {
      context.go('/dialogues');
    } else {
      context.go('/home');
    }
  }

  Future<void> _copyToClipboard(String text) async {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.copiedToClipboard)));
    return Future.value();
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
