import 'package:app_core/app_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_info_entity.freezed.dart';
part 'qr_info_entity.g.dart';

@modelFreezed
sealed class QrInfoEntity with _$QrInfoEntity {
  const factory QrInfoEntity({
    required String id,
    @JsonKey(name: 'machine_name') required String machineName,
    @JsonKey(name: 'machine_number') required String machineNumber,
    @JsonKey(name: 'construction_site_id') required String constructionSiteId,
    @JsonKey(name: 'construction_site_name') required String constructionSiteName,
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'company_name') required String companyName,
    @JsonKey(name: 'product_name') required String productName,
    @JsonKey(name: 'branch_id') required String branchId,
    @JsonKey(name: 'branch_name') required String branchName,
  }) = _QrInfoEntity;

  factory QrInfoEntity.fromJson(Map<String, dynamic> json) => _$QrInfoEntityFromJson(json);
}
