import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@modelFreezed
sealed  class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    required String id,
    @JsonKey(name: 'refueling_date') required String refuelingDate,
    @JsonKey(name: 'refueling_from_time') required String refuelingFromTime,
    @JsonKey(name: 'refueling_to_time') required String refuelingToTime,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'construction_site_name') required String constructionSiteName,
    @JsonKey(name: 'delivery_status') required String deliveryStatus,
    @JsonKey(name: 'receipt_file_id') String? receiptFileId,
    @JsonKey(name: 'signature_date') String? signatureDate,
    @JsonKey(name: 'product_id') String? productId,
    @JsonKey(name: 'order_lines') @Default([]) List<OrderLineModel> orderLines,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  OrderEntity toEntity() => OrderEntity(
    id: id,
    refuelingDate: refuelingDate,
    refuelingFromTime: refuelingFromTime,
    refuelingToTime: refuelingToTime,
    companyName: companyName,
    constructionSiteName: constructionSiteName,
    deliveryStatus: deliveryStatus,
    receiptFileId: receiptFileId,
    signatureDate: signatureDate != null ? DateTime.tryParse(signatureDate!) : null,
    productId: productId,
    orderLines: orderLines.map((e) => e.toEntity()).toList(),
  );
}

@modelFreezed
sealed class OrderLineModel with _$OrderLineModel {
  const OrderLineModel._();

  const factory OrderLineModel({
    required String id,
    @JsonKey(name: 'product_name') String? productName,
    double? quantity,
  }) = _OrderLineModel;

  factory OrderLineModel.fromJson(Map<String, dynamic> json) => _$OrderLineModelFromJson(json);

  OrderLineEntity toEntity() => OrderLineEntity(
    id: id,
    productName: productName,
    quantity: quantity,
  );
}
