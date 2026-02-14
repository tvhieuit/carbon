import 'package:app_core/app_core.dart';
import 'package:data/src/models/qr_info_model.dart';
import 'package:dio/dio.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../models/order/order_model.dart';
import '../models/staff/staff_model.dart';

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

      final List<dynamic> data = response.data['founds'] ?? [];
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
          if (tenantStoreId != null) 'tenant_store_id__eq': tenantStoreId,
        },
      );

      final List<dynamic> data = response.data['founds'] ?? [];
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

      final List<dynamic> data = response.data['founds'] ?? [];
      final stores = data.map((json) => StaffModel.fromJson(json).toEntity()).toList();
      return Result.success(stores);
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<OrderLineEntity>>> fetchDriverOrderLines({
    required int page,
    required int pageSize,
    required String refuelingDate,
    required String constructionSiteId,
    required String shippingDriverId,
    List<String>? orderStatus,
    List<String>? sortColumns,
    List<String>? sortOrders,
  }) async {
    try {
      final response = await _dio.get(
        '/driver/order-lines',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
          'refueling_date': refuelingDate,
          'construction_site_id': constructionSiteId,
          'shipping_driver_id': shippingDriverId,
          if (orderStatus != null) 'order_status': orderStatus,
          if (sortColumns != null) 'sort_columns': sortColumns,
          if (sortOrders != null) 'sort_orders': sortOrders,
        },
      );

      final List<dynamic> data = response.data['founds'] ?? [];
      final orderLines = data.map((json) => OrderLineModel.fromJson(json).toEntity()).toList();
      return Result.success(orderLines);
    } on DioException catch (e) {
      return Result.failure(Failure.network(message: e.message ?? 'Network error'));
    } catch (e) {
      return Result.failure(Failure.unknown(message: e.toString()));
    }
  }
}
