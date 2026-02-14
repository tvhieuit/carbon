import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

/// Initialize dashboard package dependencies.
@InjectableInit(
  initializerName: 'initQrScanPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initQrScanPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initQrScanPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
