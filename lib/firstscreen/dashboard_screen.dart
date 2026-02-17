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
    final currencyFormat = context.watch<CurrencyProvider>().numberFormat;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Màu nền xám nhạt cực sang
      appBar: AppBar(
        title: const Text('Financial Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Profile Section
            Consumer<UserProfileProvider>(
              builder: (context, userProfile, _) {
                return UserWelcome(
                  userName: userProfile.userName,
                  userAvatar: userProfile.userAvatar,
                );
              },
            ),
            const SizedBox(height: 30),

            // 2. Total Balance Card
            Consumer<TransactionProvider>(
              builder: (context, transactionProvider, _) {
                final income = transactionProvider.transactions
                    .where((t) => t.amount > 0)
                    .fold<double>(0, (sum, t) => sum + t.amount);
                final expense = transactionProvider.transactions
                    .where((t) => t.amount < 0)
                    .fold<double>(0, (sum, t) => sum + t.amount.abs());

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('Total Balance',
                          style: TextStyle(color: Colors.grey[500])),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(transactionProvider.totalBalance),
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildIncomeExpense(
                            Icons.arrow_upward,
                            'Income',
                            '+${currencyFormat.format(income)}',
                            const Color(0xFF2ECC71),
                          ),
                          _buildIncomeExpense(
                            Icons.arrow_downward,
                            'Expenses',
                            '-${currencyFormat.format(expense)}',
                            const Color(0xFFE74C3C),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),

            // 3. Recent Transactions Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Transactions',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                    onPressed: () {},
                    child: const Text('See All',
                        style: TextStyle(color: Color(0xFF2ECC71)))),
              ],
            ),

            // 4. Transaction List
            Consumer<TransactionProvider>(
              builder: (context, transactionProvider, _) {
                if (!transactionProvider.isLoaded) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: CircularProgressIndicator(),
                  );
                }
                if (transactionProvider.transactions.isEmpty) {
                  return Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text('Chưa có giao dịch nào'),
                  );
                }

                return Column(
                  children: transactionProvider.transactions.take(5).map((tx) {
                    final isIncome = tx.amount >= 0;
                    final amountText =
                        '${isIncome ? '+' : '-'}${currencyFormat.format(tx.amount.abs())}';
                    return _buildTransactionItem(
                      isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                      tx.title,
                      DateFormat('MMM d, yyyy - hh:mm a').format(tx.time),
                      amountText,
                      isIncome ? Colors.green : Colors.redAccent,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget con cho phần Income/Expense
  Widget _buildIncomeExpense(
      IconData icon, String label, String amount, Color color) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
        Text(amount,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Widget con cho mỗi dòng giao dịch
  Widget _buildTransactionItem(
      IconData icon, String title, String date, String amount, Color iconBg) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg.withOpacity(0.1),
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
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(amount,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: amount.startsWith('+') ? Colors.green : Colors.black)),
        ],
      ),
    );
  }
}
