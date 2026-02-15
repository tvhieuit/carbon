import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

@InjectableInit(
  initializerName: 'initFeulingDetailPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initFeulingDetailPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initFeulingDetailPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
