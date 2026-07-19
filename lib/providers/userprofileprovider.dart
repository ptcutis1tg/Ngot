import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String _userNameKey = 'userName';
  static const String _userEmailKey = 'userEmail';
  static const String _userAvatarKey = 'userAvatar';
  static const String _userFullNameKey = 'userFullName';
  static const String _userBioKey = 'userBio';
  static const String _defaultAvatar = 'assets/user/anonymous.jpg';
  static const String _profileUpdatedAtKey = 'profile_updated_at';

  final Future<SharedPreferences> _prefsFuture =
      SharedPreferences.getInstance();

  String _userName = '';
  String _userEmail = '';
  String _userAvatar = _defaultAvatar;
  String _userFullName = '';
  String _userBio = '';
  DateTime _profileUpdatedAt = DateTime.fromMillisecondsSinceEpoch(0);

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userAvatar => _userAvatar;
  String get userFullName => _userFullName;
  String get userBio => _userBio;
  DateTime get profileUpdatedAt => _profileUpdatedAt;

  Future<void> _markUpdated(SharedPreferences prefs) async {
    _profileUpdatedAt = DateTime.now();
    await prefs.setString(_profileUpdatedAtKey, _profileUpdatedAt.toIso8601String());
  }

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

    final updatedAtStr = prefs.getString(_profileUpdatedAtKey);
    if (updatedAtStr != null) {
      _profileUpdatedAt = DateTime.tryParse(updatedAtStr) ?? DateTime.fromMillisecondsSinceEpoch(0);
    }
    notifyListeners();
  }

  Future<void> setUserName(String name) async {
    final next = name.trim();
    if (_userName == next) return;

    _userName = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userNameKey, next);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> setUserEmail(String email) async {
    final next = email.trim();
    if (_userEmail == next) return;

    _userEmail = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userEmailKey, next);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> setUserAvatar(String avatar) async {
    final next = avatar.trim().isEmpty ? _defaultAvatar : avatar.trim();
    if (_userAvatar == next) return;

    _userAvatar = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userAvatarKey, next);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> setUserFullName(String fullName) async {
    final next = fullName.trim();
    if (_userFullName == next) return;

    _userFullName = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userFullNameKey, next);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> setUserBio(String bio) async {
    final next = bio.trim();
    if (_userBio == next) return;

    _userBio = next;
    final prefs = await _prefsFuture;
    await prefs.setString(_userBioKey, next);
    await _markUpdated(prefs);
    notifyListeners();
  }

  Future<void> updateProfileFromSync({
    required String userName,
    required String userFullName,
    required String userBio,
    required String userAvatar,
    required DateTime updatedAt,
  }) async {
    _userName = userName;
    _userFullName = userFullName;
    _userBio = userBio;
    _userAvatar = userAvatar;
    _profileUpdatedAt = updatedAt;

    final prefs = await _prefsFuture;
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userFullNameKey, userFullName);
    await prefs.setString(_userBioKey, userBio);
    await prefs.setString(_userAvatarKey, userAvatar);
    await prefs.setString(_profileUpdatedAtKey, updatedAt.toIso8601String());
    
    notifyListeners();
  }
}
