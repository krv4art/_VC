# Phase 3: Provider Integration - Quick Reference

## Files Created

| File | Lines | Purpose |
|------|-------|---------|
| `chat_state.dart` | 102 | State classes (ChatUIState, ChatDataState, ChatOperationsState) |
| `chat_messages_notifier.dart` | 91 | Messages state management |
| `chat_ui_notifier.dart` | 73 | UI state management (loading, animations, visibility) |
| `chat_operations_notifier.dart` | 78 | Operations state (async tracking, rate limiting) |
| `chat_provider.dart` | 138 | Main provider orchestrating all notifiers |
| `chat_ai_screen_v2.dart` | 320 | Example implementation |
| **Total** | **802** | All new provider infrastructure |

---

## Architecture Overview

```
ChatProvider (Main Facade)
├── ChatMessagesNotifier
│   ├── messages: List<ChatMessage>
│   ├── currentDialogueId: int?
│   └── linkedScanResult: ScanResult?
│
├── ChatUINotifier
│   ├── isLoading: bool
│   ├── showDisclaimer: bool
│   ├── avatarState: AvatarAnimationState
│   ├── isInputEnabled: bool
│   └── errorMessage: String?
│
└── ChatOperationsNotifier
    ├── isSendingMessage: bool
    ├── isLoadingMessages: bool
    ├── isLoadingScanResult: bool
    ├── lastMessageSentAt: DateTime?
    └── operationError: String?
```

---

## Common Usage Patterns

### Initialize in Widget

```dart
void initState() {
  super.initState();
  final chatProvider = context.read<ChatProvider>();
  chatProvider.initializeDialogue(widget.dialogueId);
}
```

### Build with Consumer

```dart
Consumer<ChatProvider>(
  builder: (context, chatProvider, _) {
    return ListView.builder(
      itemCount: chatProvider.messages.length,
      itemBuilder: (context, index) {
        return ChatMessageBubble(
          message: chatProvider.messages[index],
        );
      },
    );
  },
)
```

### Send Message

```dart
void _handleSubmit(String text) async {
  final provider = context.read<ChatProvider>();

  provider.addUserMessage(text);
  provider.setSendingMessage(true);

  try {
    final response = await geminiService.sendMessageWithHistory(text);
    provider.addBotMessage(response);
    provider.recordMessageSent();
  } catch (e) {
    provider.setError('Error: $e');
  }
}
```

### Check Operations Status

```dart
if (chatProvider.isSendingMessage) {
  return LoadingWidget();
}

if (chatProvider.errorMessage != null) {
  return ErrorWidget(chatProvider.errorMessage!);
}
```

### Rate Limiting

```dart
if (!chatProvider.operationsNotifier.canSendMessage()) {
  showSnackBar('Please wait...');
  return;
}
```

---

## State Classes

### ChatUIState
```dart
const ChatUIState({
  bool isLoading = false,
  bool showDisclaimer = true,
  AvatarAnimationState avatarState = AvatarAnimationState.speaking,
  bool isInputEnabled = true,
  String? errorMessage,
})
```

### ChatDataState
```dart
const ChatDataState({
  List<ChatMessage> messages = const [],
  int? currentDialogueId,
  ScanResult? linkedScanResult,
  AnalysisResult? linkedAnalysisResult,
})
```

### ChatOperationsState
```dart
const ChatOperationsState({
  bool isSendingMessage = false,
  bool isLoadingMessages = false,
  bool isLoadingScanResult = false,
  String? operationError,
  DateTime? lastMessageSentAt,
})
```

---

## Notifier Methods Quick Lookup

### ChatMessagesNotifier

| Method | Returns | Purpose |
|--------|---------|---------|
| `setDialogueId(int)` | void | Set current dialogue |
| `addMessage(ChatMessage)` | void | Add single message |
| `updateMessageAtIndex(int, ChatMessage)` | void | Update message at index |
| `updateMessageText(int, String)` | void | Update message text |
| `clearMessages()` | void | Clear all messages |
| `loadMessages(int)` | Future<bool> | Load from database |
| `setLinkedScanResult(scanResult, analysisResult)` | void | Set linked data |
| `getUserMessageCount()` | int | Count user messages |
| `clearState()` | void | Reset to initial |

### ChatUINotifier

| Method | Returns | Purpose |
|--------|---------|---------|
| `setLoading(bool)` | void | Set loading state |
| `setAvatarState(AvatarAnimationState)` | void | Update avatar |
| `dismissDisclaimer()` | void | Hide banner |
| `showDisclaimerBanner()` | void | Show banner |
| `setInputEnabled(bool)` | void | Enable/disable input |
| `setErrorMessage(String?)` | void | Set error |
| `clearError()` | void | Clear error |
| `updateUIState({...})` | void | Update multiple fields |
| `reset()` | void | Reset to initial |

### ChatOperationsNotifier

| Method | Returns | Purpose |
|--------|---------|---------|
| `setSendingMessage(bool)` | void | Set sending state |
| `setLoadingMessages(bool)` | void | Set loading state |
| `setLoadingScanResult(bool)` | void | Set scan loading |
| `setOperationError(String?)` | void | Set error |
| `clearError()` | void | Clear error |
| `recordMessageSent()` | void | Record timestamp |
| `canSendMessage(Duration)` | bool | Check rate limit |
| `updateOperationState({...})` | void | Update multiple fields |
| `reset()` | void | Reset to initial |

### ChatProvider (Facade)

| Method | Returns | Purpose |
|--------|---------|---------|
| `initializeDialogue(int)` | Future<bool> | Load dialogue |
| `loadScanResultById(int)` | Future<bool> | Load scan result |
| `addUserMessage(String)` | void | Add user message |
| `addBotMessage(String)` | void | Add bot message |
| `updateMessageText(int, String)` | void | Update message |
| `setLoading(bool)` | void | Set loading |
| `setAvatarState(AvatarAnimationState)` | void | Update avatar |
| `dismissDisclaimer()` | void | Hide banner |
| `setSendingMessage(bool)` | void | Set sending |
| `recordMessageSent()` | void | Record send time |
| `setError(String?)` | void | Set error |
| `clearError()` | void | Clear error |
| `reset()` | void | Reset all state |

---

## Properties Delegation

ChatProvider delegates these getters to sub-notifiers:

```dart
// From ChatMessagesNotifier
List<ChatMessage> get messages
int? get currentDialogueId
int get messageCount
ChatMessage? get lastMessage

// From ChatUINotifier
bool get isLoading
bool get showDisclaimer
AvatarAnimationState get avatarState
bool get isInputEnabled
String? get errorMessage

// From ChatOperationsNotifier
bool get isSendingMessage
bool get isLoadingMessages
bool get isAnyOperationInProgress
DateTime? get lastMessageSentAt
```

---

## Setup

### 1. Add Provider to Main App

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatProvider>(
          create: (_) => ChatProvider(),
        ),
        // ... other providers
      ],
      child: const MyApp(),
    ),
  );
}
```

### 2. Use in Your Screen

```dart
class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ChatProvider>().initializeDialogue(widget.dialogueId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return Scaffold(
          body: ChatMessageList(messages: chatProvider.messages),
        );
      },
    );
  }
}
```

---

## Best Practices

### DO ✅
- Use `context.read()` for one-time operations
- Use `Consumer` for reactive UI
- Keep providers focused
- Test notifiers separately
- Use immutable state
- Dispose resources

### DON'T ❌
- Modify state directly
- Use `watch()` in `initState()`
- Mix setState() with Provider
- Keep logic in widgets
- Forget to dispose
- Create many tiny providers

---

## Testing Quick Examples

### Unit Test Notifier

```dart
test('addMessage adds to list', () {
  final notifier = ChatMessagesNotifier();
  final msg = ChatMessage(dialogueId: 1, text: 'Hi', isUser: true);

  notifier.addMessage(msg);

  expect(notifier.messages.length, 1);
});
```

### Widget Test

```dart
testWidgets('ChatProvider updates messages', (tester) async {
  final provider = ChatProvider();

  await tester.pumpWidget(
    ChangeNotifierProvider<ChatProvider>(
      create: (_) => provider,
      child: MaterialApp(home: TestWidget()),
    ),
  );

  provider.addBotMessage('Hello');
  await tester.pump();

  expect(find.text('Hello'), findsOneWidget);
});
```

---

## Performance Tips

- 🚀 Limited to 50 cached animation controllers
- 🚀 Messages loaded on-demand from database
- 🚀 Efficient state updates with `copyWith()`
- 🚀 Built-in rate limiting
- 🚀 Separate notifiers = targeted rebuilds

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| ProviderNotFoundException | Wrap app in `MultiProvider` |
| Widget not updating | Use `Consumer` instead of `read()` |
| Memory leaks | Provider auto-disposes notifiers |
| Rate limit issues | Check `canSendMessage()` duration |
| State not persisting | Implement state restoration logic |

---

## File Locations

```
lib/providers/
├── chat_state.dart
├── chat_messages_notifier.dart
├── chat_ui_notifier.dart
├── chat_operations_notifier.dart
├── chat_provider.dart
└── ... (existing providers)

lib/screens/
├── chat_ai_screen_v2.dart (example)
└── ... (other screens)

docs/
├── PHASE_3_PROVIDER_INTEGRATION.md (detailed)
└── PHASE_3_QUICK_REFERENCE.md (this file)
```

---

## Summary

✨ **Phase 3 Complete:**
- ✅ 5 new provider files (482 lines)
- ✅ Complete example (chat_ai_screen_v2.dart)
- ✅ Comprehensive documentation
- ✅ Ready for production use

**Next:** Integrate into existing ChatAIScreen or migrate gradually screen-by-screen.

