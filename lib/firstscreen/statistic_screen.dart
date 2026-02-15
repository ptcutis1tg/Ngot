import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Bộ lọc thời gian (Weekly, Monthly, Yearly)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTimeFilter('Weekly', false),
                _buildTimeFilter('Monthly', true), // Đang chọn
                _buildTimeFilter('Yearly', false),
              ],
            ),
            const SizedBox(height: 30),

            // 2. Khu vực Biểu đồ (Visualize Finances)
            const Text('Spending Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Container(
              height: 250,
              padding: const EdgeInsets.only(right: 20, top: 10),
              child: LineChart(
                mainData(),
              ),
            ),
            const SizedBox(height: 30),

            // 3. Phân tích hạng mục (Top Categories)
            const Text('Top Spending',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildCategoryStat('Food & Drinks', '\$450.00', 0.7, Colors.orange),
            _buildCategoryStat('Transport', '\$120.00', 0.3, Colors.blue),
            _buildCategoryStat('Shopping', '\$300.00', 0.5, Colors.purple),
          ],
        ),
      ),
    );
  }

  // Widget bộ lọc thời gian
  Widget _buildTimeFilter(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2ECC71) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget thanh tiến trình hạng mục
  Widget _buildCategoryStat(
      String title, String amount, double percent, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  // Cấu hình dữ liệu biểu đồ (Mẫu)
  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: const FlTitlesData(show: true),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          color: const Color(0xFF2ECC71),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2ECC71).withOpacity(0.1),
          ),
        ),
      ],
    );
  }
}
