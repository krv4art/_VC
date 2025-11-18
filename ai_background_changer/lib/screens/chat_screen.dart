import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';
import '../services/typing_animation_service.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_field.dart';
import '../constants/app_dimensions.dart';

class ChatScreen extends StatefulWidget {
  final String? dialogueId;

  const ChatScreen({Key? key, this.dialogueId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TypingAnimationService _typingService = TypingAnimationService();

  // Track which message is currently typing
  String? _typingMessageId;
  String? _typingDisplayText;

  @override
  void initState() {
    super.initState();
    _loadDialogue();
  }

  Future<void> _loadDialogue() async {
    final chatProvider = context.read<ChatProvider>();
    if (widget.dialogueId != null) {
      await chatProvider.loadDialogue(widget.dialogueId!);
    } else {
      await chatProvider.createDialogue(title: 'New Chat');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Avatar state indicator
          Consumer<ChatProvider>(
            builder: (context, provider, _) {
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.space8),
                child: _buildAvatarState(provider.isSending),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, _) {
                if (provider.messages.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.space16,
                  ),
                  itemCount: provider.messages.length,
                  itemBuilder: (context, index) {
                    final message = provider.messages[index];
                    return _buildMessage(message, provider.isSending && index == provider.messages.length - 1);
                  },
                );
              },
            ),
          ),
          Consumer<ChatProvider>(
            builder: (context, provider, _) {
              return ChatInputField(
                controller: _messageController,
                onSend: _sendMessage,
                isEnabled: !provider.isSending,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarState(bool isSending) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isSending ? const Color(0xFF6B4EFF) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.smart_toy,
        size: 20,
        color: isSending ? Colors.white : Colors.grey[600],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF6B4EFF).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 50,
                color: Color(0xFF6B4EFF),
              ),
            ),
            const SizedBox(height: AppDimensions.space24),
            const Text(
              'Ask me anything!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.space8),
            Text(
              'I can help you with background ideas,\nphoto editing tips, and creative suggestions!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space32),
            _buildSuggestionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    final suggestions = [
      'Nature backgrounds',
      'Studio lighting',
      'Creative ideas',
      'Color palettes',
    ];

    return Wrap(
      spacing: AppDimensions.space8,
      runSpacing: AppDimensions.space8,
      alignment: WrapAlignment.center,
      children: suggestions.map((suggestion) {
        return ActionChip(
          label: Text(suggestion),
          onPressed: () {
            _messageController.text = suggestion;
            _sendMessage();
          },
          backgroundColor: const Color(0xFF6B4EFF).withOpacity(0.1),
          labelStyle: const TextStyle(
            color: Color(0xFF6B4EFF),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessage(ChatMessage message, bool shouldAnimate) {
    // Start typing animation for AI messages
    if (!message.isUser && shouldAnimate && _typingMessageId != message.id) {
      _typingMessageId = message.id;
      _typingDisplayText = '';

      _typingService.animateTyping(message.id, message.content).listen(
        (displayText) {
          if (mounted) {
            setState(() {
              _typingDisplayText = displayText;
            });
            _scrollToBottom();
          }
        },
        onDone: () {
          if (mounted) {
            setState(() {
              _typingMessageId = null;
              _typingDisplayText = null;
            });
          }
        },
      );
    }

    final isTyping = _typingMessageId == message.id;
    final displayText = isTyping ? _typingDisplayText : null;

    return ChatMessageBubble(
      message: message,
      isTyping: isTyping,
      displayText: displayText,
    );
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();

    try {
      await context.read<ChatProvider>().sendMessage(message);
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
