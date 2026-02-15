import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

class UpdateReceiptFileParams {
  final String orderId;
  final String receiptId;
  final String fileId;

  UpdateReceiptFileParams({
    required this.orderId,
    required this.receiptId,
    required this.fileId,
  });
}

@injectable
class UpdateReceiptFileUseCase
    implements UseCaseWithParams<void, UpdateReceiptFileParams> {
  final IFuelingRepository _repository;

  UpdateReceiptFileUseCase(this._repository);

  @override
  Future<Result<void>> call(UpdateReceiptFileParams params) async {
    return _repository.updateReceiptFile(
      params.orderId,
      params.receiptId,
      params.fileId,
    );
  }
}
