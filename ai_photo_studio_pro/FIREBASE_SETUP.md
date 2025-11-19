# Firebase Setup Guide

Это руководство поможет вам настроить Firebase для AI Photo Studio Pro.

## Шаг 1: Создание проекта в Firebase

1. Откройте [Firebase Console](https://console.firebase.google.com/)
2. Нажмите "Add project" / "Добавить проект"
3. Введите имя проекта: `ai-photo-studio-pro`
4. Отключите Google Analytics (опционально)
5. Нажмите "Create project"

## Шаг 2: Добавление Android приложения

1. В консоли Firebase выберите "Add app" → Android
2. Введите package name: `com.ai.photo.studio.pro`
3. Введите App nickname: `AI Photo Studio Pro`
4. Скачайте файл `google-services.json`
5. Поместите файл в: `android/app/google-services.json`

### Обновите android/build.gradle:

```gradle
buildscript {
    dependencies {
        // ... existing dependencies
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

### Обновите android/app/build.gradle:

```gradle
apply plugin: 'com.android.application'
apply plugin: 'com.google.gms.google-services' // Add this line

// ... rest of the file
```

## Шаг 3: Добавление iOS приложения

1. В консоли Firebase выберите "Add app" → iOS
2. Введите iOS bundle ID: `com.ai.photo.studio.pro`
3. Введите App nickname: `AI Photo Studio Pro`
4. Скачайте файл `GoogleService-Info.plist`
5. Откройте Xcode: `open ios/Runner.xcworkspace`
6. Перетащите `GoogleService-Info.plist` в папку Runner в Xcode
7. Убедитесь что выбрано "Copy items if needed"

## Шаг 4: Настройка Cloud Messaging

### Для Android:

Ничего дополнительного не требуется, уже настроено в `google-services.json`.

### Для iOS:

1. В Xcode откройте Runner → Signing & Capabilities
2. Нажмите "+ Capability"
3. Добавьте "Push Notifications"
4. Добавьте "Background Modes"
5. В Background Modes включите:
   - Remote notifications
   - Background fetch

## Шаг 5: Получение Server Key (для отправки уведомлений)

1. В Firebase Console перейдите в Project Settings → Cloud Messaging
2. Найдите "Server key"
3. Скопируйте его (понадобится для backend)

## Шаг 6: Добавление зависимостей

Зависимости уже добавлены в `pubspec.yaml`:

```yaml
dependencies:
  firebase_core: ^3.8.1
  firebase_messaging: ^15.1.5
  flutter_local_notifications: ^18.0.1
```

Запустите:
```bash
flutter pub get
```

## Шаг 7: Инициализация Firebase в коде

Код уже добавлен в `lib/services/app_initialization_service.dart` и должен быть вызван в `main.dart`:

```dart
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // ... rest of initialization

  runApp(const MyApp());
}
```

## Шаг 8: Настройка разрешений

### Android (android/app/src/main/AndroidManifest.xml):

```xml
<manifest>
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.VIBRATE"/>

    <application>
        <!-- ... existing code ... -->

        <!-- Add this for notifications -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="ai_photo_studio_channel" />
    </application>
</manifest>
```

### iOS (ios/Runner/Info.plist):

```xml
<dict>
    <!-- ... existing keys ... -->

    <!-- Add notification permissions -->
    <key>UIBackgroundModes</key>
    <array>
        <string>remote-notification</string>
        <string>fetch</string>
    </array>
</dict>
```

## Шаг 9: Тестирование

### Тест на Android:

```bash
flutter run
```

Проверьте логи на наличие FCM token:
```
FCM Token: xxxxxxxxxxxxxxxxxxxxx
```

### Тест на iOS:

```bash
cd ios
pod install
cd ..
flutter run
```

## Шаг 10: Отправка тестового уведомления

1. В Firebase Console → Cloud Messaging → "Send your first message"
2. Введите текст уведомления
3. Нажмите "Send test message"
4. Вставьте FCM token из логов приложения
5. Нажмите "Test"

## Troubleshooting

### Android проблемы:

1. **"Default FirebaseApp is not initialized"**
   - Проверьте что `google-services.json` в правильной папке
   - Проверьте что добавлен plugin в `build.gradle`

2. **Gradle sync failed**
   - Обновите Google Services plugin до последней версии
   - Очистите кэш: `./gradlew clean`

### iOS проблемы:

1. **"No GoogleService-Info.plist found"**
   - Убедитесь что файл добавлен в Xcode, не просто скопирован
   - Проверьте Build Phases → Copy Bundle Resources

2. **Notifications not working**
   - Проверьте что Push Notifications capability добавлена
   - Проверьте Background Modes
   - Убедитесь что используете физическое устройство (симулятор не поддерживает push)

## Дополнительные настройки

### Топики для уведомлений:

Приложение автоматически подписывается на топик `all_users`. Вы можете добавить больше в `app_initialization_service.dart`:

```dart
await pushService.subscribeToTopic('premium_users');
await pushService.subscribeToTopic('new_features');
```

### Кастомизация уведомлений:

Редактируйте `lib/services/push_notification_service.dart` для изменения:
- Звуков
- Иконок
- Действий
- Каналов уведомлений

## Полезные ссылки

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)

## Безопасность

⚠️ **Важно:**
- НЕ коммитьте файлы конфигурации Firebase в публичный репозиторий
- Добавьте в `.gitignore`:
  ```
  google-services.json
  GoogleService-Info.plist
  ```
- Используйте разные проекты Firebase для dev/prod окружений
