import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

class UpdateReceiptSignatureParams {
  final String orderId;
  final String receiptId;
  final String signatureId;

  UpdateReceiptSignatureParams({
    required this.orderId,
    required this.receiptId,
    required this.signatureId,
  });
}

@injectable
class UpdateReceiptSignatureUseCase
    implements
        UseCaseWithParams<FuelingSubmitResultEntity,
            UpdateReceiptSignatureParams> {
  final IFuelingRepository _repository;

  UpdateReceiptSignatureUseCase(this._repository);

  @override
  Future<Result<FuelingSubmitResultEntity>> call(
      UpdateReceiptSignatureParams params) async {
    return _repository.updateReceiptSignature(
      params.orderId,
      params.receiptId,
      params.signatureId,
    );
  }
}
