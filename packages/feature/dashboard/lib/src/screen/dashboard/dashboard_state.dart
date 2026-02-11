part of 'dashboard_bloc.dart';

@stateFreezed
sealed class DashboardState with _$DashboardState {
  const DashboardState._();

  const factory DashboardState({
    @Default(false) bool isLoading,
    @Default(false) bool isRefreshing,
    @Default(false) bool isInitialized,
    required DateTime selectedDate,
    required DateTime focusedDate,
    required DateTime firstDay,
    required DateTime lastDay,
    @Default([]) List<OrderEntity> orders,
    @Default([]) List<StaffEntity> staffs,
    @Default([]) List<StaffEntity> stores,
    String? selectedStaffId,
    String? selectedStoreId,
    String? tenantId,
  }) = _DashboardState;

  factory DashboardState.initial(String? tenantId) => DashboardState(
    selectedDate: DateTime.now(),
    focusedDate: DateTime.now(),
    firstDay: DateTime(2020),
    lastDay: DateTime(2050),
    tenantId: tenantId,
  );
}
