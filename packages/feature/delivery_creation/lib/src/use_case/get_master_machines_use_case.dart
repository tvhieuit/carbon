import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';

@injectable
class GetMasterMachinesUseCase implements UseCase<List<MachineryItemEntity>> {
  final IMachineRepository _repository;

  GetMasterMachinesUseCase(this._repository);

  @override
  Future<Result<List<MachineryItemEntity>>> call() async {
    return _repository.getMasterMachines();
  }
}
