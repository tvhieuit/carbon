import 'package:app_core/app_core.dart';
import 'package:data/src/models/delivery/delivery_order_model.dart';
import 'package:data/src/models/delivery/machinery_item_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IDeliveryRepository)
class DeliveryRepositoryImpl implements IDeliveryRepository {
  final Dio _dio;

  DeliveryRepositoryImpl(this._dio);

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
      final model = DeliveryOrderModel.fromEntity(deliveryOrder);
      await _dio.post('/driver/orders', data: model.toJson());
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
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
