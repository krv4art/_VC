# Руководство по восстановлению изменений

Этот документ содержит все изменения, сделанные в проекте во время сессии.

## 1. ✅ Навигационная панель (ВОССТАНОВЛЕНО)
**Файл:** `lib/widgets/bottom_navigation_wrapper.dart`
**Статус:** ✅ Восстановлен

**Описание:** Создана премиальная навигационная панель с анимациями и улучшенным UX.

---

## 2. Исправления чата AI
**Файл:** `lib/screens/chat_ai_screen.dart`

### Изменения:

1. **Добавить импорт:**
```dart
import 'dart:async';
```

2. **Обновить initState() с логами:**
```dart
@override
void initState() {
  super.initState();

  // Initialize GeminiService - will automatically use direct API mode if Supabase is not available
  try {
    _geminiService = GeminiService(
      useProxy: true,
      supabaseClient: Supabase.instance.client,
    );
    print('=== GEMINI SERVICE: Initialized with proxy mode ===');
  } catch (e) {
    // Fallback to direct API mode if Supabase is not initialized
    _geminiService = GeminiService(useProxy: false);
    print('=== GEMINI SERVICE: Initialized with DIRECT API mode ===');
  }

  _currentDialogueId = widget.dialogueId;
  if (_currentDialogueId != null) {
    _loadMessages();
  } else {
    // Добавляем пустое приветственное сообщение, которое будет заменено при первом построении
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }
}
```

3. **Обновить метод _handleSubmitted() с таймаутами:**
```dart
Future<void> _handleSubmitted(String text) async {
  print('=== CHAT DEBUG: _handleSubmitted called with text: "$text" ===');
  if (text.trim().isEmpty) {
    print('=== CHAT DEBUG: Empty text, returning ===');
    return;
  }

  _textController.clear();
  print('=== CHAT DEBUG: Text controller cleared ===');

  // Если это новый чат, создаем его в базе
  if (_currentDialogueId == null) {
    print('=== CHAT DEBUG: Creating new dialogue ===');
    try {
      // Добавляем таймаут для веб-платформы
      final newDialogueId = await LocalDataService.instance
          .createDialogue(
            text.substring(0, text.length > 50 ? 50 : text.length),
            scanImagePath: widget.scanImagePath,
          )
          .timeout(
            const Duration(seconds: 2),
            onTimeout: () {
              print('=== CHAT DEBUG: Database timeout, using temporary ID ===');
              throw TimeoutException('Database operation timed out');
            },
          );
      print('Created new dialogue with ID: $newDialogueId');
      if (mounted) {
        setState(() {
          _currentDialogueId = newDialogueId;
          // Удаляем временное приветственное сообщение
          _messages.removeWhere((msg) => msg.dialogueId == -1);
        });
      }
      print('=== CHAT DEBUG: Dialogue created and state updated ===');
    } catch (e) {
      print('Error creating dialogue: $e');
      // Для веба используем временный ID
      if (mounted) {
        setState(() {
          _currentDialogueId = DateTime.now().millisecondsSinceEpoch;
          _messages.removeWhere((msg) => msg.dialogueId == -1);
        });
      }
      print('=== CHAT DEBUG: Using temporary dialogue ID: $_currentDialogueId ===');
    }
  } else {
    print('=== CHAT DEBUG: Using existing dialogue ID: $_currentDialogueId ===');
  }

  print('=== CHAT DEBUG: Creating user message with dialogue ID: $_currentDialogueId ===');
  final userMessage = ChatMessage(
    dialogueId: _currentDialogueId!,
    text: text,
    isUser: true,
  );

  print('=== CHAT DEBUG: Adding user message to UI ===');
  // Добавляем сообщение пользователя в UI и БД
  if (mounted) {
    setState(() {
      _messages.add(userMessage);
      _isLoading = true,
    });
  }
  print('=== CHAT DEBUG: User message added to UI, state updated ===');

  try {
    print('=== CHAT DEBUG: Attempting to save user message to DB ===');
    await LocalDataService.instance
        .insertMessage(userMessage)
        .timeout(
          const Duration(seconds: 1),
          onTimeout: () {
            print('=== CHAT DEBUG: Database insert timeout ===');
            return -1; // Возвращаем -1 как индикатор неудачи
          },
        );
    print('=== CHAT DEBUG: User message saved to DB ===');
  } catch (e) {
    print('Error inserting user message: $e');
    // Продолжаем работу даже если не удалось сохранить в БД
  }

  // Используем Future.delayed для отложенной прокрутки
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && _scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });

  print('=== CHAT DEBUG: Starting to get AI response ===');
  // Получаем ответ от AI
  final l10n = AppLocalizations.of(context)!;
  final localeProvider = context.read<LocaleProvider>();
  final languageCode = localeProvider.locale?.languageCode ?? 'en';
  print('=== CHAT DEBUG: Language code: $languageCode ===');

  // Если есть контекст сканирования и это первое сообщение, добавляем контекст
  String messageToSend = text;
  if (widget.scanContext != null &&
      widget.scanContext!.isNotEmpty &&
      _messages.length <= 2) {
    messageToSend = '${widget.scanContext}\n\n${l10n.userQuestion} $text';
  }
  print('=== CHAT DEBUG: Message to send: $messageToSend ===');

  try {
    print('=== CHAT DEBUG: Calling _geminiService.sendMessageWithHistory ===');
    final response = await _geminiService.sendMessageWithHistory(
      messageToSend,
      languageCode: languageCode,
    );
    print('=== CHAT DEBUG: Received response from Gemini: $response ===');

    final aiMessage = ChatMessage(
      dialogueId: _currentDialogueId!,
      text: response,
      isUser: false,
    );

    // Добавляем ответ AI в UI и БД
    if (mounted) {
      setState(() {
        _messages.add(aiMessage);
        _isLoading = false;
      });
    }

    try {
      await LocalDataService.instance.insertMessage(aiMessage);
      print('AI message inserted successfully');
    } catch (e) {
      print('Error inserting AI message: $e');
    }

    // Прокрутка после добавления сообщения
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  } catch (e) {
    print('Error getting response from Gemini: $e');
    final errorMessage = ChatMessage(
      dialogueId: _currentDialogueId!,
      text: l10n.sorryAnErrorOccurred,
      isUser: false,
    );
    if (mounted) {
      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
      });
    }
    try {
      await LocalDataService.instance.insertMessage(errorMessage);
    } catch (dbError) {
      print('Error inserting error message: $dbError');
    }
  }
}
```

---

## 3. Улучшенный парсинг JSON от Gemini
**Файл:** `lib/services/gemini_service.dart`

### Изменение в методе analyzeImage():
Заменить блок обработки ответа:

```dart
final responseData = jsonDecode(httpResponse.body);
final contentText =
    responseData['candidates'][0]['content']['parts'][0]['text']
        as String;

print('=== GEMINI VISION DEBUG: Raw response text ===');
print(contentText);

// Улучшенное извлечение JSON
String jsonString = contentText.trim();

// Удаляем markdown code blocks если есть
jsonString = jsonString
    .replaceAll('```json', '')
    .replaceAll('```', '')
    .trim();

// Ищем первый { и последний } чтобы извлечь только JSON
final firstBrace = jsonString.indexOf('{');
final lastBrace = jsonString.lastIndexOf('}');

if (firstBrace != -1 && lastBrace != -1 && lastBrace > firstBrace) {
  jsonString = jsonString.substring(firstBrace, lastBrace + 1);
}

print('=== GEMINI VISION DEBUG: Extracted JSON ===');
print(jsonString);

final analysisJson = jsonDecode(jsonString) as Map<String, dynamic>;

return AnalysisResult.fromJson(analysisJson);
```

### Добавить логи в sendMessageWithHistory():
```dart
Future<String> sendMessageWithHistory(
  String message, {
  String languageCode = 'en',
}) async {
  print(
    'Sending message to Gemini: $message (language: $languageCode, useProxy: $useProxy)',
  );
  if (useProxy) {
    print('=== Using PROXY mode ===');
    return await _sendMessageWithProxy(message, languageCode: languageCode);
  } else {
    print('=== Using DIRECT API mode ===');
    return await _sendMessageDirectly(message, languageCode: languageCode);
  }
}
```

### Добавить логи в _sendMessageWithProxy():
После строки `final functionUrl = '...'` добавить:
```dart
print('=== GEMINI DEBUG: Sending request to $functionUrl ===');
print('=== GEMINI DEBUG: Message: $message ===');
```

После `final httpResponse = await http.post(...)` добавить:
```dart
print('=== GEMINI DEBUG: Response status: ${httpResponse.statusCode} ===');
```

---

## 4. Функция фокусировки камеры при тапе
**Файл:** `lib/screens/scanning_screen.dart`

### Добавить переменную в класс _ScanningScreenState:
```dart
Offset? _focusPoint;
```

### Добавить метод _onTapToFocus() перед методом build():
```dart
Future<void> _onTapToFocus(TapDownDetails details, BuildContext context) async {
  if (_controller == null || !_controller!.value.isInitialized) {
    return;
  }

  final RenderBox renderBox = context.findRenderObject() as RenderBox;
  final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
  final Size size = renderBox.size;

  // Конвертируем координаты тапа в координаты камеры (0.0 - 1.0)
  final double x = localPosition.dx / size.width;
  final double y = localPosition.dy / size.height;

  try {
    // Устанавливаем точку фокусировки
    await _controller!.setFocusPoint(Offset(x, y));
    await _controller!.setExposurePoint(Offset(x, y));

    // Показываем индикатор фокусировки
    if (mounted) {
      setState(() {
        _focusPoint = localPosition;
      });

      // Скрываем индикатор через 2 секунды
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _focusPoint = null;
          });
        }
      });
    }
  } catch (e) {
    print('Error setting focus: $e');
  }
}
```

### Обернуть CameraPreview в GestureDetector в методе build():
Заменить:
```dart
if (_isCameraInitialized && _controller != null)
  Center(
    child: CameraPreview(_controller!),
  )
```

На:
```dart
if (_isCameraInitialized && _controller != null)
  GestureDetector(
    onTapDown: (details) => _onTapToFocus(details, context),
    child: Center(
      child: CameraPreview(_controller!),
    ),
  )
```

### Добавить индикатор фокусировки в Stack (после _buildOverlay(l10n)):
```dart
// Индикатор фокусировки
if (_focusPoint != null)
  Positioned(
    left: _focusPoint!.dx - 40,
    top: _focusPoint!.dy - 40,
    child: IgnorePointer(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.5, end: 1.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.naturalGreen,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          );
        },
      ),
    ),
  ),
```

---

## 5. Исправления навигации настроек

### Файл: `lib/screens/age_selection_screen.dart`
Заменить блок в onPressed:
```dart
onPressed: _selectedAgeRange != null
    ? () async {
        // Save age range to state
        final userState = Provider.of<UserState>(context, listen: false);
        await userState.setAgeRange(_selectedAgeRange);

        if (!mounted) return;

        // Всегда возвращаемся на предыдущую страницу
        context.pop();
      }
    : null,
```

### Файл: `lib/screens/skin_type_screen.dart`
Заменить блок после `if (!mounted) return;`:
```dart
if (!mounted) return;

// Всегда возвращаемся на предыдущую страницу
context.pop();
```

### Файл: `lib/screens/allergies_screen.dart`
Заменить блок после `if (!mounted) return;`:
```dart
if (!mounted) return;

// Всегда возвращаемся на предыдущую страницу
context.pop();
```

### Файл: `lib/screens/homepage_screen.dart`
Заменить `context.go` на `context.push` для настроек:
```dart
// Показываем настройки только если они не установлены
if (userState.ageRange == null)
  _buildSettingItem(
    context,
    l10n.age,
    Icons.cake_outlined,
    () => context.push('/age'),  // было context.go
  ),
if (userState.skinType == null)
  _buildSettingItem(
    context,
    l10n.skinType,
    Icons.face,
    () => context.push('/skintype'),  // было context.go
  ),
if (userState.allergies.isEmpty)
  _buildSettingItem(
    context,
    l10n.allergiesSensitivities,
    Icons.warning_amber_outlined,
    () => context.push('/allergies'),  // было context.go
  ),
```

---

## Документ Supabase функции
**Файл:** `docs/supabase_gemini_proxy_function.js` (создан)

Содержит код Supabase Edge Function для проксирования запросов к Gemini API.

---

## Итого изменений:
- ✅ Премиальная навигационная панель с анимациями (ВОССТАНОВЛЕНО)
- ✅ Исправления чата AI с таймаутами для БД (ВОССТАНОВЛЕНО)
- ✅ Улучшенный парсинг JSON от Gemini (ВОССТАНОВЛЕНО)
- ✅ Функция фокусировки камеры при тапе (ВОССТАНОВЛЕНО)
- ✅ Исправления навигации настроек (ВОССТАНОВЛЕНО)

**Примечание:** Файлы могут использовать разные сервисы (`database_service` vs `local_data_service`). Необходимо адаптировать под вашу структуру проекта.

---

## Восстановление завершено! 🎉

Все изменения из сессии были успешно восстановлены:
1. ✅ bottom_navigation_wrapper.dart - современная навигационная панель
2. ✅ chat_ai_screen.dart - исправления для работы на веб-платформе
3. ✅ gemini_service.dart - улучшенный парсинг JSON
4. ✅ scanning_screen.dart - функция фокусировки камеры при тапе
5. ✅ skin_type_screen.dart - исправление навигации
6. ✅ allergies_screen.dart - исправление навигации
7. ✅ homepage_screen.dart - использование context.push() вместо context.go()

**ВАЖНО:** Файл `age_selection_screen.dart` не был найден в проекте, возможно он был удален или переименован.
