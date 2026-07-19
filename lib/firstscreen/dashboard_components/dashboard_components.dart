import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        final email = Supabase.instance.client.auth.currentUser?.email ?? 'Guest';
        return Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF0C3A29),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.menu, color: Color(0xFF1CF07B), size: 26),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Real-time Ledger',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFE5F4EB),
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1CF07B),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4A1515),
                borderRadius: BorderRadius.circular(25),
              ),
              child: IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

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
                    currencyProvider.numberFormat
                        .format(txProvider.totalBalance),
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

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

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
              child: IncomeExpenseTile(
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
              child: IncomeExpenseTile(
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

class IncomeExpenseTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final String change;
  final Color valueColor;
  final Color trendColor;

  const IncomeExpenseTile({
    super.key,
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

class DayTransactionGroup {
  final String heading;
  final List<dynamic> items;

  const DayTransactionGroup({required this.heading, required this.items});
}

class TxVisualMeta {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String subtitle;

  const TxVisualMeta({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.subtitle,
  });
}

List<DayTransactionGroup> groupByDay(
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
    final heading = formatGroupHeading(day, now, isVietnamese);
    return DayTransactionGroup(heading: heading, items: dayMap[key]!);
  }).toList();
}

String formatGroupHeading(DateTime day, DateTime now, bool isVietnamese) {
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

TxVisualMeta getTxMeta(String title, bool isIncome, bool isVietnamese) {
  final lower = title.toLowerCase();
  if (lower.contains('ăn') ||
      lower.contains('trưa') ||
      lower.contains('food')) {
    return TxVisualMeta(
      icon: Icons.restaurant,
      iconBg: const Color(0xFF4F3A11),
      iconColor: const Color(0xFFFF9B29),
      subtitle: isVietnamese ? 'Ăn uống' : 'Food',
    );
  }
  if (lower.contains('xăng') || lower.contains('xe') || lower.contains('gas')) {
    return TxVisualMeta(
      icon: Icons.directions_car,
      iconBg: const Color(0xFF1A3850),
      iconColor: const Color(0xFF4AA3FF),
      subtitle: isVietnamese ? 'Di chuyển' : 'Transport',
    );
  }
  if (lower.contains('lương') || lower.contains('salary') || isIncome) {
    return TxVisualMeta(
      icon: Icons.payments,
      iconBg: const Color(0xFF0B5A30),
      iconColor: const Color(0xFF2CFF7D),
      subtitle: isVietnamese ? 'Thu nhập' : 'Income',
    );
  }
  return TxVisualMeta(
    icon: isIncome ? Icons.south_west : Icons.north_east,
    iconBg: const Color(0xFF343651),
    iconColor: const Color(0xFFA7B2FF),
    subtitle: isVietnamese ? 'Khác' : 'Other',
  );
}

class RecentHeader extends StatelessWidget {
  const RecentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final isVietnamese = localeCode == 'vi';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            isVietnamese ? 'Lịch sử giao dịch' : 'Transaction History',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 38,
              color: Color(0xFFE9F5EE),
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
        ),
        const SizedBox(width: 16),
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

class RecentList extends StatelessWidget {
  const RecentList({super.key});

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

        final groups = groupByDay(context, txProvider.transactions.take(8).toList());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groups.map((group) {
            return TransactionGroupSection(
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

class TransactionGroupSection extends StatelessWidget {
  final String heading;
  final List<dynamic> entries;
  final NumberFormat currencyFormat;
  final bool isVietnamese;

  const TransactionGroupSection({
    super.key,
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
              final meta = getTxMeta(tx.title, isIncome, isVietnamese);

              return TransactionRow(
                icon: meta.icon,
                title: tx.title,
                subtitle: meta.subtitle,
                amount: amountText,
                iconBg: meta.iconBg,
                iconColor: meta.iconColor,
                amountColor: isIncome
                    ? const Color(0xFF27EC79)
                    : const Color(0xFFFF4A73),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color iconBg;
  final Color iconColor;
  final Color amountColor;

  const TransactionRow({
    super.key,
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF90AE9F),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: amountColor,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
