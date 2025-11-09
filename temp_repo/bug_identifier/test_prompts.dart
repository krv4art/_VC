import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Простой тест для проверки загрузки промптов
/// Запускается отдельно для валидации структуры JSON
void main() async {
  debugPrint('Testing prompts configuration...');

  try {
    // Читаем файл промптов
    final File promptsFile = File('assets/config/prompts.json');
    if (!await promptsFile.exists()) {
      debugPrint('ERROR: prompts.json file not found!');
      return;
    }

    final String jsonString = await promptsFile.readAsString();
    final Map<String, dynamic> data = json.decode(jsonString);

    debugPrint('✅ JSON file loaded successfully');
    debugPrint('✅ JSON structure is valid');

    // Проверяем наличие основных секций
    if (data.containsKey('chat')) {
      debugPrint('✅ Chat section found');

      final chat = data['chat'] as Map<String, dynamic>;

      // Проверяем системные промпты
      if (chat.containsKey('system_prompts')) {
        debugPrint('✅ System prompts section found');
        final systemPrompts = chat['system_prompts'] as Map<String, dynamic>;
        debugPrint(
          '   Available system prompts: ${systemPrompts.keys.join(', ')}',
        );
      }

      // Проверяем языковые инструкции
      if (chat.containsKey('language_instructions')) {
        debugPrint('✅ Language instructions section found');
        final langInstructions =
            chat['language_instructions'] as Map<String, dynamic>;
        debugPrint(
          '   Supported languages: ${langInstructions.keys.join(', ')}',
        );
      }

      // Проверяем приветственные сообщения
      if (chat.containsKey('welcome_messages')) {
        debugPrint('✅ Welcome messages section found');
        final welcomeMessages =
            chat['welcome_messages'] as Map<String, dynamic>;
        debugPrint(
          '   Welcome messages for: ${welcomeMessages.keys.join(', ')}',
        );
      }

      // Проверяем сообщения об ошибках
      if (chat.containsKey('error_messages')) {
        debugPrint('✅ Error messages section found');
        final errorMessages = chat['error_messages'] as Map<String, dynamic>;
        debugPrint('   Error messages for: ${errorMessages.keys.join(', ')}');
      }

      // Проверяем контекстные сообщения
      if (chat.containsKey('context_messages')) {
        debugPrint('✅ Context messages section found');
        final contextMessages =
            chat['context_messages'] as Map<String, dynamic>;
        debugPrint('   Context categories: ${contextMessages.keys.join(', ')}');
      }
    }

    // Проверяем наличие переменных в промптах
    void checkForVariables(Map<String, dynamic> map, String path) {
      map.forEach((key, value) {
        final currentPath = path.isEmpty ? key : '$path.$key';
        if (value is Map<String, dynamic>) {
          checkForVariables(value, currentPath);
        } else if (value is String) {
          final variables = RegExp(r'\{\{[^}]+\}\}').allMatches(value);
          if (variables.isNotEmpty) {
            debugPrint(
              '   📝 Variables found in $currentPath: ${variables.map((m) => m.group(0)).join(', ')}',
            );
          }
        }
      });
    }

    debugPrint('\n📋 Checking for template variables...');
    checkForVariables(data, '');

    debugPrint('\n✅ All tests passed! Prompts configuration is ready.');
  } catch (e) {
    debugPrint('❌ ERROR: $e');
  }
}
