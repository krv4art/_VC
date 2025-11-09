# Android Keystore Issues with Codemagic - НЕ РЕШЕНО

## ⚠️ ПРОБЛЕМА: Невозможно задеплоить через Codemagic со старым keystore

### Описание
При попытке собрать и подписать Android App Bundle (AAB) через Codemagic возникала ошибка:
```
Failed to read key from store: Tag number over 30 is not supported
```

### Причина
Старый keystore файл (из архива `a-i-cosmetics-scanner-8p4jdl-keystore.jks`), созданный в августе 2025 года, использует формат JKS, который несовместим с современными версиями Java/Android Build Tools на серверах Codemagic.

SHA1 требуемого ключа: `3D:4E:C8:BD:51:01:7C:A6:CD:C0:08:75:24:DE:A3:4E:A6:98:26:83`

## ❌ Попытки решения (ВСЕ НЕ СРАБОТАЛИ)

### ❌ Попытка 1: Конвертация keystore через keytool
```bash
keytool -importkeystore \
  -srckeystore old-keystore.jks \
  -destkeystore new-keystore.jks \
  -deststoretype PKCS12
```
**Результат:** Конвертация прошла успешно локально, но Codemagic все равно не мог прочитать keystore.

### ❌ Попытка 2: Использование jarsigner вместо Gradle signing
```yaml
- name: Sign AAB with jarsigner
  script: |
    jarsigner -keystore /tmp/keystore.jks \
      -storepass "$PASSWORD" \
      app-release.aab \
      "$ALIAS"
```
**Результат:** jarsigner также не смог прочитать старый keystore из-за той же проблемы с форматом.

### ❌ Попытка 3: Явная настройка keystore через скрипт
```yaml
- name: Set up keystore
  script: |
    echo $CM_KEYSTORE | base64 --decode > $CM_KEYSTORE_PATH
    cat >> "$CM_BUILD_DIR/android/key.properties" <<EOF
    storePassword=$CM_KEYSTORE_PASSWORD
    keyPassword=$CM_KEY_PASSWORD
    keyAlias=$CM_KEY_ALIAS
    storeFile=$CM_KEYSTORE_PATH
    EOF
```
**Результат:** Gradle/bundletool все равно не могли прочитать keystore.

### ❌ Попытка 4: Создание нового keystore в формате PKCS12
```bash
keytool -genkeypair -keystore new-keystore.jks \
  -storetype PKCS12 \
  -keyalg RSA -keysize 2048
```
**Результат:** Новый keystore работал, но имел другой SHA1, который не совпадал с ожидаемым Google Play.

## ✅ Решение: Ручная загрузка + Google Play App Signing

### Что сработало:

1. **Локальная сборка с оригинальным keystore**
   ```bash
   # Обновить android/key.properties с абсолютным путем
   storeFile=E:\\_VIBE\\ACS\\old-keystore.jks

   # Собрать локально
   flutter build appbundle --release
   ```

   Локальная Java/Build Tools смогли прочитать старый keystore.

2. **Ручная загрузка AAB в Google Play Console**
   - Загрузили AAB через веб-интерфейс Google Play Console
   - Release → Testing → Internal testing → Create new release

3. **Настройка Google Play App Signing**
   - Google сгенерировал новый production key
   - Google создал новый upload certificate для будущих загрузок
   - Теперь можно использовать новый upload key для Codemagic

### Преимущества этого подхода:
- ✅ Google управляет production ключом (безопаснее)
- ✅ Новый upload key в современном формате, совместим с Codemagic
- ✅ Можно потерять upload key без потери доступа к приложению
- ✅ Автоматическая оптимизация APK для разных устройств

## Рекомендации для будущего

### Для новых приложений:
1. **Сразу создавать keystore в формате PKCS12:**
   ```bash
   keytool -genkeypair -v \
     -keystore app-keystore.jks \
     -storetype PKCS12 \
     -keyalg RSA -keysize 2048 \
     -validity 10000 \
     -alias app-release
   ```

2. **Использовать Google Play App Signing с первого релиза:**
   - Загрузить первую версию вручную
   - Включить Google Play App Signing
   - Получить upload certificate
   - Настроить Codemagic с upload key

3. **Тестировать keystore локально перед загрузкой в Codemagic:**
   ```bash
   # Проверить формат
   keytool -list -v -keystore app-keystore.jks

   # Попробовать собрать
   flutter build appbundle --release

   # Проверить подпись
   keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab
   ```

### Для существующих приложений с проблемными keystore:

1. **НЕ пытаться конвертировать keystore** - обычно не работает с Codemagic
2. **Собрать локально и загрузить вручную** первую версию
3. **Настроить Google Play App Signing** после первой загрузки
4. **Получить новый upload key** от Google
5. **Настроить Codemagic с новым upload key**

## Структура итоговой настройки

### Локальная конфигурация (android/key.properties):
```properties
storePassword=your_password
keyPassword=your_password
keyAlias=your_alias
storeFile=/absolute/path/to/keystore.jks
```

### Codemagic конфигурация (после App Signing):
```yaml
environment:
  android_signing:
    - upload_keystore  # Новый upload key от Google
  groups:
    - google_play
```

### Google Play Console:
- **App signing key (production):** управляется Google
- **Upload certificate:** используется для Codemagic
- **Track:** internal/alpha/beta/production

## Сравнение: iOS vs Android

### iOS (TestFlight):
- ✅ Apple управляет сертификатами через Xcode/Fastlane
- ✅ Автоматическое обновление provisioning profiles
- ✅ Меньше проблем с форматами ключей
- ✅ Codemagic хорошо интегрируется с Apple Developer Portal

### Android (Google Play):
- ⚠️ Больше проблем с legacy keystores
- ⚠️ Нужно вручную управлять keystore форматами
- ⚠️ Проблемы совместимости между версиями Java/Build Tools
- ✅ Google Play App Signing решает большинство проблем

**Вывод:** iOS публикация через Codemagic обычно проще, так как Apple имеет более унифицированный процесс управления сертификатами.

## Полезные команды для диагностики

### Проверить формат keystore:
```bash
keytool -list -v -keystore your-keystore.jks -storepass your_password
```

### Проверить подпись AAB:
```bash
keytool -printcert -jarfile app-release.aab
```

### Проверить SHA1:
```bash
keytool -list -v -keystore your-keystore.jks -storepass your_password | grep SHA1
```

### Конвертировать keystore (если нужно):
```bash
keytool -importkeystore \
  -srckeystore old.jks \
  -destkeystore new.jks \
  -deststoretype PKCS12 \
  -srcstorepass old_pass \
  -deststorepass new_pass
```

### Проверить версию Java:
```bash
java -version
keytool -version
```

## Временная шкала проблемы

1. **Попытка 1-3:** Создание нового keystore → Неправильный SHA1
2. **Попытка 4-6:** Конвертация старого keystore → "Tag number over 30"
3. **Попытка 7-8:** Использование jarsigner → Та же ошибка
4. **Попытка 9:** Явная настройка через скрипт → Не помогло
5. **Решение:** Локальная сборка + ручная загрузка → ✅ Успех

**Время, потраченное на решение:** ~2-3 часа

## Итоговый чеклист для деплоя Android приложения

- [ ] Создать/найти keystore с правильным SHA1
- [ ] Проверить формат keystore (должен быть PKCS12)
- [ ] Протестировать локальную сборку
- [ ] Проверить подпись AAB
- [ ] Загрузить первую версию в Google Play (вручную, если нужно)
- [ ] Настроить Google Play App Signing
- [ ] Получить upload certificate от Google
- [ ] Настроить Codemagic с upload key
- [ ] Протестировать автоматический деплой через Codemagic
- [ ] Убедиться, что версия успешно появилась в Google Play Console

## Ссылки

- [Flutter Android Deployment Guide](https://docs.flutter.dev/deployment/android)
- [Google Play App Signing](https://developer.android.com/studio/publish/app-signing)
- [Codemagic Android Code Signing](https://docs.codemagic.io/yaml-code-signing/signing-android/)
- [Keytool Documentation](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html)

---

**Создано:** 2025-10-22
**Проблема:** Tag number over 30 is not supported
**Решение:** Локальная сборка + Google Play App Signing
**Статус:** ✅ Решено
