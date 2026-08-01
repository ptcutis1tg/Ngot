# AI Bill Scanner Design Spec

## 1. Mục tiêu (Objective)
Thêm tính năng chụp ảnh hóa đơn (bill) từ ứng dụng, sau đó gửi ảnh cho một AI xử lý hình ảnh (vision model) để tự động trích xuất các thông tin cốt lõi (Số tiền, Thời gian, Tên cửa hàng/món hàng). Kết quả trả về sẽ được tự động lưu trực tiếp vào cơ sở dữ liệu dưới dạng một giao dịch mới.

## 2. Yêu cầu hệ thống (Requirements)
- **Input:** Một tấm ảnh (File) chụp hóa đơn được lấy từ Camera của thiết bị.
- **Processing:** Gửi ảnh qua API HTTP POST tới một AI model độc lập. AI có nhiệm vụ đọc và bóc tách dữ liệu theo cấu trúc được chỉ định sẵn.
- **Output:** Dữ liệu JSON chứa `amount` (bắt buộc), `time` (bắt buộc), và `title` (tùy chọn - có thể là tên cửa hàng hoặc mô tả ngắn gọn món đồ).
- **Trải nghiệm người dùng:** Nhấn nút -> Chụp ảnh -> Chờ AI xử lý -> Lưu tự động và hiện Snackbar thông báo thành công (không qua bước trung gian mở form).

## 3. Kiến trúc (Architecture)

### 3.1. Giao diện (UI) - `main.dart`
Khu vực Floating Action Button ở màn hình chính sẽ được tái cấu trúc từ một nút duy nhất thành một nhóm nút (Row):
- Nút "Thêm giao dịch thủ công" (Dấu `+`).
- Nút "Chụp hóa đơn" (Icon Camera).

Khi người dùng nhấn nút Camera:
1. Gọi gói `image_picker` khởi chạy máy ảnh hệ thống.
2. Hiển thị Dialog Loading chặn tương tác ("Đang phân tích hóa đơn...").
3. Gọi lớp `BillScannerService` để xử lý.
4. Nhận kết quả, lưu vào `TransactionProvider`, đóng Dialog và hiện thông báo thành công.

### 3.2. Dịch vụ (Service) - `bill_scanner_service.dart`
Lớp chịu trách nhiệm kết nối mạng:
- Hàm `Future<TransactionProfile?> scanBill(File image)`
- **Định dạng dữ liệu trả về mong đợi từ AI (JSON):**
  ```json
  {
    "amount": 150000.0,
    "time": "2026-08-01T12:00:00",
    "title": "Bữa trưa / Mua sắm tạp hóa"
  }
  ```
  *(Lưu ý: `title` AI có thể tự đoán dựa trên hóa đơn).*
- **URL API:** API URL tạm thời sẽ lấy từ biến môi trường `AI_API_ENDPOINT` trong file `.env`. (Sẽ cần cấu hình cụ thể khi API đã sẵn sàng).

### 3.3. Dependencies (`pubspec.yaml`)
Cần bổ sung các gói thư viện sau:
- `image_picker`: Truy cập camera.
- `http`: Gửi ảnh và nhận phản hồi từ API.

## 4. Rủi ro & Cách phòng ngừa
- **AI trả về sai định dạng / Không đọc được:** Service cần có `try-catch` khi parse JSON. Nếu thất bại, quăng lỗi để UI bắt và báo cho người dùng: *"Không thể đọc hóa đơn, vui lòng thử lại hoặc nhập tay."*
- **Lỗi mạng (Timeout):** Thiết lập timeout cho HTTP Request (VD: 30s) vì các model AI xử lý ảnh có thể mất thời gian.
