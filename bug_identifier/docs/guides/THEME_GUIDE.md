# Руководство по использованию системы тем

Этот документ описывает правила работы с системой тем в приложении.

## 1. Основные принципы

- В приложении используется **единая** система тем, основанная на `ChangeNotifierProvider` и `ThemeExtension`.
- Провайдер темы: `ThemeProviderV2` ([`lib/providers/theme_provider_v2.dart`](lib/providers/theme_provider_v2.dart)).
- Цвета определены в классе `AppColors` ([`lib/theme/app_colors.dart`](lib/theme/app_colors.dart)).
- Расширение для доступа к цветам: `ThemeExtensionV2` ([`lib/theme/theme_extensions_v2.dart`](lib/theme/theme_extensions_v2.dart)).

## 2. Как использовать цвета в виджетах

Для доступа к цветам текущей темы используйте `context.colors`. Это самый простой и предпочтительный способ.

```dart
// ✅ Правильно
Container(
  color: context.colors.primary,
  child: Text(
    'Пример текста',
    style: TextStyle(color: context.colors.onPrimary),
  ),
)
```

## 3. Как получить доступ к теме

Полный доступ к теме (включая не только цвета, но и другие параметры) можно получить через `Theme.of(context)`.

```dart
// ✅ Правильно
ThemeData theme = Theme.of(context);
```

## 4. Запрещенные практики

- **НЕЛЬЗЯ** использовать старые классы `ThemeProvider` или `ThemeExtension`. Они были удалены.
- **НЕЛЬЗЯ** использовать статический доступ к цветам, например `AppTheme.lightTheme`.
- **ИЗБЕГАЙТЕ** прямого использования `ThemeExtensionV2(context)`. Используйте `context.colors` для краткости.

```dart
// ❌ Неправильно
import '.../theme_extensions.dart'; // Старый файл
Color color = ThemeExtension(context).colors.primary; // Старый синтаксис
```

## 5. Добавление новых цветов

1.  Добавьте новое поле в класс `AppColors` в файле [`lib/theme/app_colors.dart`](lib/theme/app_colors.dart).
2.  Инициализируйте его в конструкторе.
3.  Определите значения этого цвета для каждой из 5 тем (Light, Dark, Ocean, Forest, Sunset) в соответствующем фабричном конструкторе.