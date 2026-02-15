import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

@injectable
class SubmitFuelingOrderUseCase
    implements
        UseCaseWithParams<FuelingSubmitResultEntity, DeliveryOrderEntity> {
  final IFuelingRepository _repository;

  SubmitFuelingOrderUseCase(this._repository);

  @override
  Future<Result<FuelingSubmitResultEntity>> call(
      DeliveryOrderEntity params) async {
    return _repository.submitOrder(params);
  }
}
