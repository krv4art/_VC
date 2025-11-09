# Документация проекта ACS (AI Cosmetic Scanner)

Полная документация Flutter-приложения для сканирования и анализа косметических продуктов.

## 📚 Структура документации

```
docs/
├── README.md                      (этот файл)
│
├── 🏗️ Архитектурные документы (корень docs/)
│   ├── ARCHITECTURE.md
│   ├── API_INTEGRATION.md
│   ├── DESIGN_SYSTEM.md
│   ├── DESIGN_SYSTEM_QUICK_REFERENCE.md
│   ├── ADAPTIVE_DARK_THEMES_UPDATE.md
│   ├── EDGE_TO_EDGE_NAVIGATION.md
│   ├── SCANNING_SCREEN_REFACTORING.md
│   └── THEME_IMPLEMENTATION_REVIEW.md
│
├── 📖 guides/ - Руководства и гайды
│   ├── Темы
│   │   ├── MULTI_THEME_GUIDE.md
│   │   ├── ADD_NEW_THEME_ULTIMATE_GUIDE.md
│   │   ├── THEME_FIX_GUIDE.md
│   │   └── THEME_GUIDE.md
│   ├── Анимации
│   │   ├── ANIMATIONS_SYSTEM_GUIDE.md
│   │   ├── ANIMATIONS_IMPLEMENTATION_GUIDE.md
│   │   ├── HOMEPAGE_ANIMATIONS_GUIDE.md
│   │   └── ANIMATED_AVATAR_GUIDE.md
│   ├── Локализация
│   │   ├── LOCALIZATION_GUIDE.md
│   │   ├── ADD_NEW_LANGUAGE_GUIDE.md
│   │   ├── PROMPTS_LOCALIZATION_GUIDE.md
│   │   └── STORE_LISTINGS_GUIDE.md
│   ├── UX/UI
│   │   ├── RATING_SYSTEM_GUIDE.md
│   │   └── ERROR_HANDLING_GUIDE.md
│   ├── Справочники
│   │   ├── COMMON_ISSUES.md
│   │   └── CHAT_QUICK_REFERENCE.md
│
├── 🚀 deployment/ - CI/CD и публикация
│   ├── CODEMAGIC_SETUP.md
│   ├── CODEMAGIC_ANDROID_KEYSTORE_ISSUES.md
│   ├── SIGNING_SETUP.md
│   └── RESTORATION_GUIDE.md
│
├── ⚙️ setup/ - Настройка и конфигурация
│   ├── SUBSCRIPTION_SETUP.md
│   └── TELEGRAM_SETUP.md
│
├── 🎨 assets/ - Ресурсы и иконки
│   ├── ICON_REPLACEMENT_GUIDE.md
│   └── QUICK_ICON_CHANGE.md
│
├── ✨ features/ - Документация фич
│   ├── CHAT_ONBOARDING_IMPLEMENTATION.md
│   └── POLL_WIDGET.md
│
├── 📋 planning/ - Планы и анализы
│   ├── POLL_OPTIMIZATION_PLAN.md
│   ├── OPTIMIZATION_SUMMARY.md
│   ├── OPTIMIZATION_INSTRUCTIONS.md
│   ├── 8PX_SYSTEM_ANALYSIS_REPORT.md
│   ├── 8PX_ANALYSIS_SUMMARY.txt
│   └── liveplan_analiz_otzyvov.md
│
├── 📝 changelogs/ - История изменений
│   ├── CHANGELOG_REFACTORING.md
│   ├── CHANGELOG_RATING_SYSTEM.md
│   ├── CHANGELOG_NAVBAR_FIX.md
│   ├── CHANGELOG_ERROR_HANDLING.md
│   └── CHANGELOG_ICON_DOCS.md
│
└── 📦 archive/ - Завершенные проекты
    ├── ITERATION_1-4_COMPLETED.md
    ├── COLOR_REFACTORING_*.md
    ├── PHASE_3_*.md
    └── ...
```

---

## 🏗️ Архитектура и структура

### Основная архитектура
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Общая архитектура приложения
  - Структура проекта
  - Паттерны проектирования
  - Зависимости и библиотеки
  - ⭐ **ОБНОВЛЕНО**: Рефакторинг scanning screen (январь 2025)

- **[SCANNING_SCREEN_REFACTORING.md](SCANNING_SCREEN_REFACTORING.md)** ⭐ **НОВОЕ** - Рефакторинг экрана сканирования
  - Уменьшение с 1,593 до 363 строк (77% reduction)
  - Извлечение 15 файлов (services, widgets, constants)
  - Снижение cyclomatic complexity с 8-12 до 1-5
  - Исправление критических багов UI синхронизации
  - Поддержка переводов ингредиентов (Korean, Japanese, Chinese)

### Дизайн-система
- **[DESIGN_SYSTEM.md](DESIGN_SYSTEM.md)** - Полная дизайн-система приложения
  - Цветовая палитра
  - Типографика
  - Компоненты UI

- **[DESIGN_SYSTEM_QUICK_REFERENCE.md](DESIGN_SYSTEM_QUICK_REFERENCE.md)** - Быстрый справочник
  - Краткие примеры использования
  - Часто используемые паттерны

- **[ADAPTIVE_DARK_THEMES_UPDATE.md](ADAPTIVE_DARK_THEMES_UPDATE.md)** - Адаптивные тёмные темы
  - Автоматическая адаптация цветов
  - Контрастность и читаемость

- **[THEME_IMPLEMENTATION_REVIEW.md](THEME_IMPLEMENTATION_REVIEW.md)** - Обзор реализации тем

### API и интеграции
- **[API_INTEGRATION.md](API_INTEGRATION.md)** - Интеграция с внешними API
  - Gemini API
  - Supabase Edge Functions
  - RevenueCat

### Навигация и UI
- **[EDGE_TO_EDGE_NAVIGATION.md](EDGE_TO_EDGE_NAVIGATION.md)** - Edge-to-Edge навигация на Android
  - Проблема перекрытия навбара
  - SafeArea правильное использование
  - Системные отступы

---

## 📖 Руководства (guides/)

### 🎨 Темы
- **[MULTI_THEME_GUIDE.md](guides/MULTI_THEME_GUIDE.md)** - Руководство по мультитемингу
  - Система тем v2
  - Создание новых тем
  - Переключение между темами

- **[ADD_NEW_THEME_ULTIMATE_GUIDE.md](guides/ADD_NEW_THEME_ULTIMATE_GUIDE.md)** - Подробное руководство по добавлению новых тем
  - Пошаговая инструкция
  - Примеры кода
  - Best practices

- **[THEME_FIX_GUIDE.md](guides/THEME_FIX_GUIDE.md)** - Исправления проблем с темами

- **[THEME_GUIDE.md](guides/THEME_GUIDE.md)** - Базовое руководство по темам (legacy)

### ✨ Анимации
- **[ANIMATIONS_SYSTEM_GUIDE.md](guides/ANIMATIONS_SYSTEM_GUIDE.md)** - Система анимаций
  - Типы анимаций
  - AnimationController
  - Staggered animations

- **[ANIMATIONS_IMPLEMENTATION_GUIDE.md](guides/ANIMATIONS_IMPLEMENTATION_GUIDE.md)** - Руководство по реализации анимаций
  - Примеры кода
  - Best practices

- **[HOMEPAGE_ANIMATIONS_GUIDE.md](guides/HOMEPAGE_ANIMATIONS_GUIDE.md)** - Анимации на главном экране
  - Пошаговая реализация
  - Timing и curves

- **[ANIMATED_AVATAR_GUIDE.md](guides/ANIMATED_AVATAR_GUIDE.md)** - Анимированные аватары

### 🌍 Локализация
- **[LOCALIZATION_GUIDE.md](guides/LOCALIZATION_GUIDE.md)** - Руководство по локализации
  - Добавление новых языков
  - Структура файлов локализации
  - Flutter Intl
  - Интеграция со store listings

- **[ADD_NEW_LANGUAGE_GUIDE.md](guides/ADD_NEW_LANGUAGE_GUIDE.md)** - Добавление нового языка
  - Пошаговая инструкция
  - Файлы для изменения

- **[PROMPTS_LOCALIZATION_GUIDE.md](guides/PROMPTS_LOCALIZATION_GUIDE.md)** - Локализация AI-промптов
  - Структура промптов
  - Мультиязычные промпты
  - ⭐ **ОБНОВЛЕНО**: Поля original_name, name, hint (январь 2025)

- **[STORE_LISTINGS_GUIDE.md](guides/STORE_LISTINGS_GUIDE.md)** - Управление материалами сторов
  - Унифицированная структура
  - Процесс добавления новых языков
  - Ограничения и рекомендации

### ⭐ UX/UI и пользовательский опыт
- **[RATING_SYSTEM_GUIDE.md](guides/RATING_SYSTEM_GUIDE.md)** - Система запроса оценки приложения
  - Умная логика показа после 2-го сообщения в чате
  - Лучшие практики UX для запроса оценок
  - Настройка интервалов и ограничений
  - Интеграция с Google Play

- **[ERROR_HANDLING_GUIDE.md](guides/ERROR_HANDLING_GUIDE.md)** - Обработка ошибок API
  - Пользовательские исключения
  - Локализованные сообщения об ошибках
  - Скрытие технических деталей от пользователя

### 📘 Справочники
- **[COMMON_ISSUES.md](guides/COMMON_ISSUES.md)** - Частые проблемы и их решения
  - Проблемы навигации (canPop, go vs push)
  - Перекрытие системного navbar ⭐ **ОБНОВЛЕНО 23.10.2025**
  - **Code Quality Issues** ⭐ **НОВОЕ 23.10.2025**
    - print() vs debugPrint() - правильное логирование
    - Best practices для отладки
  - State management issues
  - API errors (Gemini)
  - Design system issues
  - Build issues

- **[CHAT_QUICK_REFERENCE.md](guides/CHAT_QUICK_REFERENCE.md)** - Быстрый справочник по чату

---

## 🚀 Deployment и CI/CD (deployment/)

- **[CODEMAGIC_SETUP.md](deployment/CODEMAGIC_SETUP.md)** - Настройка Codemagic для Google Play
  - Конфигурация CI/CD
  - Автоматическая сборка и публикация
  - Закрытое тестирование

- **[SIGNING_SETUP.md](deployment/SIGNING_SETUP.md)** - Настройка подписи приложения
  - Keystore конфигурация
  - Gradle signing
  - Решение проблем с подписью

- **[CODEMAGIC_ANDROID_KEYSTORE_ISSUES.md](deployment/CODEMAGIC_ANDROID_KEYSTORE_ISSUES.md)** - Проблемы с keystore
  - Troubleshooting
  - Конвертация keystore

- **[RESTORATION_GUIDE.md](deployment/RESTORATION_GUIDE.md)** - Восстановление и откат
  - Резервное копирование
  - Процедуры восстановления

---

## ⚙️ Настройка и конфигурация (setup/)

- **[SUBSCRIPTION_SETUP.md](setup/SUBSCRIPTION_SETUP.md)** - Настройка подписок RevenueCat
  - Интеграция RevenueCat
  - Настройка продуктов
  - Google Play и App Store конфигурация

- **[TELEGRAM_SETUP.md](setup/TELEGRAM_SETUP.md)** - Настройка Telegram интеграции

---

## 🎨 Ассеты и ресурсы (assets/)

- **[ICON_REPLACEMENT_GUIDE.md](assets/ICON_REPLACEMENT_GUIDE.md)** - Замена иконки приложения
  - Генерация иконок для всех платформ
  - flutter_launcher_icons
  - Решение проблем

- **[QUICK_ICON_CHANGE.md](assets/QUICK_ICON_CHANGE.md)** - Быстрая замена иконки
  - Упрощённая инструкция (одна команда)

---

## ✨ Документация фич (features/)

- **[CHAT_ONBOARDING_IMPLEMENTATION.md](features/CHAT_ONBOARDING_IMPLEMENTATION.md)** - Онбординг в стиле чата
  - 4-step onboarding flow
  - UI layout и компоненты
  - Детали реализации

- **[POLL_WIDGET.md](features/POLL_WIDGET.md)** - Виджет опросов
  - Функциональность
  - Интеграция
  - API

---

## 📋 Планы и анализы (planning/)

- **[POLL_OPTIMIZATION_PLAN.md](planning/POLL_OPTIMIZATION_PLAN.md)** - План оптимизации системы опросов
- **[OPTIMIZATION_SUMMARY.md](planning/OPTIMIZATION_SUMMARY.md)** - Сводка оптимизаций
- **[OPTIMIZATION_INSTRUCTIONS.md](planning/OPTIMIZATION_INSTRUCTIONS.md)** - Инструкции по оптимизации
- **[8PX_SYSTEM_ANALYSIS_REPORT.md](planning/8PX_SYSTEM_ANALYSIS_REPORT.md)** - Анализ системы отступов 8px
- **[8PX_ANALYSIS_SUMMARY.txt](planning/8PX_ANALYSIS_SUMMARY.txt)** - Краткая сводка анализа
- **[liveplan_analiz_otzyvov.md](planning/liveplan_analiz_otzyvov.md)** - Анализ отзывов LivePlan

---

## 📝 История изменений (changelogs/)

- **[CHANGELOG_REFACTORING.md](changelogs/CHANGELOG_REFACTORING.md)** - Рефакторинг scanning screen (январь 2025)
  - Метрики улучшения качества кода
  - Новые services и widgets
  - Исправленные критические баги
  - Поддержка переводов ингредиентов

- **[CHANGELOG_RATING_SYSTEM.md](changelogs/CHANGELOG_RATING_SYSTEM.md)** - Система запроса оценки (26.10.2025)

- **[CHANGELOG_NAVBAR_FIX.md](changelogs/CHANGELOG_NAVBAR_FIX.md)** - Исправление навбара (23.10.2025)
  - Детали изменений
  - До/После сравнение
  - Тестирование

- **[CHANGELOG_ERROR_HANDLING.md](changelogs/CHANGELOG_ERROR_HANDLING.md)** - Обработка ошибок API

- **[CHANGELOG_ICON_DOCS.md](changelogs/CHANGELOG_ICON_DOCS.md)** - История изменений иконок

---

## 📦 Архив (archive/)

Завершенные проекты и устаревшие документы:
- Итерации разработки (ITERATION_1-4_COMPLETED.md)
- Рефакторинги (COLOR_REFACTORING_*, COMPLETE_REFACTORING_OVERVIEW.md)
- Фазы проектов (PHASE_3_*)
- Миграции (MIGRATION_TO_PROVIDER_COMPLETE.md)
- Планы и чеклисты (CUSTOM_THEMES_ROADMAP.md, PROJECT_COMPLETION_CHECKLIST.md)
- Старые реорганизации (DOCUMENTATION_REORGANIZATION.md)

---

## 🚀 Быстрый старт

### Новому разработчику
1. **Начните с архитектуры**: [ARCHITECTURE.md](ARCHITECTURE.md)
2. **Изучите дизайн-систему**: [DESIGN_SYSTEM_QUICK_REFERENCE.md](DESIGN_SYSTEM_QUICK_REFERENCE.md)
3. **Локализация**: [guides/LOCALIZATION_GUIDE.md](guides/LOCALIZATION_GUIDE.md)
4. **Частые проблемы**: [guides/COMMON_ISSUES.md](guides/COMMON_ISSUES.md)

### Частые задачи

#### Добавить новую тему
👉 [guides/ADD_NEW_THEME_ULTIMATE_GUIDE.md](guides/ADD_NEW_THEME_ULTIMATE_GUIDE.md)

#### Добавить новый язык
👉 [guides/ADD_NEW_LANGUAGE_GUIDE.md](guides/ADD_NEW_LANGUAGE_GUIDE.md)

#### Добавить анимации
👉 [guides/ANIMATIONS_IMPLEMENTATION_GUIDE.md](guides/ANIMATIONS_IMPLEMENTATION_GUIDE.md)

#### Настроить подписки
👉 [setup/SUBSCRIPTION_SETUP.md](setup/SUBSCRIPTION_SETUP.md)

#### Настроить CI/CD
👉 [deployment/CODEMAGIC_SETUP.md](deployment/CODEMAGIC_SETUP.md)

#### Заменить иконку
👉 [assets/QUICK_ICON_CHANGE.md](assets/QUICK_ICON_CHANGE.md)

#### Решить проблему
👉 [guides/COMMON_ISSUES.md](guides/COMMON_ISSUES.md)

---

## 🆕 Последние обновления

### ⭐ Ноябрь 2025 - Масштабная реорганизация документации
- ✅ **Новая структура папок**
  - 📖 guides/ - Все руководства и гайды
  - ✨ features/ - Документация фич
  - 📋 planning/ - Планы и анализы
  - 📝 changelogs/ - История изменений
  - 📦 archive/ - Завершенные проекты

- ✅ **Перемещено 8 файлов из корня проекта в docs/**
  - TELEGRAM_SETUP.md → setup/
  - CHAT_ONBOARDING_IMPLEMENTATION.md → features/
  - Планы оптимизации → planning/
  - Анализы системы → planning/

- ✅ **Архивировано 17 завершенных документов**
  - ITERATION_1-4_COMPLETED.md
  - COLOR_REFACTORING_*, PHASE_3_*
  - MIGRATION_TO_PROVIDER_COMPLETE.md
  - И другие завершенные проекты

- ✅ **Организовано 14 гайдов в guides/**
  - По темам, анимациям, локализации, UX/UI
  - Справочники вынесены отдельно

- ✅ **Собрано 5 CHANGELOG файлов в changelogs/**

### Январь 2025 - Масштабный рефакторинг scanning screen
- ✅ Уменьшение с 1,593 до 363 строк (77% reduction)
- ✅ Снижение cyclomatic complexity с 8-12 до 1-5 (60% reduction)
- ✅ Создано 15 новых файлов (services, widgets)
- ✅ Поддержка переводов ингредиентов

### Октябрь 2025
- ✅ Первичная реорганизация (deployment/, setup/, assets/)
- ✅ Исправление навбара Android
- ✅ Система запроса оценки приложения

---

## 💡 Best Practices

### Логирование и отладка
```dart
// ✅ Для отладки - работает только в debug mode
debugPrint('Debug info: $value');

// ✅ Для production логов - структурированное логирование
import 'dart:developer' as developer;
developer.log('Error occurred', name: 'app', level: 1000);

// ❌ НИКОГДА не используйте print() в коде
print('This will appear in production!'); // ❌ НЕ ТАК!
```

### Навигация
```dart
// ✅ Добавить в стек
context.push('/route');

// ✅ Заменить route
context.go('/route');

// ✅ Вернуться назад
if (context.canPop()) {
  context.pop();
}
```

### Темы и цвета
```dart
// ✅ Использовать context.colors
Text(
  'Hello',
  style: TextStyle(color: context.colors.onBackground),
)

// ❌ НЕ использовать хардкод цвета
Text(
  'Hello',
  style: TextStyle(color: Color(0xFF123456)),
)
```

### SafeArea и отступы
```dart
// ✅ Правильно - SafeArea снаружи фиксированных размеров
Container(
  child: SafeArea(
    child: SizedBox(
      height: 65,
      child: content,
    ),
  ),
)

// ❌ Неправильно - фиксированная высота блокирует SafeArea
Container(
  height: 65,
  child: SafeArea(
    child: content,
  ),
)
```

---

## 🛠️ Техническая информация

### Версии
- **Flutter**: 3.32.6
- **Dart**: 3.8.1
- **Android**: min SDK 21, target SDK 34
- **iOS**: min deployment 12.0

### Основные зависимости
- `go_router` - навигация
- `provider` - state management
- `flutter_localizations` - локализация
- `google_generative_ai` - Gemini API
- `supabase_flutter` - backend
- `purchases_flutter` - подписки (RevenueCat)

---

## 📞 Контакты и поддержка

Если у вас есть вопросы или нужна помощь:
1. Проверьте [guides/COMMON_ISSUES.md](guides/COMMON_ISSUES.md)
2. Поищите в соответствующем разделе документации
3. Обратитесь к команде разработки

---

## 📄 Лицензия

Внутренняя документация проекта ACS.

---

**Последнее обновление**: Ноябрь 2025
**Версия документации**: 3.0
