import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/messages_provider.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import 'package:intl/intl.dart';

/// Screen for viewing messages in a conversation
class ConversationScreen extends StatefulWidget {
  final Conversation conversation;

  const ConversationScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  bool _showDeleted = false;

  @override
  void initState() {
    super.initState();

    // Load messages and mark as read
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final messagesProvider = context.read<MessagesProvider>();
      messagesProvider.loadMessages(widget.conversation.id);
      messagesProvider.markAsRead(widget.conversation.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.conversation.contactName),
            Text(
              widget.conversation.messenger.displayName,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showDeleted ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _showDeleted = !_showDeleted;
              });
            },
            tooltip: _showDeleted ? 'Hide deleted' : 'Show deleted',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deleteConversation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete conversation'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<MessagesProvider>(
        builder: (context, messagesProvider, child) {
          final messages = messagesProvider.getMessages(widget.conversation.id);

          if (messages.isEmpty) {
            return const Center(
              child: Text('No messages yet'),
            );
          }

          // Filter messages based on showDeleted
          final displayMessages = _showDeleted
              ? messages
              : messages.where((m) => !m.isDeleted).toList();

          if (displayMessages.isEmpty && _showDeleted) {
            return const Center(
              child: Text('No deleted messages'),
            );
          }

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: displayMessages.length,
            itemBuilder: (context, index) {
              final message = displayMessages[index];
              return _MessageBubble(message: message);
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteConversation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete conversation'),
        content: const Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final messagesProvider = context.read<MessagesProvider>();
      await messagesProvider.deleteConversation(widget.conversation.id);
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}

/// Message bubble widget
class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDeleted = message.isDeleted;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender name and timestamp
          Row(
            children: [
              Text(
                message.senderName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: _getMessengerColor(),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(message.timestamp),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              if (isDeleted) ...[
                const SizedBox(width: 8),
                const Icon(
                  Icons.delete_outline,
                  size: 14,
                  color: Colors.red,
                ),
                const Text(
                  'Deleted',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),

          // Message content
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDeleted
                  ? Colors.red.shade50
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: isDeleted
                  ? Border.all(color: Colors.red.shade200)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text content
                Text(
                  message.text,
                  style: TextStyle(
                    fontSize: 15,
                    color: isDeleted
                        ? Colors.red.shade900
                        : theme.textTheme.bodyLarge?.color,
                    decoration: isDeleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),

                // Media indicator
                if (message.hasMedia) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.attachment,
                        size: 16,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Media attached',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMessengerColor() {
    final colorHex = message.messenger.colorHex;
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      // Today: show time
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'Yesterday ${DateFormat('HH:mm').format(timestamp)}';
    } else if (difference.inDays < 7) {
      // This week: show day and time
      return DateFormat('EEE HH:mm').format(timestamp);
    } else {
      // Older: show date and time
      return DateFormat('dd MMM HH:mm').format(timestamp);
    }
  }
}
