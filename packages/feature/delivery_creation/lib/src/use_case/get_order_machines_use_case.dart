import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

@injectable
class GetOrderMachinesUseCase implements UseCaseWithParams<List<MachineryItemEntity>, String> {
  final IDeliveryRepository _repository;

  GetOrderMachinesUseCase(this._repository);

  @override
  Future<Result<List<MachineryItemEntity>>> call(String params) async {
    return _repository.getOrderMachines(params);
  }
}
