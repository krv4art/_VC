# Common Issues & Solutions

## Navigation Issues

### Проблема: Кнопка "Назад" не работает (canPop() возвращает false)

**Симптомы:**
- Кнопка "Назад" в CustomAppBar не работает
- Ничего не происходит при нажатии
- В логах: `context.canPop(): false`
- После `context.go()` невозможно вернуться назад

**Причина:**
- Использование `context.go('/route')` вместо `context.push('/route')` при открытии экрана
- `context.go()` **ЗАМЕНЯЕТ** текущий маршрут (как в браузере)
- `context.push()` **ДОБАВЛЯЕТ** маршрут в стек навигации
- Когда используется `go()`, стек пустой → `canPop()` возвращает false → кнопка "Назад" не работает

**Решение:**
```dart
// ❌ НЕПРАВИЛЬНО - заменяет маршрут, нельзя вернуться назад
onTap: () => context.go('/theme-selection'),

// ✅ ПРАВИЛЬНО - добавляет в стек, можно вернуться назад
onTap: () => context.push('/theme-selection'),
```

**Когда использовать go() vs push():**
- `context.go()` - для **замены** маршрута (login → home, редирект)
- `context.push()` - для **добавления** в стек (все остальные случаи)

**Отладка:**
```dart
print('Can pop: ${context.canPop()}'); // Если false - используется go() вместо push()
print('Current location: ${GoRouter.of(context).location}');
```

**Файлы где исправлено:**
- `lib/widgets/modern_drawer.dart` - меню тем и языков
- `lib/screens/profile_screen.dart` - кнопка "Темы"

---

### Проблема: Async функция в CustomAppBar.onBackPressed не работает

**Симптомы:**
- `onBackPressed: () async { ... }` не выполняется
- IconButton не реагирует на async callback

**Причина:**
- `IconButton.onPressed` требует `VoidCallback` (синхронная функция)
- `Future<void> Function()` (async) несовместим с `VoidCallback`
- Async функции не работают как callback для IconButton

**Решение:**
```dart
// ❌ НЕПРАВИЛЬНО - async не работает с IconButton
final Future<void> Function()? onBackPressed;

// ✅ ПРАВИЛЬНО - используем синхронную функцию
final VoidCallback? onBackPressed;

// В screen:
onBackPressed: () {  // БЕЗ async!
  if (!_isSaved && _originalTheme != null) {
    themeProvider.setTheme(_originalTheme!); // БЕЗ await!
  }
  if (context.mounted && context.canPop()) {
    context.pop();
  }
},
```

**Файлы где исправлено:**
- `lib/widgets/custom_app_bar.dart` - тип callback
- `lib/screens/theme_selection_screen.dart` - убран async
- `lib/screens/language_screen.dart` - убран async

---

### Проблема: Чёрный экран после navigation

**Симптомы:**
- После нажатия кнопки "назад" или "сохранить" экран становится чёрным
- Ошибка: "There is nothing to pop"

**Причина:**
- Использование `Navigator.of(context).pop()` вместо `context.pop()`
- Попытка pop когда стек навигации пуст

**Решение:**
```dart
// ✅ Правильно - проверяем перед pop
if (context.canPop()) {
  context.pop();
} else {
  context.go('/home'); // Fallback route
}

// ✅ Используем push для добавления в стек
context.push('/allergies'); // Добавляет в стек

// ❌ Неправильно - go заменяет текущий route
context.go('/allergies'); // Заменяет в стеке
```

**Файлы где исправлено:**
- `lib/screens/allergies_screen.dart`
- `lib/screens/skin_type_screen.dart`
- `lib/screens/subscription_screen.dart`
- `lib/screens/chat_ai_screen.dart`

---

### Проблема: "You have popped the last page"

**Симптомы:**
- Assertion error при навигации
- "You have popped the last page off of the stack"

**Причина:**
- Попытка вернуться назад когда это последняя страница в стеке

**Решение:**
```dart
// Всегда проверяем canPop()
if (context.canPop()) {
  context.pop();
} else {
  context.go('/home');
}
```

---

### Проблема: Системный navigation bar Android перекрывает навбар приложения

**Симптомы:**
- На некоторых Android устройствах системный navigation bar (жестовая или 3-кнопочная навигация) перекрывает bottom navigation bar приложения
- Нижние элементы навбара частично или полностью скрыты за системной панелью
- Особенно заметно на устройствах с жестовой навигацией
- На части устройств навбар отображается правильно, на части - нет

**Причина:**
- Фиксированная высота контейнера снаружи `SafeArea`
- `SafeArea` не может растянуть родительский контейнер с фиксированной высотой
- Содержимое сжимается внутри `SafeArea`, но контейнер остаётся 65px
- Системный navbar перекрывает сжатое содержимое

**Решение:**
```dart
// ❌ НЕПРАВИЛЬНО - фиксированная высота снаружи SafeArea
bottomNavigationBar: Container(
  height: 65,
  child: SafeArea(
    top: false,
    child: Row(...),
  ),
),

// ✅ ПРАВИЛЬНО - SafeArea может свободно добавлять padding
bottomNavigationBar: Container(
  // БЕЗ height!
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

**Принцип:**
- Внешний `Container` без фиксированной высоты - может растягиваться
- `SafeArea` добавляет необходимые отступы снизу
- Внутренний `SizedBox(height: 65)` - фиксированная высота для контента навбара
- Итоговая высота = 65px (контент) + системные отступы

**Файлы где исправлено:**
- `lib/widgets/bottom_navigation_wrapper.dart`

**Дополнительная документация:**
- См. [EDGE_TO_EDGE_NAVIGATION.md](EDGE_TO_EDGE_NAVIGATION.md) для подробного объяснения edge-to-edge режима и SafeArea

---

## State Management Issues

### Проблема: setState вызывается после dispose

**Симптомы:**
- Error: "setState() called after dispose()"
- Происходит при async операциях

**Причина:**
- Виджет был удалён пока выполнялась async операция
- setState вызывается после того как виджет unmounted

**Решение:**
```dart
// ✅ Проверяем mounted перед setState
Future<void> loadData() async {
  final data = await api.fetchData();

  if (!mounted) return; // Важная проверка!

  setState(() {
    _data = data;
  });
}

// ✅ Проверяем перед навигацией
if (!mounted) return;
context.pop();
```

---

### Проблема: Provider rebuild loops

**Симптомы:**
- Бесконечные rebuilds
- Приложение зависает

**Причина:**
- Использование Provider.of с listen: true внутри actions
- Изменение состояния во время build

**Решение:**
```dart
// ✅ Используем listen: false для actions
ElevatedButton(
  onPressed: () {
    final state = Provider.of<UserState>(context, listen: false);
    state.updateData();
  },
)

// ✅ Используем listen: true (по умолчанию) только для чтения
@override
Widget build(BuildContext context) {
  final state = Provider.of<UserState>(context);
  return Text(state.name);
}
```

---

## API Issues

### Проблема: Gemini API "Model not found"

**Симптомы:**
- Error: "models/gemini-1.5-flash is not found for API version v1beta"
- Error: "models/gemini-2.0-flash is not found"
- Ошибка 404 от API `generativelanguage.googleapis.com`

**Причина:**
- **Неправильное имя модели:** Имена моделей могут меняться
- **Неправильный URL:** URL для прямых HTTP запросов должен быть в формате `https://generativelanguage.googleapis.com/v1beta/models/НАЗВАНИЕ_МОДЕЛИ:generateContent`

**Решение:**
Использовать прямые HTTP запросы с **актуальным** именем модели.

```dart
class GeminiService {
  final String _apiKey = 'YOUR_API_KEY';
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  final String _model = 'gemini-2.0-flash'; // ✅ Актуальное имя модели

  Future<String> sendMessage(String message) async {
    final url = '$_baseUrl/models/$_model:generateContent?key=$_apiKey';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [{
          'parts': [{'text': message}]
        }]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      throw Exception('API Error: ${response.body}');
    }
  }
}
```

**Для Vision API (анализ изображений):**
```typescript
// supabase/functions/gemini-vision-proxy/index.ts
const model = "gemini-2.0-flash"; // ✅ НЕ используйте gemini-1.5-flash
const url = `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${geminiApiKey}`;
```

**Важно:**
- ✅ Актуальные модели (январь 2025): `gemini-2.0-flash`, `gemini-2.5-flash`, `gemini-2.5-pro`
- ❌ `gemini-1.5-flash` больше не существует в API v1beta
- После изменения модели в Edge Function необходимо задеплоить: `npx supabase functions deploy gemini-vision-proxy`

---

## Scanning Issues

### Проблема: Сканирование не-косметических объектов

**Симптомы:**
- При сканировании книги, телефона или другого объекта показывается ошибка
- Нет юмористического сообщения

**Причина:**
- AI не распознал тип объекта
- Промпт не содержит инструкций по определению типа

**Решение:**
Убедитесь что промпт содержит STEP 1 для определения типа объекта:

```dart
String _buildAnalysisPrompt(String userProfilePrompt) {
  return '''
    STEP 1: DETERMINE OBJECT TYPE
    First, carefully examine the image and determine if this is a cosmetic product label/packaging.

    If this is NOT a cosmetic product label:
    - Set "is_cosmetic_label" to false
    - Create a humorous message with emojis
    ...
  ''';
}
```

Проверьте что модель `AnalysisResult` содержит поля:
- `isCosmeticLabel: bool`
- `humorousMessage: String?`

---

## Design System Issues

### Проблема: Текст не виден в темной теме (плохой контраст)

**Симптомы:**
- Темный текст на темном фоне в dark theme
- Серый текст сливается с серым фоном у неактивных элементов
- Текст в модалках/диалогах не виден

**Причина:**
- Использование фиксированных цветов (`Colors.grey`, `deepBrown`, `mediumBrown`)
- Эти цвета не адаптируются к темной теме
- Неправильный выбор цвета для текста/границ

**Решение:**
```dart
// ❌ НЕПРАВИЛЬНО - фиксированные цвета
style: AppTheme.body.copyWith(
  color: AppTheme.mediumBrown,  // Темный в обеих темах!
),
border: Border.all(
  color: Colors.grey.withValues(alpha: 0.3),
),

// ✅ ПРАВИЛЬНО - адаптивные цвета из context
style: AppTheme.body.copyWith(
  color: context.colors.onBackground,  // Светлый в dark theme!
),
border: Border.all(
  color: context.colors.onBackground.withValues(alpha: 0.3),
),
```

**Правила выбора цвета текста:**
- **Основной текст** → `context.colors.onBackground`
- **Второстепенный текст** → `context.colors.onBackground.withValues(alpha: 0.7)`
- **Текст на цветном фоне** → `Colors.white` (для градиентов/кнопок)
- **Границы элементов** → `context.colors.onBackground.withValues(alpha: 0.3)`

**Файлы где исправлено:**
- `lib/screens/subscription_screen.dart` - текст на карточках подписок
- `lib/screens/language_screen.dart` - текст языков
- `lib/screens/allergies_screen.dart` - поле добавления аллергена
- `lib/screens/profile_screen.dart` - модалки редактирования и очистки

---

### Проблема: Цвета не соответствуют дизайн-системе

**Симптомы:**
- Используются хардкод цвета `Color(0xFF47EB99)` или `Colors.grey[...]`
- Inconsistent UI

**Решение:**
Всегда используйте константы из `AppTheme`:

```dart
// ❌ Неправильно
Color(0xFF47EB99)
Colors.grey[200]

// ✅ Правильно
AppTheme.naturalGreen
AppTheme.lightGrey
AppTheme.cardBackground
```

### Проблема: Deprecated withOpacity

**Симптомы:**
- Warning: 'withOpacity' is deprecated

**Решение:**
```dart
// ❌ Deprecated
Colors.black.withOpacity(0.5)

// ✅ Используем withValues
Colors.black.withValues(alpha: 0.5)
```

---

## Database & Type Issues

### Проблема: type 'List<dynamic>' is not a subtype of type 'List<String>'

**Симптомы:**
- Error при загрузке данных из SQLite или JSON
- Type casting errors

**Причина:**
- `jsonDecode()` возвращает `List<dynamic>`
- Dart требует явного приведения типов

**Решение:**
```dart
// ❌ Неправильно
List<String> items = jsonDecode(json['items']);

// ✅ Правильно
List<String> items = List<String>.from(jsonDecode(json['items']));

// ✅ Безопасная функция
List<T> safeCast<T>(List<dynamic>? list) {
  return list?.whereType<T>().toList() ?? [];
}
```

---

## Build Issues

### Проблема: Старая иконка Flutter отображается после замены

**Симптомы:**
- После замены иконки в `assets/icon/` приложение всё равно показывает старую иконку Flutter
- Новая иконка видна в папке проекта, но не в установленном APK
- `dart run flutter_launcher_icons` завершается успешно, но иконки не обновляются

**Причины:**
1. **`flutter_launcher_icons` НЕ перезаписывает существующие файлы** - главная причина!
2. AndroidManifest.xml ссылается на `ic_launcher` вместо `launcher_icon`
3. Старые иконки Flutter остались в mipmap папках
4. Иконки сгенерировались пустыми (0 байт) из-за бага в `flutter_launcher_icons`

**Решение (ПРАВИЛЬНЫЙ порядок):**
```bash
# 1. Скопировать новую иконку (512x512 PNG рекомендуется)
cp /path/to/icon.png assets/icon/logo.png

# 2. СНАЧАЛА удалить старые иконки (КРИТИЧНО!)
cd android/app/src/main/res
find . -name "launcher_icon.png" -type f -delete
find . -name "ic_launcher.png" -type f -delete
cd ../../../..

# 3. Сгенерировать новые иконки
dart run flutter_launcher_icons

# 4. ПРОВЕРИТЬ что иконки создались правильно
ls -lh android/app/src/main/res/mipmap-hdpi/launcher_icon.png
# Размер должен быть ~5-7 КБ, НЕ 0 байт!
# Если 0 байт - используйте ручную генерацию (см. Icon Replacement Guide)

# 5. Проверить AndroidManifest.xml
grep "android:icon" android/app/src/main/AndroidManifest.xml
# Должно быть: android:icon="@mipmap/launcher_icon"

# 6. Очистить кэш и пересобрать
flutter clean
flutter build apk --release

# 7. Удалить старое приложение перед установкой нового APK
```

**Подробности и ручная генерация:** См. [Icon Replacement Guide](../ICON_REPLACEMENT_GUIDE.md)

---

### Проблема: Hot reload не работает

**Симптомы:**
- Изменения не отражаются в приложении
- Flutter говорит "Performing hot reload..." но ничего не меняется

**Решение:**
```bash
# 1. Hot restart вместо reload
r

# 2. Полная пересборка
flutter clean
flutter pub get
flutter run -d chrome

# 3. Убить все процессы Chrome
taskkill /F /IM chrome.exe
flutter run -d chrome
```

---

## Code Quality Issues

### Проблема: Использование print() вместо debugPrint()

**Симптомы:**
- Множество `print()` statements в продакшн коде
- Неконтролируемое логирование в релизе
- Засорение консоли отладочными сообщениями

**Причина:**
- `print()` выводит логи **всегда**, даже в production builds
- `debugPrint()` работает **только в debug mode** и автоматически отключается в release
- `print()` может приводить к утечке конфиденциальной информации в логах production

**Решение:**

**ВСЕГДА используйте `debugPrint()` для отладочных сообщений:**

```dart
// ❌ НЕПРАВИЛЬНО - будет работать в production
print('User login: $email');
print('API Error: $error');
print('Loading data...');

// ✅ ПРАВИЛЬНО - работает только в debug mode
debugPrint('User login: $email');
debugPrint('API Error: $error');
debugPrint('Loading data...');
```

**Когда использовать что:**

| Метод | Когда использовать | Production |
|-------|-------------------|------------|
| `debugPrint()` | Отладочные сообщения, диагностика, логи разработки | ❌ Отключен |
| `print()` | **НИКОГДА** (только для quick debugging) | ✅ Работает |
| `log()` | Структурированное логирование с уровнями (info/warning/error) | ✅ Работает |

**Пример использования log() для production:**
```dart
import 'dart:developer' as developer;

// ✅ Для production логирования используйте dart:developer
developer.log(
  'User authentication failed',
  name: 'auth',
  error: error,
  level: 900, // WARNING level
);

// Для разных уровней:
developer.log('Info message', level: 800);    // INFO
developer.log('Warning', level: 900);         // WARNING
developer.log('Error', level: 1000);          // ERROR
```

**Автоматическая проверка:**
```bash
# Найти все print() в коде
grep -rn "print(" lib/ --include="*.dart"

# Найти все debugPrint()
grep -rn "debugPrint(" lib/ --include="*.dart"
```

**Best Practices:**
1. ✅ Используйте `debugPrint()` для всех временных отладочных сообщений
2. ✅ Используйте `log()` из `dart:developer` для production логирования
3. ✅ Добавьте pre-commit hook для проверки `print()` в коде
4. ✅ Удаляйте временные debugPrint() перед коммитом (или замените на log())
5. ❌ НИКОГДА не используйте `print()` в production коде

**Файлы где было исправлено (январь 2025):**
- `lib/navigation/app_router.dart` - navigation debugging
- `lib/providers/auth_provider.dart` - auth errors
- `lib/providers/user_state.dart` - state management
- `lib/providers/theme_provider_v2.dart` - theme errors
- `lib/providers/locale_provider.dart` - locale state

**Итоговая статистика очистки:**
- ❌ Было: 184 `print()` statements в 21 файле
- ✅ Стало: 0 `print()` statements
- ✅ Все заменены на `debugPrint()`

---

## Debugging Tips

### Включить verbose логи
```bash
flutter run -d chrome -v
```

### Проверить состояние навигации
```dart
// ✅ Используйте debugPrint() для отладки
debugPrint('Can pop: ${context.canPop()}');
debugPrint('Current route: ${GoRouter.of(context).location}');
```

### Проверить состояние Provider
```dart
final state = Provider.of<UserState>(context, listen: false);
debugPrint('User name: ${state.name}');
debugPrint('Allergies: ${state.allergies}');
```

### DevTools
```bash
# Открыть DevTools
flutter pub global activate devtools
flutter pub global run devtools
```
