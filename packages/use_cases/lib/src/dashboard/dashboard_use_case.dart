import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DashboardUseCase {
  final IStaffRepository _staffRepository;

  DashboardUseCase(this._staffRepository);

  Future<Result<List<OrderEntity>>> fetchOrders({
    required int page,
    required int pageSize,
    String? refuelingDate,
    String? shippingCompanyId,
    String? tenantStoreId,
    String? shippingDriverId,
  }) {
    return _staffRepository.fetchOrders(
      page: page,
      pageSize: pageSize,
      refuelingDate: refuelingDate,
      shippingCompanyId: shippingCompanyId,
      tenantStoreId: tenantStoreId,
      shippingDriverId: shippingDriverId,
    );
  }

  Future<Result<List<StaffEntity>>> fetchStaffs({
    required int page,
    required int pageSize,
    String? tenantStoreId,
  }) {
    return _staffRepository.fetchStaffs(
      page: page,
      pageSize: pageSize,
      tenantStoreId: tenantStoreId,
    );
  }

  Future<Result<List<StaffEntity>>> fetchStores({
    required int page,
    required int pageSize,
    required String tenantId,
  }) {
    return _staffRepository.fetchStores(
      page: page,
      pageSize: pageSize,
      tenantId: tenantId,
    );
  }
}
