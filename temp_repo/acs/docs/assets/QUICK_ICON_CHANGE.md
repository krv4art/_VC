# Быстрая замена иконки приложения

## ⚡ Одна команда
```bash
cp /path/to/new/icon.png assets/icon/logo.png && \
cd android/app/src/main/res && \
find . -name "launcher_icon.png" -type f -delete && \
find . -name "ic_launcher.png" -type f -delete && \
cd ../../../.. && \
dart run flutter_launcher_icons && \
flutter clean && \
flutter build apk --release
```

## 📋 Шаги по отдельности

1. **Копируем новую иконку:**
   ```bash
   cp /path/to/new/icon.png assets/icon/logo.png
   ```

2. **Удаляем старые иконки:**
   ```bash
   cd android/app/src/main/res
   find . -name "launcher_icon.png" -type f -delete
   find . -name "ic_launcher.png" -type f -delete
   cd ../../../..
   ```

3. **Генерируем новые:**
   ```bash
   dart run flutter_launcher_icons
   ```

4. **Проверяем:**
   ```bash
   ls -lh android/app/src/main/res/mipmap-hdpi/launcher_icon.png
   # Размер должен быть ~5-7 КБ, НЕ 0 байт!
   ```

5. **Собираем APK:**
   ```bash
   flutter clean
   flutter build apk --release
   ```

6. **Устанавливаем:**
   - Удалите старое приложение с устройства
   - Установите `build/app/outputs/flutter-apk/app-release.apk`

## ⚠️ Важно!

- **ВСЕГДА** удаляйте старые иконки перед генерацией новых
- `flutter_launcher_icons` НЕ перезаписывает существующие файлы
- Если иконки сгенерировались пустыми (0 байт) - используйте ручную генерацию

## 🔗 Подробная инструкция

См. [ICON_REPLACEMENT_GUIDE.md](ICON_REPLACEMENT_GUIDE.md)
