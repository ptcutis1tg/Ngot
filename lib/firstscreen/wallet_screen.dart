import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('My Wallets'),
        actions: [
          IconButton(icon: const Icon(Icons.add_card), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Cards',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            // 1. Thẻ ngân hàng (Page View để vuốt ngang)
            SizedBox(
              height: 200,
              child: PageView(
                controller: PageController(viewportFraction: 0.9),
                children: [
                  _buildCreditCard(
                    'Main Balance',
                    '\$12,450.00',
                    '**** 5562',
                    const Color(0xFF2ECC71), // Xanh lá theo Brand
                  ),
                  _buildCreditCard(
                    'Savings Account',
                    '\$5,200.50',
                    '**** 1289',
                    const Color(0xFF2C3E50), // Xanh đen sang trọng
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 2. Danh sách các tài khoản khác
            const Text('Account Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),

            _buildAccountItem(
                Icons.account_balance_wallet, 'Cash', '\$1,200.00'),
            _buildAccountItem(Icons.credit_card, 'Visa Card', '\$8,500.00'),
            _buildAccountItem(Icons.savings, 'Emergency Fund', '\$2,750.00'),
          ],
        ),
      ),
    );
  }

  // Widget thiết kế Thẻ tín dụng
  Widget _buildCreditCard(
      String label, String amount, String cardNumber, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const Icon(Icons.contactless, color: Colors.white, size: 28),
            ],
          ),
          Text(amount,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(cardNumber,
                  style:
                      const TextStyle(color: Colors.white, letterSpacing: 2)),
              const Text('VISA',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ],
      ),
    );
  }

  // Widget dòng danh sách tài khoản
  Widget _buildAccountItem(IconData icon, String title, String amount) {
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
            backgroundColor: const Color(0xFF2ECC71).withOpacity(0.1),
            child: Icon(icon, color: const Color(0xFF2ECC71)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
