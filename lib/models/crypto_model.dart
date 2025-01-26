class Crypto {
  String id;
  String symbol;
  String name;
  String image;
  int currentPrice;
  int marketCap;
  int marketCapRank;
  int fullyDilutedValuation;
  int totalVolume;
  int high24H;
  int low24H;
  double priceChange24H;
  double priceChangePercentage24H;
  int marketCapChange24H;
  double marketCapChangePercentage24H;
  int circulatingSupply;
  int totalSupply;
  int maxSupply;
  int ath;
  double athChangePercentage;
  DateTime athDate;
  double atl;
  double atlChangePercentage;
  DateTime atlDate;
  dynamic roi;
  DateTime lastUpdated;

  Crypto({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24H,
    required this.low24H,
    required this.priceChange24H,
    required this.priceChangePercentage24H,
    required this.marketCapChange24H,
    required this.marketCapChangePercentage24H,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.athChangePercentage,
    required this.athDate,
    required this.atl,
    required this.atlChangePercentage,
    required this.atlDate,
    required this.roi,
    required this.lastUpdated,
  });
}