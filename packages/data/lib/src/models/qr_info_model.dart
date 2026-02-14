import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_info_model.freezed.dart';
part 'qr_info_model.g.dart';

@modelFreezed
sealed class QrInfoModel with _$QrInfoModel {

  const QrInfoModel._();

  const factory QrInfoModel({
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
  }) = _QrInfoModel;

  factory QrInfoModel.fromJson(Map<String, dynamic> json) => _$QrInfoModelFromJson(json);

  factory QrInfoModel.fromEntity(QrInfoEntity entity) {
    return QrInfoModel(
      id: entity.id,
      machineName: entity.machineName,
      machineNumber: entity.machineNumber,
      constructionSiteId: entity.constructionSiteId,
      constructionSiteName: entity.constructionSiteName,
      companyId: entity.companyId,
      companyName: entity.companyName,
      productName: entity.productName,
      branchId: entity.branchId,
      branchName: entity.branchName,
    );
  }

  QrInfoEntity toEntity() {
    return QrInfoEntity(
      id: id,
      machineName: machineName,
      machineNumber: machineNumber,
      constructionSiteId: constructionSiteId,
      constructionSiteName: constructionSiteName,
      companyId: companyId,
      companyName: companyName,
      productName: productName,
      branchId: branchId,
      branchName: branchName,
    );
  }
}
