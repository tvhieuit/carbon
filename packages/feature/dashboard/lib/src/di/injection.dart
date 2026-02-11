import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize dashboard package dependencies.
@InjectableInit(
  initializerName: 'initDashboardPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initDashboardPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initDashboardPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
