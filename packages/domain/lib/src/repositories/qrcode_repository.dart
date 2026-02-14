import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IQrcodeRepository {
  Future<Result<QrInfoEntity>> fetchQrInfo({
    required String machineId,
  });
}
