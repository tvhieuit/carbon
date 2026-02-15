import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IQrcodeRepository {
  Future<Result<QrInfoEntity>> fetchQrInfo({
    required String machineId,
  });
  Future<Result<void>> saveLocalQrOrder({
    required QrInfoEntity qrInfo,
    required List<OrderLineEntity> orderLines,
    String? orderId,
    String? productType,
  });
  Future<Result<List<Map<String, dynamic>>>> getLocalQrOrders();
  Future<Result<Map<String, dynamic>?>> getLatestQrOrder();
  Future<Result<void>> deleteLocalQrOrdersByOrder(String orderId);
  Future<Result<void>> updateQrOrderQuantity({
    required String orderId,
    required String machineId,
    required String productId,
    required String quantity,
    String? machineName,
    String? machineNumber,
    String? productType,
  });
  Future<Result<Map<String, dynamic>?>> getOrderQrByMachineAndSite(String machineId, String siteId);
  Future<Result<List<Map<String, dynamic>>>> getMachineQrByOrderAndType(String orderId, String productType);
  Future<Result<List<Map<String, dynamic>>>> getMachineOfflineById(String machineId);
  Future<Result<void>> clearAllQrOrders();
}
