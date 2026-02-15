import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

@injectable
class GetFileUrlUseCase implements UseCaseWithParams<String, String> {
  final IFuelingRepository _repository;

  GetFileUrlUseCase(this._repository);

  @override
  Future<Result<String>> call(String fileId) async {
    return _repository.getFileUrl(fileId);
  }
}
