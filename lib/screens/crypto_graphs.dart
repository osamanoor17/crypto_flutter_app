import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/crypto_model.dart';

class CryptoGraph extends StatelessWidget {
  final Crypto crypto;

  const CryptoGraph({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${crypto.name} Price Trend',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 350,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: generatePriceTrend().asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blueAccent, // Line color
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                    ),
                  ],
                  titlesData: const FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 32),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                  ),
                  borderData: FlBorderData(
                    border: const Border(
                      top: BorderSide.none,
                      right: BorderSide.none,
                      bottom: BorderSide(width: 1, color: Colors.blueGrey),
                      left: BorderSide(width: 1, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> generatePriceTrend() {
    // Example price trend data (simulated). Use real data here.
    return [94898, 94000, 93500, 94500, 95080, 95200, 94800]; // Replace with dynamic data
  }
}
