# Tài liệu Nghiệp vụ Màn hình Tạo phiếu Giao hàng (Delivery Creation)

Tài liệu này mô tả logic nghiệp vụ của tính năng tạo phiếu giao hàng (refueling information) tại hiện trường, cụ thể là màn hình `DeliveryCreationQrCodePage`.

## 1. Mục tiêu Nghiệp vụ
Màn hình này cho phép tài xế ghi nhận chi tiết về việc cấp phát nhiên liệu (dầu) và các sản phẩm đi kèm (không phải dầu) cho từng máy móc tại hiện trường xây dựng.

## 2. Luồng Xử lý Chính (Main Flow)

1.  **Khởi tạo**: Dữ liệu đơn hàng (`orderId`, `orderLineId`) được truyền vào. BLoC sẽ lấy chi tiết đơn hàng và các máy móc đã được gán cho đơn hàng này.
2.  **Phân nhóm Sản phẩm**: Các máy móc được nhóm theo loại sản phẩm (ví dụ: 軽油 - Dầu Diesel).
3.  **Quản lý Máy móc**:
    *   **Thêm máy**: Tài xế có thể chọn máy từ danh sách Master (đồng bộ từ server) hoặc đăng ký máy mới (nhập tay) nếu đang ở chế độ Offline.
    *   **Xóa máy**: Loại bỏ máy khỏi danh sách cấp phát hiện tại.
4.  **Nhập thông tin Cấp phát**:
    *   **Số lượng (Quantity)**: Tài xế nhập số lượng nhiên liệu đã đổ cho từng máy.
    *   **Hình ảnh**: Đính kèm hình ảnh máy móc hoặc đồng hồ đo (nếu cần).
5.  **Sản phẩm Khác (Non-Oil)**: Nhập số lượng cho các sản phẩm không phải là dầu (ví dụ: AdBlue, vật tư tiêu hao).
6.  **Xác nhận và Lưu**: 
    *   Khi nhấn "Xác nhận", dữ liệu được cập nhật vào cơ sở dữ liệu nội bộ (Realm).
    *   Ứng dụng chuyển sang màn hình chi tiết nạp nhiên liệu để tiếp tục luồng công việc (như lấy chữ ký).

## 3. Quy tắc Nghiệp vụ (Business Rules)

*   **Chế độ Offline**:
    *   Khi không có mạng, tính năng "Chọn từ Master" sẽ bị vô hiệu hóa.
    *   Tài xế bắt buộc phải sử dụng tính năng "Đăng ký mới" (New Registration) để nhập thông tin máy.
*   **Kiểm soát Trạng thái**:
    *   Nếu đơn hàng đã được giao (`isDelivered = true`), các trường nhập liệu sẽ bị chuyển sang chế độ chỉ đọc (Read-only).
    *   Trong quá trình đang gửi dữ liệu (`isSubmitting`), phím quay lại (Back button) sẽ bị vô hiệu hóa để tránh gián đoạn dữ liệu.
*   **Chuẩn hóa dữ liệu**:
    *   Số lượng nhập vào hỗ trợ cả dấu phẩy `,` và dấu chấm `.`, nhưng sẽ được chuẩn hóa về định dạng số thập phân chuẩn.
    *   Số lượng tối đa được giới hạn bởi cấu hình `Constant.inputProductQuantityMaxLength`.

## 4. Tương tác Dữ liệu Nội bộ (Local Persistence)
Trước khi đồng bộ lên server, mọi thay đổi được lưu tức thì vào **Realm** qua `LocalStorageService`:
*   `updateQrOrderQuantity`: Cập nhật số lượng cho từng máy hoặc sản phẩm.
*   `saveDeliveryOrder`: Lưu toàn bộ trạng thái đơn hàng giao hàng để sẵn sàng cho việc đồng bộ sau này.
