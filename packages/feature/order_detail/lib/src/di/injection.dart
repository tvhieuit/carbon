import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize order detail package dependencies.
@InjectableInit(
  initializerName: 'initOrderDetailPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initOrderDetailPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initOrderDetailPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
