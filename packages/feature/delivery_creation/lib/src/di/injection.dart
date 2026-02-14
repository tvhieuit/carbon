import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart' as config;

@InjectableInit(
  initializerName: 'initDeliveryCreationPackageConfig',
  preferRelativeImports: true,
  asExtension: false,
)
GetIt initDeliveryCreationPackage({
  GetIt? getIt,
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  return config.initDeliveryCreationPackageConfig(
    getIt ?? GetIt.instance,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
