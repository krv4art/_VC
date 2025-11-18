import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/chat_message.dart';
import '../../constants/app_dimensions.dart';
import '../common/app_spacer.dart';

/// Message bubble widget with animations and markdown support
class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool isTyping;
  final String? displayText;

  const ChatMessageBubble({
    Key? key,
    required this.message,
    this.isTyping = false,
    this.displayText,
  }) : super(key: key);

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Slide from left for AI, from right for user
    final slideOffset = widget.message.isUser
        ? const Offset(0.1, 0.2)
        : const Offset(-0.1, 0.2);

    _slideAnimation = Tween<Offset>(
      begin: slideOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space16,
            vertical: AppDimensions.space8,
          ),
          child: Row(
            mainAxisAlignment: widget.message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!widget.message.isUser) ...[
                _buildAvatar(),
                AppSpacer.h12(),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: widget.message.isUser
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    _buildMessageBubble(),
                    if (!widget.message.isUser && !widget.isTyping) ...[
                      AppSpacer.v8(),
                      _buildActionButtons(),
                    ],
                  ],
                ),
              ),
              if (widget.message.isUser) ...[
                AppSpacer.h12(),
                _buildAvatar(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: widget.message.isUser
            ? const Color(0xFF6B4EFF)
            : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: Icon(
        widget.message.isUser ? Icons.person : Icons.smart_toy,
        size: 18,
        color: widget.message.isUser ? Colors.white : Colors.grey[700],
      ),
    );
  }

  Widget _buildMessageBubble() {
    final displayContent = widget.displayText ?? widget.message.content;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: widget.message.isUser
            ? const Color(0xFF6B4EFF)
            : Colors.grey[200],
        borderRadius: _getBorderRadius(),
      ),
      child: widget.message.isUser
          ? Text(
              displayContent,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            )
          : MarkdownBody(
              data: displayContent,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 15,
                ),
                code: TextStyle(
                  backgroundColor: Colors.grey[300],
                  color: Colors.grey[900],
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
    );
  }

  BorderRadius _getBorderRadius() {
    // 24px on 3 corners, 4px on tail corner
    if (widget.message.isUser) {
      return const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.radius24),
        topRight: Radius.circular(AppDimensions.radius24),
        bottomLeft: Radius.circular(AppDimensions.radius24),
        bottomRight: Radius.circular(AppDimensions.radius4),
      );
    } else {
      return const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.radius24),
        topRight: Radius.circular(AppDimensions.radius24),
        bottomLeft: Radius.circular(AppDimensions.radius4),
        bottomRight: Radius.circular(AppDimensions.radius24),
      );
    }
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: Icons.copy,
          label: 'Copy',
          onTap: _copyMessage,
        ),
        AppSpacer.h8(),
        _buildActionButton(
          icon: Icons.share,
          label: 'Share',
          onTap: _shareMessage,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space8,
          vertical: AppDimensions.space4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Colors.grey[600],
            ),
            AppSpacer.h4(),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyMessage() {
    Clipboard.setData(ClipboardData(text: widget.message.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareMessage() {
    Share.share(widget.message.content);
  }
}
