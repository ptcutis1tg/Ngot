import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/transaction_provider.dart';
import '../providers/app_settings_provider.dart';
import '../providers/userprofileprovider.dart';
import '../models/transactionproflie.dart';

class SyncService {
  final _supabase = Supabase.instance.client;

  static const String _lastTxSyncKey = 'sync_last_tx_time';
  static const String _lastProfileSyncKey = 'sync_last_profile_time';

  Future<void> syncAll(
    TransactionProvider txProvider,
    AppSettingsProvider settingsProvider,
    UserProfileProvider profileProvider,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await syncTransactions(txProvider);
      await syncProfiles(settingsProvider, profileProvider);
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi đồng bộ: $e');
      }
    }
  }

  Future<void> syncTransactions(TransactionProvider provider) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(_lastTxSyncKey);
    final lastSync = lastSyncStr != null
        ? DateTime.parse(lastSyncStr)
        : DateTime.fromMillisecondsSinceEpoch(0);

    final now = DateTime.now();

    // 1. PUSH (Local -> Remote)
    final localTxs = await provider.getAllRawTransactions();
    final pendingTxs = localTxs.where((t) => t.updatedAt.isAfter(lastSync)).toList();
    
    for (final tx in pendingTxs) {
      final data = tx.toJson();
      data['user_id'] = user.id;
      await _supabase.from('transactions').upsert(data);
    }

    // 2. PULL (Remote -> Local)
    final remoteData = await _supabase
        .from('transactions')
        .select()
        .gt('updated_at', lastSync.toIso8601String());

    for (final row in remoteData) {
      final remoteTx = TransactionProfile.fromJson(row);
      await provider.upsertTransactionFromSync(remoteTx);
    }

    // 3. Cập nhật thời gian
    await prefs.setString(_lastTxSyncKey, now.toIso8601String());
  }

  Future<void> syncProfiles(
    AppSettingsProvider settings, 
    UserProfileProvider profile
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString(_lastProfileSyncKey);
    final lastSync = lastSyncStr != null
        ? DateTime.parse(lastSyncStr)
        : DateTime.fromMillisecondsSinceEpoch(0);

    final now = DateTime.now();

    // 1. PULL (Remote -> Local)
    final remoteData = await _supabase
        .from('user_profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    DateTime remoteUpdatedAt = DateTime.fromMillisecondsSinceEpoch(0);

    if (remoteData != null && remoteData['updated_at'] != null) {
       remoteUpdatedAt = DateTime.parse(remoteData['updated_at'] as String);
       
       if (remoteUpdatedAt.isAfter(settings.settingsUpdatedAt)) {
         await settings.updateSettingsFromSync(
           darkMode: remoteData['dark_mode'] as bool? ?? true,
           notificationsEnabled: remoteData['notifications_enabled'] as bool? ?? true,
           languageCode: remoteData['language_code'] as String? ?? 'vi',
           updatedAt: remoteUpdatedAt,
         );
       }
       if (remoteUpdatedAt.isAfter(profile.profileUpdatedAt)) {
         await profile.updateProfileFromSync(
           userName: remoteData['user_name'] as String? ?? '',
           userFullName: remoteData['user_full_name'] as String? ?? '',
           userBio: remoteData['user_bio'] as String? ?? '',
           userAvatar: remoteData['user_avatar'] as String? ?? 'assets/user/anonymous.jpg',
           updatedAt: remoteUpdatedAt,
         );
       }
    }

    // 2. PUSH (Local -> Remote)
    if (settings.settingsUpdatedAt.isAfter(lastSync) || 
        profile.profileUpdatedAt.isAfter(lastSync)) {
        
      final latestUpdate = settings.settingsUpdatedAt.isAfter(profile.profileUpdatedAt) 
           ? settings.settingsUpdatedAt 
           : profile.profileUpdatedAt;

      if (latestUpdate.isAfter(remoteUpdatedAt)) {
         await _supabase.from('user_profiles').upsert({
           'id': user.id,
           'dark_mode': settings.darkMode,
           'notifications_enabled': settings.notificationsEnabled,
           'language_code': settings.languageCode,
           'user_name': profile.userName,
           'user_full_name': profile.userFullName,
           'user_bio': profile.userBio,
           'user_avatar': profile.userAvatar,
           'updated_at': latestUpdate.toIso8601String(),
         });
      }
    }

    await prefs.setString(_lastProfileSyncKey, now.toIso8601String());
  }
}
