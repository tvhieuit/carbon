# Order Detail UI Documentation

Tài liệu này mô tả cấu trúc giao diện và các thành phần UI trong màn hình Chi tiết đơn hàng (`OrderDetailPage`).

## 1. Cấu trúc Tổng quan (Layout Overview)
Màn hình được xây dựng bằng `Scaffold` với `SingleChildScrollView` để chứa các thẻ thông tin (Sections). Dữ liệu được quản lý bởi `OrderDetailBloc` và phản ứng theo 3 trạng thái chính:
- **Loading**: Hiển thị vòng xoay chờ (`CircularProgressIndicator`).
- **Error**: Hiển thị thông báo lỗi và nút "Thử lại" (`Retry`).
- **Loaded**: Hiển thị toàn bộ các thành phần thông tin chi tiết.

---

## 2. Các Thành phần Giao diện (UI Sections)

### A. Header & Thời gian (`_buildDeliveryHeader`)
- **Vị trí**: Trên cùng của danh sách cuộn.
- **Nội dung**:
    - Tiêu đề: "Chi tiết đơn hàng" (`DELIVERY_DETAILS_TITLE`).
    - Thời gian: Hiển thị khung giờ cấp dầu (ví dụ: `08:00-10:00`).
- **Logic**: Tự động lấy khung giờ từ API (`orderDetail`), nếu không có sẽ lấy từ dữ liệu đơn hàng ban đầu (`order`).

### B. Thông tin Giao hàng (`_buildDeliveryInfo`)
- **Hiển thị**: Danh sách các cặp Label - Value trong một thẻ trắng (`Card`).
- **Các trường dữ liệu**:
    - Cửa hàng, Nhân viên thực hiện.
    - Công ty, Chi nhánh khách hàng.
    - Tên hiện trường, Người phụ trách.
    - **Số điện thoại**: Hiển thị màu xanh và có thể nhấn vào để thực hiện cuộc gọi (`url_launcher`).

### C. Bảng sản phẩm (`_buildProductTable`)
- **Cấu trúc**: Bảng gồm 2 cột: **Tên sản phẩm** và **Số lượng**.
- **Tính năng**: 
    - Hiển thị danh sách tất cả `orderLines`.
    - Nếu khối lượng chưa xác định, hiển thị text "Hiện trường xác nhận" (`現地確認`).

### D. Bản đồ & Vị trí (`_buildLocationSection`)
- **Địa chỉ**: Hiển thị địa chỉ đầy đủ của hiện trường.
- **External Map**: Nút "Link bản đồ" để mở ứng dụng Google Maps ngoài.
- **Embedded Map**: Tích hợp `GoogleMap` widget trực tiếp trong app:
    - Hiển thị Marker tại tọa độ của hiện trường.
    - Camera tự động căn giữa và zoom (mặc định zoom level 17).

### E. Ghi chú (`_buildNotesAndCaseNotesSection`)
- Hiển thị hai phần ghi chú riêng biệt:
    - **Ghi chú (`REMARKS`)**: Xử lý dữ liệu động (có thể là String, List hoặc Map).
    - **Ghi chú vụ việc (`CASE_NOTES`)**.

---

## 3. Thanh Điều hướng Dưới (`_buildBottomButtons`)
Thanh này luôn cố định ở dưới màn hình (`bottomNavigationBar`):

| Nút | Hành động | Logic |
| :--- | :--- | :--- |
| **Quay lại** | Đóng màn hình hiện tại | `Navigator.pop(context)` |
| **Hành động chính** | Sang màn quét QR / Biên nhận | Bị vô hiệu hóa (`grey`) nếu tài xế không có quyền hoặc đơn bị hủy. |

**Logic điều hướng của nút chính**:
- Nếu đơn hàng chưa hoàn thành (`isDelivered == false`): Điều hướng sang màn hình **Quét mã QR** (`deliveryCreationQrCode`).
- Nếu đơn hàng đã hoàn thành (`isDelivered == true`): Điều hướng sang màn hình **Xem biên nhận** (`fuelingDetailQrcode`).

---

## 4. Resource & Dependencies
- **Localization**: Sử dụng phương thức `.tr` và `.trParams` để hỗ trợ đa ngôn ngữ.
- **Packages**: `google_maps_flutter`, `url_launcher`, `flutter_bloc`.
