import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../base_use_case.dart';

@injectable
class SubmitDeliveryOrderUseCase implements UseCaseWithParams<void, DeliveryOrderEntity> {
  final IDeliveryRepository _repository;

  SubmitDeliveryOrderUseCase(this._repository);

  @override
  Future<Result<void>> call(DeliveryOrderEntity params) async {
    return _repository.submitDeliveryOrder(params);
  }
}
