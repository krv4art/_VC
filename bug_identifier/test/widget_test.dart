// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:bug_identifier/main.dart';
import 'package:bug_identifier/providers/user_state.dart';
import 'package:bug_identifier/providers/auth_provider.dart';
import 'package:bug_identifier/providers/locale_provider.dart';
import 'package:bug_identifier/providers/theme_provider_v2.dart';
import 'package:bug_identifier/providers/ai_bot_provider.dart';
import 'package:bug_identifier/providers/subscription_provider.dart';
import 'package:bug_identifier/providers/chat_provider.dart';
import 'package:bug_identifier/services/gemini_service.dart';
import 'package:bug_identifier/services/storage_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserState()),
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProviderV2()),
          ChangeNotifierProvider(create: (context) => AiBotProvider()),
          ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
          ChangeNotifierProvider(create: (context) => ChatProvider()),
          Provider<GeminiService>(
            create: (context) =>
                GeminiService(useProxy: true, supabaseClient: null),
          ),
          Provider<StorageService>(create: (_) => StorageService()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the app builds and renders without errors
    expect(find.byType(MyApp), findsOneWidget);

    // Give the app time to execute timers (splash screen has a 2-second timer)
    // Wait 2.1 seconds for the timer to complete
    await tester.pump(const Duration(seconds: 3));
  });
}
