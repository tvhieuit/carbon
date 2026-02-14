import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

import '../base_use_case.dart';

@injectable
class GetOrderDetailUseCase implements UseCaseWithParams<OrderEntity, String> {
  final IStaffRepository _repository;

  GetOrderDetailUseCase(this._repository);

  @override
  Future<Result<OrderEntity>> call(String orderId) async {
    return await _repository.getOrderDetail(orderId);
  }
}
