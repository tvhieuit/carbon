import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_entity.freezed.dart';
part 'order_entity.g.dart';

@modelFreezed
sealed class OrderEntity with _$OrderEntity {
  const factory OrderEntity({
    required String id,
    @JsonKey(name: 'refueling_date') required String refuelingDate,
    @JsonKey(name: 'refueling_from_time') required String refuelingFromTime,
    @JsonKey(name: 'refueling_to_time') required String refuelingToTime,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'construction_site_name') required String constructionSiteName,
    @JsonKey(name: 'delivery_status') required String deliveryStatus,
    @JsonKey(name: 'shipping_driver_id') String? shippingDriverId,
    @JsonKey(name: 'receipt_file_id') String? receiptFileId,
    @JsonKey(name: 'signature_date') DateTime? signatureDate,
    @JsonKey(name: 'product_id') String? productId,
    @JsonKey(name: 'order_lines') @Default([]) List<OrderLineEntity> orderLines,
  }) = _OrderEntity;

  factory OrderEntity.fromJson(Map<String, dynamic> json) => _$OrderEntityFromJson(json);
}

@modelFreezed
sealed class OrderLineEntity with _$OrderLineEntity {
  const factory OrderLineEntity({
    required String id,
    @JsonKey(name: 'product_name') String? productName,
    double? quantity,
  }) = _OrderLineEntity;

  factory OrderLineEntity.fromJson(Map<String, dynamic> json) => _$OrderLineEntityFromJson(json);
}
