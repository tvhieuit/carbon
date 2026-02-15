part of 'delivery_creation_qr_code_bloc.dart';

@stateFreezed
sealed class DeliveryCreationQrCodeState with _$DeliveryCreationQrCodeState {
  const factory DeliveryCreationQrCodeState({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    String? orderId,
    String? orderLineId,
    OrderEntity? order,
    @Default([]) List<MachineryItemEntity> machines,
    @Default([]) List<ReceiptLineEntity> receiptLines,
    String? error,
    @Default(false) bool isSuccess,
    @Default(false) bool isOfflineMode,
    @Default(false) bool isDelivered,
  }) = _DeliveryCreationQrCodeState;

  const DeliveryCreationQrCodeState._();

  Map<String, List<MachineryItemEntity>> get machinesGroupedByProduct {
    final groups = <String, List<MachineryItemEntity>>{};
    for (final machine in machines) {
      final productName = machine.productName ?? 'Unknown';
      groups.putIfAbsent(productName, () => []).add(machine);
    }
    return groups;
  }

  factory DeliveryCreationQrCodeState.initial() => const DeliveryCreationQrCodeState();
}
