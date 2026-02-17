class TransactionProfile {
  final String title;
  final DateTime time;
  final double amount; // Số tiền đã cộng hoặc đã chuyển

  TransactionProfile({
    required this.title,
    required this.time,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time.toIso8601String(),
      'amount': amount,
    };
  }

  factory TransactionProfile.fromJson(Map<String, dynamic> json) {
    return TransactionProfile(
      title: (json['title'] ?? '') as String,
      time: DateTime.parse(json['time'] as String),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
