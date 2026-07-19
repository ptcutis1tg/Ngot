import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializer {
  // Initialize app với option reset
  static Future<void> initialize({bool resetData = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (resetData) {
      // Xóa tất cả dữ liệu
      await prefs.clear();
      debugPrint('🔄 App data reset successfully!');
    }

    // Khởi tạo dữ liệu mặc định
    bool userProfileExists = prefs.getBool('userProfileExists') ?? false;

    if (!userProfileExists) {
      await prefs.setBool('userProfileExists', true);
      await prefs.setString('userName', '');
      await prefs.setString('userEmail', '');
      await prefs.setString('userAvatar', 'assets/user/anonymous.jpg');
      debugPrint('✅ User profile initialized');
    }
  }
}
