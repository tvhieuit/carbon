import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:feature_auth/auth.dart';
import 'package:use_cases/use_cases.dart';
// Note: In a real production app, tenantId should be provided via DI or Auth state.
// For now, we will use the correct UUID directly as requested.

part 'dashboard_event.dart';
part 'dashboard_state.dart';
part 'dashboard_bloc.freezed.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUseCase _dashboardUseCase;
  final StackRouter _router;
  final AppRoute _appRoute;
  final AppToast _toast;

  DashboardBloc(this._dashboardUseCase, this._router, this._appRoute, this._toast, @tenantIdNamed String? tenantId)
    : super(DashboardState.initial(tenantId)) {
    on<_Started>(_onStarted);
    on<_PullRefresh>(_onPullRefresh);
    on<_CalendarDaySelected>(_onCalendarDaySelected);
    on<_SelectStore>(_onSelectStore);
    on<_SelectStaff>(_onSelectStaff);
    on<_NavigateToOrderDetail>(_onNavigateToOrderDetail);
    on<_QrScanPressed>(_onQrScanPressed);
    on<_CopyOrder>(_onCopyOrder);
    on<_EditOrder>(_onEditOrder);
    on<_DeleteOrder>(_onDeleteOrder);

    add(const DashboardEvent.started());
  }

  Future<void> _onStarted(_Started event, emit) async {
    emit(state.copyWith(isLoading: true));

    try {
      final result = await _dashboardUseCase.fetchStores(
        page: 1,
        pageSize: 1000,
        tenantId: state.tenantId ?? '',
      );

      if (result.isSuccess) {
        final stores = result.data ?? [];
        emit(state.copyWith(stores: stores, isInitialized: true));

        if (stores.isNotEmpty) {
          add(DashboardEvent.selectStore(stores.first.id));
        }
      } else {
        _toast.error(result.failure?.message ?? 'Failed to fetch stores');
      }
    } catch (e) {
      _toast.error('An unexpected error occurred');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onPullRefresh(_PullRefresh event, emit) async {
    emit(state.copyWith(isRefreshing: true));
    await _fetchOrders(emit);
    emit(state.copyWith(isRefreshing: false));
  }

  Future<void> _onCalendarDaySelected(_CalendarDaySelected event, emit) async {
    emit(
      state.copyWith(
        selectedDate: event.selectedDate,
        focusedDate: event.focusedDate,
        isLoading: true,
      ),
    );
    await _fetchOrders(emit);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _onSelectStore(_SelectStore event, emit) async {
    emit(
      state.copyWith(
        selectedStoreId: event.storeId,
        selectedStaffId: null, // Reset staff when store changes
        staffs: [],
        isLoading: true,
      ),
    );

    try {
      final staffResult = await _dashboardUseCase.fetchStaffs(
        page: 1,
        pageSize: 1000,
        tenantStoreId: event.storeId,
      );

      if (staffResult.isSuccess) {
        emit(state.copyWith(staffs: staffResult.data ?? []));
      } else {
        _toast.error(staffResult.failure?.message ?? 'Failed to fetch staffs');
      }

      await _fetchOrders(emit);
    } catch (e) {
      _toast.error('An unexpected error occurred');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onSelectStaff(_SelectStaff event, emit) async {
    emit(state.copyWith(selectedStaffId: event.staffId, isLoading: true));
    await _fetchOrders(emit);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchOrders(emit) async {
    final refuelingDate = state.selectedDate.toIso8601String().split('T').first;

    final result = await _dashboardUseCase.fetchOrders(
      page: 1,
      pageSize: 1000,
      refuelingDate: refuelingDate,
      tenantStoreId: state.selectedStoreId,
      shippingDriverId: state.selectedStaffId,
    );

    if (result.isSuccess) {
      emit(state.copyWith(orders: result.data ?? []));
    } else {
      _toast.error(result.failure?.message ?? 'Failed to fetch orders');
    }
  }

  Future<void> _onNavigateToOrderDetail(_NavigateToOrderDetail event, emit) async {
    // TODO: Implement Network check and Offline mode as per dashboard_business.md
    // For now, just navigate
    _router.push(_appRoute.dashboard); // Placeholder for detail
  }

  void _onQrScanPressed(_QrScanPressed event, emit) {
    _router.push(_appRoute.qrScan);
  }

  Future<void> _onCopyOrder(_CopyOrder event, emit) async {
    final order = event.order;
    final orderLines = order.orderLines
        .map((line) => '${line.productName ?? '-'}: ${line.quantity?.toInt() ?? '-'}')
        .join(', ');
    final text = '${order.companyName} | ${order.constructionSiteName} | '
        '${order.refuelingFromTime}-${order.refuelingToTime} | $orderLines';
    await Clipboard.setData(ClipboardData(text: text));
    _toast.success('Order copied');
  }

  Future<void> _onEditOrder(_EditOrder event, emit) async {
    // Navigate to order detail for editing
    _router.push(_appRoute.dashboard); // TODO: Replace with actual edit route
  }

  Future<void> _onDeleteOrder(_DeleteOrder event, emit) async {
    // Remove the order from local state
    final updatedOrders = state.orders.where((o) => o.id != event.order.id).toList();
    emit(state.copyWith(orders: updatedOrders));
    // TODO: Call API to delete the order on the server
    _toast.success('Order deleted');
  }
}
