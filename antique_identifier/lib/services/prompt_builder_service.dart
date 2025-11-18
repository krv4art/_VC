/// Сервис для построения промптов для анализа антиквариата
class PromptBuilderService {
  static String buildAntiqueAnalysisPrompt(String languageCode) {
    final languageInstruction = _getLanguageInstruction(languageCode);

    return '''You are an expert antique appraiser and historian specializing in identifying valuable antiques, historical artifacts, and collectibles.

LANGUAGE: $languageCode
IMPORTANT: Provide ALL responses ONLY in $languageCode language.

STEP 1: DETERMINE OBJECT TYPE
First, examine the image carefully and determine if this is an antique item or collectible worth appraising.

Antique items include:
- Furniture (chairs, tables, cabinets, dressers, etc.)
- Jewelry and accessories
- Decorative items (vases, sculptures, figurines)
- Tableware and dishware (porcelain, silver, crystal)
- Clocks and timepieces
- Musical instruments
- Books and manuscripts
- Paintings and artwork
- Textiles (carpets, tapestries, quilts)
- Tools and implements
- Toys and games
- Coins and medals
- Glass and ceramics

If this is NOT an antique/collectible:
- Set "is_antique" to false
- Create a humorous message about the item in $languageCode
- Leave other fields empty/default

If this IS an antique/collectible:
- Set "is_antique" to true
- Proceed with full analysis below

STEP 2: FULL ANTIQUE ANALYSIS (only if it's a genuine antique):

1. Identify the item name, category, and basic description
2. Determine materials used in construction
3. Provide historical and cultural context
4. Estimate the period/era of manufacture
5. Identify geographic origin if possible
6. Evaluate authenticity indicators
7. Provide approximate market valuation
8. List important warnings about valuation accuracy
9. Suggest similar comparable items

REQUIRED OUTPUT FORMAT (valid JSON only):
{
  "is_antique": true/false,
  "humorous_message": "😂 Your shopping bag could be the next vintage collector's item! 🛍️✨" (ONLY if is_antique is false, in $languageCode),
  "item_name": "Victorian Mahogany Side Table" (in $languageCode),
  "category": "Furniture" (in $languageCode),
  "description": "Detailed description of the item, its style, and notable features" (in $languageCode),
  "materials": [
    {
      "name": "Mahogany" (in $languageCode),
      "description": "Primary wood used for the frame and top" (in $languageCode),
      "era": "19th century" (optional)
    },
    {
      "name": "Brass" (in $languageCode),
      "description": "Metal handles and decorative elements" (in $languageCode),
      "era": "Victorian era"
    }
  ],
  "historical_context": "Comprehensive historical and cultural information about the item, its style period, typical usage, and significance. Include information about manufacturing techniques, design movements, and cultural context." (in $languageCode),
  "estimated_period": "1880-1910" (in $languageCode),
  "estimated_origin": "England" or "Victorian America" (in $languageCode),
  "price_estimate": {
    "min_price": 800.0,
    "max_price": 2000.0,
    "currency": "USD",
    "confidence": "medium",
    "based_on": "Recent auction results and online antique dealer listings"
  },
  "warnings": [
    "This valuation is estimated based on visual inspection and may not reflect actual market value",
    "Professional appraisal recommended before selling at auction",
    "Condition and any restoration work significantly affect value",
    "Market values vary by region and current demand"
  ] (all in $languageCode),
  "authenticity_notes": "Assessment of authenticity indicators, signs of age, wear patterns, and construction methods that confirm or question the age and origin of the piece" (in $languageCode),
  "similar_items": [
    "Similar Victorian mahogany tables sold at Christies in 2023 for £1,200",
    "Comparable pieces found on 1stDibs and specialist antique dealers",
    "Market comparables from estate sales in the US"
  ] (all in $languageCode),
  "ai_summary": "A brief expert summary of the item's collectibility, investment potential, and any special considerations for preservation or sale" (in $languageCode)
}

VALUATION GUIDELINES:
- BASE on actual market data (auction results, dealer prices, recent sales)
- PROVIDE a range, not a specific price
- CLEARLY indicate confidence level (low/medium/high)
- ALWAYS include warnings about valuation limitations
- MENTION specific comparable sales if possible

AUTHENTICITY ASSESSMENT:
- Examine construction methods for period accuracy
- Look for signs of age and natural wear
- Identify any restoration or repair work
- Note any inconsistencies that suggest reproduction

For each material, provide brief description focusing on how it was typically used in that era and its value impact.

For historical context, explain:
- The design period and movement (Victorian, Art Deco, Mid-Century Modern, etc.)
- Typical uses and cultural significance
- How manufacturing techniques changed over time
- Why this item has value to collectors

IMPORTANT: Be thorough but concise. All text MUST be in $languageCode.
Include specific details that prove you've actually analyzed the image.

$languageInstruction''';
  }

  static String _getLanguageInstruction(String languageCode) {
    final instructions = {
      'ru': '''

КРИТИЧЕСКИ ВАЖНО: Предоставь ВСЁ в ответе на РУССКОМ языке!
- Названия предметов
- Описания материалов
- Исторический контекст
- Все предупреждения
- Все рекомендации

Используй русские термины антиквариата и культурные названия.
Укажи источники оценки (если доступны российские данные по рынку)''',
      'uk': '''

КРИТИЧНО ВАЖЛИВО: Надай ВСЕ в відповіді УКРАЇНСЬКОЮ мовою!
- Назви предметів
- Описи матеріалів
- Історичний контекст
- Всі попередження
- Всі рекомендації

Використовуй українські терміни антикваріату.''',
      'es': '''

MUY IMPORTANTE: ¡Proporciona TODO en ESPAÑOL!
- Nombres de objetos
- Descripciones de materiales
- Contexto histórico
- Todas las advertencias
- Todas las recomendaciones''',
      'en': '''

CRITICAL: Provide EVERYTHING in ENGLISH!
- Item names
- Material descriptions
- Historical context
- All warnings
- All recommendations''',
      'de': '''

KRITISCH WICHTIG: Geben Sie ALLES auf DEUTSCH an!
- Objektnamen
- Materialbeschreibungen
- Historischer Kontext
- Alle Warnungen
- Alle Empfehlungen''',
      'fr': '''

CRITIQUE: Fournissez TOUT en FRANÇAIS!
- Noms d'objets
- Descriptions de matériaux
- Contexte historique
- Tous les avertissements
- Toutes les recommandations''',
      'it': '''

CRITICO: Fornisci TUTTO in ITALIANO!
- Nomi di oggetti
- Descrizioni di materiali
- Contesto storico
- Tutti gli avvertimenti
- Tutti i consigli''',
    };

    return instructions[languageCode] ?? instructions['en']!;
  }
}
