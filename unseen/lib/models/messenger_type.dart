/// Supported messaging platforms
enum MessengerType {
  whatsapp('WhatsApp', 'com.whatsapp'),
  telegram('Telegram', 'org.telegram.messenger'),
  facebook('Facebook Messenger', 'com.facebook.orca'),
  instagram('Instagram', 'com.instagram.android'),
  viber('Viber', 'com.viber.voip'),
  line('LINE', 'jp.naver.line.android'),
  tiktok('TikTok', 'com.zhiliaoapp.musically'),
  other('Other', '');

  const MessengerType(this.displayName, this.packageName);

  final String displayName;
  final String packageName;

  /// Get messenger type from package name
  static MessengerType fromPackageName(String packageName) {
    for (final type in MessengerType.values) {
      if (type.packageName == packageName) {
        return type;
      }
    }
    return MessengerType.other;
  }

  /// Icon asset path for this messenger
  String get iconPath => 'assets/images/messengers/${name.toLowerCase()}.png';

  /// Color associated with this messenger
  String get colorHex {
    switch (this) {
      case MessengerType.whatsapp:
        return '#25D366';
      case MessengerType.telegram:
        return '#0088CC';
      case MessengerType.facebook:
        return '#0084FF';
      case MessengerType.instagram:
        return '#E4405F';
      case MessengerType.viber:
        return '#7360F2';
      case MessengerType.line:
        return '#00B900';
      case MessengerType.tiktok:
        return '#000000';
      case MessengerType.other:
        return '#9E9E9E';
    }
  }
}
