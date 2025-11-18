import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

/// Animated chat input field
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEnabled;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.onSend,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    widget.controller.addListener(_onTextChanged);
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 40,
                    maxHeight: 120,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: widget.controller,
                    enabled: widget.isEnabled,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Ask for background ideas...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.space16,
                        vertical: AppDimensions.space12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              _buildSendButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    final canSend = _hasText && widget.isEnabled;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: canSend ? const Color(0xFF6B4EFF) : Colors.grey[300],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: canSend ? _handleSend : null,
        icon: const Icon(Icons.send),
        color: Colors.white,
        iconSize: 20,
        padding: EdgeInsets.zero,
      ),
    );
  }

  void _handleSend() {
    if (widget.controller.text.trim().isEmpty) return;
    widget.onSend();
  }
}
