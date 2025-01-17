
import 'package:flutter/material.dart';
import 'package:crypto_flutter_app/models/crypto_model.dart';
import 'crypto_graphs.dart';

class CryptoDetailsScreen extends StatelessWidget {
  final Crypto crypto;

  const CryptoDetailsScreen({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${crypto.name} Details'),
        backgroundColor: const Color.fromARGB(255, 51, 134, 109),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(crypto.image),
                  radius: 30,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Symbol: ${crypto.symbol.toUpperCase()}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Price: \$${crypto.currentPrice.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Price Trend (24h):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CryptoGraph(crypto: crypto),  // Graph showing price trend
            const SizedBox(height: 24),
            const Text(
              'Additional Details:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '24h Price Change: ${crypto.priceChange24h.toStringAsFixed(2)} USD',
              style: TextStyle(
                fontSize: 16,
                color: crypto.priceChange24h > 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Market Cap: \$${crypto.marketCap.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
