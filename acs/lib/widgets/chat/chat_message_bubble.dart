import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/chat_message.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';
import '../../widgets/animated/animated_card.dart';
import '../../widgets/animated/animated_ai_avatar.dart';
import '../../providers/user_state.dart';

/// Callback for copy action
typedef OnCopyCallback = Future<void> Function(String text);

/// Callback for share action
typedef OnShareCallback = Future<void> Function(String text);

/// A reusable widget that displays a chat message bubble with animations
class ChatMessageBubble extends StatelessWidget {
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
    Key? key,
    required this.message,
    required this.displayText,
    required this.messageIndex,
    required this.animation,
    required this.avatarState,
    this.isTyping = false,
    this.onCopy,
    this.onShare,
    this.fullText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: message.isUser
                      ? const Offset(0.1, 0.2)
                      : const Offset(-0.1, 0.2),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: Padding(
              padding: EdgeInsets.only(
                left: message.isUser ? 0 : AppDimensions.space8,
                right: message.isUser ? AppDimensions.space8 : 0,
                bottom: AppDimensions.space8,
              ),
              child: Column(
                crossAxisAlignment: message.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: message.isUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!message.isUser)
                        _buildBotAvatar(context)
                      else
                        const SizedBox.shrink(),
                      if (!message.isUser) AppSpacer.h12(),
                      Flexible(child: _buildMessageBubble(context)),
                      if (message.isUser) ...[
                        AppSpacer.h8(),
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
    final effectiveState = isTyping ? avatarState : AvatarAnimationState.idle;

    return GestureDetector(
      onTap: () {
        context.push('/ai-bot-settings');
      },
      child: SizedBox(
        width: AppDimensions.iconMedium * 2,
        height: AppDimensions.iconMedium * 2,
        child: AnimatedAiAvatar(
          size: AppDimensions.iconMedium * 2,
          state: effectiveState,
          colors: context.colors.currentColors,
        ),
      ),
    );
  }

  /// Build user avatar with photo
  Widget _buildUserAvatar(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        ImageProvider? backgroundImage;
        if (userState.photoBase64 != null) {
          try {
            backgroundImage = MemoryImage(base64Decode(userState.photoBase64!));
          } catch (e) {
            backgroundImage = null;
          }
        }

        return GestureDetector(
          onTap: () {
            context.push('/profile');
          },
          child: CircleAvatar(
            backgroundColor: context.colors.onSecondary.withValues(alpha: 0.3),
            radius: AppDimensions.iconMedium,
            backgroundImage: backgroundImage,
            child: backgroundImage == null
                ? Icon(
                    Icons.person,
                    size: AppDimensions.iconMedium,
                    color: context.colors.onSecondary,
                  )
                : null,
          ),
        );
      },
    );
  }

  /// Build the message bubble card
  Widget _buildMessageBubble(BuildContext context) {
    return AnimatedCard(
      elevation: 2,
      backgroundColor: message.isUser
          ? context.colors.primary
          : context.colors.surface,
      borderRadius: message.isUser
          ? BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radius24),
              topRight: Radius.circular(AppDimensions.radius24),
              bottomLeft: Radius.circular(AppDimensions.radius24),
              bottomRight: Radius.circular(AppDimensions.space4),
            )
          : BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radius24),
              topRight: Radius.circular(AppDimensions.radius24),
              bottomRight: Radius.circular(AppDimensions.radius24),
              bottomLeft: Radius.circular(AppDimensions.space4),
            ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectionArea(
              child: MarkdownBody(
                data: displayText,
                styleSheet: _buildMarkdownStyleSheet(context),
              ),
            ),
            if (!message.isUser && messageIndex > 0) ...[
              // Reserve space for action buttons to prevent layout shift
              if (displayText.isNotEmpty)
                _buildActionButtons(context)
              else
                SizedBox(height: 28), // Same height as action buttons
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
        color: message.isUser
            ? Colors.white.withValues(alpha: 0.95)
            : context.colors.onSurface,
        fontSize: AppDimensions.iconSmall,
      ),
      strong: TextStyle(
        color: message.isUser ? Colors.white : context.colors.onSurface,
        fontSize: AppDimensions.iconSmall,
        fontWeight: FontWeight.bold,
      ),
      em: TextStyle(
        color: message.isUser
            ? Colors.white.withValues(alpha: 0.95)
            : context.colors.onSurface,
        fontSize: AppDimensions.iconSmall,
        fontStyle: FontStyle.italic,
      ),
      code: TextStyle(
        color: message.isUser
            ? Colors.white.withValues(alpha: 0.9)
            : context.colors.onSurface,
        fontSize:
            AppDimensions.space8 + AppDimensions.space4 + AppDimensions.space4,
        backgroundColor: message.isUser
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.black12,
      ),
      listBullet: TextStyle(
        color: message.isUser
            ? Colors.white.withValues(alpha: 0.95)
            : context.colors.onSurface,
        fontSize: AppDimensions.iconSmall,
      ),
    );
  }

  /// Build action buttons for bot messages
  Widget _buildActionButtons(BuildContext context) {
    final textToCopy = fullText ?? displayText;
    const double containerSize = 28.0; // Уменьшенный размер контейнера

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Кнопка "Копировать"
        GestureDetector(
          onTap: onCopy != null ? () => onCopy!(textToCopy) : null,
          child: Container(
            width: containerSize,
            height: containerSize,
            alignment: Alignment.center,

            child: Icon(
              Icons.copy,
              size: AppDimensions.iconSmall,
              color: context.colors.onSecondary.withValues(alpha: 0.6),
            ),
          ),
        ),
        // Кнопка "Поделиться"
        GestureDetector(
          onTap: onShare != null ? () => onShare!(textToCopy) : null,
          child: Container(
            width: containerSize,
            height: containerSize,
            alignment: Alignment.center,

            child: Icon(
              Icons.share,
              size: AppDimensions.iconSmall,
              color: context.colors.onSecondary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
