import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../base_use_case.dart';

part 'fetch_driver_order_lines_use_case.freezed.dart';

@paramsFreezed
sealed class FetchDriverOrderLinesParams with _$FetchDriverOrderLinesParams {
  const factory FetchDriverOrderLinesParams({
    required int page,
    required int pageSize,
    required String refuelingDate,
    required String constructionSiteId,
    required String shippingDriverId,
    List<String>? orderStatus,
    List<String>? sortColumns,
    List<String>? sortOrders,
  }) = _FetchDriverOrderLinesParams;
}

@injectable
class FetchDriverOrderLinesUseCase implements UseCaseWithParams<List<OrderLineEntity>, FetchDriverOrderLinesParams> {
  final IStaffRepository _repository;

  FetchDriverOrderLinesUseCase(this._repository);

  @override
  Future<Result<List<OrderLineEntity>>> call(FetchDriverOrderLinesParams params) async {
    return await _repository.fetchDriverOrderLines(
      page: params.page,
      pageSize: params.pageSize,
      refuelingDate: params.refuelingDate,
      constructionSiteId: params.constructionSiteId,
      shippingDriverId: params.shippingDriverId,
      orderStatus: params.orderStatus,
      sortColumns: params.sortColumns,
      sortOrders: params.sortOrders,
    );
  }
}
