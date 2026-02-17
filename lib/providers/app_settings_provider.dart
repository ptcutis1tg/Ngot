import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _notificationsKey = 'settings_notifications';
  static const String _biometricKey = 'settings_biometric';
  static const String _bankAccountsKey = 'settings_bank_accounts_count';
  static const String _passwordKey = 'settings_app_password';

  bool _loaded = false;
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  int _bankAccountsCount = 0;
  String _password = '';

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  int get bankAccountsCount => _bankAccountsCount;

  Future<void> loadSettings() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_darkModeKey) ?? false;
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _biometricEnabled = prefs.getBool(_biometricKey) ?? false;
    _bankAccountsCount = prefs.getInt(_bankAccountsKey) ?? 0;
    _password = prefs.getString(_passwordKey) ?? '';
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    _biometricEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
    notifyListeners();
  }

  Future<void> setBankAccountsCount(int value) async {
    _bankAccountsCount = value < 0 ? 0 : value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bankAccountsKey, _bankAccountsCount);
    notifyListeners();
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.length < 4) {
      return 'Mật khẩu mới cần ít nhất 4 ký tự';
    }
    if (newPassword != confirmPassword) {
      return 'Xác nhận mật khẩu không khớp';
    }
    if (_password.isNotEmpty && currentPassword != _password) {
      return 'Mật khẩu hiện tại không đúng';
    }
    _password = newPassword;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, _password);
    notifyListeners();
    return null;
  }
}
