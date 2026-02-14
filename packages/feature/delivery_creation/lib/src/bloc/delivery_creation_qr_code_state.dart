part of 'delivery_creation_qr_code_bloc.dart';

@freezed
sealed class DeliveryCreationQrCodeState with _$DeliveryCreationQrCodeState {
  const factory DeliveryCreationQrCodeState({
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    String? orderId,
    String? orderLineId,
    @Default([]) List<MachineryItemEntity> machines,
    @Default([]) List<ReceiptLineEntity> receiptLines,
    String? error,
    @Default(false) bool isSuccess,
  }) = _DeliveryCreationQrCodeState;

  factory DeliveryCreationQrCodeState.initial() => const DeliveryCreationQrCodeState();
}
