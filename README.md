# Simple Store - Flutter E-commerce App

**Simple Store** là một ứng dụng mua sắm trực tuyến hiện đại được xây dựng bằng Flutter. Ứng dụng tích hợp **FakeStore API** để cung cấp dữ liệu thực tế, kết hợp với các kỹ thuật tối ưu hóa hiệu suất và trải nghiệm người dùng như phân trang (pagination) và quản lý trạng thái tập trung.

## 🚀 Tính năng chính

- **Dữ liệu Sản phẩm Thực tế**: Tích hợp [FakeStore API](https://fakestoreapi.com/) để lấy danh sách sản phẩm.
- **Giao diện Hiện đại (Material 3)**: Thiết kế với tông màu tối (Dark Mode) sang trọng, sử dụng linh hoạt các thành phần của Material 3.
- **Banner Khuyến mãi**: Hệ thống banner tự động chạy (Auto-play Carousel) sử dụng `PageView` và `Timer`.
- **Tìm kiếm & Lọc thông minh**:
    - Tìm kiếm sản phẩm theo tên thời gian thực.
    - Lọc sản phẩm theo danh mục (Electronics, Jewelery, Men's Clothing, Women's Clothing).
- **Tối ưu hóa Cuộn (Infinite Scrolling)**: Tự động tải thêm dữ liệu khi người dùng cuộn xuống cuối trang (Pagination), giúp ứng dụng hoạt động mượt mà.
- **Quản lý Giỏ hàng**: 
    - Thêm/Xóa sản phẩm, cập nhật số lượng.
    - Quản lý trạng thái bằng `Provider`.
    - Dữ liệu được lưu trữ bền vững qua `SharedPreferences`.
- **Thanh toán & Đơn hàng**:
    - Quy trình Checkout đơn giản.
    - Theo dõi lịch sử đơn hàng với các trạng thái (Pending, Shipping, Delivered).
    - Sử dụng `ValueNotifier` trong `OrderStore` để cập nhật trạng thái đơn hàng tức thì.

## 🛠 Công nghệ sử dụng

- **Flutter & Dart**: Framework phát triển ứng dụng di động.
- **Provider**: Quản lý trạng thái giỏ hàng.
- **ValueNotifier & Singleton Pattern**: Quản lý và lưu trữ dữ liệu đơn hàng.
- **Http**: Kết nối REST API.
- **Shared Preferences**: Lưu trữ dữ liệu cục bộ (Local Storage).

## 📂 Cấu trúc dự án

```text
lib/
├── models/         # Chứa các model dữ liệu (Product, Category, Order,...)
├── providers/      # Quản lý trạng thái (CartProvider, OrderStore)
├── screens/        # Các màn hình (Home, Cart, Detail, Order History, Checkout)
└── main.dart       # Điểm khởi chạy ứng dụng
```

## 📦 Cài đặt và Chạy ứng dụng

1. **Clone repository:**
   ```bash
   git clone https://github.com/your-username/SimpleStore.git
   ```
2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```
3. **Chạy ứng dụng:**
   ```bash
   flutter run
   ```

---
*Dự án được thực hiện bởi: **TH4 - Nhóm G3_C4***
