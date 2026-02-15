import 'dart:io';

import 'package:codebase/entities/delivery_order.dart';
import 'package:codebase/repository/response/order_detail_response.dart';
import 'package:equatable/equatable.dart';

/// Base state for FuelingDetailsBloc
abstract class QrCodeFuelingDetailsState extends Equatable {
  const QrCodeFuelingDetailsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class FuelingDetailsInitial extends QrCodeFuelingDetailsState {
  const FuelingDetailsInitial();
}

/// Loading state
class FuelingDetailsLoading extends QrCodeFuelingDetailsState {
  const FuelingDetailsLoading();
}

/// State loading
class FuelingDetailsLoadingState extends QrCodeFuelingDetailsState {
  const FuelingDetailsLoadingState();
}

/// Main loaded state that handles view status
class FuelingDetailsLoaded extends QrCodeFuelingDetailsState {
  final OrderDetail? orderDetail;
  final DeliveryOrder? deliveryOrder;
  final bool isSubmitting;
  final bool isCapturing;
  final File? capturedReceiptImage;
  final bool isSubmitEnabled;
  final bool isPrintEnabled;
  final String? signatureUrl;

  const FuelingDetailsLoaded({
    this.orderDetail,
    this.deliveryOrder,
    this.isSubmitting = false,
    this.isCapturing = false,
    this.capturedReceiptImage,
    required this.isSubmitEnabled,
    required this.isPrintEnabled,
    this.signatureUrl,
  });

  @override
  List<Object?> get props => [
        orderDetail,
        deliveryOrder,
        isSubmitting,
        isCapturing,
        capturedReceiptImage,
        isSubmitEnabled,
        isPrintEnabled,
        signatureUrl,
      ];

  /// Tạo bản sao với các giá trị được cập nhật
  FuelingDetailsLoaded copyWith({
    OrderDetail? orderDetail,
    DeliveryOrder? deliveryOrder,
    bool? isSubmitting,
    bool? isCapturing,
    File? capturedReceiptImage,
    bool clearCapturedImage = false,
    bool? isSubmitEnabled,
    bool? isPrintEnabled,
    String? signatureUrl,
  }) {
    return FuelingDetailsLoaded(
      orderDetail: orderDetail ?? this.orderDetail,
      deliveryOrder: deliveryOrder ?? this.deliveryOrder,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isCapturing: isCapturing ?? this.isCapturing,
      capturedReceiptImage: clearCapturedImage
          ? null
          : capturedReceiptImage ?? this.capturedReceiptImage,
      isSubmitEnabled: isSubmitEnabled ?? this.isSubmitEnabled,
      isPrintEnabled: isPrintEnabled ?? this.isPrintEnabled,
      signatureUrl: signatureUrl ?? this.signatureUrl,
    );
  }
}

/// State after successful order submission, ready for receipt capture
class FuelingDetailsSubmitSuccess extends QrCodeFuelingDetailsState {
  final String orderNumber;
  final String receiptNumber;
  final String? receiptImagePath;
  final DeliveryOrder deliveryOrder;

  const FuelingDetailsSubmitSuccess({
    required this.orderNumber,
    required this.receiptNumber,
    required this.deliveryOrder,
    this.receiptImagePath,
  });

  @override
  List<Object?> get props =>
      [orderNumber, receiptNumber, receiptImagePath, deliveryOrder];
}

/// State while updating receipt file
class FuelingDetailsUpdatingReceipt extends QrCodeFuelingDetailsState {
  final DeliveryOrder deliveryOrder;

  const FuelingDetailsUpdatingReceipt({
    required this.deliveryOrder,
  });

  @override
  List<Object?> get props => [deliveryOrder];
}

/// Error state
class FuelingDetailsError extends QrCodeFuelingDetailsState {
  final String message;
  final Exception? exception;

  const FuelingDetailsError({
    required this.message,
    this.exception,
  });

  @override
  List<Object?> get props => [message, exception];
}

/// Print success state
class FuelingDetailsPrintSuccess extends QrCodeFuelingDetailsState {
  final String message;

  const FuelingDetailsPrintSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}

/// Print error state
class FuelingDetailsPrintError extends QrCodeFuelingDetailsState {
  final String message;

  const FuelingDetailsPrintError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
