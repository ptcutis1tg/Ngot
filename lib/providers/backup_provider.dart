import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'transaction_provider.dart';
import 'userprofileprovider.dart';

class BackupProvider extends ChangeNotifier {
  static const String _backupEnabledKey = 'backup_enabled';
  static const String _backupServerUrlKey = 'backup_server_url';
  static const String _lastBackupAtKey = 'backup_last_at';
  static const String _lastBackupStatusKey = 'backup_last_status';

  bool _enabled = false;
  String _serverUrl = '';
  DateTime? _lastBackupAt;
  String _lastBackupStatus = 'Chưa sao lưu';
  bool _isBackingUp = false;
  bool _loaded = false;

  bool get enabled => _enabled;
  String get serverUrl => _serverUrl;
  DateTime? get lastBackupAt => _lastBackupAt;
  String get lastBackupStatus => _lastBackupStatus;
  bool get isBackingUp => _isBackingUp;

  Future<void> loadConfig() async {
    if (_loaded) return;
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_backupEnabledKey) ?? false;
    _serverUrl = prefs.getString(_backupServerUrlKey) ?? '';
    final rawDate = prefs.getString(_lastBackupAtKey);
    _lastBackupAt = rawDate == null ? null : DateTime.tryParse(rawDate);
    _lastBackupStatus =
        prefs.getString(_lastBackupStatusKey) ?? 'Chưa sao lưu';
    _loaded = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backupEnabledKey, value);
    notifyListeners();
  }

  Future<void> setServerUrl(String value) async {
    _serverUrl = value.trim();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_backupServerUrlKey, _serverUrl);
    notifyListeners();
  }

  Future<bool> backupNow({
    required UserProfileProvider userProvider,
    required TransactionProvider transactionProvider,
  }) async {
    if (!_enabled || _serverUrl.isEmpty) {
      _lastBackupStatus = 'Tắt sao lưu hoặc chưa có URL';
      notifyListeners();
      return false;
    }

    _isBackingUp = true;
    notifyListeners();

    try {
      final uri = Uri.parse(_serverUrl);
      final client = HttpClient();
      final request = await client.postUrl(uri);
      final payload = {
        'timestamp': DateTime.now().toIso8601String(),
        'profile': {
          'userName': userProvider.userName,
          'userEmail': userProvider.userEmail,
          'userAvatar': userProvider.userAvatar,
        },
        'transactions':
            transactionProvider.transactions.map((e) => e.toJson()).toList(),
      };
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload));
      final response = await request.close();
      await response.drain();
      client.close();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        _lastBackupAt = DateTime.now();
        _lastBackupStatus = 'Sao lưu thành công';
        await _persistBackupMeta();
        return true;
      }

      _lastBackupStatus = 'Lỗi server: ${response.statusCode}';
      await _persistBackupMeta();
      return false;
    } catch (_) {
      _lastBackupStatus = 'Không thể kết nối server';
      await _persistBackupMeta();
      return false;
    } finally {
      _isBackingUp = false;
      notifyListeners();
    }
  }

  Future<void> _persistBackupMeta() async {
    final prefs = await SharedPreferences.getInstance();
    if (_lastBackupAt != null) {
      await prefs.setString(_lastBackupAtKey, _lastBackupAt!.toIso8601String());
    }
    await prefs.setString(_lastBackupStatusKey, _lastBackupStatus);
  }
}
