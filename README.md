# Simple Store - Flutter E-commerce App

Simple Store là một ứng dụng mua sắm trực tuyến hiện đại, mượt mà và đầy đủ tính năng, được xây dựng bằng Flutter. Ứng dụng sử dụng FakeStore API để cung cấp dữ liệu sản phẩm thực tế và tích hợp các kỹ thuật tối ưu hóa trải nghiệm người dùng tiên tiến.

## 🚀 Tính năng chính

*   **Dữ liệu sản phẩm thực tế**: Tích hợp FakeStore API để lấy danh sách sản phẩm đa dạng.
*   **Trải nghiệm cuộn mượt mà**:
    *   **Pull to Refresh**: Vuốt từ trên xuống để làm mới danh sách sản phẩm.
    *   **Infinite Scrolling (Pagination)**: Tự động tải thêm sản phẩm khi cuộn xuống cuối trang.
*   **Tìm kiếm & Lọc**:
    *   Tìm kiếm sản phẩm theo tên thời gian thực.
    *   Lọc sản phẩm theo danh mục (Electronics, Jewelery, Men's Clothing, Women's Clothing).
*   **Quản lý Giỏ hàng**:
    *   Thêm sản phẩm vào giỏ hàng với các tùy chọn thuộc tính.
    *   Cập nhật số lượng, xóa sản phẩm hoặc chọn nhiều sản phẩm để thanh toán.
    *   **Lưu trữ cục bộ**: Tự động lưu giỏ hàng vào bộ nhớ máy (SharedPreferences).
*   **Quy trình Thanh toán (Checkout)**:
    *   Nhập thông tin địa chỉ nhận hàng.
    *   Hỗ trợ nhiều phương thức thanh toán: COD (Thanh toán khi nhận hàng) và Ví Momo.
*   **Quản lý Đơn mua**:
    *   Xem lịch sử đơn hàng được phân loại theo trạng thái: **Chờ xác nhận, Đang giao, Đã giao, Đã hủy**.
    *   **Hủy đơn hàng**: Người dùng có thể chủ động hủy các đơn hàng đang ở trạng thái "Chờ xác nhận".
    *   Thông báo xác nhận và phản hồi trạng thái đơn hàng trực quan qua Dialog và BottomSheet.

## 🛠 Công nghệ sử dụng

*   **Flutter & Dart**: Framework phát triển ứng dụng đa nền tảng.
*   **Provider**: Quản lý trạng thái (State Management) hiệu quả.
*   **Http**: Kết nối và xử lý dữ liệu từ REST API.
*   **Shared Preferences**: Lưu trữ dữ liệu giỏ hàng và đơn hàng cục bộ bền vững.
*   **Material 3**: Ngôn ngữ thiết kế giao diện hiện đại nhất của Google.

## 📦 Cài đặt và Chạy thử

1.  **Clone repository**:
    ```bash
    git clone https://github.com/your-username/SimpleStore.git
    ```
2.  **Di chuyển vào thư mục dự án**:
    ```bash
    cd SimpleStore
    ```
3.  **Cài đặt các thư viện phụ thuộc**:
    ```bash
    flutter pub get
    ```
4.  **Chạy ứng dụng**:
    ```bash
    flutter run
    ```

---
*Dự án được phát triển nhằm mục đích học tập và thực hành các kỹ năng lập trình Flutter chuyên sâu.*
