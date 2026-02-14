import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:domain/domain.dart';
import 'package:use_cases/use_cases.dart';

part 'order_detail_event.dart';
part 'order_detail_state.dart';
part 'order_detail_bloc.freezed.dart';

@injectable
class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  final GetOrderDetailUseCase _getOrderDetailUseCase;
  final GetMeUseCase _getMeUseCase;

  String? _currentOrderId;

  OrderDetailBloc(
    this._getOrderDetailUseCase,
    this._getMeUseCase,
  ) : super(const OrderDetailState.initial()) {
    on<_Started>(_onStarted);
    on<_RefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStarted(_Started event, Emitter<OrderDetailState> emit) async {
    _currentOrderId = event.orderId;
    await _fetchOrderDetail(emit);
  }

  Future<void> _onRefreshRequested(_RefreshRequested event, Emitter<OrderDetailState> emit) async {
    await _fetchOrderDetail(emit);
  }

  Future<void> _fetchOrderDetail(Emitter<OrderDetailState> emit) async {
    if (_currentOrderId == null) return;

    emit(const OrderDetailState.loading());

    // 1. Fetch User Info for permission check
    final meResult = await _getMeUseCase();

    // 2. Fetch Order Detail
    final orderResult = await _getOrderDetailUseCase(_currentOrderId!);

    if (orderResult.isSuccess) {
      emit(
        OrderDetailState.loaded(
          order: orderResult.data!,
          me: meResult.data,
        ),
      );
    } else {
      emit(OrderDetailState.error(orderResult.failure?.message ?? 'Failed to load order detail'));
    }
  }
}
