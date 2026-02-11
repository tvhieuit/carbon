import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_entity.freezed.dart';
part 'staff_entity.g.dart';

@modelFreezed
sealed class StaffEntity with _$StaffEntity {
  const factory StaffEntity({
    required String id,
    required String name,
  }) = _StaffEntity;

  factory StaffEntity.fromJson(Map<String, dynamic> json) => _$StaffEntityFromJson(json);
}
