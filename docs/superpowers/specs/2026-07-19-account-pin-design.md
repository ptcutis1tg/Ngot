# Thiết kế PIN đồng bộ theo tài khoản

## Mục tiêu

Cho phép mỗi tài khoản Supabase tùy chọn thiết lập một mã PIN gồm đúng 6 chữ số. PIN đi theo tài khoản trên mọi thiết bị, được gợi ý khi người dùng đăng nhập mà chưa thiết lập, có thể quản lý từ Profile và có thể đặt lại qua email khôi phục. PIN không tham gia vào luồng đổi mật khẩu.

## Phạm vi

- Lưu trạng thái PIN trong `user_metadata` của Supabase Auth.
- Gợi ý PIN 6 số ngẫu nhiên khi thiết lập; người dùng có thể dùng gợi ý hoặc tự nhập PIN khác.
- Yêu cầu người dùng xác nhận PIN trước khi lưu.
- Hiển thị lời nhắc sau đăng nhập nếu tài khoản chưa có PIN; người dùng có thể bỏ qua mà không thiết lập.
- Thêm mục quản lý PIN trong Profile: thiết lập, thay đổi và xoá PIN.
- Hỗ trợ quên PIN bằng email khôi phục Supabase, sau đó cho đặt PIN mới.

## Không thuộc phạm vi

- PIN không dùng để thay thế mật khẩu đăng nhập Supabase.
- PIN không dùng để xác nhận hoặc thay đổi mật khẩu tài khoản.
- Không tạo bảng, Edge Function hoặc RPC Supabase mới.
- Không hiển thị hoặc khôi phục lại PIN cũ.

## Mô hình dữ liệu

Ứng dụng lưu trong `user_metadata.pin` đối tượng sau:

```json
{
  "version": 1,
  "salt": "base64url-random-salt",
  "hash": "base64url-pbkdf2-sha256-output"
}
```

- `salt` được sinh ngẫu nhiên cho từng lần tạo hoặc đổi PIN.
- `hash` là PBKDF2-HMAC-SHA256 của PIN, dùng salt trên và số vòng lặp cố định trong ứng dụng.
- Chỉ gửi cấu trúc trên đến `Supabase.auth.updateUser`; không lưu PIN rõ, không log PIN.
- PIN gồm chính xác sáu ký tự ASCII từ `0` đến `9`; giữ được số `0` ở đầu.

## Luồng người dùng

### Sau đăng nhập

1. Đăng nhập Supabase thành công.
2. Ứng dụng đọc `currentUser.userMetadata['pin']`.
3. Nếu không có PIN hợp lệ, hiển thị hộp thoại: **Thiết lập PIN** hoặc **Để sau**.
4. Chọn **Để sau** đóng hộp thoại; lần đăng nhập thành công tiếp theo sẽ nhắc lại.
5. Chọn **Thiết lập PIN** mở màn hình thiết lập PIN.

### Thiết lập hoặc đổi PIN

1. Màn hình hiển thị một PIN ngẫu nhiên gồm 6 số và nút dùng PIN gợi ý.
2. Người dùng có thể nhập một PIN 6 số khác.
3. Người dùng nhập lại PIN để xác nhận.
4. Ứng dụng kiểm tra định dạng và hai lần nhập trùng nhau, băm PIN, rồi gọi `auth.updateUser(data: {'pin': pinRecord})`.
5. Khi thành công, màn hình thông báo và Profile phản ánh trạng thái mới.
6. Khi đổi hoặc xoá PIN, người dùng phải nhập đúng PIN hiện tại trước khi thao tác được gửi.

### Quên PIN

1. Người dùng chọn **Quên PIN?** từ giao diện xác nhận PIN.
2. Ứng dụng gọi `resetPasswordForEmail(email, redirectTo: ...)` với liên kết deep link khôi phục sẵn có của app.
3. Khi Supabase phát sự kiện `passwordRecovery`, router chuyển đến màn hình đặt PIN mới thay vì màn hình đổi mật khẩu.
4. Người dùng đặt và xác nhận PIN mới; bản ghi `user_metadata.pin` được thay thế.

## Thành phần ứng dụng

- Dịch vụ/tiện ích PIN thuần Dart: tạo PIN gợi ý, kiểm tra định dạng, tạo bản ghi băm và xác minh PIN.
- Provider quản lý trạng thái PIN hiện tại, đồng bộ metadata và các thao tác tạo/đổi/xoá.
- Hộp thoại nhắc PIN sau đăng nhập.
- Màn hình thiết lập/đổi PIN có thể dùng lại trong Profile và luồng khôi phục.
- Mục PIN trong màn hình Profile.
- Router và xử lý sự kiện Supabase recovery dành cho đặt lại PIN.

## Xử lý lỗi và bảo mật

- Không cho phép lưu PIN thiếu, dài/ngắn hơn 6 ký tự hoặc chứa ký tự không phải số.
- Lỗi Supabase hiển thị thông báo thân thiện, giữ nguyên dữ liệu nhập để người dùng thử lại.
- Luồng đặt lại yêu cầu một phiên `passwordRecovery` hợp lệ của Supabase; không có phiên thì chuyển về đăng nhập.
- Vì `user_metadata` được phía ứng dụng đọc được, đây là PIN tiện dụng/xác nhận thao tác chứ không phải yếu tố xác thực mạnh. Người có phiên đăng nhập có thể có được mã băm và thử đoán PIN ngoại tuyến.

## Kiểm thử

- Unit test: sinh PIN, kiểm tra định dạng, băm/xác minh đúng và sai, dữ liệu metadata không hợp lệ.
- Widget test: lời nhắc sau đăng nhập chỉ hiện khi chưa có PIN; thiết lập PIN yêu cầu hai lần nhập hợp lệ; chọn bỏ qua đóng lời nhắc.
- Provider test với Supabase client trừu tượng: payload metadata, đổi/xoá khi PIN hiện tại hợp lệ và xử lý lỗi.
