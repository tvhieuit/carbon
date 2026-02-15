import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

class GetOrderProductsParams {
  final String orderId;
  final String orderLineId;

  GetOrderProductsParams({required this.orderId, required this.orderLineId});
}

@injectable
class GetOrderProductsUseCase implements UseCaseWithParams<List<ReceiptLineEntity>, GetOrderProductsParams> {
  final IDeliveryRepository _repository;

  GetOrderProductsUseCase(this._repository);

  @override
  Future<Result<List<ReceiptLineEntity>>> call(GetOrderProductsParams params) async {
    return _repository.getOrderProducts(params.orderId, params.orderLineId);
  }
}
