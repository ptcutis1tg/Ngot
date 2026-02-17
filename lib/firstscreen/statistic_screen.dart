import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/transactionproflie.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum _TimeFilter { weekly, monthly, yearly }

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: _StatisticsAppBar(),
      body: _StatisticsBody(),
    );
  }
}

class _StatisticsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _StatisticsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text('Statistics'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _StatisticsBody extends StatefulWidget {
  const _StatisticsBody();

  @override
  State<_StatisticsBody> createState() => _StatisticsBodyState();
}

class _StatisticsBodyState extends State<_StatisticsBody> {
  _TimeFilter _selectedFilter = _TimeFilter.monthly;

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final currency = context.watch<CurrencyProvider>().numberFormat;
    final now = DateTime.now();
    final buckets = _buildBuckets(txProvider.transactions, now);
    final categories = _buildTopCategories(txProvider.transactions, now);
    final totalExpense = categories.fold<double>(0, (sum, item) => sum + item.amount);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterBar(
            selected: _selectedFilter,
            onChanged: (next) => setState(() => _selectedFilter = next),
          ),
          const SizedBox(height: 30),
          _ChartSection(buckets: buckets),
          const SizedBox(height: 30),
          _TopSpendingSection(
            categories: categories,
            totalExpense: totalExpense,
            formatAmount: currency.format,
          ),
        ],
      ),
    );
  }

  List<_BucketData> _buildBuckets(List<TransactionProfile> transactions, DateTime now) {
    switch (_selectedFilter) {
      case _TimeFilter.weekly:
        final today = DateTime(now.year, now.month, now.day);
        final start = today.subtract(const Duration(days: 6));
        final list = List<_BucketData>.generate(
          7,
          (i) => _BucketData(
            label: DateFormat('E').format(start.add(Duration(days: i))),
            total: 0,
          ),
        );
        for (final tx in transactions) {
          if (tx.amount >= 0) continue;
          final d = DateTime(tx.time.year, tx.time.month, tx.time.day);
          if (d.isBefore(start) || d.isAfter(today)) continue;
          final idx = d.difference(start).inDays;
          list[idx] = list[idx].copyWith(total: list[idx].total + tx.amount.abs());
        }
        return list;
      case _TimeFilter.monthly:
        final days = DateTime(now.year, now.month + 1, 0).day;
        final list =
            List<_BucketData>.generate(days, (i) => _BucketData(label: '${i + 1}', total: 0));
        for (final tx in transactions) {
          if (tx.amount >= 0) continue;
          if (tx.time.year != now.year || tx.time.month != now.month) continue;
          final idx = tx.time.day - 1;
          list[idx] = list[idx].copyWith(total: list[idx].total + tx.amount.abs());
        }
        return list;
      case _TimeFilter.yearly:
        final list = List<_BucketData>.generate(
          12,
          (i) => _BucketData(
            label: DateFormat('MMM').format(DateTime(now.year, i + 1, 1)),
            total: 0,
          ),
        );
        for (final tx in transactions) {
          if (tx.amount >= 0) continue;
          if (tx.time.year != now.year) continue;
          final idx = tx.time.month - 1;
          list[idx] = list[idx].copyWith(total: list[idx].total + tx.amount.abs());
        }
        return list;
    }
  }

  List<_CategoryData> _buildTopCategories(List<TransactionProfile> transactions, DateTime now) {
    final totals = <String, double>{};
    for (final tx in transactions) {
      if (tx.amount >= 0) continue;
      if (!_inRange(tx.time, now)) continue;
      final key = tx.title.trim().isEmpty ? 'Other' : tx.title.trim();
      totals[key] = (totals[key] ?? 0) + tx.amount.abs();
    }
    final list = totals.entries
        .map((e) => _CategoryData(title: e.key, amount: e.value))
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
    return list;
  }

  bool _inRange(DateTime time, DateTime now) {
    switch (_selectedFilter) {
      case _TimeFilter.weekly:
        final today = DateTime(now.year, now.month, now.day);
        final start = today.subtract(const Duration(days: 6));
        final d = DateTime(time.year, time.month, time.day);
        return !d.isBefore(start) && !d.isAfter(today);
      case _TimeFilter.monthly:
        return time.year == now.year && time.month == now.month;
      case _TimeFilter.yearly:
        return time.year == now.year;
    }
  }
}

class _FilterBar extends StatefulWidget {
  final _TimeFilter selected;
  final ValueChanged<_TimeFilter> onChanged;

  const _FilterBar({required this.selected, required this.onChanged});

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterChip(
            title: 'Weekly',
            selected: widget.selected == _TimeFilter.weekly,
            onTap: () => widget.onChanged(_TimeFilter.weekly),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterChip(
            title: 'Monthly',
            selected: widget.selected == _TimeFilter.monthly,
            onTap: () => widget.onChanged(_TimeFilter.monthly),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterChip(
            title: 'Yearly',
            selected: widget.selected == _TimeFilter.yearly,
            onTap: () => widget.onChanged(_TimeFilter.yearly),
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.selected ? const Color(0xFF2ECC71) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          widget.title,
          style: TextStyle(
            color: widget.selected ? Colors.white : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ChartSection extends StatefulWidget {
  final List<_BucketData> buckets;

  const _ChartSection({required this.buckets});

  @override
  State<_ChartSection> createState() => _ChartSectionState();
}

class _ChartSectionState extends State<_ChartSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending Over Time',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: widget.buckets.every((b) => b.total == 0)
              ? const Center(child: Text('No expense data in selected range'))
              : LineChart(_lineDataFromBuckets(widget.buckets)),
        ),
      ],
    );
  }

  LineChartData _lineDataFromBuckets(List<_BucketData> buckets) {
    final maxY = buckets.fold<double>(0, (m, e) => math.max(m, e.total));
    final safeMaxY = maxY <= 0 ? 10.0 : maxY * 1.2;

    return LineChartData(
      minY: 0.0,
      maxY: safeMaxY,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            interval: _titleInterval(buckets.length),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= buckets.length) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  buckets[index].label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            buckets.length,
            (index) => FlSpot(index.toDouble(), buckets[index].total),
          ),
          isCurved: true,
          color: const Color(0xFF2ECC71),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: FlDotData(show: buckets.length <= 12),
          belowBarData: BarAreaData(
            show: true,
            color: const Color(0xFF2ECC71).withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }

  double _titleInterval(int length) {
    if (length <= 8) return 1;
    if (length <= 16) return 2;
    if (length <= 24) return 3;
    return 5;
  }
}

class _TopSpendingSection extends StatefulWidget {
  final List<_CategoryData> categories;
  final double totalExpense;
  final String Function(num) formatAmount;

  const _TopSpendingSection({
    required this.categories,
    required this.totalExpense,
    required this.formatAmount,
  });

  @override
  State<_TopSpendingSection> createState() => _TopSpendingSectionState();
}

class _TopSpendingSectionState extends State<_TopSpendingSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Spending',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        if (widget.categories.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('No spending in selected range'),
          ),
        ...widget.categories.take(5).map((item) {
          final percent =
              widget.totalExpense == 0 ? 0.0 : (item.amount / widget.totalExpense);
          return _CategoryTile(
            title: item.title,
            amount: widget.formatAmount(item.amount),
            percent: percent,
            color: _colorForName(item.title),
          );
        }),
      ],
    );
  }

  Color _colorForName(String value) {
    const palette = [
      Color(0xFFE67E22),
      Color(0xFF3498DB),
      Color(0xFF9B59B6),
      Color(0xFFE74C3C),
      Color(0xFF1ABC9C),
      Color(0xFFF1C40F),
    ];
    final idx = value.codeUnits.fold<int>(0, (sum, e) => sum + e) % palette.length;
    return palette[idx];
  }
}

class _CategoryTile extends StatefulWidget {
  final String title;
  final String amount;
  final double percent;
  final Color color;

  const _CategoryTile({
    required this.title,
    required this.amount,
    required this.percent,
    required this.color,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(widget.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: widget.percent,
            backgroundColor: widget.color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}

class _BucketData {
  final String label;
  final double total;

  const _BucketData({required this.label, required this.total});

  _BucketData copyWith({String? label, double? total}) {
    return _BucketData(
      label: label ?? this.label,
      total: total ?? this.total,
    );
  }
}

class _CategoryData {
  final String title;
  final double amount;

  const _CategoryData({required this.title, required this.amount});
}
