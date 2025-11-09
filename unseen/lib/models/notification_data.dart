import 'messenger_type.dart';

/// Data extracted from a notification
class NotificationData {
  final String id;
  final String packageName;
  final MessengerType messenger;
  final String title;
  final String text;
  final String? subText;
  final String? bigText;
  final DateTime timestamp;
  final String? conversationId;
  final String? senderId;
  final List<String>? mediaUrls;
  final Map<String, dynamic>? extras;

  const NotificationData({
    required this.id,
    required this.packageName,
    required this.messenger,
    required this.title,
    required this.text,
    this.subText,
    this.bigText,
    required this.timestamp,
    this.conversationId,
    this.senderId,
    this.mediaUrls,
    this.extras,
  });

  /// Create from platform notification data
  factory NotificationData.fromPlatform(Map<String, dynamic> data) {
    final packageName = data['packageName'] as String? ?? '';
    final messenger = MessengerType.fromPackageName(packageName);

    return NotificationData(
      id: data['id']?.toString() ?? '',
      packageName: packageName,
      messenger: messenger,
      title: data['title'] as String? ?? '',
      text: data['text'] as String? ?? '',
      subText: data['subText'] as String?,
      bigText: data['bigText'] as String?,
      timestamp: DateTime.now(),
      conversationId: data['conversationId'] as String?,
      senderId: data['senderId'] as String?,
      mediaUrls: (data['mediaUrls'] as List?)?.cast<String>(),
      extras: data['extras'] as Map<String, dynamic>?,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'packageName': packageName,
      'messenger': messenger.name,
      'title': title,
      'text': text,
      'subText': subText,
      'bigText': bigText,
      'timestamp': timestamp.toIso8601String(),
      'conversationId': conversationId,
      'senderId': senderId,
      'mediaUrls': mediaUrls,
      'extras': extras,
    };
  }

  /// Get the actual message text (prefers bigText if available)
  String get messageText => bigText ?? text;

  /// Check if notification has media
  bool get hasMedia => mediaUrls != null && mediaUrls!.isNotEmpty;

  /// Extract sender name from title
  String get senderName {
    // For WhatsApp: "Contact Name"
    // For Telegram: "Contact Name" or "Group: Sender"
    // For others: usually in title
    if (title.contains(':')) {
      return title.split(':').first.trim();
    }
    return title;
  }

  /// Generate unique conversation ID
  String get generatedConversationId {
    if (conversationId != null && conversationId!.isNotEmpty) {
      return conversationId!;
    }
    // Generate ID from package + sender
    return '${messenger.name}_${senderName.hashCode}';
  }

  @override
  String toString() {
    return 'NotificationData(messenger: ${messenger.displayName}, from: $title, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
