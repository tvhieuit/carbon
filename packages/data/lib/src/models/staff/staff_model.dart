import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@modelFreezed
sealed class StaffModel with _$StaffModel {
  const StaffModel._();

  const factory StaffModel({
    required String id,
    required String name,
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) => _$StaffModelFromJson(json);

  StaffEntity toEntity() => StaffEntity(
    id: id,
    name: name,
  );
}
