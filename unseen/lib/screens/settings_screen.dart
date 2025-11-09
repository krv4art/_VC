import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/messages_provider.dart';
import '../providers/subscription_provider.dart';
import '../models/messenger_type.dart';

/// Settings screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Notification Access Section
          _Section(
            title: 'Notification Access',
            children: [
              Consumer<MessagesProvider>(
                builder: (context, messagesProvider, child) {
                  return FutureBuilder<bool>(
                    future: messagesProvider.hasPermission(),
                    builder: (context, snapshot) {
                      final hasPermission = snapshot.data ?? false;

                      return ListTile(
                        leading: Icon(
                          hasPermission
                              ? Icons.check_circle
                              : Icons.notifications_off,
                          color: hasPermission ? Colors.green : Colors.red,
                        ),
                        title: const Text('Notification Access'),
                        subtitle: Text(
                          hasPermission
                              ? 'Enabled'
                              : 'Not enabled - tap to grant access',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          await messagesProvider.requestPermission();
                        },
                      );
                    },
                  );
                },
              ),
              Consumer<MessagesProvider>(
                builder: (context, messagesProvider, child) {
                  return SwitchListTile(
                    title: const Text('Listening for notifications'),
                    subtitle: Text(
                      messagesProvider.isListening
                          ? 'Currently listening'
                          : 'Not listening',
                    ),
                    value: messagesProvider.isListening,
                    onChanged: (value) async {
                      if (value) {
                        await messagesProvider.resumeListening();
                      } else {
                        await messagesProvider.stopListening();
                      }
                    },
                  );
                },
              ),
            ],
          ),

          // Statistics Section
          _Section(
            title: 'Statistics',
            children: [
              Consumer<MessagesProvider>(
                builder: (context, messagesProvider, child) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.forum),
                        title: const Text('Total Conversations'),
                        trailing: Text(
                          '${messagesProvider.totalConversations}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.message),
                        title: const Text('Total Messages'),
                        trailing: Text(
                          '${messagesProvider.totalMessages}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.mark_chat_unread),
                        title: const Text('Unread Messages'),
                        trailing: Text(
                          '${messagesProvider.totalUnreadMessages}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: messagesProvider.totalUnreadMessages > 0
                                ? Colors.orange
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),

          // Supported Messengers Section
          _Section(
            title: 'Supported Messengers',
            children: MessengerType.values
                .where((m) => m != MessengerType.other)
                .map((messenger) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMessengerColor(messenger),
                        child: Text(
                          messenger.displayName[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(messenger.displayName),
                      subtitle: Text(messenger.packageName),
                    ))
                .toList(),
          ),

          // Subscription Section
          _Section(
            title: 'Subscription',
            children: [
              Consumer<SubscriptionProvider>(
                builder: (context, subscriptionProvider, child) {
                  return ListTile(
                    leading: Icon(
                      subscriptionProvider.isPremium
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                    ),
                    title: const Text('Premium Status'),
                    subtitle: Text(
                      subscriptionProvider.isPremium
                          ? 'Premium Active'
                          : 'Free Tier',
                    ),
                    trailing: subscriptionProvider.isPremium
                        ? null
                        : TextButton(
                            onPressed: () {
                              // TODO: Navigate to paywall
                            },
                            child: const Text('Upgrade'),
                          ),
                  );
                },
              ),
            ],
          ),

          // Data Management Section
          _Section(
            title: 'Data Management',
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Clear All Data'),
                subtitle: const Text('Delete all conversations and messages'),
                onTap: () async {
                  final confirmed = await _confirmClearData(context);
                  if (confirmed && context.mounted) {
                    final messagesProvider = context.read<MessagesProvider>();
                    try {
                      await messagesProvider.clearAllData();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All data cleared successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error clearing data: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),

          // About Section
          _Section(
            title: 'About',
            children: [
              const ListTile(
                leading: Icon(Icons.info),
                title: Text('Version'),
                subtitle: Text('1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Open privacy policy
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMessengerColor(MessengerType messenger) {
    final colorHex = messenger.colorHex;
    return Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
  }

  Future<bool> _confirmClearData(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all conversations and messages? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

/// Section widget for grouping settings
class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        ...children,
        const Divider(),
      ],
    );
  }
}
