import 'package:app_core/app_core.dart';
import 'package:data/src/models/fueling/fueling_submit_result_model.dart';
import 'package:data/src/models/delivery/delivery_order_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IFuelingRepository)
class FuelingRepositoryImpl implements IFuelingRepository {
  final Dio _dio;

  FuelingRepositoryImpl(this._dio);

  @override
  Future<Result<FuelingSubmitResultEntity>> submitOrder(
      DeliveryOrderEntity deliveryOrder) async {
    try {
      final model = DeliveryOrderModel.fromEntity(deliveryOrder);
      final response =
          await _dio.post('/driver/orders/submit', data: model.toJson());
      final result = FuelingSubmitResultModel.fromJson(response.data);
      return Result.success(result.toEntity());
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> uploadFile(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post('/files/upload', data: formData);
      final fileId = response.data['file_id'] as String;
      return Result.success(fileId);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<String>> getFileUrl(String fileId) async {
    try {
      final response = await _dio.get('/files/$fileId/url');
      final url = response.data['url'] as String;
      return Result.success(url);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<FuelingSubmitResultEntity>> updateReceiptSignature(
      String orderId, String receiptId, String signatureId) async {
    try {
      final response = await _dio.put(
        '/driver/orders/$orderId/receipts/$receiptId/signature',
        data: {'signature_file_id': signatureId},
      );
      final result = FuelingSubmitResultModel.fromJson(response.data);
      return Result.success(result.toEntity());
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> updateReceiptFile(
      String orderId, String receiptId, String fileId) async {
    try {
      await _dio.put(
        '/driver/orders/$orderId/receipts/$receiptId/file',
        data: {'file_id': fileId},
      );
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
