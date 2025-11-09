# Инструкция по замене иконки приложения

## Требования
- Новая иконка в формате PNG (рекомендуемый размер: 512x512 или больше)
- Иконка должна быть квадратной

## ⚠️ Важно
`flutter_launcher_icons` НЕ перезаписывает существующие иконки! Перед генерацией нужно удалить старые файлы.

## Шаги

### 1. Подготовка иконки
Скопируйте новую иконку в папку `assets/icon/`:
```bash
cp /path/to/new/icon.png assets/icon/logo.png
```

### 2. Удаление старых иконок (ОБЯЗАТЕЛЬНО!)
```bash
cd android/app/src/main/res
find . -name "launcher_icon.png" -type f -delete
find . -name "ic_launcher.png" -type f -delete
cd ../../../..
```

### 3. Генерация новых иконок
```bash
dart run flutter_launcher_icons
```

**Проблема:** Если иконки сгенерировались пустыми (0 байт), используйте ручную генерацию:

<details>
<summary>Альтернатива: Ручная генерация иконок</summary>

Создайте файл `generate_icons.dart`:
```dart
import 'dart:io';
import 'package:image/image.dart' as img;

void main() async {
  final sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };

  final sourceFile = File('assets/icon/logo.png');
  final bytes = await sourceFile.readAsBytes();
  final sourceImage = img.decodeImage(bytes);

  for (final entry in sizes.entries) {
    final resized = img.copyResize(
      sourceImage!,
      width: entry.value,
      height: entry.value,
      interpolation: img.Interpolation.cubic,
    );
    final pngBytes = img.encodePng(resized);
    final outputPath = 'android/app/src/main/res/${entry.key}/launcher_icon.png';
    await File(outputPath).create(recursive: true);
    await File(outputPath).writeAsBytes(pngBytes);
    print('✓ Created $outputPath');
  }
}
```

Запустите:
```bash
dart run generate_icons.dart
rm generate_icons.dart
```
</details>

### 4. Проверка AndroidManifest.xml
Убедитесь, что в `android/app/src/main/AndroidManifest.xml` указано:
```xml
android:icon="@mipmap/launcher_icon"
```

### 5. Очистка кэша и сборка
```bash
flutter clean
flutter build apk --release
```

### 6. Установка
1. **Удалите старое приложение** с устройства
2. Установите новый APK: `build/app/outputs/flutter-apk/app-release.apk`
3. Проверьте иконку на главном экране

## Конфигурация
Настройки генерации иконок находятся в `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/logo.png"
  min_sdk_android: 21
  remove_alpha_ios: true
  web:
    generate: true
    image_path: "assets/icon/logo.png"
  windows:
    generate: true
    image_path: "assets/icon/logo.png"
  macos:
    generate: true
    image_path: "assets/icon/logo.png"
```

## Быстрая команда (все шаги сразу)
```bash
# Замените /path/to/new/icon.png на путь к новой иконке
cp /path/to/new/icon.png assets/icon/logo.png && \
cd android/app/src/main/res && \
find . -name "launcher_icon.png" -type f -delete && \
find . -name "ic_launcher.png" -type f -delete && \
cd ../../../.. && \
dart run flutter_launcher_icons && \
flutter clean && \
flutter build apk --release
```

## Проверка правильности генерации

Проверьте, что иконки создались корректно:
```bash
ls -lh android/app/src/main/res/mipmap-hdpi/launcher_icon.png
```

**Должно быть:**
- Размер файла: ~5-7 КБ (НЕ 0 байт!)
- Дата: сегодняшняя дата

Если размер 0 байт - используйте ручную генерацию из шага 3.

## Устранение проблем

### Проблема: Старая иконка Flutter отображается
**Причина:** AndroidManifest.xml ссылается на `ic_launcher` вместо `launcher_icon`

**Решение:**
```bash
# Проверьте AndroidManifest.xml
grep "android:icon" android/app/src/main/AndroidManifest.xml

# Должно быть: android:icon="@mipmap/launcher_icon"
# Если видите ic_launcher - замените на launcher_icon
```

### Проблема: Иконки сгенерировались пустыми (0 байт)
**Причина:** Баг в `flutter_launcher_icons`

**Решение:** Используйте ручную генерацию из шага 3 (раскрывающийся блок)
