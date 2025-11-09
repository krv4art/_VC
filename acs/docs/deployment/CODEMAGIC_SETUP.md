# Настройка Codemagic для публикации в Google Play (Закрытое тестирование)

## Предварительные требования

### 1. Keystore (у вас уже есть)
- Файл: `acs-release-key.keystore`
- Пароли сохранены в надежном месте

### 2. Google Play Service Account (нужно создать)

## Шаг 1: Создание Google Play Service Account

### 1.1. Создайте Service Account в Google Cloud Console

**ВАЖНО:** Service Account создается в Google Cloud Console, а затем подключается к Google Play Console.

1. Перейдите в **Google Cloud Console**: https://console.cloud.google.com/
2. Выберите проект, связанный с вашим приложением (или создайте новый)
   - Если проекта нет: нажмите на выпадающий список проектов → **NEW PROJECT**
   - Название: например `ACS App`
3. В боковом меню откройте **IAM & Admin → Service Accounts**
   - Или используйте поиск (вверху): введите "Service Accounts"
4. Нажмите **+ CREATE SERVICE ACCOUNT**
5. Заполните форму:
   - **Service account name:** `codemagic-publisher`
   - **Service account ID:** автоматически заполнится
   - **Description:** `Service account for Codemagic CI/CD and Google Play publishing`
6. Нажмите **CREATE AND CONTINUE**
7. **Grant this service account access to project (необязательно для Google Play):**
   - Можете пропустить, нажмите **CONTINUE**
8. **Grant users access to this service account (необязательно):**
   - Пропустите, нажмите **DONE**

### 1.2. Создайте JSON ключ
1. В списке Service Accounts найдите `codemagic-publisher`
2. Нажмите на email service account (например, `codemagic-publisher@your-project.iam.gserviceaccount.com`)
3. Перейдите на вкладку **KEYS**
4. Нажмите **ADD KEY → Create new key**
5. Выберите тип **JSON**
6. Нажмите **CREATE**
7. Файл JSON будет автоматически загружен на ваш компьютер
8. **КРИТИЧЕСКИ ВАЖНО:**
   - Сохраните этот файл в безопасном месте!
   - Не делитесь им и не загружайте в Git
   - Это единственная копия ключа

### 1.3. Подключите Service Account к Google Play Console

Теперь нужно связать созданный Service Account с вашим приложением в Google Play:

1. Перейдите в **Google Play Console**: https://play.google.com/console
2. Выберите **All apps** или ваше приложение
3. В левом боковом меню найдите:
   - Для всех приложений: **Users and permissions** (в самом низу меню)
   - ИЛИ для конкретного приложения: **Setup → API access**
4. На странице API access:
   - Если видите раздел **Google Cloud project** - убедитесь, что проект связан
   - Если нет связанного проекта, нажмите **Link** и выберите проект из шага 1.1
5. Прокрутите вниз до раздела **Service accounts**
6. Найдите в списке ваш service account `codemagic-publisher@...`
   - Если его нет в списке, нажмите **View service accounts** → откроется Google Cloud Console
7. Напротив service account нажмите **Manage Play Console permissions** (или **Grant access**)
8. **Настройте права доступа:**
   - **Releases:**
     - ☑ **View app information and download bulk reports** (автоматически)
     - ☑ **Manage testing track releases** (обязательно!)
     - ☑ **Manage production releases** (опционально, если планируете автоматизировать production релизы)
   - Остальные разделы (Financials, Orders и т.д.) можно оставить без изменений
9. Внизу страницы нажмите **Invite user**
10. Подтвердите, нажав **Send invite**

**Готово!** Теперь Service Account имеет доступ к публикации в треки тестирования.

### 1.4. Проверьте настройку
1. В Google Play Console → **Setup → API access** (или **Users and permissions**)
2. В разделе **Service accounts** должен быть виден:
   - Email: `codemagic-publisher@your-project.iam.gserviceaccount.com`
   - Status: **Active**
   - Permissions: отображаются назначенные права

## Шаг 2: Регистрация в Codemagic

### 2.1. Создайте аккаунт
1. Перейдите на https://codemagic.io
2. Зарегистрируйтесь через GitHub/GitLab/Bitbucket
3. Подключите ваш репозиторий

### 2.2. Добавьте приложение
1. В Codemagic нажмите **Add application**
2. Выберите ваш Git репозиторий
3. Выберите **Flutter** как тип проекта
4. Codemagic автоматически найдет файл `codemagic.yaml`

## Шаг 3: Настройка переменных окружения в Codemagic

### 3.1. Загрузите Android Keystore
1. В Codemagic откройте ваше приложение
2. Перейдите в **Settings → Code signing identities**
3. В разделе **Android** нажмите **Add key**
4. Заполните форму:
   - **Keystore file:** загрузите `acs-release-key.keystore`
   - **Keystore password:** ваш пароль keystore
   - **Key alias:** `acs-release`
   - **Key password:** ваш пароль ключа
   - **Reference name:** `acs_keystore` (должно совпадать с codemagic.yaml)
5. Нажмите **Save**

### 3.2. Добавьте Google Play Service Account
1. В той же секции **Code signing identities**
2. В разделе **Google Play** нажмите **Add credentials**
3. Загрузите JSON файл service account (скачанный на шаге 1.3)
4. **Reference name:** оставьте по умолчанию или укажите `GCLOUD_SERVICE_ACCOUNT_CREDENTIALS`
5. Нажмите **Save**

### 3.3. Создайте Environment Variable Group
1. Перейдите в **Teams → Personal Account → Integrations**
2. Нажмите **Create new group**
3. Название: `google_play`
4. Добавьте переменные (если нужны дополнительные):
   ```
   PACKAGE_NAME = com.ai.cosmetic.scanner.beauty.ingredients.analyzer
   ```
5. Нажмите **Add**

### 3.4. Настройте Email уведомления
1. В файле `codemagic.yaml` найдите секцию `publishing → email`
2. Замените `your-email@example.com` на ваш реальный email
3. Закоммитьте изменения

## Шаг 4: Настройка workflow для закрытого тестирования

Файл `codemagic.yaml` уже создан со следующими настройками:

### Основные параметры:
- **Workflow name:** `android-closed-testing`
- **Track:** `internal` (внутреннее тестирование)
- **Submit as draft:** `true` (публикуется как черновик)

### Если нужно изменить тип тестирования:

```yaml
google_play:
  track: internal     # Внутреннее тестирование (до 100 тестеров)
  # track: alpha      # Закрытое альфа (нужны списки тестеров)
  # track: beta       # Открытое/закрытое бета
```

## Шаг 5: Запуск первой сборки

### 5.1. Закоммитьте изменения
```bash
git add codemagic.yaml CODEMAGIC_SETUP.md
git commit -m "Add Codemagic configuration for Google Play deployment"
git push
```

### 5.2. Запустите build в Codemagic
1. Откройте Codemagic
2. Выберите ваше приложение
3. Нажмите **Start new build**
4. Выберите workflow: `android-closed-testing`
5. Выберите ветку (обычно `main` или `master`)
6. Нажмите **Start new build**

### 5.3. Мониторинг сборки
- Вы увидите live логи сборки
- Процесс займет примерно 10-20 минут
- После успешной сборки AAB будет автоматически загружен в Google Play Console

## Шаг 6: Проверка в Google Play Console

1. Откройте Google Play Console
2. Перейдите в **Release → Testing → Internal testing**
3. Вы увидите новый релиз в статусе "Draft"
4. Проверьте детали релиза
5. Нажмите **Review and rollout** для публикации на трек тестирования

## Автоматизация

### Триггеры сборки

Вы можете настроить автоматические сборки:

1. В Codemagic откройте **Settings → Workflow settings**
2. В разделе **Triggering** выберите:
   - **Push to branch:** например, `main` или `release/*`
   - **Pull request updates:** для проверки PR
   - **Tag creation:** для релизов по тегам

### Пример с тегами

Если хотите публиковать по тегам, добавьте в `codemagic.yaml`:

```yaml
triggering:
  events:
    - tag
  tag_patterns:
    - pattern: 'v*.*.*'
      include: true
```

Затем создавайте релизы:
```bash
git tag v1.0.1
git push origin v1.0.1
```

## Управление версиями

### Автоматическое увеличение версии

Текущая настройка в `codemagic.yaml`:
```yaml
flutter build appbundle --release \
  --build-name=1.0.$((BUILD_NUMBER)) \
  --build-number=$((BUILD_NUMBER))
```

- `BUILD_NUMBER` автоматически увеличивается с каждой сборкой
- `build-name` будет: 1.0.1, 1.0.2, 1.0.3...
- `build-number` будет: 1, 2, 3...

### Ручное управление версией

Если хотите управлять вручную, измените в `pubspec.yaml`:
```yaml
version: 1.0.1+3  # version+build_number
```

И в `codemagic.yaml` уберите параметры `--build-name` и `--build-number`.

## Переменные окружения (.env)

Если у вас есть файл `.env` с секретами:

1. В Codemagic перейдите в **Environment variables**
2. Добавьте каждую переменную отдельно:
   - Имя: `SUPABASE_URL`
   - Значение: ваш URL
   - Отметьте **Secure** если это секрет
3. В `codemagic.yaml` добавьте в секцию `environment → vars`:
   ```yaml
   environment:
     vars:
       SUPABASE_URL: $SUPABASE_URL
       SUPABASE_ANON_KEY: $SUPABASE_ANON_KEY
   ```

Или создайте скрипт для генерации `.env`:
```yaml
scripts:
  - name: Create .env file
    script: |
      echo "SUPABASE_URL=$SUPABASE_URL" > .env
      echo "SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY" >> .env
```

## Troubleshooting

### Ошибка: "Service account doesn't have permission"
- Проверьте права service account в Google Play Console
- Убедитесь, что выбрана роль "Manage testing track releases"

### Ошибка: "Keystore not found"
- Проверьте Reference name в Codemagic (должно быть `acs_keystore`)
- Убедитесь, что файл загружен в Code signing identities

### Ошибка: "Version code must be greater than..."
- Google Play требует увеличения versionCode с каждым релизом
- Убедитесь, что `BUILD_NUMBER` увеличивается

### Build завис или упал
- Проверьте логи в Codemagic
- Возможно нужно увеличить `max_build_duration`
- Проверьте, что все зависимости доступны

## Стоимость

Codemagic предоставляет:
- **Free tier:** 500 минут сборки в месяц
- **Paid plans:** от $29/месяц для неограниченных сборок

Одна сборка Flutter app обычно занимает 10-15 минут.

## Полезные ссылки

- [Codemagic Flutter Documentation](https://docs.codemagic.io/flutter-configuration/flutter-projects/)
- [Google Play Publishing Guide](https://docs.codemagic.io/yaml-publishing/google-play/)
- [Android Code Signing](https://docs.codemagic.io/yaml-code-signing/signing-android/)

## Чеклист

Перед первым запуском убедитесь:

- [ ] Google Play Service Account создан
- [ ] JSON ключ service account скачан
- [ ] Права настроены в Google Play Console
- [ ] Аккаунт Codemagic создан
- [ ] Репозиторий подключен к Codemagic
- [ ] Android Keystore загружен в Codemagic (Reference: `acs_keystore`)
- [ ] Google Play credentials загружены в Codemagic
- [ ] Email в `codemagic.yaml` обновлен
- [ ] Environment variable group `google_play` создана (если нужна)
- [ ] Файл `codemagic.yaml` закоммичен в репозиторий
- [ ] Первая сборка запущена вручную для проверки

---

**Создано:** 2025-10-22
**Версия приложения:** 1.0.0+2
**Package:** com.ai.cosmetic.scanner.beauty.ingredients.analyzer
