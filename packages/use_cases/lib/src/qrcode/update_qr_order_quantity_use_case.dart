import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateQrOrderQuantityUseCase {
  final IQrcodeRepository _repository;

  UpdateQrOrderQuantityUseCase(this._repository);

  Future<Result<void>> call({
    required String orderId,
    required String machineId,
    required String productId,
    required String quantity,
  }) async {
    return _repository.updateQrOrderQuantity(
      orderId: orderId,
      machineId: machineId,
      productId: productId,
      quantity: quantity,
    );
  }
}
