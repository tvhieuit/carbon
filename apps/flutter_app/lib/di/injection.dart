import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:data/data.dart';
import 'package:feature_app_settings/app_settings.dart';
import 'package:feature_auth/auth.dart';
import 'package:feature_dashboard/feature_dashboard.dart';
import 'package:feature_qr_scan/feature_qr_scan.dart';
import 'package:use_cases/use_cases.dart';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() {
  initCorePackage();

  // Initialize widget package dependencies
  initWidgetPackage();

  // Initialize data package dependencies (repo implementations, Dio, SharedPrefs)
  initDataPackage();

  // Initialize domain package dependencies
  initDomainPackage();

  // Initialize use cases package dependencies
  initUseCasesPackage();

  // Initialize auth package dependencies
  initAuthPackage();

  // Initialize dashboard package dependencies
  initDashboardPackage();

  // Initialize app settings package dependencies
  initAppSettingsPackage();

  // Initialize app qr scan package dependencies
  initQrScanPackage();

  // Initialize main app dependencies
  getIt.init();
}
