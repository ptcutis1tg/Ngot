# Extreme RAM & Build Optimization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Triệt để tối ưu hóa việc chiếm dụng RAM và giảm dung lượng Build bằng cách áp dụng bộ nhớ đệm thủ công, RepaintBoundary, và Deferred Loading.

**Architecture:** Sử dụng `PaintingBinding.instance.imageCache` để giới hạn bộ nhớ ảnh, dùng deferred loading tách JS bundle, và bọc các UI phức tạp vào `RepaintBoundary` để tiết kiệm chu kỳ GPU. Sembast sẽ bị giới hạn để không gây tràn RAM.

**Tech Stack:** Flutter, Dart, Sembast.

## Global Constraints

- Dart version >= 3.0.0
- Không phá vỡ luồng người dùng (UX) hiện tại.

---

### Task 1: Thiết lập Global Memory Limits (PaintingBinding)

**Files:**
- Modify: `lib/main.dart`

**Interfaces:**
- Thay đổi cấu hình khởi tạo của Flutter.

- [ ] **Step 1: Thêm giới hạn PaintingBinding vào hàm `main()`**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Giới hạn RAM cho Image Cache
  PaintingBinding.instance.imageCache.maximumSize = 20; // Tối đa 20 ảnh
  PaintingBinding.instance.imageCache.maximumSizeBytes = 20 << 20; // Tối đa 20MB
```

- [ ] **Step 2: Commit**

```bash
git add lib/main.dart
git commit -m "perf: limit global image cache size to 20MB"
```

### Task 2: Tối ưu Asset Decoding & RepaintBoundary

**Files:**
- Modify: `lib/firstscreen/dashboard_components/dashboard_components.dart`
- Modify: `lib/firstscreen/statistic_screen.dart`

**Interfaces:**
- Đảm bảo các component không render lại dư thừa.

- [ ] **Step 1: Thay thế các ListView thường thành ListView.builder và bọc biểu đồ vào RepaintBoundary**

Tìm các biểu đồ (ví dụ `PieChart` trong dashboard hoặc `LineChart`/`BarChart` trong statistic_screen) và bọc bằng `RepaintBoundary`.

```dart
RepaintBoundary(
  child: PieChart(
     // ...
  ),
)
```

- [ ] **Step 2: Đảm bảo các widget cuộn lớn dùng `ListView.builder`**
*(Chỉnh sửa các file chứa danh sách giao dịch để dùng `.builder`)*

- [ ] **Step 3: Commit**

```bash
git add lib/firstscreen/dashboard_components/dashboard_components.dart lib/firstscreen/statistic_screen.dart
git commit -m "perf: use RepaintBoundary for charts and optimize ListViews"
```

### Task 3: Giới hạn Cache Sembast

**Files:**
- Modify: `lib/firstscreen/widget/addtransaction.dart` (hoặc file chứa logic query Sembast chính)

**Interfaces:**
- Thay vì lấy toàn bộ record, sử dụng `Finder(limit: 500)` hoặc xoá bớt data cũ.

- [ ] **Step 1: Cập nhật hàm load data từ Sembast**

```dart
final finder = Finder(
  sortOrders: [SortOrder('date', false)],
  limit: 500, // Chỉ load 500 giao dịch gần nhất vào RAM
);
```

- [ ] **Step 2: Commit**

```bash
git add .
git commit -m "perf: limit sembast memory footprint to 500 recent transactions"
```

### Task 4: Triển khai Deferred Loading cho Web

**Files:**
- Modify: `lib/main.dart`

**Interfaces:**
- Tách file JS.

- [ ] **Step 1: Sửa import thành deferred**

```dart
import 'package:flutter_application_1/firstscreen/dashboard_components/dashboard_components.dart' deferred as dashboard;
import 'package:flutter_application_1/firstscreen/statistic_screen.dart' deferred as statistic;
import 'package:flutter_application_1/firstscreen/wallet_screen.dart' deferred as wallet;
import 'package:flutter_application_1/firstscreen/settings_screen.dart' deferred as settings;
```

- [ ] **Step 2: Tạo FutureBuilder bên trong các tab của IndexedStack / BottomNavigationBar**

```dart
FutureBuilder(
  future: dashboard.loadLibrary(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return dashboard.DashboardComponents();
    }
    return const Center(child: CircularProgressIndicator());
  },
)
```

- [ ] **Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "perf: implement deferred loading for main tabs"
```

### Task 5: Cấu trúc lệnh Build (--split-per-abi)

**Files:**
- Modify: `android/app/build.gradle`

- [ ] **Step 1: Bật split per abi tự động trong Android build.gradle**

```gradle
android {
    buildTypes {
        release {
            ndk {
                abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
            }
        }
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add android/app/build.gradle
git commit -m "build: setup split-per-abi for android release"
```
