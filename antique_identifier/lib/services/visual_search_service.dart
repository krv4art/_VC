import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../models/similar_item.dart';

/// Сервис для поиска визуально похожих предметов онлайн
class VisualSearchService {
  static const String _supabaseUrl = 'https://yerbryysrnaraqmbhqdm.supabase.co';
  static const String _anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InllcmJyeXlzcm5hcmFxbWJocWRtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1OTYzNDYsImV4cCI6MjA0NzE3MjM0Nn0.ipERbuUJkhBK-SUtXWvgQXo_KrfLnpJFu_ZqsrVyxZg';

  /// Ищет похожие предметы используя AI с поиском в интернете
  Future<List<SimilarItem>> findSimilarItems({
    required String itemName,
    required String category,
    String? description,
    int maxResults = 5,
  }) async {
    try {
      developer.log(
        'Searching for similar items: $itemName ($category)',
        name: 'VisualSearchService',
      );

      final searchQuery = _buildSearchQuery(itemName, category, description);

      final prompt = '''
Find ${maxResults} similar antique items currently for sale online for: "$searchQuery"

Search the internet and return a JSON array with items found on eBay, Etsy, 1stDibs, or other marketplaces.

For each item, provide:
- title: Item title/name
- imageUrl: Direct URL to item image (if available)
- price: Numeric price value (extract from price string)
- currency: Currency code (USD, EUR, GBP, etc.)
- source: Platform name (ebay, etsy, 1stdibs, etc.)
- sourceUrl: Direct link to the listing
- condition: Item condition (new, used, vintage, etc.)
- seller: Seller name (if available)

Return ONLY a valid JSON array, nothing else. Example:
[
  {
    "title": "Victorian Oak Table 1880s",
    "imageUrl": "https://...",
    "price": 450.00,
    "currency": "USD",
    "source": "ebay",
    "sourceUrl": "https://ebay.com/...",
    "condition": "Used - Excellent",
    "seller": "AntiqueDealer123"
  }
]

If no items found, return empty array: []
''';

      final response = await http.post(
        Uri.parse('$_supabaseUrl/functions/v1/gemini-vision-proxy'),
        headers: {
          'Authorization': 'Bearer $_anonKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
          'useSearch': true, // Enable web search
        }),
      ).timeout(const Duration(seconds: 30));

      developer.log(
        'Visual search response status: ${response.statusCode}',
        name: 'VisualSearchService',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['text'] as String?;

        if (text == null || text.isEmpty) {
          developer.log('Empty response from visual search', name: 'VisualSearchService');
          return [];
        }

        // Extract JSON from response
        final jsonMatch = _extractJson(text);
        if (jsonMatch == null) {
          developer.log('No JSON found in response', name: 'VisualSearchService');
          return [];
        }

        final List<dynamic> itemsJson = jsonDecode(jsonMatch) as List<dynamic>;
        final items = itemsJson
            .map((json) => SimilarItem.fromJson(json as Map<String, dynamic>))
            .toList();

        developer.log('Found ${items.length} similar items', name: 'VisualSearchService');
        return items;
      } else {
        developer.log(
          'Visual search failed: ${response.statusCode} - ${response.body}',
          name: 'VisualSearchService',
        );
        return [];
      }
    } catch (e, stackTrace) {
      developer.log(
        'Error finding similar items: $e',
        name: 'VisualSearchService',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Строит поисковый запрос из данных о предмете
  String _buildSearchQuery(String itemName, String category, String? description) {
    final parts = <String>[itemName];

    if (category.isNotEmpty && !itemName.toLowerCase().contains(category.toLowerCase())) {
      parts.add(category);
    }

    // Добавляем ключевое слово для поиска антиквариата
    parts.add('antique');

    return parts.join(' ');
  }

  /// Извлекает JSON из текстового ответа
  String? _extractJson(String text) {
    // Try to find JSON array
    final arrayMatch = RegExp(r'\[[\s\S]*\]').firstMatch(text);
    if (arrayMatch != null) {
      return arrayMatch.group(0);
    }

    // Try to find JSON object
    final objectMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (objectMatch != null) {
      return objectMatch.group(0);
    }

    return null;
  }

  /// Получает прямую ссылку на поиск в eBay
  String getEbaySearchUrl(String itemName, String category) {
    final query = Uri.encodeComponent('$itemName $category antique');
    return 'https://www.ebay.com/sch/i.html?_nkw=$query&_sop=12'; // Sort by price+shipping: lowest
  }

  /// Получает прямую ссылку на поиск в Etsy
  String getEtsySearchUrl(String itemName, String category) {
    final query = Uri.encodeComponent('$itemName $category antique vintage');
    return 'https://www.etsy.com/search?q=$query';
  }

  /// Получает прямую ссылку на поиск в 1stDibs
  String get1stDibsSearchUrl(String itemName, String category) {
    final query = Uri.encodeComponent('$itemName $category');
    return 'https://www.1stdibs.com/search/?q=$query';
  }
}
