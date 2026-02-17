import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: _WalletAppBar(),
      body: _WalletBody(),
    );
  }
}

class _WalletAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _WalletAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('My Wallets'),
      actions: [
        IconButton(icon: const Icon(Icons.add_card), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WalletBody extends StatefulWidget {
  const _WalletBody();

  @override
  State<_WalletBody> createState() => _WalletBodyState();
}

class _WalletBodyState extends State<_WalletBody> {
  @override
  Widget build(BuildContext context) {
    final txProvider = context.watch<TransactionProvider>();
    final format = context.watch<CurrencyProvider>().numberFormat;

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
        .where((t) => t.amount > 0 && t.time.year == now.year && t.time.month == now.month)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final monthExpense = txProvider.transactions
        .where((t) => t.amount < 0 && t.time.year == now.year && t.time.month == now.month)
        .fold<double>(0, (sum, t) => sum + t.amount.abs());
    final monthlyNet = monthIncome - monthExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Cards',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const Text(
            'Account Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _AccountItem(
            icon: Icons.arrow_upward,
            title: 'Total Income',
            amount: format.format(income),
          ),
          _AccountItem(
            icon: Icons.arrow_downward,
            title: 'Total Expense',
            amount: format.format(expense),
          ),
          _AccountItem(
            icon: Icons.calendar_month,
            title: 'This Month Expense',
            amount: format.format(monthExpense),
          ),
          _AccountItem(
            icon: Icons.receipt_long,
            title: 'Total Transactions',
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
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: [
          _WalletCard(
            label: 'Main Balance',
            amount: widget.balanceText,
            subtitle: '${widget.transactionCount} transactions',
            color: const Color(0xFF2ECC71),
          ),
          _WalletCard(
            label: 'This Month Net',
            amount: widget.monthlyNetText,
            subtitle: 'Income ${widget.monthIncomeText}',
            color: const Color(0xFF2C3E50),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatefulWidget {
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
  State<_WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<_WalletCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.3),
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
                widget.label,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const Icon(Icons.contactless, color: Colors.white, size: 28),
            ],
          ),
          Text(
            widget.amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.subtitle,
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

class _AccountItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String amount;

  const _AccountItem({
    required this.icon,
    required this.title,
    required this.amount,
  });

  @override
  State<_AccountItem> createState() => _AccountItemState();
}

class _AccountItemState extends State<_AccountItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF2ECC71).withValues(alpha: 0.1),
            child: Icon(widget.icon, color: const Color(0xFF2ECC71)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(widget.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
