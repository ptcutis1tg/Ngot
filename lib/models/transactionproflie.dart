import 'package:uuid/uuid.dart';

class TransactionProfile {
  final String id;
  final String title;
  final DateTime time;
  final double amount;
  final DateTime updatedAt;
  final bool isDeleted;
  final String? userId;

  TransactionProfile({
    String? id,
    required this.title,
    required this.time,
    required this.amount,
    DateTime? updatedAt,
    this.isDeleted = false,
    this.userId,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'time': time.toIso8601String(),
      'amount': amount,
      'updated_at': updatedAt.toIso8601String(),
      'is_deleted': isDeleted,
      'user_id': userId,
    };
  }

  factory TransactionProfile.fromJson(Map<String, dynamic> json) {
    return TransactionProfile(
      id: json['id'] as String?,
      title: (json['title'] ?? '') as String,
      time: DateTime.parse(json['time'] as String),
      amount: (json['amount'] as num).toDouble(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.parse(json['time'] as String),
      isDeleted: json['is_deleted'] == true,
      userId: json['user_id'] as String?,
    );
  }
}
