import 'package:app_core/app_core.dart';
import 'package:data/src/models/order/order_model.dart';
import 'package:data/src/models/staff/staff_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IStaffRepository)
class StaffRepositoryImpl implements IStaffRepository {
  final Dio _dio;

  StaffRepositoryImpl(this._dio);

  @override
  Future<Result<List<OrderEntity>>> fetchOrders({
    required int page,
    required int pageSize,
    String? refuelingDate,
    String? shippingCompanyId,
    String? tenantStoreId,
    String? shippingDriverId,
  }) async {
    try {
      final response = await _dio.get(
        '/driver/orders',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (refuelingDate != null) 'refueling_date': refuelingDate,
          if (shippingCompanyId != null) 'shipping_company_id': shippingCompanyId,
          if (tenantStoreId != null) 'tenant_store_id': tenantStoreId,
          if (shippingDriverId != null) 'shipping_driver_id': shippingDriverId,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final orders = data.map((json) => OrderModel.fromJson(json).toEntity()).toList();
      return Result.success(orders);
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<StaffEntity>>> fetchStaffs({
    required int page,
    required int pageSize,
    String? tenantStoreId,
  }) async {
    try {
      final response = await _dio.get(
        '/account/staff/dropdown',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          if (tenantStoreId != null) 'tenant_store_id': tenantStoreId,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final staffs = data.map((json) => StaffModel.fromJson(json).toEntity()).toList();
      return Result.success(staffs);
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<StaffEntity>>> fetchStores({
    required int page,
    required int pageSize,
    required String tenantId,
  }) async {
    try {
      final response = await _dio.get(
        '/tenant/$tenantId/stores/dropdown',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final stores = data.map((json) => StaffModel.fromJson(json).toEntity()).toList();
      return Result.success(stores);
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
