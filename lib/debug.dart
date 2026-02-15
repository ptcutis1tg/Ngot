import 'package:shared_preferences/shared_preferences.dart';

class DebugHelper {
  // In tất cả dữ liệu
  static Future<void> printAllData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();

    print('========== ALL SAVED DATA ==========');
    for (String key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    print('====================================');
  }

  // Xóa tất cả dữ liệu (Reset)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('✅ All data cleared!');
  }
}
