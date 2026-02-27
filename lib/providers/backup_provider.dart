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

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  bool _enabled = false;
  String _serverUrl = '';
  DateTime? _lastBackupAt;
  String _lastBackupStatus = 'No backup yet';
  bool _isBackingUp = false;
  bool _loaded = false;

  bool get enabled => _enabled;
  String get serverUrl => _serverUrl;
  DateTime? get lastBackupAt => _lastBackupAt;
  String get lastBackupStatus => _lastBackupStatus;
  bool get isBackingUp => _isBackingUp;

  Future<void> loadConfig() async {
    if (_loaded) return;

    final prefs = await _prefsFuture;
    _enabled = prefs.getBool(_backupEnabledKey) ?? false;
    _serverUrl = prefs.getString(_backupServerUrlKey) ?? '';
    final rawDate = prefs.getString(_lastBackupAtKey);
    _lastBackupAt = rawDate == null ? null : DateTime.tryParse(rawDate);
    _lastBackupStatus =
        prefs.getString(_lastBackupStatusKey) ?? 'No backup yet';
    _loaded = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    if (_enabled == value) return;

    _enabled = value;
    final prefs = await _prefsFuture;
    await prefs.setBool(_backupEnabledKey, value);
    notifyListeners();
  }

  Future<void> setServerUrl(String value) async {
    final next = value.trim();
    if (_serverUrl == next) return;

    _serverUrl = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_backupServerUrlKey, _serverUrl);
    notifyListeners();
  }

  Future<bool> backupNow({
    required UserProfileProvider userProvider,
    required TransactionProvider transactionProvider,
  }) async {
    if (!_enabled || _serverUrl.isEmpty) {
      _lastBackupStatus = 'Backup disabled or missing endpoint URL';
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
        _lastBackupStatus = 'Backup completed';
        await _persistBackupMeta();
        return true;
      }

      _lastBackupStatus = 'Server error: ${response.statusCode}';
      await _persistBackupMeta();
      return false;
    } catch (_) {
      _lastBackupStatus = 'Cannot connect to backup server';
      await _persistBackupMeta();
      return false;
    } finally {
      _isBackingUp = false;
      notifyListeners();
    }
  }

  Future<void> _persistBackupMeta() async {
    final prefs = await _prefsFuture;
    if (_lastBackupAt != null) {
      await prefs.setString(_lastBackupAtKey, _lastBackupAt!.toIso8601String());
    }
    await prefs.setString(_lastBackupStatusKey, _lastBackupStatus);
  }
}
