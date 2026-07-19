# Kế hoạch Tối ưu hóa Hiệu năng & Nâng cấp Bảo mật (Daily Expense Diary)

## Mục tiêu
- Loại bỏ các thành phần Code Generation (`build_runner`, `hive_generator`) làm chậm quá trình biên dịch.
- Chuyển đổi dữ liệu từ `SharedPreferences` sang NoSQL để tăng hiệu năng lưu trữ và tính toán.
- Áp dụng các tiêu chuẩn bảo mật cao cấp (Mã hóa Database AES-256 + Bảo mật Key qua Keystore/Keychain).
- Cải thiện tốc độ render của Widget Tree bằng cách gỡ bỏ các đoạn tính toán thừa.

## 1. Loại bỏ Dead Code & Phụ thuộc dư thừa
- Quét dự án cho thấy các thư viện `hive`, `hive_flutter` và `hive_generator` được nạp vào, đồng thời file `userprofile.dart` được cài cắm annotaions. Tuy nhiên, toàn bộ luồng thực thi trong `UserProfileProvider` không hề gọi đến file model này. 
- **Hành động:** 
  - Gỡ bỏ hoàn toàn `hive`, `hive_flutter`, `hive_generator` và `build_runner` khỏi `pubspec.yaml`.
  - Xóa bỏ `lib/models/userprofile.dart` và `lib/models/userprofile.g.dart`.

## 2. Di chuyển từ SharedPreferences sang Sembast
- `SharedPreferences` không phù hợp để lưu trữ hàng nghìn bản ghi giao dịch (`TransactionProfile`) do phải ghi đè và parse toàn bộ JSON string liên tục.
- **Giải pháp:** Sử dụng `sembast`, một NoSQL Database viết thuần bằng Dart (không cần `build_runner`). Sembast cung cấp API bất đồng bộ tốc độ cao và cho phép chèn Codec mã hóa dễ dàng.
- Thiết lập Conditional Imports (`db_factory.dart`) để ứng dụng có thể build chéo cả trên Web (`sembast_web`) lẫn Desktop/Mobile (`sembast_io`).

## 3. Nâng cấp Bảo mật Mã hóa (AES-256)
- **Vấn đề:** Ứng dụng tài chính lưu trữ giao dịch dạng plain text (như trước đây dùng SharedPreferences) là lỗi bảo mật nghiêm trọng.
- **Giải pháp:**
  - Tích hợp package `encrypt` và `flutter_secure_storage`.
  - Ở lần khởi chạy đầu tiên, sinh ra một khóa `Secret Key` (AES-256) ngẫu nhiên.
  - Khóa bí mật này được đẩy xuống phần cứng thiết bị (Keystore trên Android / Keychain trên iOS / Web Crypto trên Web) thông qua `flutter_secure_storage`.
  - Viết Custom Codec `_SembastEncryptCodec` dùng khóa lấy từ secure storage để mã hóa/giải mã on-the-fly dữ liệu ghi xuống Sembast.

## 4. Tối ưu hóa Widget Tree
- Tại file `dashboard_components.dart`, `RecentList` đang khởi tạo một bản sao và sort `TransactionProfile` bên trong hàm `build()`.
- Việc này tạo thêm gánh nặng cho UI Thread ở mỗi chu kỳ render, đặc biệt khi danh sách giao dịch lớn.
- Dữ liệu vốn đã được sắp xếp từ `TransactionProvider.loadTransactions()`.
- **Hành động:** Xóa bỏ lệnh copy & sort trong `build()`, trực tiếp đọc danh sách đã được tối ưu.

## 5. Xác minh
- Chạy `flutter pub get` để tải các thư viện mới (`sembast`, `sembast_web`, `encrypt`, `flutter_secure_storage`, `path`).
- Chạy `dart analyze` để đảm bảo code sạch.
- Biên dịch ứng dụng để xác nhận Hot Restart & Cold Build diễn ra thành công và nhanh hơn.
