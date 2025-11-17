import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../models/chat_message.dart';
import '../../constants/app_dimensions.dart';
import '../animated/animated_card.dart';
import '../animated/animated_plant_avatar.dart';

/// Callback for copy action
typedef OnCopyCallback = Future<void> Function(String text);

/// Callback for share action
typedef OnShareCallback = Future<void> Function(String text);

/// A reusable widget that displays a chat message bubble with animations
class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final String displayText;
  final int messageIndex;
  final Animation<double> animation;
  final AvatarAnimationState avatarState;
  final bool isTyping;
  final OnCopyCallback? onCopy;
  final OnShareCallback? onShare;
  final String? fullText;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.displayText,
    required this.messageIndex,
    required this.animation,
    required this.avatarState,
    this.isTyping = false,
    this.onCopy,
    this.onShare,
    this.fullText,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: widget.message.isUser
                  ? const Offset(0.1, 0.2)
                  : const Offset(-0.1, 0.2),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: widget.animation,
                curve: Curves.easeOutCubic,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: widget.message.isUser ? 0 : AppDimensions.space8,
                right: widget.message.isUser ? AppDimensions.space8 : 0,
                bottom: AppDimensions.space8,
              ),
              child: Column(
                crossAxisAlignment: widget.message.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: widget.message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!widget.message.isUser)
                        _buildBotAvatar(context)
                      else
                        const SizedBox.shrink(),
                      if (!widget.message.isUser)
                        const SizedBox(width: AppDimensions.space12),
                      Flexible(child: _buildMessageBubble(context)),
                      if (widget.message.isUser) ...[
                        const SizedBox(width: AppDimensions.space8),
                        _buildUserAvatar(context),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build bot avatar with animation
  Widget _buildBotAvatar(BuildContext context) {
    // Use animation only for typing messages, otherwise use idle state
    final effectiveState = widget.isTyping
        ? widget.avatarState
        : AvatarAnimationState.idle;

    return SizedBox(
      width: 40,
      height: 40,
      child: AnimatedPlantAvatar(
        size: 40,
        state: effectiveState,
        primaryColor: Theme.of(context).primaryColor,
        secondaryColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  /// Build user avatar with icon
  Widget _buildUserAvatar(BuildContext context) {
    return CircleAvatar(
      backgroundColor:
          Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      radius: 20,
      child: Icon(
        Icons.person,
        size: 20,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }

  /// Build the message bubble card
  Widget _buildMessageBubble(BuildContext context) {
    return AnimatedCard(
      elevation: 2,
      backgroundColor: widget.message.isUser
          ? Theme.of(context).primaryColor
          : Theme.of(context).cardColor,
      borderRadius: widget.message.isUser
          ? const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(4),
            )
          : const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
              bottomLeft: Radius.circular(4),
            ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectionArea(
              child: MarkdownBody(
                data: widget.displayText,
                styleSheet: _buildMarkdownStyleSheet(context),
              ),
            ),
            if (!widget.message.isUser && widget.messageIndex > 0) ...[
              // Reserve space for action buttons
              if (widget.displayText.isNotEmpty)
                _buildActionButtons(context)
              else
                const SizedBox(height: 28),
            ],
          ],
        ),
      ),
    );
  }

  /// Build markdown style sheet for message text
  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    return MarkdownStyleSheet(
      p: TextStyle(
        color: widget.message.isUser
            ? Colors.white.withOpacity(0.95)
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 15,
      ),
      strong: TextStyle(
        color: widget.message.isUser
            ? Colors.white
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: widget.message.isUser
            ? Colors.white.withOpacity(0.95)
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 15,
        fontStyle: FontStyle.italic,
      ),
      code: TextStyle(
        color: widget.message.isUser
            ? Colors.white.withOpacity(0.9)
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 14,
        backgroundColor: widget.message.isUser
            ? Colors.black.withOpacity(0.2)
            : Colors.black12,
      ),
      listBullet: TextStyle(
        color: widget.message.isUser
            ? Colors.white.withOpacity(0.95)
            : Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 15,
      ),
    );
  }

  /// Build action buttons for bot messages
  Widget _buildActionButtons(BuildContext context) {
    final textToCopy = widget.fullText ?? widget.displayText;
    const double containerSize = 28.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Copy button
        GestureDetector(
          onTap: widget.onCopy != null ? () => widget.onCopy!(textToCopy) : null,
          child: Container(
            width: containerSize,
            height: containerSize,
            alignment: Alignment.center,
            child: Icon(
              Icons.copy,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.space8),
        // Share button
        GestureDetector(
          onTap: widget.onShare != null ? () => widget.onShare!(textToCopy) : null,
          child: Container(
            width: containerSize,
            height: containerSize,
            alignment: Alignment.center,
            child: Icon(
              Icons.share,
              size: 16,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
            ),
          ),
        ),
      ],
    );
  }
}
