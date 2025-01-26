import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  // Fetch all coins with their prices
  static Future<List<dynamic>> fetchCoins({int page = 1, required int pageSize}) async {
    final response = await http.get(
      Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&page=$page'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchPriceHistory(String coinId) async {
    final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=7'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> prices = data['prices'];
      return prices.map((priceData) {
        return {
          'date': DateTime.fromMillisecondsSinceEpoch(priceData[0]),
          'close': priceData[1],
        };
      }).toList();
    } else {
      throw Exception('Failed to load price history');
    }
  }

  // Fetch details for a specific coin
  static Future<Map<String, dynamic>> fetchCoinDetails(String id) async {
    final url = '$_baseUrl/coins/$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch coin details');
    }
  }
}
