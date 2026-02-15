import 'package:hive/hive.dart';

// Tên file này phải trùng với tên file hiện tại + .g.dart
part 'userprofile.g.dart';

@HiveType(typeId: 1) // Sử dụng typeId khác với Transaction (ví dụ: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name; // Bắt buộc

  @HiveField(1)
  String? profilePicPath; // Bắt buộc (Lưu đường dẫn ảnh hoặc URL)

  @HiveField(2)
  double? totalBalance; // Tùy chọn, có thể thêm sau

  @HiveField(3)
  DateTime? createdAt; // Tùy chọn

  // Constructor với các tham số bắt buộc dùng từ khóa 'required'
  UserProfile({
    required this.name,
    required this.profilePicPath,
    this.totalBalance,
    this.createdAt,
  });
}
