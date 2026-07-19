import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const int _passwordHashIterations = 120000;
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _notificationsKey = 'settings_notifications';
  static const String _biometricKey = 'settings_biometric';
  static const String _legacyPasswordKey = 'settings_app_password';
  static const String _passwordHashKey = 'settings_app_password_hash';
  static const String _languageCodeKey = 'settings_language_code';
  static const String _settingsUpdatedAtKey = 'settings_updated_at';

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  bool _loaded = false;
  bool _darkMode = true;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _passwordHash = '';
  String _languageCode = 'vi';
  DateTime _settingsUpdatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  bool get darkMode => _darkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get biometricEnabled => _biometricEnabled;
  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);
  bool get hasPassword => _passwordHash.isNotEmpty;
  DateTime get settingsUpdatedAt => _settingsUpdatedAt;

  Future<void> _markUpdated(SharedPreferences prefs) async {
    _settingsUpdatedAt = DateTime.now();
    await prefs.setString(_settingsUpdatedAtKey, _settingsUpdatedAt.toIso8601String());
  }

  Future<void> loadSettings() async {
    if (_loaded) return;

    final prefs = await _prefsFuture;
    _darkMode = prefs.getBool(_darkModeKey) ?? true;
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _biometricEnabled = prefs.getBool(_biometricKey) ?? false;
    _passwordHash = prefs.getString(_passwordHashKey) ?? '';
    final legacyPassword = prefs.getString(_legacyPasswordKey) ?? '';
    if (_passwordHash.isEmpty && legacyPassword.isNotEmpty) {
      _passwordHash = _hashPassword(legacyPassword);
      await prefs.setString(_passwordHashKey, _passwordHash);
      await prefs.remove(_legacyPasswordKey);
    }
    _languageCode = prefs.getString(_languageCodeKey) ?? 'vi';
    final updatedAtStr = prefs.getString(_settingsUpdatedAtKey);
    if (updatedAtStr != null) {
      _settingsUpdatedAt = DateTime.tryParse(updatedAtStr) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_darkMode == value) return;

    _darkMode = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_darkModeKey, value);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool value) async {
    if (_notificationsEnabled == value) return;

    _notificationsEnabled = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_notificationsKey, value);
    await _markUpdated(prefs);
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
    if (next != 'vi' && next != 'en' && next != 'ko') return;
    if (_languageCode == next) return;

    _languageCode = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_languageCodeKey, _languageCode);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> updateSettingsFromSync({
    required bool darkMode,
    required bool notificationsEnabled,
    required String languageCode,
    required DateTime updatedAt,
  }) async {
    _darkMode = darkMode;
    _notificationsEnabled = notificationsEnabled;
    _languageCode = languageCode;
    _settingsUpdatedAt = updatedAt;

    final prefs = await _prefsFuture;
    await prefs.setBool(_darkModeKey, darkMode);
    await prefs.setBool(_notificationsKey, notificationsEnabled);
    await prefs.setString(_languageCodeKey, languageCode);
    await prefs.setString(_settingsUpdatedAtKey, updatedAt.toIso8601String());
    
    notifyListeners();
  }

  Future<void> setPinLockEnabled(bool value) async {
    if (_pinLockEnabled == value) return;

    _pinLockEnabled = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_pinLockEnabledKey, value);
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
    if (_passwordHash.isNotEmpty &&
        !_verifyPassword(currentPassword, _passwordHash)) {
      return 'Current password is incorrect';
    }
    if (_passwordHash.isNotEmpty &&
        _verifyPassword(newPassword, _passwordHash)) {
      return null;
    }

    _passwordHash = _hashPassword(newPassword);
    final prefs = await _prefsFuture;
    await prefs.setString(_passwordHashKey, _passwordHash);
    await prefs.remove(_legacyPasswordKey);
    notifyListeners();
    return null;
  }

  String _hashPassword(String password) {
    final saltBytes =
        List<int>.generate(16, (_) => Random.secure().nextInt(256));
    final salt = base64UrlEncode(saltBytes);
    final digest = _pbkdf2(
      password: password,
      salt: saltBytes,
      iterations: _passwordHashIterations,
    );
    return 'v1\$_passwordHashIterations\$$salt\$${base64UrlEncode(digest)}';
  }

  bool _verifyPassword(String password, String storedHash) {
    final parts = storedHash.split(r'$');
    if (parts.length != 4 || parts.first != 'v1') {
      return false;
    }

    final iterations = int.tryParse(parts[1]);
    if (iterations == null || iterations < 1) {
      return false;
    }

    final salt = base64Url.decode(parts[2]);
    final expected = base64Url.decode(parts[3]);
    final actual = _pbkdf2(
      password: password,
      salt: salt,
      iterations: iterations,
      keyLength: expected.length,
    );
    return _constantTimeEquals(actual, expected);
  }

  List<int> _pbkdf2({
    required String password,
    required List<int> salt,
    required int iterations,
    int keyLength = 32,
  }) {
    final hmac = Hmac(sha256, utf8.encode(password));
    final blockCount = (keyLength / sha256.convert([]).bytes.length).ceil();
    final derivedKey = <int>[];

    for (var block = 1; block <= blockCount; block++) {
      final blockSalt = [
        ...salt,
        (block >> 24) & 0xff,
        (block >> 16) & 0xff,
        (block >> 8) & 0xff,
        block & 0xff,
      ];
      var previous = hmac.convert(blockSalt).bytes;
      final output = List<int>.from(previous);

      for (var i = 1; i < iterations; i++) {
        previous = hmac.convert(previous).bytes;
        for (var j = 0; j < output.length; j++) {
          output[j] ^= previous[j];
        }
      }

      derivedKey.addAll(output);
    }

    return derivedKey.take(keyLength).toList();
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }

    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
