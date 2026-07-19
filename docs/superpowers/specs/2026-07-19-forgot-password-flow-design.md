# Thiết kế luồng Quên mật khẩu (OTP Verification)

## 1. Mục tiêu
Thay thế luồng "Quên mật khẩu" hiện tại (vốn dĩ chỉ gửi email rồi đẩy về màn hình đăng nhập) bằng một luồng hoàn chỉnh bao gồm nhập mã OTP (gửi qua email) và đổi mật khẩu trực tiếp trên ứng dụng.

## 2. Thay đổi về Giao diện (UI)
Tại file `lib/firstscreen/onboarding_flow.dart`:
- Thêm một trạng thái view mới: `_isVerifyOtpView`.
- Trạng thái luồng (Flow state) sẽ là: 
  `Login` -> Nhấn "Quên mật khẩu" -> `Forgot Password (Email)` -> Nhấn Gửi -> `Verify OTP & New Password` -> Thành công -> `Login`.
- Màn hình `Verify OTP` sẽ tái sử dụng `AnimatedSwitcher` hiện tại để tạo hiệu ứng chuyển cảnh mượt mà.
- Màn hình này bao gồm các trường nhập liệu (TextFields):
  1. **Mã xác nhận (OTP)**: 6 chữ số.
  2. **Mật khẩu mới**: Yêu cầu bảo mật cơ bản.
  3. **Nhập lại mật khẩu mới**: Khớp với mật khẩu mới.
  4. Nút **Xác nhận đổi mật khẩu**.

## 3. Thay đổi về Logic & API (Supabase)
### Bước 1: Gửi mã OTP
- Khi người dùng ở màn hình "Quên mật khẩu", gọi `resetPasswordForEmail` của Supabase.
- Đổi trạng thái hiển thị UI sang `_isVerifyOtpView = true`. Lưu lại email đã nhập.

### Bước 2: Xác thực & Đổi mật khẩu
- Khi người dùng điền OTP + Mật khẩu mới và nhấn nút:
  1. Kiểm tra tính hợp lệ: Mật khẩu mới và Nhập lại mật khẩu mới phải khớp nhau.
  2. Gọi `Supabase.instance.client.auth.verifyOTP(email, token: otp, type: OtpType.recovery)`.
  3. Nếu verify thành công, gọi ngay `Supabase.instance.client.auth.updateUser(UserAttributes(password: newPassword))`.
  4. Lập tức Sign out (`Supabase.instance.client.auth.signOut()`) để hủy session tạm và buộc họ đăng nhập lại.
  5. Đổi UI về `_isLoginView = true`, dọn dẹp các field nhập liệu và hiển thị Snackbar báo Đổi mật khẩu thành công.

## 4. Xử lý Lỗi (Error Handling)
- **Sai mã OTP**: Hiển thị Snackbar "Mã xác nhận không hợp lệ".
- **Lỗi mạng**: Quản lý bằng khối `try/catch` có sẵn.
- Trạng thái loading (`_isAuthLoading`) sẽ block các nút bấm chống click liên tục.

## 5. Dọn dẹp Code cũ
- Tạm thời giữ lại file `update_password_screen.dart` làm phương án dự phòng (fallback) nếu user bấm vào deep link thay vì nhập mã OTP bằng tay.
