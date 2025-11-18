import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/supabase_constants.dart';
import 'screenshot_mode/screenshot_mode_app.dart';

/// Точка входа для режима создания скриншотов
///
/// Запуск:
/// flutter run -d windows -t lib/screenshot_mode_main.dart --dart-define=LOCALE=en
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase (необходимо для HomePage)
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl.isNotEmpty
        ? SupabaseConfig.supabaseUrl
        : (kDebugMode
            ? SupabaseConfig.devSupabaseUrl
            : SupabaseConfig.prodSupabaseUrl),
    anonKey: SupabaseConfig.supabaseAnonKey.isNotEmpty
        ? SupabaseConfig.supabaseAnonKey
        : (kDebugMode
            ? SupabaseConfig.devSupabaseAnonKey
            : SupabaseConfig.prodSupabaseAnonKey),
  );

  // Получаем локаль из параметров запуска
  const String locale = String.fromEnvironment('LOCALE');

  runApp(
    ScreenshotModeApp(
      initialLocale: locale.isEmpty ? null : locale,
    ),
  );
}
