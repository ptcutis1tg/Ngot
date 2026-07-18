import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugHelper {
  // In tất cả dữ liệu
  static Future<void> printAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    debugPrint('========== ALL SAVED DATA ==========');
    for (String key in keys) {
      debugPrint('$key: ${prefs.get(key)}');
    }
    debugPrint('====================================');
  }

  // Xóa tất cả dữ liệu (Reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    debugPrint('✅ All data cleared!');
  }
}
