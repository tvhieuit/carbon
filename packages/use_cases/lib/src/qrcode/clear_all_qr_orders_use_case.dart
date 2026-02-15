import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class ClearAllQrOrdersUseCase {
  final IQrcodeRepository _repository;

  ClearAllQrOrdersUseCase(this._repository);

  Future<Result<void>> call() async {
    return _repository.clearAllQrOrders();
  }
}
