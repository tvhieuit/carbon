import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fueling_submit_result_model.freezed.dart';
part 'fueling_submit_result_model.g.dart';

@modelFreezed
sealed class FuelingSubmitResultModel with _$FuelingSubmitResultModel {
  const FuelingSubmitResultModel._();

  const factory FuelingSubmitResultModel({
    @JsonKey(name: 'order_id') String? orderId,
    @JsonKey(name: 'receipt_id') String? receiptId,
    @JsonKey(name: 'receipt_number') String? receiptNumber,
    String? message,
  }) = _FuelingSubmitResultModel;

  factory FuelingSubmitResultModel.fromJson(Map<String, dynamic> json) =>
      _$FuelingSubmitResultModelFromJson(json);

  factory FuelingSubmitResultModel.fromEntity(
      FuelingSubmitResultEntity entity) {
    return FuelingSubmitResultModel(
      orderId: entity.orderId,
      receiptId: entity.receiptId,
      receiptNumber: entity.receiptNumber,
      message: entity.message,
    );
  }

  FuelingSubmitResultEntity toEntity() {
    return FuelingSubmitResultEntity(
      orderId: orderId,
      receiptId: receiptId,
      receiptNumber: receiptNumber,
      message: message,
    );
  }
}
