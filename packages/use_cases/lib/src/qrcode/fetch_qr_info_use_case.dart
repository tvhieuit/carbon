import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../base_use_case.dart';

@injectable
class FetchQrInfoUseCase implements UseCaseWithParams<QrInfoEntity, String> {
  final IQrcodeRepository _repository;

  FetchQrInfoUseCase(this._repository);

  @override
  Future<Result<QrInfoEntity>> call(String machineId) async {
    if (machineId.trim().isEmpty) {
      return const Result.failure(
        Failure.validation(
          message: 'Machine ID cannot be empty',
          code: 'EMPTY_MACHINE_ID',
        ),
      );
    }

    return await _repository.fetchQrInfo(machineId: machineId.trim());
  }
}
