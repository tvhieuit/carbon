import 'package:app_core/app_core.dart';
import 'package:data/src/models/qr_info_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IQrcodeRepository)
class QrcodeRepositoryImpl implements IQrcodeRepository {
  final Dio _dio;

  QrcodeRepositoryImpl(this._dio);

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

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode ?? 0;
      final message = e.response?.data?['message'] ?? 'An error occurred';
      return Failure.server(message: message, statusCode: statusCode);
    }
    return Failure.network(message: e.message ?? 'Network error');
  }
}
