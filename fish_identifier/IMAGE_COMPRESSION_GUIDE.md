# 📸 Руководство по внедрению двойного сжатия изображений

## 🎯 Цель

Снижение размера изображений на 60-80% перед отправкой в AI API для:
- Экономии трафика пользователей
- Уменьшения затрат на API
- Ускорения обработки
- Улучшения производительности на слабых сетях

## 🔄 Концепция двойного сжатия

**Уровень 1: Базовое сжатие (image_picker)**
- Происходит при выборе/создании фото
- Ограничивает размеры и базовое качество

**Уровень 2: Интеллектуальное сжатие (перед API)**
- Дополнительная оптимизация перед отправкой
- Целевой размер: до 500KB
- Сохранение качества для AI распознавания

## 📦 Необходимые зависимости

### Для Flutter (рекомендуется)

```yaml
# pubspec.yaml
dependencies:
  flutter_image_compress: ^2.3.0  # Основной пакет для сжатия
  image_picker: ^1.1.2            # Для выбора фото
  path_provider: ^2.1.3           # Для работы с путями
  path: ^1.9.0                    # Утилиты путей
```

### Альтернатива (для продвинутого контроля)

```yaml
dependencies:
  image: ^4.5.4  # Более низкоуровневая работа с изображениями
```

## 🛠️ Шаг 1: Создание сервиса сжатия

### Вариант A: С flutter_image_compress (проще, быстрее)

Создайте файл `lib/services/image_compression_service.dart`:

```dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageCompressionService {
  // Настройки сжатия
  static const int maxWidth = 1920;
  static const int maxHeight = 1920;
  static const int quality = 85;
  static const int maxFileSizeKB = 500;

  /// Сжать файл изображения
  static Future<Uint8List> compressImageFile(String imagePath) async {
    try {
      debugPrint('📸 Compressing: $imagePath');

      // Получить размер оригинала
      final originalFile = File(imagePath);
      final originalSize = await originalFile.length();
      debugPrint('📏 Original: ${(originalSize / 1024).toStringAsFixed(2)} KB');

      // Сжать изображение
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imagePath,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        throw Exception('Compression failed');
      }

      final compressedSize = compressedBytes.length;
      debugPrint('🗜️ Compressed: ${(compressedSize / 1024).toStringAsFixed(2)} KB');
      debugPrint('💰 Savings: ${((1 - compressedSize / originalSize) * 100).toStringAsFixed(1)}%');

      // Если всё ещё слишком большой - сжать агрессивнее
      if (compressedSize > maxFileSizeKB * 1024) {
        return await _compressAggressively(imagePath, compressedBytes);
      }

      return compressedBytes;
    } catch (e) {
      debugPrint('❌ Compression error: $e');
      return await File(imagePath).readAsBytes(); // Fallback
    }
  }

  /// Агрессивное сжатие для больших файлов
  static Future<Uint8List> _compressAggressively(
    String imagePath,
    Uint8List firstAttempt,
  ) async {
    debugPrint('⚠️ File too large, applying aggressive compression...');

    final aggressiveBytes = await FlutterImageCompress.compressWithFile(
      imagePath,
      minWidth: 1280,
      minHeight: 1280,
      quality: 70, // Ниже качество
      format: CompressFormat.jpeg,
    );

    if (aggressiveBytes == null) return firstAttempt;

    debugPrint('🗜️ Aggressive result: ${(aggressiveBytes.length / 1024).toStringAsFixed(2)} KB');
    return aggressiveBytes;
  }

  /// Сжать байты напрямую (для in-memory изображений)
  static Future<Uint8List> compressImageBytes(Uint8List imageBytes) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithList(
        imageBytes,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
        format: CompressFormat.jpeg,
      );

      debugPrint('💾 In-memory compressed: ${(compressedBytes.length / 1024).toStringAsFixed(2)} KB');
      return compressedBytes;
    } catch (e) {
      debugPrint('❌ In-memory compression error: $e');
      return imageBytes;
    }
  }

  /// Сохранить сжатое изображение
  static Future<String> compressAndSaveImage(String sourcePath) async {
    try {
      final compressedBytes = await compressImageFile(sourcePath);

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = p.extension(sourcePath);
      final fileName = 'compressed_$timestamp$extension';
      final targetPath = p.join(tempDir.path, fileName);

      final file = File(targetPath);
      await file.writeAsBytes(compressedBytes);

      debugPrint('💾 Saved to: $targetPath');
      return targetPath;
    } catch (e) {
      debugPrint('❌ Save error: $e');
      return sourcePath;
    }
  }

  /// Проверить, нужно ли сжатие
  static Future<bool> needsCompression(String imagePath) async {
    try {
      final file = File(imagePath);
      final size = await file.length();
      return size > maxFileSizeKB * 1024;
    } catch (e) {
      return false;
    }
  }

  /// Оценить размер base64
  static int estimateBase64Size(Uint8List bytes) {
    return (bytes.length * 1.33).ceil();
  }
}
```

### Вариант B: С пакетом image (больше контроля)

```dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class ImageCompressionService {
  static Future<Uint8List> compressImage(Uint8List originalBytes) async {
    try {
      // Декодировать изображение
      img.Image? image = img.decodeImage(originalBytes);
      if (image == null) {
        debugPrint('⚠️ Failed to decode image');
        return originalBytes;
      }

      final originalSize = originalBytes.length / (1024 * 1024);
      debugPrint('📸 Original: ${originalSize.toStringAsFixed(2)} MB');
      debugPrint('📐 Dimensions: ${image.width}x${image.height}');

      // Ресайз если слишком большое
      const int maxDimension = 1920;
      if (image.width > maxDimension || image.height > maxDimension) {
        if (image.width > image.height) {
          image = img.copyResize(image, width: maxDimension);
        } else {
          image = img.copyResize(image, height: maxDimension);
        }
        debugPrint('📏 Resized to: ${image.width}x${image.height}');
      }

      // Конвертировать в JPEG с качеством 85%
      final compressedBytes = img.encodeJpg(image, quality: 85);

      final compressedSize = compressedBytes.length / (1024 * 1024);
      final savings = ((originalSize - compressedSize) / originalSize * 100).round();

      debugPrint('✅ Compressed: ${compressedSize.toStringAsFixed(2)} MB');
      debugPrint('💰 Savings: $savings%');

      return Uint8List.fromList(compressedBytes);
    } catch (e) {
      debugPrint('❌ Compression error: $e');
      return originalBytes;
    }
  }
}
```

## 🔧 Шаг 2: Настройка image_picker (Уровень 1)

```dart
// В вашем экране выбора фото
Future<void> _pickImage(ImageSource source) async {
  try {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1920,      // ⬅️ Уровень 1: Базовое ограничение
      maxHeight: 1920,     // ⬅️ Уровень 1: Базовое ограничение
      imageQuality: 85,    // ⬅️ Уровень 1: Базовое качество
    );

    if (image != null) {
      await _processImage(image.path);
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
  }
}
```

## 📤 Шаг 3: Интеграция в отправку AI (Уровень 2)

### Было (без сжатия):

```dart
Future<void> _identifyFish(String imagePath) async {
  // ❌ ПЛОХО: Прямая конвертация в base64
  final imageBytes = await File(imagePath).readAsBytes();
  final base64Image = base64Encode(imageBytes);

  final result = await aiService.identify(base64Image);
}
```

### Стало (с двойным сжатием):

```dart
import 'dart:convert';
import '../services/image_compression_service.dart';

Future<void> _identifyFish(String imagePath) async {
  try {
    // ✅ ХОРОШО: Уровень 2 сжатия перед отправкой
    final compressedBytes = await ImageCompressionService.compressImageFile(imagePath);
    final base64Image = base64Encode(compressedBytes);

    final result = await aiService.identify(base64Image);
  } catch (e) {
    debugPrint('Error: $e');
  }
}
```

## 📊 Шаг 4: Мониторинг и логирование

Добавьте отслеживание эффективности сжатия:

```dart
class CompressionStats {
  static int totalOriginalBytes = 0;
  static int totalCompressedBytes = 0;
  static int compressionCount = 0;

  static void recordCompression(int originalSize, int compressedSize) {
    totalOriginalBytes += originalSize;
    totalCompressedBytes += compressedSize;
    compressionCount++;
  }

  static String getStats() {
    if (compressionCount == 0) return 'No compressions yet';

    final avgSavings = ((1 - totalCompressedBytes / totalOriginalBytes) * 100).toStringAsFixed(1);
    final totalSavedMB = ((totalOriginalBytes - totalCompressedBytes) / (1024 * 1024)).toStringAsFixed(2);

    return '''
📊 Compression Statistics:
   Total images: $compressionCount
   Average savings: $avgSavings%
   Total saved: $totalSavedMB MB
    ''';
  }
}
```

## ⚙️ Шаг 5: Настройка параметров

Создайте конфигурационный файл `lib/config/compression_config.dart`:

```dart
class CompressionConfig {
  // Размеры
  static const int maxWidth = 1920;
  static const int maxHeight = 1920;

  // Качество
  static const int normalQuality = 85;  // Обычное сжатие
  static const int aggressiveQuality = 70;  // Агрессивное сжатие

  // Лимиты
  static const int maxFileSizeKB = 500;  // Целевой размер
  static const int warningThresholdKB = 300;  // Порог предупреждения

  // Форматы
  static bool useJpegForPhotos = true;
  static bool usePngForGraphics = false;

  // Режимы
  static bool enableAggressiveMode = true;
  static bool enableCaching = true;
}
```

## 🧪 Шаг 6: Тестирование

Создайте тесты для проверки сжатия:

```dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ImageCompressionService', () {
    test('should compress large images', () async {
      // Тест с реальным изображением
      final originalBytes = await File('test_assets/large_image.jpg').readAsBytes();
      final compressed = await ImageCompressionService.compressImageBytes(originalBytes);

      expect(compressed.length, lessThan(originalBytes.length));
      expect(compressed.length, lessThan(500 * 1024)); // < 500KB
    });

    test('should maintain quality for small images', () async {
      final smallBytes = await File('test_assets/small_image.jpg').readAsBytes();
      final compressed = await ImageCompressionService.compressImageBytes(smallBytes);

      // Маленькое изображение не должно сильно сжиматься
      expect(compressed.length, greaterThan(smallBytes.length * 0.8));
    });
  });
}
```

## 📈 Ожидаемые результаты

### До внедрения:
```
📷 Оригинальное фото: 3.5 MB
📤 Отправлено в API: 3.5 MB → base64: 4.7 MB
⏱️ Время загрузки (4G): 8-12 секунд
💰 Стоимость API: 1 запрос = 3.5 MB
```

### После внедрения:
```
📷 Оригинальное фото: 3.5 MB
🗜️ После Уровня 1 (picker): 2.1 MB
🗜️ После Уровня 2 (service): 450 KB
📤 Отправлено в API: 450 KB → base64: 600 KB
⏱️ Время загрузки (4G): 1-2 секунды
💰 Стоимость API: 1 запрос = 450 KB
📊 Экономия: 87% трафика, 6-10x быстрее
```

## 🎯 Checklist внедрения

- [ ] Установить зависимости (`flutter_image_compress` или `image`)
- [ ] Создать `ImageCompressionService`
- [ ] Настроить параметры в `image_picker`
- [ ] Интегрировать сжатие перед отправкой в API
- [ ] Добавить логирование
- [ ] Протестировать на разных размерах изображений
- [ ] Измерить метрики (размер, время, качество)
- [ ] Обновить документацию

## ⚠️ Важные замечания

1. **Качество vs Размер**
   - 85% качество - оптимально для AI распознавания
   - Не опускайтесь ниже 70% - может снизить точность

2. **Форматы**
   - JPEG для фотографий (лучшее сжатие)
   - PNG для графики с прозрачностью
   - Избегайте BMP, TIFF (слишком большие)

3. **Производительность**
   - Сжатие происходит асинхронно
   - Не блокирует UI
   - Показывайте индикатор прогресса

4. **Fallback**
   - Всегда предусмотрите возврат к оригиналу при ошибке
   - Не теряйте данные пользователя

5. **Кэширование**
   - Храните сжатые версии локально
   - Избегайте повторного сжатия одного файла

## 📚 Дополнительные ресурсы

- [flutter_image_compress документация](https://pub.dev/packages/flutter_image_compress)
- [image package](https://pub.dev/packages/image)
- [Best practices для работы с изображениями](https://docs.flutter.dev/perf/rendering/best-practices)

## 💡 Советы по оптимизации

1. **Адаптивное сжатие**
   ```dart
   // Сжимать сильнее на медленной сети
   final quality = isSlowNetwork ? 70 : 85;
   ```

2. **Прогрессивное сжатие**
   ```dart
   // Отправить низкое качество сразу, потом высокое
   await sendPreview(lowQualityImage);
   await sendFull(highQualityImage);
   ```

3. **Батчинг**
   ```dart
   // Сжимать несколько изображений параллельно
   await Future.wait([
     compress(image1),
     compress(image2),
     compress(image3),
   ]);
   ```

---

**Создано:** 2025-11-12
**Версия:** 1.0
**Автор:** Claude Code Assistant
