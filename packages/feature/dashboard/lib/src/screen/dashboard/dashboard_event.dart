part of 'dashboard_bloc.dart';

@eventFreezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.started() = _Started;
  const factory DashboardEvent.pullRefresh() = _PullRefresh;
  const factory DashboardEvent.calendarDaySelected(DateTime selectedDate, DateTime focusedDate) = _CalendarDaySelected;
  const factory DashboardEvent.selectStore(String storeId) = _SelectStore;
  const factory DashboardEvent.selectStaff(String staffId) = _SelectStaff;
  const factory DashboardEvent.navigateToOrderDetail(OrderEntity order, bool isDelivered) = _NavigateToOrderDetail;
  const factory DashboardEvent.qrScanPressed() = _QrScanPressed;
  const factory DashboardEvent.copyOrder(OrderEntity order) = _CopyOrder;
  const factory DashboardEvent.editOrder(OrderEntity order) = _EditOrder;
  const factory DashboardEvent.deleteOrder(OrderEntity order) = _DeleteOrder;
}
