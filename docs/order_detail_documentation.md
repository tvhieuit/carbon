# Tài liệu Màn hình Chi tiết đơn hàng (Order Detail)

Màn hình này hiển thị thông tin chi tiết về một đơn hàng cấp nhiên liệu, cho phép tài xế xem thông tin khách hàng, hiện trường và bắt đầu quy trình giao hàng.

## 1. Tính năng Chính
- **Thông tin khách hàng & Hiện trường**: Hiển thị tên công ty, chi nhánh, tên hiện trường và địa chỉ đầy đủ.
- **Thời gian yêu cầu**: Hiển thị ngày và khung giờ dự kiến cấp nhiên liệu.
- **Danh sách mặt hàng**: Hiển thị các sản phẩm (Dầu DO, v.v.) và khối lượng yêu cầu.
- **Thông tin tài xế**: Hiển thị tên tài xế được gán cho đơn hàng này.
- **Nút hành động**: 
    - Cho phép "Bắt đầu cấp dầu" (Chuyển sang màn quét QR).
    - Hiển thị thông tin biên nhận (nếu đơn hàng đã giao xong).

## 2. Quy tắc Nghiệp vụ quan trọng
- **Gán tài xế**: Chỉ tài xế được gán cho đơn hàng mới có quyền thực hiện các thao tác xử lý. Nếu đơn hàng chưa có tài xế, người đầu tiên nhấn bắt đầu sẽ được hệ thống ghi nhận.
- **Trạng thái đơn hàng**: Trạng thái được cập nhật tự động qua các bước từ `NEW` -> `DELIVERING` -> `COMPLETED`.

## 3. Tài liệu Kỹ thuật
> [!IMPORTANT]
> Để xem chi tiết về cấu trúc API, các tham số và logic xử lý dữ liệu phức tạp trong code, vui lòng truy cập:
> [**Tài liệu Logic và API Chi tiết đơn hàng**](file:///Users/admn/workspace/Carbon/docs/order_detail_logic_api.md)

---

- **Thành phần Giao diện (UI Components)**: Chi tiết về các Widget, Layout và tương tác người dùng. Xem thêm tại [Tài liệu UI Chi tiết đơn hàng](file:///Users/admn/workspace/Carbon/docs/order_detail_ui.md).
