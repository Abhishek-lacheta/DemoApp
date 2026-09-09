class CryptoAsset {
  const CryptoAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.priceChangePercent24h,
    required this.sparklinePrices,
  });

  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final double priceChangePercent24h;
  final List<double> sparklinePrices;

  bool get isPositive => priceChangePercent24h >= 0;

  CryptoAsset copyWith({
    String? id,
    String? symbol,
    String? name,
    String? imageUrl,
    double? currentPrice,
    double? priceChangePercent24h,
    List<double>? sparklinePrices,
  }) {
    return CryptoAsset(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      currentPrice: currentPrice ?? this.currentPrice,
      priceChangePercent24h:
          priceChangePercent24h ?? this.priceChangePercent24h,
      sparklinePrices: sparklinePrices ?? this.sparklinePrices,
    );
  }

  factory CryptoAsset.fromJson(Map<String, dynamic> json) {
    final sparkline = json['sparkline_in_7d'] as Map<String, dynamic>?;
    final prices = sparkline?['price'] as List<dynamic>? ?? [];
    final sparklinePrices = prices
        .map((e) => (e as num).toDouble())
        .toList();

    return CryptoAsset(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0,
      priceChangePercent24h:
          (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0,
      sparklinePrices: sparklinePrices,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'name': name,
        'image': imageUrl,
        'current_price': currentPrice,
        'price_change_percentage_24h': priceChangePercent24h,
        'sparkline_in_7d': {'price': sparklinePrices},
      };
}
