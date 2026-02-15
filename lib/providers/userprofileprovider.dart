import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  String _userName = '';
  String _userEmail = '';
  String _userAvatar = 'https://i.pravatar.cc/150?img=11';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatar => _userAvatar;

  // Load profile từ SharedPreferences lần đầu
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    _userAvatar =
        prefs.getString('userAvatar') ?? 'https://i.pravatar.cc/150?img=11';
    notifyListeners();
  }

  // Cập nhật tên
  Future<void> setUserName(String name) async {
    _userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    notifyListeners();
  }

  // Cập nhật email
  Future<void> setUserEmail(String email) async {
    _userEmail = email;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    notifyListeners();
  }

  // Cập nhật avatar
  Future<void> setUserAvatar(String avatar) async {
    _userAvatar = avatar;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userAvatar', avatar);
    notifyListeners();
  }
}
