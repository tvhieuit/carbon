import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'machinery_item_model.dart';

part 'delivery_order_model.freezed.dart';
part 'delivery_order_model.g.dart';

@modelFreezed
sealed class DeliveryOrderModel with _$DeliveryOrderModel {
  const DeliveryOrderModel._();

  const factory DeliveryOrderModel({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'order_line_id') required String orderLineId,
    @JsonKey(name: 'construction_site_id') required String constructionSiteId,
    @JsonKey(name: 'construction_machines') @Default([]) List<MachineryItemModel> constructionMachines,
    @JsonKey(name: 'receipt_lines') @Default([]) List<ReceiptLineModel> receiptLines,
  }) = _DeliveryOrderModel;

  factory DeliveryOrderModel.fromJson(Map<String, dynamic> json) => _$DeliveryOrderModelFromJson(json);

  factory DeliveryOrderModel.fromEntity(DeliveryOrderEntity entity) {
    return DeliveryOrderModel(
      orderId: entity.orderId,
      orderLineId: entity.orderLineId,
      constructionSiteId: entity.constructionSiteId,
      constructionMachines: entity.constructionMachines.map((e) => MachineryItemModel.fromEntity(e)).toList(),
      receiptLines: entity.receiptLines.map((e) => ReceiptLineModel.fromEntity(e)).toList(),
    );
  }

  DeliveryOrderEntity toEntity() {
    return DeliveryOrderEntity(
      orderId: this.orderId,
      orderLineId: this.orderLineId,
      constructionSiteId: this.constructionSiteId,
      constructionMachines: constructionMachines.map((e) => e.toEntity()).toList(),
      receiptLines: receiptLines.map((e) => e.toEntity()).toList(),
    );
  }
}

@modelFreezed
sealed class ReceiptLineModel with _$ReceiptLineModel {
  const ReceiptLineModel._();

  const factory ReceiptLineModel({
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'product_name') required String productName,
    double? quantity,
  }) = _ReceiptLineModel;

  factory ReceiptLineModel.fromJson(Map<String, dynamic> json) => _$ReceiptLineModelFromJson(json);

  factory ReceiptLineModel.fromEntity(ReceiptLineEntity entity) {
    return ReceiptLineModel(
      productId: entity.productId,
      productName: entity.productName,
      quantity: entity.quantity,
    );
  }

  ReceiptLineEntity toEntity() {
    return ReceiptLineEntity(
      productId: this.productId,
      productName: this.productName,
      quantity: this.quantity,
    );
  }
}
