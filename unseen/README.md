# Unseen - Privacy-Focused Messaging App

![Flutter](https://img.shields.io/badge/Flutter-3.32.6-blue)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue)
![License](https://img.shields.io/badge/license-MIT-green)

**Read messages from WhatsApp, Telegram, and other messengers without sending read receipts.**

## 🌟 Features

### Core Functionality
- 👻 **Read Without Being Seen** - Read messages without triggering read receipts
- 📱 **Multi-Messenger Support** - WhatsApp, Telegram, Facebook, Instagram, Viber, LINE, TikTok
- 💬 **Message History** - All messages saved locally in SQLite
- 🗑️ **Deleted Messages** - Recover and view deleted messages
- 🔔 **Smart Notifications** - Intercepts notifications before you open the app
- 🎭 **Invisible Mode** - Stay offline while browsing messages

### User Experience
- 🌐 **Multi-language** - 27+ languages (inherited from ACS base)
- 🎨 **Privacy-Focused Design** - Dark themes, modern UI
- 📱 **Responsive** - Works on all screen sizes
- 💾 **Local Storage** - All data stored locally (no cloud)
- 🔒 **Privacy First** - No data sent to servers

### Premium Features
- ✨ **Unlimited Messages** - No daily limits
- 🎯 **All Messengers** - Access to all supported platforms
- 🚫 **No Ads** - Clean, distraction-free experience
- 📊 **Advanced Analytics** - Message statistics and insights

## 🏗️ Architecture

Based on **ACS (AI Cosmetic Scanner)** architecture with adaptations for messaging:

```
unseen/
├── lib/
│   ├── models/              # Data models
│   │   ├── message.dart
│   │   ├── conversation.dart
│   │   ├── messenger_type.dart
│   │   └── notification_data.dart
│   ├── services/            # Business logic
│   │   ├── notification_listener_service.dart
│   │   ├── message_storage_service.dart
│   │   ├── notification_parser_service.dart
│   │   └── messenger_detector_service.dart
│   ├── providers/           # State management (from ACS)
│   ├── screens/             # UI screens
│   ├── theme/               # Design system (adapted from ACS)
│   ├── l10n/                # Localization (27 languages from ACS)
│   └── widgets/             # Reusable components
├── android/                 # Android platform (NotificationListener)
└── ios/                     # iOS platform
```

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.32.6+
- Dart 3.8.1+
- Android Studio / VS Code

### Installation

```bash
# Navigate to project
cd unseen

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run the app
flutter run
```

### Android Permissions

The app requires special notification access permissions:

```xml
<uses-permission android:name="android.permission.BIND_NOTIFICATION_LISTENER_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

Users will be guided through the permission setup during onboarding.

## 📱 Supported Messengers

| Messenger | Status | Package Name |
|-----------|--------|--------------|
| WhatsApp | ✅ Full | com.whatsapp |
| Telegram | ✅ Full | org.telegram.messenger |
| Facebook Messenger | ✅ Full | com.facebook.orca |
| Instagram | ✅ Full | com.instagram.android |
| Viber | ✅ Full | com.viber.voip |
| LINE | ✅ Full | jp.naver.line.android |
| TikTok | ✅ Full | com.zhiliaoapp.musically |

## 🎨 Design System

### Color Palette (Privacy-Focused)

**Light Theme (Privacy)**
- **Primary**: Deep Indigo `#3949AB` - Privacy, security, trust
- **Primary Light**: Indigo 400 `#5C6BC0`
- **Primary Pale**: Indigo 200 `#9FA8DA`
- **Primary Dark**: Indigo 800 `#283593`
- **Background**: Soft blue-grey `#F5F6FA`
- **Surface**: White `#FFFFFF`

**Dark Theme (Dark Privacy)**
- **Primary**: Indigo 400 `#5C6BC0`
- **Background**: Material Dark `#121212`
- **Surface**: Dark Indigo `#1E1E2D`

### Typography

- **Headers**: Lora (Serif) - Elegant, professional
- **Body**: Open Sans (Sans-serif) - Clean, readable

## 🔌 Key Technologies

### Inherited from ACS
- **State Management**: Provider
- **Navigation**: go_router
- **Storage**: SQLite + SharedPreferences
- **Localization**: flutter_localizations (27 languages)
- **Monetization**: RevenueCat
- **UI**: Material 3 with custom themes

### Unseen-Specific
- **Notification Listener**: flutter_notification_listener
- **Image Caching**: cached_network_image
- **Video Player**: video_player
- **File Handling**: open_file

## 💰 Monetization

### Free Tier
- ✅ 10 messages per day
- ✅ 2 messengers (WhatsApp + Telegram)
- ✅ Basic features

### Premium ($2.99/month or $19.99/year)
- ✅ Unlimited messages
- ✅ All messengers
- ✅ No ads
- ✅ Priority support
- ✅ Advanced features

## 📊 Database Schema

### Conversations Table
```sql
CREATE TABLE conversations (
    id TEXT PRIMARY KEY,
    contact_name TEXT NOT NULL,
    avatar TEXT,
    messenger INTEGER NOT NULL,
    last_message_time INTEGER NOT NULL,
    last_message_text TEXT,
    unread_count INTEGER DEFAULT 0
);
```

### Messages Table
```sql
CREATE TABLE messages (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    text TEXT,
    media_url TEXT,
    timestamp INTEGER NOT NULL,
    sender_id TEXT NOT NULL,
    sender_name TEXT NOT NULL,
    messenger INTEGER NOT NULL,
    is_deleted INTEGER DEFAULT 0,
    is_read INTEGER DEFAULT 0,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);
```

## 🔐 Privacy & Security

### Data Storage
- ✅ All messages stored **locally** in SQLite
- ✅ No data sent to external servers
- ✅ Optional encrypted cloud backup (future feature)

### Permissions
- **Notification Access**: Required to intercept messages
- **Foreground Service**: Keeps the app running in background
- **Wake Lock**: Ensures notifications are captured

### GDPR Compliance
- Clear privacy policy
- Right to delete data
- No tracking or analytics (in free version)

## 🛣️ Roadmap

### MVP (v1.0) - ✅ COMPLETED
- [x] Basic project structure
- [x] Data models (Message, Conversation, MessengerType, NotificationData)
- [x] Database schema (SQLite with conversations and messages tables)
- [x] Android NotificationListenerService (Kotlin)
- [x] MethodChannel/EventChannel bridge for Flutter-Android communication
- [x] Core UI screens (Home, Conversation, Settings, Onboarding)
- [x] Privacy-focused theme (Deep Indigo color scheme)
- [x] All 7 messengers support (WhatsApp, Telegram, Facebook, Instagram, Viber, LINE, TikTok)
- [x] RevenueCat integration for subscriptions
- [x] Deleted messages toggle view
- [x] Clear all data functionality
- [x] Statistics dashboard in Settings
- [x] Onboarding flow for first-time users
- [x] 27 language localizations (inherited from ACS)

### v1.1 - Next Release
- [ ] Media messages preview (images, videos, audio)
- [ ] Advanced search functionality
- [ ] Export conversations to text/JSON
- [ ] Push notifications for new messages
- [ ] Custom notification sounds

### v1.2 - Enhanced Features
- [ ] Message filters (by messenger, date, sender)
- [ ] Conversation archiving
- [ ] Backup/restore to local file
- [ ] Dark/Light theme auto-switching
- [ ] Per-messenger statistics

### v2.0 - Premium Features
- [ ] Cloud backup (E2E encrypted)
- [ ] Cross-device sync
- [ ] Auto-reply templates
- [ ] Scheduled messages
- [ ] Message reactions capture
- [ ] Voice message transcription (AI-powered)

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## 🤝 Contributing

This project is based on the ACS codebase. Contributions are welcome!

## 📄 License

This project is licensed under the MIT License.

## 🙏 Acknowledgments

- **ACS Project** - Base architecture and design system
- Flutter community for amazing packages
- Open source contributors

## 📞 Support

- 📧 Email: support@unseen-app.com
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/unseen/issues)

---

Made with ❤️ and Flutter | Built on ACS Architecture
