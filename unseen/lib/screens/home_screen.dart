import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/messages_provider.dart';
import '../models/conversation.dart';
import 'conversation_screen.dart';
import 'settings_screen.dart';

/// Home screen showing list of conversations
class HomeScreen extends Scaffold {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unseen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<MessagesProvider>(
        builder: (context, messagesProvider, child) {
          if (messagesProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = messagesProvider.conversations;

          if (conversations.isEmpty) {
            return _buildEmptyState(context, messagesProvider);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await messagesProvider.loadConversations();
            },
            child: ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                return _ConversationListItem(
                  conversation: conversations[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(
                          conversation: conversations[index],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: Consumer<MessagesProvider>(
        builder: (context, messagesProvider, child) {
          return FloatingActionButton.extended(
            onPressed: () async {
              final hasPermission = await messagesProvider.hasPermission();
              if (!hasPermission) {
                await messagesProvider.requestPermission();
              } else {
                if (messagesProvider.isListening) {
                  await messagesProvider.stopListening();
                } else {
                  await messagesProvider.resumeListening();
                }
              }
            },
            icon: Icon(
              messagesProvider.isListening ? Icons.pause : Icons.play_arrow,
            ),
            label: Text(
              messagesProvider.isListening ? 'Listening' : 'Start Listening',
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, MessagesProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.inbox_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start listening to notifications to see messages',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final hasPermission = await provider.hasPermission();
              if (!hasPermission) {
                await provider.requestPermission();
              } else {
                await provider.resumeListening();
              }
            },
            icon: const Icon(Icons.notifications_active),
            label: const Text('Enable Notification Access'),
          ),
        ],
      ),
    );
  }
}

/// List item for a conversation
class _ConversationListItem extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback onTap;

  const _ConversationListItem({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getMessengerColor(),
        child: conversation.avatar != null
            ? Image.network(conversation.avatar!)
            : Text(
                conversation.contactName[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
      ),
      title: Text(
        conversation.contactName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        conversation.lastMessageText ?? 'No messages',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            conversation.timeAgo,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${conversation.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  Color _getMessengerColor() {
    final colorHex = conversation.messenger.colorHex;
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }
}
