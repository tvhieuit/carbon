import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IDeliveryRepository {
  Future<Result<List<MachineryItemEntity>>> getOrderMachines(String orderId);
  Future<Result<List<ReceiptLineEntity>>> getOrderProducts(String orderId, String orderLineId);
  Future<Result<void>> submitDeliveryOrder(DeliveryOrderEntity deliveryOrder);
  Future<Result<String>> saveLocalDeliveryOrder(
    DeliveryOrderEntity deliveryOrder, {
    bool isSubmitted = false,
    String? errorMessage,
    String? receiptImageFilePath,
  });
  Future<Result<List<DeliveryOrderEntity>>> getLocalOrders();
  Future<Result<List<DeliveryOrderEntity>>> getOrdersForResubmission();
  Future<Result<void>> updateLocalSubmissionStatus(
    String id, {
    required bool isSubmitted,
    String? errorMessage,
    String? receiptImageFilePath,
  });
  Future<Result<void>> deleteLocalOrder(String id);
  Future<Result<void>> clearAllDeliveryOrders();
}
