# Data Sync (Offline-First) Architecture Design

## 1. Overview
Mục tiêu là đồng bộ dữ liệu cục bộ của ứng dụng (lịch sử giao dịch và tùy chỉnh cá nhân) với máy chủ Supabase để cho phép sử dụng đa thiết bị, theo mô hình **Offline-First**.

## 2. Kiến trúc cốt lõi
- **Offline-First:** Tất cả các thao tác trên UI đều đọc/ghi trực tiếp vào bộ nhớ cục bộ (Sembast cho Giao dịch, SharedPreferences cho Cài đặt). Đảm bảo phản hồi giao diện tức thì và hoạt động hoàn hảo khi offline.
- **Sync Trigger (On-Demand):** Đồng bộ diễn ra ở các thời điểm:
  1. Khi khởi động ứng dụng.
  2. Khi người dùng vuốt để làm mới (Pull-to-Refresh) ở màn hình chính.
- **Conflict Resolution (Giải quyết xung đột):** Áp dụng Last-Write-Wins (LWW) - dữ liệu nào có `updated_at` lớn hơn (mới hơn) sẽ ghi đè lên dữ liệu cũ.
- **Soft Deletes (Xóa mềm):** Khi người dùng xóa giao dịch offline, giao dịch không bị xóa hoàn toàn khỏi DB mà chỉ bị đánh dấu `is_deleted = true`. Khi có mạng, cờ này đẩy lên Supabase để đồng bộ việc xóa sang máy khác, và bị bỏ qua trên giao diện UI.

## 3. Cập nhật Model Dữ liệu
### 3.1. TransactionProfile
Hiện tại thiếu định danh duy nhất. Cần thêm:
- `id` (String - UUID): Khóa chính chung giữa các thiết bị.
- `updated_at` (DateTime): Thời gian thao tác gần nhất để so sánh xung đột.
- `is_deleted` (bool): Đánh dấu xóa mềm.
- `user_id` (String): Khóa ngoại liên kết với tài khoản (Supabase Auth).

*Migration:* Đối với những người dùng cũ, app sẽ tự động tạo UUID mới cho các bản ghi cũ và gán `updated_at = time`.

### 3.2. Settings Profile
Đồng bộ `AppSettingsProvider` lên bảng `user_settings` trên Supabase, gồm các cột:
- `user_id` (String - PK)
- `dark_mode` (bool)
- `language_code` (String)
- `notifications_enabled` (bool)
- `updated_at` (DateTime)

## 4. Thuật toán Đồng bộ (Sync Logic)
Tạo mới một file `SyncService` để quản lý luồng đồng bộ:
### Đẩy lên mạng (Push: Local -> Remote)
1. Quét tìm tất cả các giao dịch cục bộ có `updated_at > last_sync_time`.
2. Đẩy (Upsert) các bản ghi này lên bảng `transactions` trên Supabase.
3. Đẩy cài đặt hiện tại lên bảng `user_settings` nếu có thay đổi kể từ lần cuối đồng bộ.

### Tải về máy (Pull: Remote -> Local)
1. Lấy tất cả giao dịch từ Supabase có `updated_at > last_sync_time` VÀ `user_id = current_user`.
2. Với mỗi giao dịch tải về:
   - Nếu bản ghi cục bộ chưa có: Thêm mới vào Sembast.
   - Nếu đã có: So sánh `updated_at`. Nếu bản trên mạng mới hơn, cập nhật lại Sembast.
3. Tải `user_settings`. Nếu trên mạng có `updated_at` mới hơn, cập nhật lại cấu hình local (SharedPreferences).
4. Ghi nhận `last_sync_time = now`.

## 5. Bảo mật & Cơ sở dữ liệu
- Yêu cầu thiết lập **Row Level Security (RLS)** trên Supabase:
  - Bảng `transactions`: Cấu hình Policy `user_id = auth.uid()`
  - Bảng `user_settings`: Cấu hình Policy `user_id = auth.uid()`
- Ứng dụng chỉ được đồng bộ dữ liệu khi người dùng đã đăng nhập thành công.
