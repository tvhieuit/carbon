import 'dart:io';

import 'package:codebase/entities/delivery_order.dart';

/// Các sự kiện cho FuelingDetailsBloc
abstract class QrCodeFuelingDetailsEvent {
  const QrCodeFuelingDetailsEvent();
}

/// Sự kiện khởi tạo
class QrCodeFuelingDetailsInitialized extends QrCodeFuelingDetailsEvent {
  final String orderId;
  final String? machineid;


  const QrCodeFuelingDetailsInitialized({
    required this.orderId,
    this.machineid,
  });
}

/// Sự kiện yêu cầu tải lại dữ liệu
class FuelingDetailsRefreshed extends QrCodeFuelingDetailsEvent {
  const FuelingDetailsRefreshed();
}

/// Sự kiện cập nhật trạng thái đơn hàng
class OrderStatusUpdated extends QrCodeFuelingDetailsEvent {
  final String newStatus;

  const OrderStatusUpdated({required this.newStatus});
}

/// Sự kiện gửi đơn hàng
class OrderSubmitted extends QrCodeFuelingDetailsEvent {
  final DeliveryOrder deliveryOrder;
  final File receiptImageFile;

  const OrderSubmitted({
    required this.deliveryOrder,
    required this.receiptImageFile,
  });
}

/// Sự kiện in hóa đơn
class PrintReceipt extends QrCodeFuelingDetailsEvent {
  final String imagePath;
  final DeliveryOrder? deliveryOrder;

  const PrintReceipt({
    required this.imagePath,
    this.deliveryOrder,
  });
}

/// Sự kiện cập nhật ID file biên lai
class UpdateReceiptFileId extends QrCodeFuelingDetailsEvent {
  final String receiptFileId;

  const UpdateReceiptFileId(this.receiptFileId);
}

/// Sự kiện cập nhật trạng thái loading
class SetLoadingEvent extends QrCodeFuelingDetailsEvent {
  final bool isLoading;

  const SetLoadingEvent({required this.isLoading});
}

/// Sự kiện cập nhật chữ ký cho order separate đã delivery
class UpdateOrderSignature extends QrCodeFuelingDetailsEvent {
  final String orderId;
  final String receiptId;
  final String signatureId;

  const UpdateOrderSignature({
    required this.orderId,
    required this.receiptId,
    required this.signatureId,
  });
}

