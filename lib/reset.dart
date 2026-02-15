import 'package:shared_preferences/shared_preferences.dart';

class AppInitializer {
  // Flag để kiểm tra có reset hay không
  static const String _resetFlagKey = 'app_reset_on_launch';

  // Initialize app với option reset
  static Future<void> initialize({bool resetData = false}) async {
    final prefs = await SharedPreferences.getInstance();

    if (resetData) {
      // Xóa tất cả dữ liệu
      await prefs.clear();
      print('🔄 App data reset successfully!');
    }

    // Khởi tạo dữ liệu mặc định
    bool userProfileExists = prefs.getBool('userProfileExists') ?? false;

    if (!userProfileExists) {
      await prefs.setBool('userProfileExists', true);
      await prefs.setString('userName', '');
      await prefs.setString('userEmail', '');
      await prefs.setString('userAvatar', 'https://i.pravatar.cc/150?img=11');
      print('✅ User profile initialized');
    }
  }
}
