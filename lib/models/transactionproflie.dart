class TransactionProfile {
  final String title;
  final DateTime time;
  final double amount; // Số tiền đã cộng hoặc đã chuyển

  TransactionProfile({
    required this.title,
    required this.time,
    required this.amount,
  });
}
