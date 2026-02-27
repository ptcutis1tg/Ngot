import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/dashboardscreen/userwelcome.dart';
import 'package:flutter_application_1/providers/currency_provider.dart';
import 'package:flutter_application_1/providers/transaction_provider.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _DashboardAppBar(),
      body: _DashboardBody(),
    );
  }
}

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Financial Dashboard'),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileSection(),
          SizedBox(height: 30),
          _BalanceCard(),
          SizedBox(height: 30),
          _RecentHeader(),
          _RecentList(),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfile, _) {
        return UserWelcome(
          userName: userProfile.userName,
          userAvatar: userProfile.userAvatar,
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final currencyFormat = context.watch<CurrencyProvider>().numberFormat;

    return Consumer<TransactionProvider>(
      builder: (context, txProvider, _) {
        final income = txProvider.transactions
            .where((t) => t.amount > 0)
            .fold<double>(0, (sum, t) => sum + t.amount);
        final expense = txProvider.transactions
            .where((t) => t.amount < 0)
            .fold<double>(0, (sum, t) => sum + t.amount.abs());

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Total Balance',
                style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 8),
              Text(
                currencyFormat.format(txProvider.totalBalance),
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _IncomeExpenseTile(
                    icon: Icons.arrow_upward,
                    label: 'Income',
                    amount: '+${currencyFormat.format(income)}',
                    color: const Color(0xFF2ECC71),
                  ),
                  _IncomeExpenseTile(
                    icon: Icons.arrow_downward,
                    label: 'Expenses',
                    amount: '-${currencyFormat.format(expense)}',
                    color: const Color(0xFFE74C3C),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IncomeExpenseTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color color;

  const _IncomeExpenseTile({
    required this.icon,
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 12),
        ),
        Text(
          amount,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _RecentHeader extends StatelessWidget {
  const _RecentHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child:
              const Text('See All', style: TextStyle(color: Color(0xFF2ECC71))),
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

    return Consumer<TransactionProvider>(
      builder: (context, txProvider, _) {
        if (!txProvider.isLoaded) {
          return const Padding(
            padding: EdgeInsets.only(top: 12),
            child: CircularProgressIndicator(),
          );
        }
        if (txProvider.transactions.isEmpty) {
          return Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text('Chua co giao dich nao'),
          );
        }

        return Column(
          children: txProvider.transactions.take(5).map((tx) {
            final isIncome = tx.amount >= 0;
            final amountText =
                '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount.abs())}';
            return _TransactionRow(
              icon: isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              title: tx.title,
              date: DateFormat('MMM d, yyyy - hh:mm a').format(tx.time),
              amount: amountText,
              iconBg: isIncome ? Colors.green : Colors.redAccent,
            );
          }).toList(),
        );
      },
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final Color iconBg;

  const _TransactionRow({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBg),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date,
                    style:
                        TextStyle(color: onSurface.withValues(alpha: 0.7), fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: amount.startsWith('+') ? Colors.green : onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
