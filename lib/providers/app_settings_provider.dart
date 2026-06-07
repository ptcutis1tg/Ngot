import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _notificationsKey = 'settings_notifications';
  static const String _biometricKey = 'settings_biometric';
  static const String _passwordKey = 'settings_app_password';
  static const String _languageCodeKey = 'settings_language_code';

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  bool _loaded = false;
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _password = '';
  String _languageCode = 'vi';

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  Future<void> loadSettings() async {
    if (_loaded) return;

    final prefs = await _prefsFuture;
    _darkMode = prefs.getBool(_darkModeKey) ?? false;
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _biometricEnabled = prefs.getBool(_biometricKey) ?? false;
    _password = prefs.getString(_passwordKey) ?? '';
    _languageCode = prefs.getString(_languageCodeKey) ?? 'vi';
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_darkMode == value) return;

    _darkMode = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (_notificationsEnabled == value) return;

    _notificationsEnabled = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_notificationsKey, value);
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool value) async {
    if (_biometricEnabled == value) return;

    _biometricEnabled = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_biometricKey, value);
    notifyListeners();
  }

  Future<void> setLanguageCode(String value) async {
    final next = value.trim().toLowerCase();
    if (next != 'vi' && next != 'en') return;
    if (_languageCode == next) return;

    _languageCode = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_languageCodeKey, _languageCode);
    notifyListeners();
  }

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (newPassword.length < 4) {
      return 'New password must be at least 4 characters';
    }
    if (newPassword != confirmPassword) {
      return 'Password confirmation does not match';
    }
    if (_password.isNotEmpty && currentPassword != _password) {
      return 'Current password is incorrect';
    }
    if (_password == newPassword) {
      return null;
    }

    _password = newPassword;
    final prefs = await _prefsFuture;
    await prefs.setString(_passwordKey, _password);
    notifyListeners();
    return null;
  }
}
