part of 'dashboard_bloc.dart';

@eventFreezed
sealed class DashboardEvent with _$DashboardEvent {
  const factory DashboardEvent.started() = _Started;
  const factory DashboardEvent.pullRefresh() = _PullRefresh;
  const factory DashboardEvent.calendarDaySelected(DateTime selectedDate, DateTime focusedDate) = _CalendarDaySelected;
  const factory DashboardEvent.selectStore(String storeId) = _SelectStore;
  const factory DashboardEvent.selectStaff(String staffId) = _SelectStaff;
  const factory DashboardEvent.navigateToOrderDetail(OrderEntity order, bool isDelivered) = _NavigateToOrderDetail;
}
