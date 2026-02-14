# Tài liệu UI Components: Delivery Creation

Mô tả các thành phần giao diện và tương tác người dùng trên màn hình `DeliveryCreationQrCodePage`.

## 1. Cấu trúc Trang (Page Structure)

Màn hình được xây dựng bằng `Scaffold` với các khu vực chính:

*   **AppBar**: Hiển thị tiêu đề "納品作成" (Tạo phiếu giao hàng). Tự động ẩn nút quay lại khi đang gửi dữ liệu.
*   **Thông tin Đơn hàng**: Sử dụng `_buildOrderInfo` để hiển thị:
    *   Tên hiện trường (Site Name).
    *   Người phụ trách (Person in charge).
    *   Số điện thoại liên hệ.
*   **Danh sách Máy theo Sản phẩm**: Hiển thị các block máy móc được nhóm theo loại dầu.

## 2. Các Widgets quan trọng

### 1. Bảng Máy móc (`_buildMachineryTable`)
Một bảng hiển thị danh sách các máy cần cấp nhiên liệu:
- **Cột Hình ảnh**: Biểu tượng icon ảnh. Nhấp vào để xem/quản lý ảnh máy.
- **Cột Tên máy**: Tên máy móc.
- **Cột Số thân máy**: Biểu tượng số máy.
- **Cột Số lượng**: Một `TextField` chỉ nhận số.
    - Tự động thay thế `,` thành `.` khi nhập.
    - Bị vô hiệu hóa nếu đã giao hàng.
- **Cột Xóa**: Nút thùng rác để gỡ máy khỏi danh sách.

### 2. Dialog Thêm máy (`_showAddMachineryDialog`)
Hộp thoại cho phép người dùng thêm máy móc mới:
- **Radio Selection**: Chọn giữa "Từ Master" (Master Selection) hoặc "Đăng ký mới" (New Registration).
- **SearchableDropdown**: Tìm kiếm máy nhanh từ danh sách master (sử dụng widget `SearchableDropdown`).
- **Input Fields**: Nhập tên máy, số thân máy, số lượng.
- **Validation**: Hiển thị cảnh báo đỏ nếu số lượng trống hoặc sai định dạng.

### 3. Khu vực Sản phẩm khác (`_buildNonOilProductsSection`)
Hiển thị danh sách các sản phẩm tiêu hao (phụ gia, vật tư) đi kèm đơn hàng để tài xế nhập số lượng.

## 3. Trạng thái Tương tác (Interactive States)

*   **Loading Overlay**: Khi `isSubmitting` là true, một lớp phủ mờ với vòng xoay Loading và chữ "納品処理中..." (Đang xử lý giao hàng...) sẽ xuất hiện để ngăn người dùng thao tác.
*   **Keyboard Handling**: Sử dụng `GestureDetector` bao quanh ứng dụng để tự động đóng bàn phím khi chạm vào vùng trống.
*   **Cảnh báo Pop**: Sử dụng `PopScope` để hiển thị SnackBar cảnh báo nếu người dùng cố gắng quay lại khi dữ liệu đang được xử lý.

## 4. Assets sử dụng
- `assets/icon/ic_album.svg`: Icon khi có ảnh.
- `assets/icon/ic_no_image.svg`: Icon khi chưa có ảnh.
- `assets/icon/ic_trash.svg`: Icon xóa dòng máy.
