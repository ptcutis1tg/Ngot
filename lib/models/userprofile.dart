import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'userprofile.g.dart';

@HiveType(typeId: 1)
class UserProfile extends HiveObject with ChangeNotifier {
  @HiveField(0)
  late String _name;

  @HiveField(1)
  String? _profilePicPath = 'assets/user/anonymous.jpg';

  @HiveField(2)
  double? totalBalance;

  @HiveField(3)
  DateTime? createdAt;

  // Getter
  String get name => _name;
  String? get profilePic => _profilePicPath;

  // Setter - tự động phát hiện thay đổi
  set name(String value) {
    if (_name != value) {
      _name = value;
      notifyListeners(); // Thông báo thay đổi
    }
  }

  // Setter - tự động phát hiện thay đổi profilePicPath
  set profilePicPath(String? value) {
    if (_profilePicPath != value) {
      _profilePicPath = value;
      notifyListeners(); // Thông báo thay đổi
    }
  }

  UserProfile({
    required String name,
    String? profilePicPath = 'assets/user/anonymous.jpg',
    this.totalBalance,
    this.createdAt,
  })  : _name = name,
        _profilePicPath = profilePicPath;
}
