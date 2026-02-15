import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

@injectable
class SubmitDeliveryOrderUseCase implements UseCaseWithParams<void, DeliveryOrderEntity> {
  final IDeliveryRepository _repository;

  SubmitDeliveryOrderUseCase(this._repository);

  @override
  Future<Result<void>> call(DeliveryOrderEntity params) async {
    return _repository.submitDeliveryOrder(params);
  }
}
