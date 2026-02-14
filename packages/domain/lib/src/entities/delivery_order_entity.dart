import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'machinery_item_entity.dart';

part 'delivery_order_entity.freezed.dart';
part 'delivery_order_entity.g.dart';

@modelFreezed
sealed class DeliveryOrderEntity with _$DeliveryOrderEntity {
  const factory DeliveryOrderEntity({
    required String orderId,
    required String orderLineId,
    required String constructionSiteId,
    @JsonKey(name: 'construction_machines') @Default([]) List<MachineryItemEntity> constructionMachines,
    @JsonKey(name: 'receipt_lines') @Default([]) List<ReceiptLineEntity> receiptLines,
  }) = _DeliveryOrderEntity;

  factory DeliveryOrderEntity.fromJson(Map<String, dynamic> json) => _$DeliveryOrderEntityFromJson(json);
}

@modelFreezed
sealed class ReceiptLineEntity with _$ReceiptLineEntity {
  const factory ReceiptLineEntity({
    required String productId,
    required String productName,
    double? quantity,
  }) = _ReceiptLineEntity;

  factory ReceiptLineEntity.fromJson(Map<String, dynamic> json) => _$ReceiptLineEntityFromJson(json);
}
