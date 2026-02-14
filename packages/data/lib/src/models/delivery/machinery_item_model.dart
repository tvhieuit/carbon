import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'machinery_item_model.freezed.dart';
part 'machinery_item_model.g.dart';

@freezed
sealed class MachineryItemModel with _$MachineryItemModel {
  const factory MachineryItemModel({
    @JsonKey(name: 'machine_id') required String machineId,
    @JsonKey(name: 'machinery_name') required String machineryName,
    @JsonKey(name: 'vehicle_number') required String vehicleNumber,
    double? quantity,
    @Default([]) List<String> images,
    @JsonKey(name: 'product_id') String? productId,
  }) = _MachineryItemModel;

  factory MachineryItemModel.fromJson(Map<String, dynamic> json) => _$MachineryItemModelFromJson(json);

  factory MachineryItemModel.fromEntity(MachineryItemEntity entity) {
    return MachineryItemModel(
      machineId: entity.machineId,
      machineryName: entity.machineryName,
      vehicleNumber: entity.vehicleNumber,
      quantity: entity.quantity,
      images: entity.images,
      productId: entity.productId,
    );
  }

  MachineryItemEntity toEntity() {
    return MachineryItemEntity(
      machineId: machineId,
      machineryName: machineryName,
      vehicleNumber: vehicleNumber,
      quantity: quantity,
      images: images,
      productId: productId,
    );
  }
}
