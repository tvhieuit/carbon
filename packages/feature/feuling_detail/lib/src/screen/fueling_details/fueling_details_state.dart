part of 'fueling_details_bloc.dart';

@freezed
sealed class FuelingDetailsState with _$FuelingDetailsState {
  const factory FuelingDetailsState({
    /// Current delivery order data
    DeliveryOrderEntity? deliveryOrder,

    /// Signature URL loaded from server (for delivered orders)
    String? signatureUrl,

    /// Receipt number returned after successful submission
    String? receiptNumber,

    /// Order ID for API calls
    String? orderId,

    /// Receipt ID for API calls
    String? receiptId,

    /// Loading state
    @Default(false) bool isLoading,

    /// Submitting state
    @Default(false) bool isSubmitting,

    /// Whether submit button is enabled
    @Default(true) bool isSubmitEnabled,

    /// Whether print button is enabled
    @Default(false) bool isPrintEnabled,

    /// Whether the order has been submitted successfully
    @Default(false) bool isSubmitSuccess,

    /// Error message if any
    String? errorMessage,

    /// Success message for snackbar
    String? successMessage,
  }) = _FuelingDetailsState;

  factory FuelingDetailsState.initial() => const FuelingDetailsState();
}
