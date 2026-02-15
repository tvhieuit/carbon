part of 'fueling_details_bloc.dart';

@freezed
class FuelingDetailsEvent with _$FuelingDetailsEvent {
  /// Initialize with delivery order data
  const factory FuelingDetailsEvent.initialized({
    required String orderId,
    String? machineId,
  }) = _Initialized;

  /// Refresh the current state
  const factory FuelingDetailsEvent.refreshed() = _Refreshed;

  /// Submit delivery order with signature
  const factory FuelingDetailsEvent.orderSubmitted({
    required DeliveryOrderEntity deliveryOrder,
    required String signatureFilePath,
  }) = _OrderSubmitted;

  /// Update receipt file ID after capture
  const factory FuelingDetailsEvent.receiptFileUpdated({
    required String receiptFileId,
  }) = _ReceiptFileUpdated;

  /// Update signature for delivered order
  const factory FuelingDetailsEvent.signatureUpdated({
    required String orderId,
    required String receiptId,
    required String signatureId,
  }) = _SignatureUpdated;

  /// Print receipt
  const factory FuelingDetailsEvent.printRequested() = _PrintRequested;
}
