import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IFuelingRepository {
  Future<Result<FuelingSubmitResultEntity>> submitOrder(
      DeliveryOrderEntity deliveryOrder);

  Future<Result<String>> uploadFile(String filePath);

  Future<Result<String>> getFileUrl(String fileId);

  Future<Result<FuelingSubmitResultEntity>> updateReceiptSignature(
      String orderId, String receiptId, String signatureId);

  Future<Result<void>> updateReceiptFile(
      String orderId, String receiptId, String fileId);
}
