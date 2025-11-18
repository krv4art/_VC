import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://yerbryysrnaraqmbhqdm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk',
  );

  final client = Supabase.instance.client;

  print('=== Testing Supabase Poll Functions ===\n');

  // Тест 1: get_poll_data с TEXT device_id
  print('Test 1: Calling get_poll_data with text device_id...');
  try {
    final result = await client.rpc('get_poll_data', params: {
      'p_device_id': 'test_device_12345',
      'p_language_code': 'en',
    });
    print('✅ SUCCESS: get_poll_data returned data');
    print('   Options count: ${(result['options'] as List).length}');
    print('   Votes count: ${(result['votes'] as List).length}');
    print('   Remaining votes: ${result['remaining_votes']}');
  } catch (e) {
    print('❌ ERROR: $e');
  }

  print('\n');

  // Тест 2: Проверка таблицы poll_votes
  print('Test 2: Querying poll_votes table...');
  try {
    final votes = await client
        .from('poll_votes')
        .select()
        .limit(3);
    print('✅ SUCCESS: Retrieved ${votes.length} votes from poll_votes');
    for (var vote in votes) {
      print('   Vote: device_id="${vote['device_id']}" (type: ${vote['device_id'].runtimeType})');
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }

  print('\n');

  // Тест 3: Проверка таблицы poll_options
  print('Test 3: Querying poll_options with translations...');
  try {
    final options = await client
        .from('poll_options')
        .select('id, vote_count, poll_option_translations!inner(text, language_code)')
        .eq('poll_option_translations.language_code', 'en')
        .limit(3);
    print('✅ SUCCESS: Retrieved ${options.length} options');
    for (var option in options) {
      final translations = option['poll_option_translations'] as List;
      final text = translations.isNotEmpty ? translations[0]['text'] : 'N/A';
      print('   Option: "$text" (votes: ${option['vote_count']})');
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }

  print('\n=== Tests completed ===');
}
