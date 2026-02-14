import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IDeliveryRepository {
  Future<Result<List<MachineryItemEntity>>> getOrderMachines(String orderId);
  Future<Result<List<ReceiptLineEntity>>> getOrderProducts(String orderId, String orderLineId);
  Future<Result<void>> submitDeliveryOrder(DeliveryOrderEntity deliveryOrder);
}
