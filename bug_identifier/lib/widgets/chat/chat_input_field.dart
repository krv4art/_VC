import 'package:flutter/material.dart';
import '../../theme/theme_extensions_v2.dart';
import '../../constants/app_dimensions.dart';
import '../../widgets/common/app_spacer.dart';
import '../../l10n/app_localizations.dart';

/// Callback when message is submitted
typedef OnMessageSubmitted = Future<void> Function(String text);

/// A reusable animated input field widget for chat
class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Animation<double> animation;
  final OnMessageSubmitted onSubmitted;

  const ChatInputField({
    Key? key,
    required this.controller,
    required this.animation,
    required this.onSubmitted,
  }) : super(key: key);

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
          position:
              Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .animate(
                    CurvedAnimation(
                      parent: widget.animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
          child: FadeTransition(
            opacity: widget.animation,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    border: Border(
                      top: BorderSide(
                        color: context.colors.onSecondary.withValues(
                          alpha: 0.1,
                        ),
                        width: 1,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.space4,
                    vertical: AppDimensions.space4,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          style: TextStyle(
                            color: context.colors.onBackground,
                            fontSize: AppDimensions.iconSmall,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.writeAMessage,
                            hintStyle: TextStyle(
                              color: context.colors.onSecondary.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.space8,
                              vertical: AppDimensions.space4,
                            ),
                            filled: false,
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: widget.onSubmitted,
                        ),
                      ),
                      AppSpacer.h4(),
                      IconButton(
                        onPressed: () =>
                            widget.onSubmitted(widget.controller.text),
                        icon: Icon(
                          Icons.send_rounded,
                          color: context.colors.primary,
                          size: AppDimensions.iconMedium,
                        ),
                        padding: EdgeInsets.all(AppDimensions.space8),
                        constraints: const BoxConstraints(),
                        splashRadius: AppDimensions.iconMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
