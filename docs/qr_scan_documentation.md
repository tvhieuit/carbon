# Tài liệu Màn hình Quét mã QR (QrScan - Carbon v2)

Tài liệu này mô tả logic nghiệp vụ tổng quan cho tính năng quét mã QR. 

> [!TIP]
> Để xem chi tiết kỹ thuật về các API endpoints, tham số và luồng dữ liệu, vui lòng tham khảo [Tài liệu Logic và API QR Scan](file:///Users/admn/workspace/Carbon/docs/qr_scan_logic_api.md).

## 1. Tổng quan Nghiệp vụ (Business Logic)

Màn hình này cho phép tài xế quét mã QR dán trên máy móc tại hiện trường để lấy thông tin đơn hàng và ghi nhận khối lượng cấp nhiên liệu.

### A. Luồng Xử lý Chính (Main Flow)
1. **Quét mã QR**: Sử dụng camera để quét mã QR. Nội dung mã QR là một chuỗi JSON chứa `machine_id`.
2. **Lấy thông tin Máy móc**: Ứng dụng gọi API để lấy thông tin chi tiết về máy (`machine_name`, `machine_number`) và hiện trường (`construction_site_name`).
3. **Lấy Đơn hàng liên quan**: Dựa trên hiện trường (`construction_site_id`), ứng dụng tìm các đơn hàng đang chờ (`NEW`) của tài xế đó trong ngày hôm nay.
4. **Kiểm tra trạng thái đã cấp (Check Completed)**: Ứng dụng kiểm tra trong cơ sở dữ liệu nội bộ (Realm) xem máy này đã được cấp nhiên liệu trong ngày hôm nay chưa. Nếu có, sẽ hiển thị cảnh báo cho tài xế.
5. **Nhập khối lượng**: Hiển thị hộp thoại (Dialog) để tài xế xác nhận thông tin và nhập số lượng (`quantity`) nhiên liệu đã cấp.
6. **Lưu trữ nội bộ**: Thông tin sau khi nhập được lưu vào bộ nhớ cục bộ (Local Storage - Realm) thay vì gọi API cập nhật ngay lập tức. Việc đồng bộ dữ liệu sẽ được thực hiện ở một bước khác (thường là ở màn hình Trang chủ).

### B. Các Quy tắc Nghiệp vụ (Business Rules)
- **Chuẩn hóa số liệu**: Khi nhập số lượng, dấu phẩy `,` sẽ tự động được chuyển thành dấu chấm `.` để đảm bảo định dạng số thập phân.
- **Trạng thái Quét**: Nếu không tìm thấy đơn hàng hoặc có lỗi API, ứng dụng sẽ thông báo lỗi và cho phép reset camera để quét lại.
- **Phân tách đơn hàng**: Nếu đơn hàng có thuộc tính `is_separate`, ứng dụng có thể điều hướng sang luồng xử lý chi tiết khác (tùy vào cài đặt trong `OrderCard`).

---

## 2. Chi tiết các API được gọi (API References)

Dưới đây là các API mà `QrScanBloc` thực hiện gọi:

| Chức năng | API Endpoint Path | Method | Controller/Usecase Method |
| :--- | :--- | :--- | :--- |
| **Lấy thông tin QR** | `/driver/construction-site/machines/{machine_id}` | `GET` | `QrcodeController.fetchQrInfo` |
| **Lấy Đơn hàng theo máy**| `/driver/order-lines` | `GET` | `StaffController.fetchDriverOrderLines` |

### Chi tiết tham số API

#### 1. Lấy thông tin QR (`fetchQrInfo`)
- **Path Params**:
  - `machine_id`: Lấy từ nội dung mã QR sau khi quét.

#### 2. Lấy Đơn hàng theo máy (`fetchDriverOrderLines`)
- **Query Params**:
  - `construction_site_id`: Lấy từ kết quả của API `fetchQrInfo`.
  - `shipping_driver_id`: ID của tài xế đang đăng nhập.
  - `refueling_date`: Ngày hiện tại (định dạng `yyyy-MM-dd`).
  - `orderStatus`: `['NEW']` (Chỉ lấy các đơn hàng mới/đang chờ).

---

## 3. Cấu trúc UI Components

- **`QrScanPage`**: Màn hình chính chứa camera scanner.
- **`MobileScanner`**: Thành phần điều khiển camera và nhận diện barcode.
- **`MachineInfoDialog`**: Hộp thoại hiển thị thông tin máy móc và form nhập liệu sau khi quét thành công.

---

## 4. Xử lý Dữ liệu Nội bộ (Local Data)

Tác vụ này không gọi API `POST/PUT` để lưu lên server ngay. Thay vào đó, nó tương tác với `LocalStorageService` (Realm):
- **Read**: `getMarchineOfflineById` để kiểm tra máy đã đổ dầu chưa.
- **Write**: `saveQrCodeOrder` để lưu thông tin đơn hàng vừa quét vào hàng chờ xử lý.
