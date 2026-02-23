# Tài liệu UI Components: Fueling Details

Tài liệu này mô tả các thành phần giao diện đặc thù và tương tác trên màn hình `QrCodeFuelingDetailsPage`.

## 1. Thành phần chính của Trang

### A. Header & Thông tin Chung (`_buildHeader`)
- Hiển thị tên hiện trường nổi bật.
- Tự động chuyển đổi ngày dương lịch sang định dạng **Niên hiệu Nhật Bản (Reiwa)**.
- Hiển thị tên người phụ trách lấy từ thông tin User đăng nhập.

### B. Bảng Tổng hợp Nhiêu liệu (`_buildMachineryGroupByProduct`)
- Phân nhóm các máy móc theo loại sản phẩm dầu.
- Mỗi nhóm có một bảng con bao gồm: STT, Tên máy, Số thân máy, Số lượng (L).
- Phần **Total** hiển thị tổng cộng số lượng cho từng loại sản phẩm.

### C. Bảng Sản phẩm Ngoài dầu (`_buildNonOilProductsTable`)
- Chỉ hiển thị nếu đơn hàng có các mặt hàng phụ trợ.
- Cấu trúc bảng đơn giản hơn chỉ gồm: STT, Tên sản phẩm, Số lượng (Cái/Bình).

## 2. Thành phần Tương tác Kỹ thuật

### A. Vùng Ký tên (`_buildSignatureSection`)
- Một `GestureDetector` bao quanh một vùng màu xám.
- Nếu đơn hàng đã hoàn tất: Hiển thị ảnh chữ ký tải từ server (`Image.network`).
- Nếu đang thực hiện: Hiển thị vùng trống với dòng chữ "Nhấp để ký tên".
- Trạng thái: Sẽ bị khóa (Lock) nếu phiếu đã được xác nhận in xong.

### B. Hộp thoại Ký tên (`_showSignaturePad`)
- Mở một `AlertDialog` toàn màn hình.
- Sử dụng `StatefulBuilder` để cập nhật tọa độ điểm vẽ theo thời gian thực.
- Có nút "Xóa" (Clear) để xóa toàn bộ các điểm đã vẽ.

### C. View tạo Biên nhận (`ReceiptView`)
Đây là một Widget **đặc biệt** có 2 chế độ:
1. **Chế độ Print Preview**: Hiển thị cho người dùng xem trước khi in.
2. **Chế độ Capture**: 
    - Bị ẩn đi bằng `Opacity(0.01)`.
    - Được bọc trong `RepaintBoundary`.
    - Dùng để tạo ra file ảnh biên nhận cuối cùng sạch đẹp (không có các nút điều hướng) để lưu trữ.

## 3. Các trạng thái Nút bấm (Bottom Buttons)
Dựa trên trạng thái đơn hàng, các nút sẽ thay đổi:
- **Button Gửi**: Hiện khi chưa submit. Cần có chữ ký mới nhấn được.
- **Button In**: Hiện sau khi submit thành công và đã hoàn tất luồng upload file biên nhận.
- **Nút Back**: Tự động chuyển thành luồng "Về trang chủ" nếu đã in thành công.
