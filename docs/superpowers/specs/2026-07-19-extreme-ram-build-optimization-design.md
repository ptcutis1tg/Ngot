# Thiết Kế: Extreme RAM & Build Optimization
Ngày: 2026-07-19

## Bối cảnh
Ứng dụng (đặc biệt khi chạy trên Web và thiết bị cấu hình yếu) thường xuyên tiêu tốn nhiều RAM và có dung lượng build lớn. Nguyên nhân đến từ việc load toàn bộ JS bundle một lần, giữ quá nhiều ảnh trong RAM (Cache mặc định của Flutter rất lớn), và render lại toàn bộ màn hình liên tục. Sembast cũng có đặc tính load mọi thứ vào RAM.

## Giải pháp (Đã chốt)

### 1. Can thiệp Hệ thống Bộ nhớ (PaintingBinding)
- Ghi đè cấu hình mặc định của Flutter trong `main.dart` ngay sau khi khởi tạo ứng dụng:
  - Giảm `maximumSize` của Image Cache từ 1000 ảnh xuống còn 20 ảnh.
  - Giảm `maximumSizeBytes` từ 100MB xuống 20MB (`20 << 20`).
- Mọi hình ảnh hiển thị (dù là ảnh tài khoản hay ảnh placeholder) bắt buộc phải dùng thuộc tính `cacheWidth` hoặc `cacheHeight` để Flutter chỉ decode ảnh đúng bằng số pixel thực tế.

### 2. Tải chậm (Deferred Loading) cho Từng Tab
- Tại màn hình chính có Bottom Navigation Bar (4 Tab: Home, Report, Wallet, Settings), thay đổi cách `import` truyền thống sang `import ... deferred as name`.
- Khi người dùng nhấn vào một tab mới, hiển thị một `CircularProgressIndicator` nhỏ trong vài mili-giây để tải phần JS bundle của tab đó vào RAM, sau đó mới render Widget.
- Ưu điểm: Chia nhỏ file `main.dart.js` khổng lồ thành các file `.js` rất nhỏ, giúp Web load nhanh gấp đôi ở lần khởi động đầu tiên.

### 3. RepaintBoundary & Giảm tải UI
- Bọc các danh sách cuộn (`ListView.builder`) và các biểu đồ bằng `RepaintBoundary`. Điều này sẽ tách phần tử đồ họa đó ra một layer riêng, khi cuộn hoặc có hiệu ứng hover, toàn bộ nền màn hình không phải vẽ lại (tiết kiệm GPU cycle).
- Đảm bảo loại bỏ mọi `SingleChildScrollView + Column` trong các danh sách dài.

### 4. Giới hạn Dữ liệu Sembast (RAM limit)
- Nếu Sembast phình to, toàn bộ data JSON của db sẽ load thẳng vào RAM.
- Cấu hình lại Sembast để dọn dẹp các giao dịch quá cũ (quá 1000 giao dịch hoặc quá 1 năm) ra khỏi file cục bộ. Nếu user kéo xuống sâu hơn, lấy từ nguồn Remote.

### 5. Tối ưu cấu hình Build (CI/CD)
- Thêm cờ `--split-per-abi` cho nền tảng Android.
- Bật `tree-shaking` nghiêm ngặt và tối ưu các cờ `--dart-define` để cắt giảm debug symbols trong production.

## Rủi ro & Trade-offs
- Deferred Loading có thể làm luồng chuyển tab lần ĐẦU TIÊN (khi mới mở web) chậm đi khoảng 100-300ms. Các lần sau sẽ bình thường vì đã lưu cache.
- Tự động dọn data Sembast có thể khiến user không xem được lịch sử siêu cũ khi mất mạng.
