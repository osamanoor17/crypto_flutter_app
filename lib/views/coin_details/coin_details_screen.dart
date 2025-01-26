import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/api_service.dart';
import '../../models/coin_analysis_model.dart';

class CoinDetailsScreen extends StatelessWidget {
  final String coinId;

  const CoinDetailsScreen({super.key, required this.coinId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coin Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.fetchCoinDetails(coinId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final coin = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          coin['image']['large'],
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, size: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context,
                      title: coin['name'],
                      subtitle: 'Symbol: ${coin['symbol'].toUpperCase()}',
                      price:
                          'Current Price: \$${coin['market_data']['current_price']['usd']}',
                      marketCap:
                          'Market Cap: \$${coin['market_data']['market_cap']['usd']}',
                      change:
                          '24h Change: ${coin['market_data']['price_change_percentage_24h'].toStringAsFixed(2)}%',
                      changeColor:
                          coin['market_data']['price_change_percentage_24h'] > 0
                              ? Colors.green
                              : Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Description:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      coin['description']['en'] ??
                          '<p>No description available</p>',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Price History (Candlestick Chart):',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: ApiService.fetchPriceHistory(coinId),
                      builder: (context, priceHistorySnapshot) {
                        if (priceHistorySnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (priceHistorySnapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${priceHistorySnapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (!priceHistorySnapshot.hasData ||
                            priceHistorySnapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No price history available'));
                        } else {
                          List<List<double>> prices = [];
                          for (var data in priceHistorySnapshot.data!) {
                            prices.add([
                              data['date'].millisecondsSinceEpoch.toDouble(),
                              data['close']
                            ]);
                          }

                          CoinAnalysis coinAnalysis = CoinAnalysis(
                              prices: prices, marketCaps: [], totalVolumes: []);
                          List<FlSpot> spots = coinAnalysis.prices
                              .map((data) => FlSpot(data[0], data[1]))
                              .toList();

                          return SizedBox(
                          height: 300,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    getDrawingHorizontalLine: (value) {
                                      return const FlLine(
                                        color:
                                            Colors.black12, // Grid line color
                                        strokeWidth: 1,
                                      );
                                    },
                                    getDrawingVerticalLine: (value) {
                                      return const FlLine(
                                        color: Colors
                                            .black12, // Vertical grid line color
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      axisNameWidget: const Padding(
                                        padding:
                                            EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Price (USD)',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          // Return Y-axis titles
                                          if (value % 100 == 0) {
                                            return Text(
                                              '\$${value.toInt()}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: const Padding(
                                        padding:
                                            EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          'Date',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        getTitlesWidget: (value, meta) {
                                          // Return X-axis titles (Date or Time-based)
                                          final DateTime date = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  value.toInt());
                                          return Text(
                                            '${date.month}/${date.day}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  backgroundColor: Colors.blueGrey,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: spots,
                                      isCurved: true,
                                      isStepLineChart: true,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.greenAccent,
                                          Colors.amberAccent
                                        ],
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                      ),
                                      belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.green.withOpacity(0.1)),
                                      dotData: const FlDotData(show: false),
                                      barWidth: 3, // Set the width of the line
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required String subtitle,
      required String price,
      required String marketCap,
      required String change,
      required Color changeColor}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              marketCap,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              change,
              style: TextStyle(fontSize: 16, color: changeColor),
            ),
          ],
        ),
      ),
    );
  }
}
