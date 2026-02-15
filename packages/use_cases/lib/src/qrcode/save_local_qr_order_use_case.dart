import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveLocalQrOrderUseCase {
  final IQrcodeRepository _repository;

  SaveLocalQrOrderUseCase(this._repository);

  Future<Result<void>> call({
    required QrInfoEntity qrInfo,
    required List<OrderLineEntity> orderLines,
    String? orderId,
    String? productType,
  }) async {
    return _repository.saveLocalQrOrder(
      qrInfo: qrInfo,
      orderLines: orderLines,
      orderId: orderId,
      productType: productType,
    );
  }
}
