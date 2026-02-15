import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'machinery_item_entity.freezed.dart';
part 'machinery_item_entity.g.dart';

@modelFreezed
sealed class MachineryItemEntity with _$MachineryItemEntity {
  const factory MachineryItemEntity({
    required String machineId,
    required String machineryName,
    @JsonKey(name: 'vehicle_number') required String vehicleNumber,
    double? quantity,
    @Default([]) List<String> images,
    String? productId,
    String? productName,
    String? manufacturer,
  }) = _MachineryItemEntity;

  factory MachineryItemEntity.fromJson(Map<String, dynamic> json) => _$MachineryItemEntityFromJson(json);
}
