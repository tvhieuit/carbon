import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';

abstract class IMachineRepository {
  Future<Result<List<MachineryItemEntity>>> getMasterMachines();
}
