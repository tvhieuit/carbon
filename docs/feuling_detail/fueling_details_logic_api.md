# Tài liệu Logic & API: Fueling Details

Chi tiết về các kết nối API, xử lý file và luồng dữ liệu trong `QrCodeFuelingDetailsBloc`.

## 1. API Endpoints

Các API chính được gọi:

| Chức năng | Phương thức | Endpoint Path | Controller |
| :--- | :--- | :--- | :--- |
| **Gửi đơn hàng** | `POST` | `/driver/orders` | `postOrder` |
| **Upload Chữ ký/Biên nhận** | `POST` | `/files` | `FileUtil.uploadFile` |
| **Lấy URL File** | `GET` | `/files/{id}/url` | `FileUtil.generateFileUrl` |
| **Cập nhật Chữ ký vào đơn** | `PUT` | `/driver/orders/{order_id}/receipts/{receipt_id}/update-signature` | `updateReceiptSignature` |
| **Cập nhật File biên nhận** | `PUT` | `/driver/orders/{order_id}/receipts/{receipt_id}/update-file` | `updateReceiptFile` |

## 2. Luồng Dữ liệu Phức tạp (Complex Flows)

### A. Quy trình Submit & Capture
Quy trình này gồm nhiều bước đan xen giữa Local và Remote:
1.  **Local Save**: Lưu đơn hàng vào Realm (trạng thái chưa gửi).
2.  **Signature Upload**: Upload file ảnh chữ ký (nếu có) lấy được ID.
3.  **Post Order**: Gọi API gửi đơn hàng kèm `receiptSignatureId`.
4.  **Auto Capture**: 
    *   Nhận `receipt_number` từ phản hồi API.
    *   Kích hoạt Render View ẩn để chụp ảnh `ReceiptView`.
    *   Upload ảnh vừa chụp lên server.
    *   Gọi API `updateReceiptFile` để gắn ID ảnh này vào đơn hàng.

### B. Đồng bộ Chữ ký
Đối với các đơn hàng đã giao (nhưng chưa in hoặc cần xem lại):
- Bloc sẽ gọi API lấy URL chữ ký từ server.
- Tải ảnh về và lưu vào thư mục `Documents` của thiết bị để hiển thị Offline.

## 3. Trạng thái BLoC (`QrCodeFuelingDetailsState`)

- `FuelingDetailsInitial`: Khởi tạo.
- `FuelingDetailsLoaded`: Chứa `deliveryOrder`, `signatureUrl`, và các cờ trạng thái `isSubmitEnabled`, `isPrintEnabled`.
- `FuelingDetailsSubmitSuccess`: Gửi đơn hàng thành công, bắt đầu luồng capture.
- `FuelingDetailsPrintSuccess/Error`: Kết quả quá trình in.

## 4. Xử lý File và Ảnh (File Handling)
- **Ký tên**: Sử dụng `CustomPainter` để vẽ các điểm `signaturePoints` thành đường nét.
- **Capture**: Sử dụng `RepaintBoundary` để chuyển đổi Widget thành `ui.Image` -> `Uint8List` -> `File`.
- **Đường dẫn**: Ảnh được lưu tạm thời trong `getApplicationDocumentsDirectory()` trước khi upload.
