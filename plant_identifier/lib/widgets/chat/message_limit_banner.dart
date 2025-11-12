import 'package:flutter/material.dart';

/// Message limit banner for free users
/// For plant identifier, this is simplified as we don't have usage tracking yet
class MessageLimitBanner extends StatelessWidget {
  final VoidCallback onUpgradePressed;

  const MessageLimitBanner({
    super.key,
    required this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    // For now, don't show the banner as we allow unlimited messages
    // This can be implemented later with usage tracking
    return const SizedBox.shrink();
  }
}
