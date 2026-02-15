import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fueling_submit_result_entity.freezed.dart';
part 'fueling_submit_result_entity.g.dart';

@modelFreezed
sealed class FuelingSubmitResultEntity with _$FuelingSubmitResultEntity {
  const factory FuelingSubmitResultEntity({
    String? orderId,
    String? receiptId,
    String? receiptNumber,
    String? message,
  }) = _FuelingSubmitResultEntity;

  factory FuelingSubmitResultEntity.fromJson(Map<String, dynamic> json) =>
      _$FuelingSubmitResultEntityFromJson(json);
}
