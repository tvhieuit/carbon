part of 'delivery_creation_qr_code_bloc.dart';

@eventFreezed
class DeliveryCreationQrCodeEvent with _$DeliveryCreationQrCodeEvent {
  const factory DeliveryCreationQrCodeEvent.init({
    required String orderId,
    required String orderLineId,
  }) = _Init;

  const factory DeliveryCreationQrCodeEvent.addMachinery({
    required MachineryItemEntity machinery,
  }) = _AddMachinery;

  const factory DeliveryCreationQrCodeEvent.updateQuantity({
    required String machineId,
    required double? quantity,
  }) = _UpdateQuantity;

  const factory DeliveryCreationQrCodeEvent.updateProductQuantity({
    required String productId,
    required double? quantity,
  }) = _UpdateProductQuantity;

  const factory DeliveryCreationQrCodeEvent.removeMachinery({
    required String machineId,
  }) = _RemoveMachinery;

  const factory DeliveryCreationQrCodeEvent.submit() = _Submit;
}
