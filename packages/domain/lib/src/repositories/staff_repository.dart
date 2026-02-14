import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IStaffRepository {
  Future<Result<List<OrderEntity>>> fetchOrders({
    required int page,
    required int pageSize,
    String? refuelingDate,
    String? shippingCompanyId,
    String? tenantStoreId,
    String? shippingDriverId,
  });

  Future<Result<List<StaffEntity>>> fetchStaffs({
    required int page,
    required int pageSize,
    String? tenantStoreId,
  });

  Future<Result<List<StaffEntity>>> fetchStores({
    required int page,
    required int pageSize,
    required String tenantId,
  });

  Future<Result<List<OrderLineEntity>>> fetchDriverOrderLines({
    required int page,
    required int pageSize,
    required String refuelingDate,
    required String constructionSiteId,
    required String shippingDriverId,
    List<String>? orderStatus,
    List<String>? sortColumns,
    List<String>? sortOrders,
  });
}
