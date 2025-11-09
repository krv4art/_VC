# Edge-to-Edge Navigation для Android

## Проблема

На некоторых Android устройствах системный navigation bar перекрывает bottom navigation bar приложения. Это происходит из-за неправильной обработки системных отступов (system insets) при использовании edge-to-edge режима.

## Причина

Проблема возникала в файле `lib/widgets/bottom_navigation_wrapper.dart`:

```dart
// ❌ НЕПРАВИЛЬНО - фиксированная высота снаружи SafeArea
bottomNavigationBar: Container(
  height: 65, // Фиксированная высота не учитывает системные отступы
  child: SafeArea(
    top: false,
    child: Row(...),
  ),
),
```

При такой структуре:
1. Container имеет фиксированную высоту 65px
2. SafeArea внутри контейнера пытается добавить padding для системного navbar
3. Но контейнер не может растянуться, поэтому содержимое сжимается
4. Системный navbar перекрывает часть навбара приложения

## Решение

Нужно изменить структуру так, чтобы SafeArea мог свободно добавлять отступы:

```dart
// ✅ ПРАВИЛЬНО - фиксированная высота внутри SafeArea
bottomNavigationBar: Container(
  // Убрали height отсюда
  decoration: BoxDecoration(...),
  child: SafeArea(
    top: false,
    child: SizedBox(
      height: 65, // Фиксированная высота для контента
      child: Row(...),
    ),
  ),
),
```

При такой структуре:
1. Внешний Container может растягиваться по высоте
2. SafeArea добавляет необходимый bottom padding для системного navbar
3. Внутренний SizedBox обеспечивает стабильную высоту 65px для контента
4. Итоговая высота = 65px (контент) + системные отступы

## Изменения в коде

### Файл: `lib/widgets/bottom_navigation_wrapper.dart`

**Было:**
```dart
bottomNavigationBar: Container(
  height: 65,
  decoration: BoxDecoration(
    color: context.colors.surface,
    boxShadow: [...],
  ),
  child: SafeArea(
    top: false,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // навигационные элементы
      ],
    ),
  ),
),
```

**Стало:**
```dart
bottomNavigationBar: Container(
  decoration: BoxDecoration(
    color: context.colors.surface,
    boxShadow: [...],
  ),
  child: SafeArea(
    top: false,
    child: SizedBox(
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // навигационные элементы
        ],
      ),
    ),
  ),
),
```

## Принципы Edge-to-Edge

### 1. SafeArea всегда снаружи фиксированных размеров

```dart
// ✅ Правильно
Container(
  child: SafeArea(
    child: SizedBox(
      height: fixedHeight,
      child: content,
    ),
  ),
)

// ❌ Неправильно
Container(
  height: fixedHeight,
  child: SafeArea(
    child: content,
  ),
)
```

### 2. Использование MediaQuery для системных отступов

Альтернативный подход - использовать `MediaQuery.viewPaddingOf(context)`:

```dart
final bottomPadding = MediaQuery.viewPaddingOf(context).bottom;

Container(
  height: 65 + bottomPadding,
  child: Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: content,
  ),
)
```

### 3. Scaffold автоматически обрабатывает SafeArea

`Scaffold` в Flutter автоматически применяет SafeArea к `body`, но не к `bottomNavigationBar`. Поэтому для навбара нужно добавлять SafeArea вручную.

## Android настройки

### AndroidManifest.xml

Убедитесь, что в `android/app/src/main/AndroidManifest.xml` установлено:

```xml
<activity
    android:name=".MainActivity"
    android:windowSoftInputMode="adjustResize"
    ...>
```

`adjustResize` позволяет правильно обрабатывать системные отступы.

### styles.xml

В `android/app/src/main/res/values/styles.xml`:

```xml
<style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
    <item name="android:windowBackground">?android:colorBackground</item>
</style>
```

## Тестирование

Проблема проявляется на устройствах с:
- Жестовой навигацией (gesture navigation)
- 3-кнопочной навигацией (3-button navigation)
- Разными размерами системного navbar

### Как тестировать:

1. **Эмулятор Android Studio:**
   - Создать эмуляторы с разными версиями Android (9+)
   - Переключить тип навигации в настройках: Settings → System → Gestures → System Navigation

2. **Реальные устройства:**
   - Протестировать на устройствах разных производителей (Samsung, Xiaomi, Google Pixel)
   - Проверить в разных режимах навигации

3. **Проверка:**
   - Навбар приложения не должен перекрываться системным navbar
   - Все элементы навбара должны быть кликабельны
   - Высота навбара должна адаптироваться к системным отступам

## Дополнительные рекомендации

### 1. Использовать SafeArea для всех экранов

```dart
Scaffold(
  body: SafeArea(
    child: YourContent(),
  ),
)
```

### 2. Избегать фиксированных размеров в корневых виджетах

Вместо:
```dart
Container(
  height: screenHeight,
  child: content,
)
```

Используйте:
```dart
LayoutBuilder(
  builder: (context, constraints) {
    return Container(
      height: constraints.maxHeight,
      child: content,
    );
  },
)
```

### 3. Проверять отступы через MediaQuery

```dart
final padding = MediaQuery.paddingOf(context);
final viewPadding = MediaQuery.viewPaddingOf(context);
final viewInsets = MediaQuery.viewInsetsOf(context);

print('Bottom padding: ${padding.bottom}');
print('Bottom view padding: ${viewPadding.bottom}');
print('Bottom view insets: ${viewInsets.bottom}');
```

## Полезные ссылки

- [Flutter SafeArea документация](https://api.flutter.dev/flutter/widgets/SafeArea-class.html)
- [Android Edge-to-Edge guide](https://developer.android.com/training/gestures/edge-to-edge)
- [MediaQuery документация](https://api.flutter.dev/flutter/widgets/MediaQuery-class.html)

## История изменений

- **23.10.2025**: Исправлена проблема перекрытия bottom navigation bar системным navbar на Android устройствах
  - Изменена структура виджета в `bottom_navigation_wrapper.dart`
  - Перенесена фиксированная высота внутрь SafeArea
  - Удален неиспользуемый импорт `app_theme.dart`
