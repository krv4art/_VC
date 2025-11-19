import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/maker_mark.dart';

/// Сервис для распознавания клейм производителей
class MarksRecognitionService {
  static const String _supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1OTYzNDYsImV4cCI6MjA0NzE3MjM0Nn0.ipERbuUJkhBK-SUtXWvgQXo_KrfLnpJFu_ZqsrVyxZg';

  /// Распознает клеймо на изображении
  Future<MakerMark?> recognizeMark(String imagePath) async {
    try {
      developer.log('Recognizing maker mark from image', name: 'MarksRecognitionService');

      // Читаем изображение
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final prompt = '''
Analyze this image and identify any maker's marks, hallmarks, or signatures visible.

If you find a maker's mark, provide the following information in JSON format:
{
  "id": "unique_id",
  "name": "Manufacturer name",
  "category": "pottery/silver/furniture/porcelain/etc",
  "description": "Detailed description of the mark",
  "period": "Time period when this mark was used",
  "country": "Country of origin",
  "keywords": ["keyword1", "keyword2"],
  "additionalInfo": "Any additional relevant information"
}

If no maker's mark is found, return: {"error": "No maker's mark identified"}

Important: Return ONLY valid JSON, nothing else.
''';

      final response = await http.post(
        Uri.parse('$_supabaseUrl/functions/v1/gemini-vision-proxy'),
        headers: {
          'Authorization': 'Bearer $_anonKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
          'prompt': prompt,
        }),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['text'] as String?;

        if (text == null || text.isEmpty) {
          developer.log('Empty response', name: 'MarksRecognitionService');
          return null;
        }

        // Extract JSON from response
        final jsonMatch = _extractJson(text);
        if (jsonMatch == null) {
          developer.log('No JSON found in response', name: 'MarksRecognitionService');
          return null;
        }

        final markJson = jsonDecode(jsonMatch) as Map<String, dynamic>;

        if (markJson.containsKey('error')) {
          developer.log('No mark identified', name: 'MarksRecognitionService');
          return null;
        }

        final mark = MakerMark.fromJson(markJson);
        developer.log('Mark identified: ${mark.name}', name: 'MarksRecognitionService');
        return mark;
      } else {
        developer.log(
          'Recognition failed: ${response.statusCode}',
          name: 'MarksRecognitionService',
        );
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error recognizing mark: $e',
        name: 'MarksRecognitionService',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Извлекает JSON из текста
  String? _extractJson(String text) {
    final objectMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (objectMatch != null) {
      return objectMatch.group(0);
    }
    return null;
  }

  /// Поиск клейма в базе данных
  Future<List<MakerMark>> searchMarks(String query) async {
    // TODO: Implement database search when marks database is populated
    // For now, return empty list
    return [];
  }

  /// Получает все клейма определенной категории
  Future<List<MakerMark>> getMarksByCategory(String category) async {
    // TODO: Implement when marks database is populated
    return [];
  }

  /// Получает популярные клейма
  Future<List<MakerMark>> getPopularMarks() async {
    // Возвращаем базовые популярные клейма
    return _getBuiltInMarks();
  }

  /// Встроенная база популярных клейм
  List<MakerMark> _getBuiltInMarks() {
    return [
      MakerMark(
        id: 'meissen',
        name: 'Meissen',
        category: 'porcelain',
        description: 'Famous crossed swords mark from Meissen porcelain manufactory',
        period: '1722-present',
        country: 'Germany',
        keywords: ['crossed swords', 'blue mark', 'porcelain'],
        additionalInfo: 'One of the oldest porcelain manufacturers in Europe',
      ),
      MakerMark(
        id: 'wedgwood',
        name: 'Wedgwood',
        category: 'pottery',
        description: 'Wedgwood pottery mark, typically shows company name',
        period: '1759-present',
        country: 'England',
        keywords: ['wedgwood', 'pottery', 'jasperware'],
        additionalInfo: 'Famous for jasperware and bone china',
      ),
      MakerMark(
        id: 'tiffany',
        name: 'Tiffany & Co.',
        category: 'silver',
        description: 'Tiffany & Co. sterling silver hallmark',
        period: '1837-present',
        country: 'USA',
        keywords: ['tiffany', 'sterling', '925', 'silver'],
        additionalInfo: 'Luxury American jewelry and silverware company',
      ),
      MakerMark(
        id: 'royal_copenhagen',
        name: 'Royal Copenhagen',
        category: 'porcelain',
        description: 'Three wavy lines mark of Royal Copenhagen',
        period: '1775-present',
        country: 'Denmark',
        keywords: ['three waves', 'blue mark', 'danish porcelain'],
        additionalInfo: 'Famous Danish porcelain manufacturer',
      ),
      MakerMark(
        id: 'limoges',
        name: 'Limoges',
        category: 'porcelain',
        description: 'Limoges porcelain marks, various manufacturers',
        period: '1771-present',
        country: 'France',
        keywords: ['limoges', 'french porcelain', 'france'],
        additionalInfo: 'Region famous for fine porcelain production',
      ),
      MakerMark(
        id: 'royal_doulton',
        name: 'Royal Doulton',
        category: 'pottery',
        description: 'Royal Doulton pottery and porcelain mark',
        period: '1815-present',
        country: 'England',
        keywords: ['doulton', 'royal', 'pottery', 'ceramics'],
        additionalInfo: 'English ceramic and home accessories manufacturer',
      ),
      MakerMark(
        id: 'herend',
        name: 'Herend',
        category: 'porcelain',
        description: 'Herend porcelain manufactory mark with crown',
        period: '1826-present',
        country: 'Hungary',
        keywords: ['herend', 'hungarian', 'crown', 'porcelain'],
        additionalInfo: 'Luxury Hungarian porcelain manufacturer',
      ),
      MakerMark(
        id: 'gorham',
        name: 'Gorham',
        category: 'silver',
        description: 'Gorham Manufacturing Company silver mark',
        period: '1831-present',
        country: 'USA',
        keywords: ['gorham', 'sterling', 'silver', 'lion anchor'],
        additionalInfo: 'American silver manufacturer, famous for sterling silver',
      ),
    ];
  }
}
