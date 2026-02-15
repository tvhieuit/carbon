import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLocalQrOrdersUseCase {
  final IQrcodeRepository _repository;

  GetLocalQrOrdersUseCase(this._repository);

  Future<Result<List<Map<String, dynamic>>>> call() async {
    return _repository.getLocalQrOrders();
  }
}
