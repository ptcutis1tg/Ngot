import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transactionproflie.dart';

class TransactionProvider extends ChangeNotifier {
  static const String _transactionsKey = 'transactions_v1';

  final List<TransactionProfile> _transactions = [];
  bool _loaded = false;

  List<TransactionProfile> get transactions => List.unmodifiable(_transactions);
  bool get isLoaded => _loaded;
  double get totalBalance =>
      _transactions.fold(0, (sum, item) => sum + item.amount);

  Future<void> loadTransactions() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_transactionsKey);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _transactions
        ..clear()
        ..addAll(decoded.map((e) => TransactionProfile.fromJson(e)));
      _transactions.sort((a, b) => b.time.compareTo(a.time));
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionProfile transaction) async {
    _transactions.insert(0, transaction);
    await _persist();
    notifyListeners();
  }

  Future<void> clearTransactions() async {
    _transactions.clear();
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _transactions.map((e) => e.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(data));
  }
}
