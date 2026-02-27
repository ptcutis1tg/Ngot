import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/transactionproflie.dart';

class TransactionProvider extends ChangeNotifier {
  static const String _transactionsKey = 'transactions_v1';

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();
  final List<TransactionProfile> _transactions = [];

  bool _loaded = false;
  double _totalBalance = 0;

  List<TransactionProfile> get transactions => List.unmodifiable(_transactions);
  bool get isLoaded => _loaded;
  double get totalBalance => _totalBalance;

  Future<void> loadTransactions() async {
    if (_loaded) return;

    final prefs = await _prefsFuture;
    final raw = prefs.getString(_transactionsKey);

    _transactions.clear();
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _transactions.addAll(decoded.map((e) => TransactionProfile.fromJson(e)));
      _transactions.sort((a, b) => b.time.compareTo(a.time));
    }

    _totalBalance =
        _transactions.fold<double>(0, (sum, item) => sum + item.amount);
    _loaded = true;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionProfile transaction) async {
    _transactions.insert(0, transaction);
    _totalBalance += transaction.amount;
    await _persist();
    notifyListeners();
  }

  Future<void> clearTransactions() async {
    if (_transactions.isEmpty && _totalBalance == 0) return;

    _transactions.clear();
    _totalBalance = 0;
    await _persist();
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await _prefsFuture;
    final data = _transactions.map((e) => e.toJson()).toList();
    await prefs.setString(_transactionsKey, jsonEncode(data));
  }
}
