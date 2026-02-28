import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF031F16),
              Color(0xFF052E1F),
            ],
          ),
        ),
        child: const SafeArea(child: _DashboardBody()),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBar(),
          const SizedBox(height: 32),
          _ProfileSection(),
          const SizedBox(height: 26),
          _BalanceCard(),
          const SizedBox(height: 32),
          _RecentHeader(),
          const SizedBox(height: 8),
          _RecentList(),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        return Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: const Color(0xFF0C3A29),
                borderRadius: BorderRadius.circular(29),
              ),
              child: const Icon(Icons.menu, color: Color(0xFF1CF07B), size: 30),
            ),
            const Spacer(),
            const Text(
              'Real-time Ledger',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE5F4EB),
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            CircleAvatar(
              key: ValueKey<String>(userProfile.userAvatar),
              radius: 29,
              backgroundColor: const Color(0xFF244A3A),
              backgroundImage: _avatarProvider(userProfile.userAvatar),
            ),
          ],
        );
      },
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';

    return Consumer<UserProfileProvider>(
      builder: (context, profile, child) {
        return Center(
          child: Column(
            children: [
              Text(
                isVietnamese ? 'SỐ DƯ HIỆN TẠI' : 'CURRENT BALANCE',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF17CB72),
                  letterSpacing: 2.2,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Consumer2<TransactionProvider, CurrencyProvider>(
                builder: (context, txProvider, currencyProvider, _) {
                  return Text(
                    currencyProvider.numberFormat.format(txProvider.totalBalance),
                    style: const TextStyle(
                      fontSize: 62,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF2FFF8),
                      height: 1,
                      letterSpacing: -1.3,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = context.watch<CurrencyProvider>().numberFormat;
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';

    return Consumer<TransactionProvider>(
      builder: (context, txProvider, _) {
        final income = txProvider.transactions
            .where((t) => t.amount > 0)
            .fold<double>(0, (sum, t) => sum + t.amount);
        final expense = txProvider.transactions
            .where((t) => t.amount < 0)
            .fold<double>(0, (sum, t) => sum + t.amount.abs());

        return Row(
          children: [
            Expanded(
              child: _IncomeExpenseTile(
                icon: Icons.arrow_downward,
                label: isVietnamese ? 'THU NHẬP' : 'INCOME',
                amount: currencyFormat.format(income),
                change: '+12%',
                valueColor: const Color(0xFFF0FFF6),
                trendColor: const Color(0xFF1CF07B),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _IncomeExpenseTile(
                icon: Icons.arrow_upward,
                label: isVietnamese ? 'CHI TIÊU' : 'EXPENSE',
                amount: currencyFormat.format(expense),
                change: '-5%',
                valueColor: const Color(0xFFF0FFF6),
                trendColor: const Color(0xFFFF4B73),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IncomeExpenseTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final String change;
  final Color valueColor;
  final Color trendColor;

  const _IncomeExpenseTile({
    required this.icon,
    required this.label,
    required this.amount,
    required this.change,
    required this.valueColor,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0C3827),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF10633E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: trendColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF95AFA1),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: TextStyle(
              color: trendColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTransactionGroup {
  final String heading;
  final List<dynamic> items;

  const _DayTransactionGroup({required this.heading, required this.items});
}

class _TxVisualMeta {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String subtitle;

  const _TxVisualMeta({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.subtitle,
  });
}

List<_DayTransactionGroup> _groupByDay(
  BuildContext context,
  List<dynamic> transactions,
) {
  final localeCode = Localizations.localeOf(context).languageCode;
  final isVietnamese = localeCode == 'vi';
  final now = DateTime.now();
  final dayMap = <String, List<dynamic>>{};
  final order = <String>[];

  for (final tx in transactions) {
    final dayKey = DateTime(tx.time.year, tx.time.month, tx.time.day)
        .millisecondsSinceEpoch
        .toString();
    if (!dayMap.containsKey(dayKey)) {
      dayMap[dayKey] = [];
      order.add(dayKey);
    }
    dayMap[dayKey]!.add(tx);
  }

  return order.map((key) {
    final day = DateTime.fromMillisecondsSinceEpoch(int.parse(key));
    final heading = _formatGroupHeading(day, now, isVietnamese);
    return _DayTransactionGroup(heading: heading, items: dayMap[key]!);
  }).toList();
}

String _formatGroupHeading(DateTime day, DateTime now, bool isVietnamese) {
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final comparingDay = DateTime(day.year, day.month, day.day);

  if (comparingDay == today) {
    return isVietnamese
        ? 'HÔM NAY, ${DateFormat('d \'THÁNG\' M', 'vi').format(day)}'
        : 'TODAY, ${DateFormat('MMM d', 'en').format(day).toUpperCase()}';
  }
  if (comparingDay == yesterday) {
    return isVietnamese
        ? 'HÔM QUA, ${DateFormat('d \'THÁNG\' M', 'vi').format(day)}'
        : 'YESTERDAY, ${DateFormat('MMM d', 'en').format(day).toUpperCase()}';
  }

  return isVietnamese
      ? DateFormat('d \'THÁNG\' M', 'vi').format(day).toUpperCase()
      : DateFormat('MMM d, yyyy', 'en').format(day).toUpperCase();
}

_TxVisualMeta _txMeta(String title, bool isIncome, bool isVietnamese) {
  final lower = title.toLowerCase();
  if (lower.contains('ăn') || lower.contains('trưa') || lower.contains('food')) {
    return _TxVisualMeta(
      icon: Icons.restaurant,
      iconBg: const Color(0xFF4F3A11),
      iconColor: const Color(0xFFFF9B29),
      subtitle: isVietnamese ? 'Ăn uống' : 'Food',
    );
  }
  if (lower.contains('xăng') || lower.contains('xe') || lower.contains('gas')) {
    return _TxVisualMeta(
      icon: Icons.directions_car,
      iconBg: const Color(0xFF1A3850),
      iconColor: const Color(0xFF4AA3FF),
      subtitle: isVietnamese ? 'Di chuyển' : 'Transport',
    );
  }
  if (lower.contains('lương') || lower.contains('salary') || isIncome) {
    return _TxVisualMeta(
      icon: Icons.payments,
      iconBg: const Color(0xFF0B5A30),
      iconColor: const Color(0xFF2CFF7D),
      subtitle: isVietnamese ? 'Thu nhập' : 'Income',
    );
  }
  return _TxVisualMeta(
    icon: isIncome ? Icons.south_west : Icons.north_east,
    iconBg: const Color(0xFF343651),
    iconColor: const Color(0xFFA7B2FF),
    subtitle: isVietnamese ? 'Khác' : 'Other',
  );
}

ImageProvider _avatarProvider(String avatar) {
  var value = avatar.trim();
  if (value.startsWith('memory:')) {
    final encoded = value.substring('memory:'.length);
    try {
      return MemoryImage(base64Decode(encoded));
    } catch (_) {
      return const AssetImage('assets/user/anonymous.jpg');
    }
  }
  if (value.startsWith('file://')) {
    value = Uri.parse(value).toFilePath();
  }
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return NetworkImage(value);
  }
  if (value.isEmpty) {
    return const AssetImage('assets/user/anonymous.jpg');
  }
  if (value.startsWith('assets/')) {
    return AssetImage(value);
  }
  if (!kIsWeb) {
    if (!File(value).existsSync()) {
      return const AssetImage('assets/user/anonymous.jpg');
    }
    return FileImage(File(value));
  }
  return const AssetImage('assets/user/anonymous.jpg');
}

class _RecentHeader extends StatelessWidget {
  const _RecentHeader();

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          isVietnamese ? 'Lịch sử giao dịch' : 'Transaction History',
          style: const TextStyle(
            fontSize: 38,
            color: Color(0xFFE9F5EE),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            isVietnamese ? 'Tất cả' : 'All',
            style: const TextStyle(
              color: Color(0xFF20F27F),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentList extends StatelessWidget {
  const _RecentList();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = context.watch<CurrencyProvider>().numberFormat;
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';

    return Consumer<TransactionProvider>(
      builder: (context, txProvider, _) {
        if (!txProvider.isLoaded) {
          return const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Center(
              child: CircularProgressIndicator(color: Color(0xFF20F27F)),
            ),
          );
        }
        if (txProvider.transactions.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0A3825),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF11653F), width: 1),
            ),
            child: Text(
              isVietnamese ? 'Chưa có giao dịch nào' : 'No transactions yet',
              style: const TextStyle(
                color: Color(0xFFC7D9D0),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final txs = [...txProvider.transactions]
          ..sort((a, b) => b.time.compareTo(a.time));
        final groups = _groupByDay(context, txs.take(8).toList());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groups.map((group) {
            return _TransactionGroupSection(
              heading: group.heading,
              entries: group.items,
              currencyFormat: currencyFormat,
              isVietnamese: isVietnamese,
            );
          }).toList(),
        );
      },
    );
  }
}

class _TransactionGroupSection extends StatelessWidget {
  final String heading;
  final List<dynamic> entries;
  final NumberFormat currencyFormat;
  final bool isVietnamese;

  const _TransactionGroupSection({
    required this.heading,
    required this.entries,
    required this.currencyFormat,
    required this.isVietnamese,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              color: Color(0xFF8FA39B),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: entries.map((tx) {
              final isIncome = tx.amount >= 0;
              final amountText =
                  '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount.abs())}';
              final meta = _txMeta(tx.title, isIncome, isVietnamese);

              return _TransactionRow(
                icon: meta.icon,
                title: tx.title,
                subtitle: meta.subtitle,
                amount: amountText,
                iconBg: meta.iconBg,
                iconColor: meta.iconColor,
                amountColor:
                    isIncome ? const Color(0xFF27EC79) : const Color(0xFFFF4A73),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color iconBg;
  final Color iconColor;
  final Color amountColor;

  const _TransactionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.iconBg,
    required this.iconColor,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3825),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF11653F), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFEBF9F0),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6E8D7E),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
