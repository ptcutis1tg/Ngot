import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/app_settings_provider.dart';
import 'package:flutter_application_1/providers/app_translations.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _WalletAppBar(),
      body: _WalletBody(),
    );
  }
}

class _WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _WalletAppBar();

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<AppSettingsProvider>().languageCode;
    return AppBar(title: Text(AppTranslations.getText(languageCode, 'wal_title')));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WalletBody extends StatelessWidget {
  const _WalletBody();

  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final format = context.watch<CurrencyProvider>().numberFormat;
    final languageCode = context.watch<AppSettingsProvider>().languageCode;

    if (!txProvider.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final income = txProvider.transactions
        .where((t) => t.amount > 0)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final expense = txProvider.transactions
        .where((t) => t.amount < 0)
        .fold<double>(0, (sum, t) => sum + t.amount.abs());
    final balance = txProvider.totalBalance;

    final now = DateTime.now();
    final monthIncome = txProvider.transactions
        .where((t) =>
            t.amount > 0 &&
            t.time.year == now.year &&
            t.time.month == now.month)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final monthExpense = txProvider.transactions
        .where((t) =>
            t.amount < 0 &&
            t.time.year == now.year &&
            t.time.month == now.month)
        .fold<double>(0, (sum, t) => sum + t.amount.abs());
    final monthlyNet = monthIncome - monthExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppTranslations.getText(languageCode, 'wal_overview'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _CardPager(
            balanceText: format.format(balance),
            transactionCount: txProvider.transactions.length,
            monthlyNetText:
                '${monthlyNet >= 0 ? '+' : '-'}${format.format(monthlyNet.abs())}',
            monthIncomeText: format.format(monthIncome),
          ),
          const SizedBox(height: 30),
          Text(
            AppTranslations.getText(languageCode, 'wal_summary'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _AccountItem(
            icon: Icons.arrow_upward,
            title: AppTranslations.getText(languageCode, 'wal_total_income'),
            amount: format.format(income),
          ),
          _AccountItem(
            icon: Icons.arrow_downward,
            title: AppTranslations.getText(languageCode, 'wal_total_expense'),
            amount: format.format(expense),
          ),
          _AccountItem(
            icon: Icons.calendar_month,
            title: AppTranslations.getText(languageCode, 'wal_this_month_expense'),
            amount: format.format(monthExpense),
          ),
          _AccountItem(
            icon: Icons.receipt_long,
            title: AppTranslations.getText(languageCode, 'wal_total_transactions'),
            amount: '${txProvider.transactions.length}',
          ),
        ],
      ),
    );
  }
}

class _CardPager extends StatefulWidget {
  final String balanceText;
  final int transactionCount;
  final String monthlyNetText;
  final String monthIncomeText;

  const _CardPager({
    required this.balanceText,
    required this.transactionCount,
    required this.monthlyNetText,
    required this.monthIncomeText,
  });

  @override
  State<_CardPager> createState() => _CardPagerState();
}

class _CardPagerState extends State<_CardPager> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<AppSettingsProvider>().languageCode;
    final String sub1 = switch (languageCode) {
      'vi' => '${widget.transactionCount} giao dịch',
      'ko' => '${widget.transactionCount}건의 거래',
      _ => '${widget.transactionCount} transactions',
    };
    final String sub2 = switch (languageCode) {
      'vi' => 'Thu nhập tháng này ${widget.monthIncomeText}',
      'ko' => '이번 달 수입 ${widget.monthIncomeText}',
      _ => 'This month income ${widget.monthIncomeText}',
    };

    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          _WalletCard(
            label: AppTranslations.getText(languageCode, 'wal_main_balance'),
            amount: widget.balanceText,
            subtitle: sub1,
            color: const Color(0xFF2ECC71),
          ),
          _WalletCard(
            label: AppTranslations.getText(languageCode, 'wal_monthly_net'),
            amount: widget.monthlyNetText,
            subtitle: sub2,
            color: const Color(0xFF2C3E50),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String label;
  final String amount;
  final String subtitle;
  final Color color;

  const _WalletCard({
    required this.label,
    required this.amount,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 28),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;

  const _AccountItem({
    required this.icon,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2ECC71).withValues(alpha: 0.1),
            child: Icon(icon, color: const Color(0xFF2ECC71)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, color: onSurface),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, color: onSurface),
          ),
        ],
      ),
    );
  }
}
