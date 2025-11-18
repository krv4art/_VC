import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Инициализация Supabase
  await Supabase.initialize(
    url: 'https://yerbryysrnaraqmbhqdm.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUwNjY4MTIsImV4cCI6MjA3MDY0MjgxMn0.jqAChRZ2f19chNlbl3PiAxydWkpnZSQhhEd6iLMiUyk',
  );

  final client = Supabase.instance.client;

  test('get_poll_data with text device_id', () async {
    print('=== Testing get_poll_data with text device_id ===');

    final result = await client.rpc('get_poll_data', params: {
      'p_device_id': 'test_device_12345',
      'p_language_code': 'en',
    });

    expect(result, isNotNull);
    expect(result['options'], isA<List>());
    expect(result['votes'], isA<List>());
    expect(result['remaining_votes'], isA<int>());

    print('✅ SUCCESS: get_poll_data works!');
    print('   Options count: ${(result['options'] as List).length}');
    print('   Votes count: ${(result['votes'] as List).length}');
    print('   Remaining votes: ${result['remaining_votes']}');
  });

  test('poll_votes table with text device_id', () async {
    print('\n=== Testing poll_votes table query ===');

    final votes = await client
        .from('poll_votes')
        .select()
        .limit(3);

    expect(votes, isA<List>());
    print('✅ SUCCESS: Retrieved ${votes.length} votes');

    if (votes.isNotEmpty) {
      for (var vote in votes) {
        print('   Vote: device_id="${vote['device_id']}" (type: ${vote['device_id'].runtimeType})');
      }
    }
  });

  test('poll_options with translations', () async {
    print('\n=== Testing poll_options with translations ===');

    final options = await client
        .from('poll_options')
        .select('id, vote_count, poll_option_translations!inner(text, language_code)')
        .eq('poll_option_translations.language_code', 'en')
        .limit(3);

    expect(options, isA<List>());
    expect(options.isNotEmpty, true);

    print('✅ SUCCESS: Retrieved ${options.length} options');
    for (var option in options) {
      final translations = option['poll_option_translations'] as List;
      final text = translations.isNotEmpty ? translations[0]['text'] : 'N/A';
      print('   Option: "$text" (votes: ${option['vote_count']})');
    }
  });
}
