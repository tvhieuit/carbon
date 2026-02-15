import 'dart:convert';
import 'package:app_core/app_core.dart';
import 'package:data/src/models/delivery/delivery_order_model.dart';
import 'package:data/src/models/delivery/machinery_item_model.dart';
import 'package:data/src/provider/local/local_database.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@Injectable(as: IDeliveryRepository)
class DeliveryRepositoryImpl implements IDeliveryRepository {
  final Dio _dio;
  final LocalDatabase _localDatabase;

  DeliveryRepositoryImpl(this._dio, this._localDatabase);

  @override
  Future<Result<List<MachineryItemEntity>>> getOrderMachines(String orderId) async {
    try {
      final response = await _dio.get('/driver/orders/$orderId/machines');
      final List<dynamic> data = response.data;
      final models = data.map((e) => MachineryItemModel.fromJson(e)).toList();
      return Result.success(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<ReceiptLineEntity>>> getOrderProducts(String orderId, String orderLineId) async {
    try {
      final response = await _dio.get('/driver/orders/$orderId/lines/$orderLineId/products');
      final List<dynamic> data = response.data;
      final models = data.map((e) => ReceiptLineModel.fromJson(e)).toList();
      return Result.success(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> submitDeliveryOrder(DeliveryOrderEntity deliveryOrder) async {
    try {
      // 1. Save locally first (using our internal upsert logic)
      final recordId = (await saveLocalDeliveryOrder(deliveryOrder)).data!;

      // 2. Submit to remote
      final model = DeliveryOrderModel.fromEntity(deliveryOrder);
      await _dio.post('/driver/orders', data: model.toJson());

      // 3. Update local status on success
      await updateLocalSubmissionStatus(recordId, isSubmitted: true);

      return const Result.success(null);
    } on DioException catch (e) {
      // Update local status with error
      final existingOrder = await _localDatabase.getDeliveryOrderByOrderId(deliveryOrder.orderId);
      if (existingOrder != null) {
        await updateLocalSubmissionStatus(
          existingOrder['id'] as String,
          isSubmitted: false,
          errorMessage: e.message,
        );
      }
      return Result.failure(_handleDioError(e));
    } catch (e) {
      final existingOrder = await _localDatabase.getDeliveryOrderByOrderId(deliveryOrder.orderId);
      if (existingOrder != null) {
        await updateLocalSubmissionStatus(
          existingOrder['id'] as String,
          isSubmitted: false,
          errorMessage: e.toString(),
        );
      }
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> saveLocalDeliveryOrder(
    DeliveryOrderEntity deliveryOrder, {
    bool isSubmitted = false,
    String? errorMessage,
    String? receiptImageFilePath,
  }) async {
    try {
      final existingOrder = await _localDatabase.getDeliveryOrderByOrderId(deliveryOrder.orderId);
      final recordId = existingOrder != null ? existingOrder['id'] as String : const Uuid().v4();

      final data = {
        'id': recordId,
        'order_id': deliveryOrder.orderId,
        'order_line_id': deliveryOrder.orderLineId,
        'company_id': deliveryOrder.constructionSiteId, // site id used as site id, wait site id site id
        'branch_id': '', // Placeholder
        'construction_site_id': deliveryOrder.constructionSiteId,
        'product_name': '', // Placeholder
        'receipt_signature_id': '', // Placeholder
        'receipt_file_id': '', // Placeholder
        'is_submitted': isSubmitted ? 1 : 0,
        'needs_resubmission': isSubmitted ? 0 : 1,
        'submission_attempts':
            (existingOrder != null ? (existingOrder['submission_attempts'] as int) : 0) + (isSubmitted ? 1 : 0),
        'machinery_items_json': jsonEncode(
          deliveryOrder.constructionMachines.map((e) => MachineryItemModel.fromEntity(e).toJson()).toList(),
        ),
        'non_oil_products_json': jsonEncode(
          deliveryOrder.receiptLines.map((e) => ReceiptLineModel.fromEntity(e).toJson()).toList(),
        ),
        'error_message': errorMessage,
        'receipt_image_file_path': receiptImageFilePath ?? existingOrder?['receipt_image_file_path'],
        'created_at': existingOrder != null ? existingOrder['created_at'] : DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      await _localDatabase.saveDeliveryOrder(data);
      return Result.success(recordId);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<DeliveryOrderEntity>>> getLocalOrders() async {
    try {
      final orders = await _localDatabase.getAllDeliveryOrders();
      return Result.success(orders.map((e) => _mapToEntity(e)).toList());
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<DeliveryOrderEntity>>> getOrdersForResubmission() async {
    try {
      final orders = await _localDatabase.getDeliveryOrdersForResubmission();
      return Result.success(orders.map((e) => _mapToEntity(e)).toList());
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateLocalSubmissionStatus(
    String id, {
    required bool isSubmitted,
    String? errorMessage,
    String? receiptImageFilePath,
  }) async {
    try {
      await _localDatabase.updateDeliverySubmissionStatus(
        id,
        isSubmitted: isSubmitted,
        errorMessage: errorMessage,
        receiptImageFilePath: receiptImageFilePath,
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteLocalOrder(String id) async {
    try {
      await _localDatabase.deleteDeliveryOrder(id);
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> clearAllDeliveryOrders() async {
    try {
      await _localDatabase.clearAllDeliveryOrders();
      return const Result.success(null);
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  DeliveryOrderEntity _mapToEntity(Map<String, dynamic> map) {
    final machinesJson = jsonDecode(map['machinery_items_json'] as String) as List;
    final linesJson = jsonDecode(map['non_oil_products_json'] as String) as List;

    return DeliveryOrderEntity(
      id: map['id'] as String?,
      orderId: map['order_id'] as String,
      orderLineId: map['order_line_id'] as String,
      constructionSiteId: map['construction_site_id'] as String,
      constructionMachines: machinesJson
          .map((e) => MachineryItemModel.fromJson(e as Map<String, dynamic>).toEntity())
          .toList(),
      receiptLines: linesJson.map((e) => ReceiptLineModel.fromJson(e as Map<String, dynamic>).toEntity()).toList(),
    );
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
