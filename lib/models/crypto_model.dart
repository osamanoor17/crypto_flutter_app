class Crypto {
  final String id;
  final String name;
  final String image;
  final String symbol;
  final double currentPrice;
  final double priceChange24h;
  final double high24h;
  final double low24h;
  final double marketCap;
  final double priceChangePercentage24h;

  Crypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.image,
    required this.priceChange24h,
    required this.high24h,
    required this.low24h,
    required this.marketCap,
    required this.priceChangePercentage24h,
  });

  factory Crypto.fromJson(Map<String, dynamic> json) {
    return Crypto(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      currentPrice: json['current_price']?.toDouble() ?? 0.0,
      image: json['image'],
      priceChange24h: json['price_change_24h']?.toDouble() ?? 0.0,
      high24h: json['high_24h']?.toDouble() ?? 0.0,
      low24h: json['low_24h']?.toDouble() ?? 0.0,
      marketCap: json['market_cap']?.toDouble() ?? 0.0,
      priceChangePercentage24h: json['price_change_percentage_24h']?.toDouble() ?? 0.0,
    );
  }
}
