import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'me_entity.freezed.dart';
part 'me_entity.g.dart';

@modelFreezed
sealed class MeEntity with _$MeEntity {
  const MeEntity._();

  const factory MeEntity({
    required String id,
    required String email,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'user_type') required String userType,
    @JsonKey(name: 'role_id') required String roleId,
    required List<String> permissions,
    @JsonKey(name: 'is_admin') required bool isAdmin,
    @JsonKey(name: 'user_detail') required UserDetailEntity userDetail,
  }) = _MeEntity;

  factory MeEntity.fromJson(Map<String, dynamic> json) => _$MeEntityFromJson(json);
}

@modelFreezed
sealed class UserDetailEntity with _$UserDetailEntity {
  const UserDetailEntity._();

  const factory UserDetailEntity({
    required String id,
    required String name,
    String? phone,
    @JsonKey(name: 'is_inhourse') required bool isInhourse,
    @JsonKey(name: 'tenant_store_id') required String tenantStoreId,
    @JsonKey(name: 'company_id') String? companyId,
  }) = _UserDetailEntity;

  factory UserDetailEntity.fromJson(Map<String, dynamic> json) => _$UserDetailEntityFromJson(json);
}
