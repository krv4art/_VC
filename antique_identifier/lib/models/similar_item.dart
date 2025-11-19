/// Модель для похожих предметов, найденных онлайн
class SimilarItem {
  final String title;
  final String? imageUrl;
  final double? price;
  final String? currency;
  final String source; // 'ebay', 'etsy', 'google_shopping', etc.
  final String? sourceUrl;
  final String? condition;
  final String? seller;

  SimilarItem({
    required this.title,
    this.imageUrl,
    this.price,
    this.currency = 'USD',
    required this.source,
    this.sourceUrl,
    this.condition,
    this.seller,
  });

  factory SimilarItem.fromJson(Map<String, dynamic> json) {
    return SimilarItem(
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      source: json['source'] as String? ?? 'unknown',
      sourceUrl: json['sourceUrl'] as String?,
      condition: json['condition'] as String?,
      seller: json['seller'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'currency': currency,
      'source': source,
      'sourceUrl': sourceUrl,
      'condition': condition,
      'seller': seller,
    };
  }

  String get formattedPrice {
    if (price == null) return 'N/A';
    final currencySymbol = _getCurrencySymbol(currency ?? 'USD');
    return '$currencySymbol${price!.toStringAsFixed(2)}';
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode.toUpperCase()) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'RUB':
        return '₽';
      case 'JPY':
        return '¥';
      default:
        return currencyCode;
    }
  }
}
