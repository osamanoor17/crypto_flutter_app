// lib/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class ApiService {
  final String baseUrl = 'https://api.coingecko.com/api/v3/coins/markets';

  Future<List<Crypto>> fetchCryptos() async {
    final response = await http.get(Uri.parse('$baseUrl?vs_currency=usd'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => Crypto.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load cryptocurrencies');
    }
  }
}
