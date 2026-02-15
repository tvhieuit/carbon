# Tài liệu Nghiệp vụ Màn hình Chi tiết Xác nhận Giao hàng (Fueling Details)

Tài liệu này mô tả logic nghiệp vụ của màn hình xác nhận cuối cùng, ký tên và in biên nhận, cụ thể là màn hình `QrCodeFuelingDetailsPage`.

## 1. Mục tiêu Nghiệp vụ
Đây là bước cuối cùng trong quy trình giao hàng. Mục tiêu là để khách hàng kiểm tra lại toàn bộ số lượng nhiên liệu/hàng hóa đã cấp, thực hiện ký xác nhận điện tử và nhận biên nhận (in hoặc số hóa).

## 2. Luồng Xử lý Chính (Main Flow)

1.  **Kiểm tra Tổng hợp**: Hiển thị bảng tổng hợp tất cả các máy móc và sản phẩm đã được nhập từ màn hình `DeliveryCreation`.
2.  **Lấy Chữ ký**: 
    *   Tài xế yêu cầu người phụ trách tại hiện trường ký tên vào vùng cảm ứng.
    *   Chữ ký được vẽ bằng các điểm (Points) và có thể xóa để ký lại.
3.  **Gửi Đơn hàng (Submit)**:
    *   Khi nhấn "Gửi đơn hàng", ứng dụng sẽ upload ảnh chữ ký lên server trước.
    *   Sau đó gọi API `postOrder` để ghi nhận phiếu giao hàng chính thức.
4.  **Tạo Biên nhận**: 
    *   Sau khi gửi thành công, server trả về Số biên nhận (Receipt Number).
    *   Ứng dụng sử dụng một View ẩn (`ReceiptView`) để chụp ảnh màn hình (Capture) toàn bộ thông tin phiếu kèm chữ ký và số biên nhận.
    *   Ảnh này được upload ngược lại server để lưu trữ làm bằng chứng pháp lý.
5.  **In ấn**: Sau khi mọi bước hoàn tất, nút "In biên nhận" (Print) sẽ được kích hoạt để tài xế in ra máy in cầm tay qua Bluetooth.

## 3. Quy tắc Nghiệp vụ (Business Rules)

*   **Offline Handling**: 
    *   Nếu không có internet khi nhấn "Gửi", đơn hàng sẽ được lưu vào Realm với trạng thái "Chờ đồng bộ". 
    *   Người dùng sẽ nhận được cảnh báo và phải đồng bộ lại sau.
*   **Trình tự Bắt buộc**:
    *   Chưa có chữ ký -> Không thể nhấn "Gửi".
    *   Chưa gửi thành công -> Không thể nhấn "In".
*   **Tự động Capture**:
    *   Ngay khi nhận được `receipt_number` từ backend, hệ thống tự động thực hiện việc capture ảnh biên nhận mà không cần tài xế thao tác.

## 4. Quản lý Trạng thái In (Print Status)
*   Tính năng In chỉ khả dụng khi: Đã có ảnh biên nhận cuối cùng được lưu trữ thành công trên server (`receiptFileId` != null).
*   Nếu in thất bại, ứng dụng sẽ gợi ý mở cài đặt máy in Bluetooth.
