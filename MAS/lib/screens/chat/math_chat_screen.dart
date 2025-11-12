import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../providers/chat_provider.dart';
import '../../providers/subscription_provider.dart';
import '../../providers/user_state.dart';
import '../../services/gemini_service.dart';
import '../../services/usage_tracking_service.dart';
import '../../services/typing_animation_service.dart';
import '../../theme/app_theme.dart';
import '../../models/chat_message.dart';

/// Math AI Chat Screen
///
/// Full-featured chat interface with:
/// - Message history persistence
/// - Typing animations
/// - Usage limits for free users
/// - Error handling
/// - AI conversation with context
class MathChatScreen extends StatefulWidget {
  final int? dialogueId;

  const MathChatScreen({
    super.key,
    this.dialogueId,
  });

  @override
  State<MathChatScreen> createState() => _MathChatScreenState();
}

class _MathChatScreenState extends State<MathChatScreen>
    with TickerProviderStateMixin {
  late final GeminiService _geminiService;
  late final TypingAnimationService _typingAnimationService;
  late final TextEditingController _textController;
  late final ScrollController _scrollController;
  late final UsageTrackingService _usageService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadInitialData();
  }

  void _initializeServices() {
    _textController = TextEditingController();
    _scrollController = ScrollController();
    _typingAnimationService = TypingAnimationService();
    _usageService = UsageTrackingService();

    try {
      _geminiService = GeminiService(
        supabaseClient: Supabase.instance.client,
      );
    } catch (e) {
      debugPrint('❌ Error initializing Gemini service: $e');
    }
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatProvider = context.read<ChatProvider>();

      // Reset state before loading new data
      chatProvider.reset();

      if (widget.dialogueId != null && widget.dialogueId! > 0) {
        // Load existing dialogue
        await chatProvider.initializeDialogue(widget.dialogueId!);
      } else {
        // New chat - add welcome message
        await _addWelcomeMessage();
      }
    });
  }

  Future<void> _addWelcomeMessage() async {
    final chatProvider = context.read<ChatProvider>();

    chatProvider.setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      const welcomeMessage = '''Hi! I'm your math AI assistant. 👋

I can help you with:
• Solving math problems step-by-step
• Explaining mathematical concepts
• Understanding formulas and equations
• Homework help and practice problems

Just ask me any math question!''';

      if (mounted) {
        chatProvider.addBotMessage(welcomeMessage);
        chatProvider.setLoading(false);
        _scrollToBottom();

        // Start typing animation
        final messageIndex = chatProvider.messages.length - 1;
        _startTypingAnimation(messageIndex, welcomeMessage);
      }
    } catch (e) {
      if (mounted) {
        chatProvider.setLoading(false);
        debugPrint('❌ Error loading welcome message: $e');
      }
    }
  }

  Future<void> _handleMessageSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    final chatProvider = context.read<ChatProvider>();
    final subscriptionProvider = context.read<SubscriptionProvider>();

    // Check if can send message
    if (chatProvider.isAnyOperationInProgress) {
      chatProvider.setError('Please wait before sending another message');
      return;
    }

    // Check usage limits for free users
    if (!subscriptionProvider.isPremium) {
      final canSend = await _usageService.canUserSendMessage();

      if (!canSend) {
        if (!mounted) return;

        // Show upgrade dialog
        final shouldUpgrade = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.lock, color: AppTheme.primaryPurple),
                SizedBox(width: 12),
                Text('Daily Message Limit Reached'),
              ],
            ),
            content: const Text(
              'You\'ve reached your daily limit of free messages. Upgrade to Premium for unlimited conversations!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                ),
                child: const Text('Upgrade to Premium'),
              ),
            ],
          ),
        );

        if (shouldUpgrade == true && mounted) {
          // TODO: Navigate to paywall screen when implemented
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Premium subscription coming soon!'),
            ),
          );
        }

        return; // Block message sending
      }
    }

    _textController.clear();

    // Create dialogue if first message
    if (chatProvider.currentDialogueId == null) {
      await chatProvider.ensureDialogueExists(text);
    }

    // Add user message
    chatProvider.addUserMessage(text);
    chatProvider.setSendingMessage(true);
    chatProvider.setLoading(true);

    // Save user message to DB
    if (chatProvider.messages.isNotEmpty) {
      final userMessage = chatProvider.messages.last;
      await chatProvider.saveMessage(userMessage);
    }

    _scrollToBottom();

    try {
      // Build user context
      final userState = context.read<UserState>();
      final userContext = _buildUserContext(userState);

      // Send message to Gemini
      final response = await _geminiService.sendMessageWithHistory(
        text,
        languageCode: 'en', // TODO: Get from LocaleProvider
        userContext: userContext,
      );

      if (mounted) {
        chatProvider.addBotMessage(response);
        chatProvider.setLoading(false);
        chatProvider.setSendingMessage(false);

        // Save bot response to DB
        if (chatProvider.messages.isNotEmpty) {
          final botMessage = chatProvider.messages.last;
          await chatProvider.saveMessage(botMessage);
        }

        // Increment message count for free users
        if (!subscriptionProvider.isPremium) {
          await _usageService.incrementMessagesCount();
        }

        // Start typing animation
        final messageIndex = chatProvider.messages.length - 1;
        _startTypingAnimation(messageIndex, response);

        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        chatProvider.setError('Failed to get response: ${e.toString()}');
        chatProvider.addBotMessage('Sorry, I encountered an error. Please try again.');
        chatProvider.setSendingMessage(false);
        chatProvider.setLoading(false);
        _scrollToBottom();
      }
    }
  }

  String _buildUserContext(UserState userState) {
    final parts = <String>[];

    if (userState.name != null && userState.name!.isNotEmpty) {
      parts.add('Student name: ${userState.name}');
    }

    if (parts.isEmpty) return '';

    return 'User context:\n${parts.join('\n')}';
  }

  void _startTypingAnimation(int messageIndex, String fullText) {
    if (!mounted) return;

    debugPrint('⌨️ Starting typing animation for message $messageIndex');

    _typingAnimationService.startTyping(messageIndex, fullText, () {
      if (!mounted) return;
      setState(() {});

      // Check if animation complete
      if (!_typingAnimationService.isTypingInProgress(messageIndex)) {
        final chatProvider = context.read<ChatProvider>();
        if (messageIndex < chatProvider.messages.length) {
          chatProvider.updateMessageText(messageIndex, fullText);
        }
        debugPrint('✅ Typing animation complete');
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: _buildAppBar(),
          body: Column(
            children: [
              // Message list
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length +
                      (chatProvider.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator
                    if (chatProvider.isLoading &&
                        index == chatProvider.messages.length) {
                      return _buildLoadingIndicator();
                    }

                    final message = chatProvider.messages[index];
                    final displayText = _typingAnimationService.getDisplayText(
                      index,
                      message.text,
                    );

                    return _MessageBubble(
                      text: displayText,
                      isUser: message.isUser,
                      onCopy: () => _copyToClipboard(message.text),
                    );
                  },
                ),
              ),

              // Usage indicator for free users
              Consumer<SubscriptionProvider>(
                builder: (context, subProvider, _) {
                  if (subProvider.isPremium) {
                    return const SizedBox.shrink();
                  }
                  return _buildUsageBanner();
                },
              ),

              // Input field
              _buildInputField(chatProvider),
            ],
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Math AI Chat'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('About Math AI Chat'),
                content: const Text(
                  'Chat with an AI assistant specialized in mathematics. '
                  'Ask questions, get explanations, and solve problems together!',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppTheme.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageBanner() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _usageService.getTodayUsageStats(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();

        final stats = snapshot.data!;
        final messagesUsed = stats['messages_used'] as int;
        final messagesLimit = stats['messages_limit'] as int;
        final remaining = messagesLimit - messagesUsed;

        if (remaining <= 0) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.orange.shade50,
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                '$remaining free messages remaining today',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to paywall
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Premium subscription coming soon!'),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 28),
                ),
                child: const Text(
                  'Upgrade',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField(ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Ask a math question...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleMessageSubmitted(_textController.text),
              enabled: !chatProvider.isAnyOperationInProgress,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(
              chatProvider.isSendingMessage ? Icons.hourglass_empty : Icons.send,
              color: chatProvider.isAnyOperationInProgress
                  ? Colors.grey
                  : AppTheme.primaryPurple,
            ),
            onPressed: chatProvider.isAnyOperationInProgress
                ? null
                : () => _handleMessageSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _typingAnimationService.dispose();
    super.dispose();
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final VoidCallback onCopy;

  const _MessageBubble({
    required this.text,
    required this.isUser,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: onCopy,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isUser ? AppTheme.primaryPurple : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
