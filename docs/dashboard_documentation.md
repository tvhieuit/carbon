# Tài liệu Màn hình Dashboard (Carbon v2)

Tài liệu này tổng hợp chi tiết logic nghiệp vụ và các API tích hợp cho màn hình Dashboard trong ứng dụng Carbon.

## 1. Tổng quan Nghiệp vụ (Business Logic)

Màn hình Dashboard quản lý danh sách đơn hàng cấp nhiên liệu theo thời gian thực.

### A. Luồng Khởi tạo & Phân quyền (Auth & Init)
- **Tài xế/Nhân viên nội bộ (`isInHourse`)**:
  - Tự động lấy danh sách Cửa hàng (`stores`) của Tenant.
  - Lấy danh sách Nhân viên (`staffs`) thuộc cửa hàng đó.
  - Tự động chọn store và staff ID của user để filter dữ liệu ban đầu.
- **Tài xế/Công ty ngoài**: Chỉ hiển thị đơn hàng thuộc phạm vi quản lý của ID/Company tương ứng.

### B. Logic Xử lý Dữ liệu trên UI
- **Nhóm đơn hàng theo giờ (Order Grouping)**:
  - Hệ thống tự động tạo các slot thời gian từ **07:00 đến 20:00**.
  - Các đơn hàng được đưa vào slot giờ tương ứng dựa trên `refuelingFromTime`.
- **Logic màu sắc trạng thái (`_bgCellColor`)**:
  - `Màu Xám`: Đơn hàng bị Hủy (`キャンセル`).
  - `Màu Xanh lá`: Đã hoàn thành (Có `receiptFileId` hoặc status `納品済`).
  - `Màu Cam`: Quá hạn (Chưa hoàn thành và quá thời gian `refuelingToTime`).
  - `Màu Trắng`: Đang chờ hoặc chưa đến giờ.

### C. Chế độ Ngoại tuyến (Offline Mode)
- Khi nhấn vào đơn hàng, Bloc kiểm tra kết nối mạng:
  - **Mất mạng**: Lưu metadata đơn hàng vào `AppState`, chuyển hướng sang màn hình QR Code Offline (`isOfflineMode: true`).
  - **Có mạng**: Điều hướng đến màn hình Chi tiết Đơn hàng bình thường.

---

## 2. Chi tiết các API được gọi (API References)

Dần từ logic trong `DashboardBloc`, dưới đây là các API thực tế đang được thực hiện:

### A. Bảng ánh xạ Logic & API
| Chức năng (Feature) | Event/Method trong Bloc | API Endpoint | Controller/Usecase Method |
| :--- | :--- | :--- | :--- |
| **Lấy Đơn hàng** | `FetchOrders` | `GET /driver/orders` | `StaffController.fetchOrders` |
| **Lấy Cửa hàng** | `FetchStores` | `GET /tenant/{tenantId}/stores/dropdown` | `StaffController.fetchStores` |
| **Lấy Nhân viên** | `FetchStaffs` & `_onInitializeView` | `GET /account/staff/dropdown` | `StaffController.fetchStaffs` |

### B. Luồng gọi chi tiết từ DashboardBloc

#### 1. Khi Khởi tạo (`_onInitializeView`)
- **API Cửa hàng**: `FetchStores` được gọi để lấy danh sách cửa hàng của Tenant.
- **API Nhân viên**: Gọi trực tiếp `_staffController.fetchStaffs` để lấy danh sách nhân viên thuộc cửa hàng của user hiện tại.
- **API Đơn hàng**: `FetchOrders` được gọi với các tham số:
  - `shipping_company_id`: ID công ty của user.
  - `refueling_date`: Ngày hiện tại.
  - `shipping_driver_id`: ID tài xế (userDetailId).

#### 2. Khi chọn Cửa hàng (`_onSelectStore`)
- **API Nhân viên**: `FetchStaffs` được gọi để cập nhật danh sách nhân viên cho cửa hàng mới.
- **API Đơn hàng**: `FetchOrders` được gọi lại cho cửa hàng vừa chọn.

#### 3. Khi chọn Nhân viên (`_onSelectStaff`)
- **API Đơn hàng**: `FetchOrders` được gọi với `shipping_driver_id` mới để lọc đơn hàng theo tài xế.

#### 4. Khi Kéo để làm mới hoặc Chuyển ngày (`PullRefresh`)
- **API Đơn hàng**: `FetchOrders` được gọi lại với đầy đủ các bộ lọc (store, staff, date) đang hiện hành.

### C. Chi tiết Tham số API (Parameter Details)

| Tham số | Ý nghĩa | Nguồn dữ liệu từ Bloc |
| :--- | :--- | :--- |
| `refueling_date` | Ngày cấp nhiên liệu | `state.selectedDate` (định dạng yyyy-MM-dd) |
| `shipping_company_id` | ID công ty/cửa hàng | `state.selectedStoreId` hoặc `user.companyId` |
| `tenant_store_id` | ID cửa hàng quản lý | `state.selectedStoreId` |
| `shipping_driver_id` | ID tài xế thực hiện | `state.selectedStaffId` hoặc `user.userDetailId` |
| `page_size` | Số lượng bản ghi | Mặc định `1000` (để lấy hết đơn trong ngày) |

---

## 3. Cấu trúc UI Components

Màn hình Dashboard được xây dựng từ các thành phần chính:
- **`DashboardPage`**: Widget chính quản lý layout và lắng nghe State.
- **`CalendarWidget`**: Hiển thị lịch chọn ngày.
- **`DashboardOrderList`**: Quản lý danh sách cuộn các đơn hàng.
- **`OrderCard`**: Hiển thị từng đơn hàng với thông tin: Giờ, Địa điểm, Sản phẩm, Số lượng.
- **`DashboardFilter`**: Các thanh dropdown chọn Store và Staff.

---

## 4. Luồng xử lý sự kiện (Event Handling)

| Sự kiện (Event) | Logic xử lý |
| :--- | :--- |
| `InitializeView` | Thiết lập giá trị mặc định, gọi API lấy Store/Order ban đầu. |
| `PullRefresh` | Làm mới lại toàn bộ dữ liệu hiện tại (thường dùng khi vuốt từ trên xuống). |
| `CalendarDaySelected`| Cập nhật `selectedDate` và fetch lại danh sách Order. |
| `SelectStore` | Xóa nhân viên đã chọn, lấy danh sách Staff mới và cập nhật Order theo Store. |
| `NavigateToOrderDetail`| Kiểm tra mạng, điều hướng đến chi tiết đơn hàng hoặc chế độ offline. |
