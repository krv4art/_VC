import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';
import '../../l10n/app_localizations.dart';

/// Callback when message is submitted
typedef OnMessageSubmitted = Future<void> Function(String text);

/// A reusable animated input field widget for chat
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Animation<double> animation;
  final OnMessageSubmitted onSubmitted;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.animation,
    required this.onSubmitted,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: widget.animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: FadeTransition(
            opacity: widget.animation,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.space16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.chatPlaceholder,
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withOpacity(0.6),
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radius24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.space16,
                          vertical: AppDimensions.space12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => widget.onSubmitted(widget.controller.text),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
                  IconButton.filled(
                    onPressed: widget.isLoading
                        ? null
                        : () => widget.onSubmitted(widget.controller.text),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
