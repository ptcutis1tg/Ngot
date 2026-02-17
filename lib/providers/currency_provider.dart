import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyOption {
  final String code;
  final String symbol;
  final String locale;
  final int decimalDigits;
  final String displayName;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.locale,
    required this.decimalDigits,
    required this.displayName,
  });
}

class CurrencyProvider extends ChangeNotifier {
  static const String _currencyCodeKey = 'app_currency_code';

  static const List<CurrencyOption> supportedCurrencies = [
    CurrencyOption(
      code: 'USD',
      symbol: '\$',
      locale: 'en_US',
      decimalDigits: 2,
      displayName: 'US Dollar',
    ),
    CurrencyOption(
      code: 'VND',
      symbol: '₫',
      locale: 'vi_VN',
      decimalDigits: 0,
      displayName: 'Vietnamese Dong',
    ),
    CurrencyOption(
      code: 'JPY',
      symbol: '¥',
      locale: 'ja_JP',
      decimalDigits: 0,
      displayName: 'Japanese Yen',
    ),
    CurrencyOption(
      code: 'EUR',
      symbol: '€',
      locale: 'de_DE',
      decimalDigits: 2,
      displayName: 'Euro',
    ),
    CurrencyOption(
      code: 'GBP',
      symbol: '£',
      locale: 'en_GB',
      decimalDigits: 2,
      displayName: 'British Pound',
    ),
  ];

  CurrencyOption _selected = supportedCurrencies.first;
  bool _loaded = false;

  CurrencyOption get selected => _selected;

  NumberFormat get numberFormat => NumberFormat.currency(
        locale: _selected.locale,
        symbol: _selected.symbol,
        decimalDigits: _selected.decimalDigits,
      );

  Future<void> loadCurrency() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_currencyCodeKey) ?? supportedCurrencies.first.code;
    _selected = _findCurrency(code);
    _loaded = true;
    notifyListeners();
  }

  Future<void> setCurrencyByCode(String code) async {
    final next = _findCurrency(code);
    if (next.code == _selected.code) return;
    _selected = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyCodeKey, _selected.code);
    notifyListeners();
  }

  CurrencyOption _findCurrency(String code) {
    return supportedCurrencies.firstWhere(
      (item) => item.code == code,
      orElse: () => supportedCurrencies.first,
    );
  }
}
