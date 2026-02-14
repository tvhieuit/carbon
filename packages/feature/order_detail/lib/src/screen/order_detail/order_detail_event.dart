part of 'order_detail_bloc.dart';

@freezed
class OrderDetailEvent with _$OrderDetailEvent {
  const factory OrderDetailEvent.started(String orderId) = _Started;
  const factory OrderDetailEvent.refreshRequested() = _RefreshRequested;
}
