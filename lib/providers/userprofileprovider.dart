import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';
  static const String _userAvatarKey = 'userAvatar';
  static const String _userFullNameKey = 'userFullName';
  static const String _userBioKey = 'userBio';
  static const String _defaultAvatar = 'assets/user/anonymous.jpg';

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  String _userName = '';
  String _userEmail = '';
  String _userAvatar = _defaultAvatar;
  String _userFullName = '';
  String _userBio = '';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatar => _userAvatar;
  String get userFullName => _userFullName;
  String get userBio => _userBio;

  Future<void> loadProfile() async {
    final prefs = await _prefsFuture;
    final nextName = prefs.getString(_userNameKey) ?? '';
    final nextEmail = prefs.getString(_userEmailKey) ?? '';
    final storedAvatar = prefs.getString(_userAvatarKey);
    final nextAvatar = (storedAvatar == null || storedAvatar.trim().isEmpty)
        ? _defaultAvatar
        : storedAvatar.trim();
    final nextFullName = prefs.getString(_userFullNameKey) ?? '';
    final nextBio = prefs.getString(_userBioKey) ?? '';

    if (_userName == nextName &&
        _userEmail == nextEmail &&
        _userAvatar == nextAvatar &&
        _userFullName == nextFullName &&
        _userBio == nextBio) {
      return;
    }

    _userName = nextName;
    _userEmail = nextEmail;
    _userAvatar = nextAvatar;
    _userFullName = nextFullName;
    _userBio = nextBio;
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final next = name.trim();
    if (_userName == next) return;

    _userName = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userNameKey, next);
    notifyListeners();
  }

  Future<void> setUserEmail(String email) async {
    final next = email.trim();
    if (_userEmail == next) return;

    _userEmail = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userEmailKey, next);
    notifyListeners();
  }

  Future<void> setUserAvatar(String avatar) async {
    final next = avatar.trim().isEmpty ? _defaultAvatar : avatar.trim();
    if (_userAvatar == next) return;

    _userAvatar = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userAvatarKey, next);
    notifyListeners();
  }

  Future<void> setUserFullName(String fullName) async {
    final next = fullName.trim();
    if (_userFullName == next) return;

    _userFullName = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userFullNameKey, next);
    notifyListeners();
  }

  Future<void> setUserBio(String bio) async {
    final next = bio.trim();
    if (_userBio == next) return;

    _userBio = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userBioKey, next);
    notifyListeners();
  }
}
