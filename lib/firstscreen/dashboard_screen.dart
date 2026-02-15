import 'package:flutter/material.dart';
import 'package:flutter_application_1/firstscreen/widget/dashboardscreen/userwelcome.dart';
import 'package:flutter_application_1/providers/userprofileprovider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                return UserWelcome(userName: userProfile.userName);
              },
            ),
            const SizedBox(height: 30),

            // 2. Total Balance Card
            Container(
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
                  const Text('\$12,450.00',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildIncomeExpense(Icons.arrow_upward, 'Income',
                          '+\$3,200.00', const Color(0xFF2ECC71)),
                      _buildIncomeExpense(Icons.arrow_downward, 'Expenses',
                          '-\$1,150.00', const Color(0xFFE74C3C)),
                    ],
                  ),
                ],
              ),
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
            _buildTransactionItem(Icons.coffee, 'Starbucks Coffee',
                'Today, 09:41 AM', '-\$5.50', Colors.orange),
            _buildTransactionItem(Icons.payments, 'Monthly Salary',
                'Yesterday, 05:00 PM', '+\$3,200.00', Colors.green),
            _buildTransactionItem(Icons.directions_car, 'Uber Ride',
                'May 21, 2024', '-\$12.00', Colors.blue),
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
