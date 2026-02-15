import 'package:app_core/app_core.dart';
import 'package:data/src/models/qr_info_model.dart';
import 'package:data/src/provider/local/local_database.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IQrcodeRepository)
class QrcodeRepositoryImpl implements IQrcodeRepository {
  final Dio _dio;
  final LocalDatabase _localDatabase;

  QrcodeRepositoryImpl(this._dio, this._localDatabase);

  @override
  Future<Result<QrInfoEntity>> fetchQrInfo({
    required String machineId,
  }) async {
    try {
      final response = await _dio.get('/driver/construction-site/machines/$machineId');
      final model = QrInfoModel.fromJson(response.data);
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> saveLocalQrOrder({
    required QrInfoEntity qrInfo,
    required List<OrderLineEntity> orderLines,
    String? orderId,
    String? productType,
  }) async {
    try {
      for (final orderLine in orderLines) {
        final quantity = orderLine.quantity ?? 0;
        if (quantity <= 0) continue;

        final machineId = qrInfo.id;
        final productId = orderLine.productId ?? orderLine.id;
        final actualOrderId = orderId ?? '';

        final existingOrder = await _localDatabase.findQrCodeOrder(
          orderId: actualOrderId,
          machineId: machineId,
          productId: productId,
          isSubmitted: false,
        );

        if (existingOrder != null) {
          final oldQuantity = double.tryParse(existingOrder['quantity'] as String) ?? 0;
          final newQuantity = oldQuantity + quantity;
          await _localDatabase.updateQrCodeOrderQuantity(
            existingOrder['id'] as String,
            newQuantity.toString(),
          );
        } else {
          final id = '$actualOrderId$machineId$productId';
          await _localDatabase.saveQrCodeOrder({
            'id': id,
            'order_id': actualOrderId,
            'machine_id': machineId,
            'product_id': productId,
            'quantity': quantity.toString(),
            'order_line_id': '', // Extract if available
            'machine_name': qrInfo.machineName,
            'machine_number': qrInfo.machineNumber,
            'construction_site_id': qrInfo.constructionSiteId,
            'construction_site_name': qrInfo.constructionSiteName,
            'company_name': qrInfo.companyName,
            'machine_product_name': qrInfo.productName,
            'order_no': '',
            'product_name': orderLine.productName,
            'product_type': productType,
            'is_submitted': 0,
            'needs_resubmission': 0,
            'submission_attempts': 0,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });
        }
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getLocalQrOrders() async {
    try {
      final orders = await _localDatabase.getUnsubmittedQrCodeOrders();
      return Result.success(orders);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>?>> getLatestQrOrder() async {
    try {
      final orders = await _localDatabase.getQrCodeOrderLatest();
      return Result.success(orders.isNotEmpty ? orders.first : null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteLocalQrOrdersByOrder(String orderId) async {
    try {
      await _localDatabase.deleteQrCodeOrdersByOrder(orderId);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateQrOrderQuantity({
    required String orderId,
    required String machineId,
    required String productId,
    required String quantity,
    String? machineName,
    String? machineNumber,
    String? productType,
  }) async {
    try {
      final id = '$orderId$machineId$productId';
      final parsedQuantity = double.tryParse(quantity.replaceAll(',', '.')) ?? 0;

      if (parsedQuantity <= 0) {
        final existingOrder = await _localDatabase.getQrCodeOrderById(id);
        if (existingOrder != null) {
          await _localDatabase.deleteQrCodeOrderById(id);
        }
        return const Result.success(null);
      }

      final existingOrder = await _localDatabase.getQrCodeOrderById(id);
      if (existingOrder != null) {
        await _localDatabase.updateQrCodeOrderQuantity(id, quantity);
      } else {
        await _localDatabase.saveQrCodeOrder({
          'id': id,
          'order_id': orderId,
          'machine_id': machineId,
          'product_id': productId,
          'quantity': quantity,
          'is_submitted': 1,
          'updated_at': DateTime.now().toIso8601String(),
          'product_type': productType,
          'machine_name': machineName,
          'machine_number': machineNumber,
        });
      }
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>?>> getOrderQrByMachineAndSite(String machineId, String siteId) async {
    try {
      final order = await _localDatabase.getQrCodeOrderByMachineAndSite(machineId: machineId, siteId: siteId);
      return Result.success(order);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getMachineQrByOrderAndType(String orderId, String productType) async {
    try {
      final orders = await _localDatabase.getQrCodeOrdersByOrderAndType(orderId: orderId, productType: productType);
      return Result.success(orders);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Map<String, dynamic>>>> getMachineOfflineById(String machineId) async {
    try {
      final orders = await _localDatabase.getUnsubmittedQrCodeOrdersByMachine(machineId);
      return Result.success(orders);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearAllQrOrders() async {
    try {
      await _localDatabase.clearAllQrCodeOrders();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode ?? 0;
      final message = e.response?.data?['message'] ?? 'An error occurred';
      return Failure.server(message: message, statusCode: statusCode);
    }
    return Failure.network(message: e.message ?? 'Network error');
  }
}
