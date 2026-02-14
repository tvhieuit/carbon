import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import '../base_use_case.dart';

@injectable
class GetMeUseCase implements UseCase<MeEntity> {
  final AuthRepository _repository;

  GetMeUseCase(this._repository);

  @override
  Future<Result<MeEntity>> call() async {
    return await _repository.getMe();
  }
}
