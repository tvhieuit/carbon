import 'package:auto_route/auto_route.dart';
import 'package:feature_auth/auth.dart';
import 'package:injectable/injectable.dart';

import '../app/app_router.dart';
import '../app/app_router.gr.dart';
import '../app/auth_routes.dart';
import '../app/dashboard_routes.dart';

import '../app/qr_scan_routes.dart';

/// Module for registering routing dependencies
@module
abstract class RouteModule {
  @lazySingleton
  AppRoute get appRoute => AppRoute(
    login: const LoginRoute(),
    register: const RegisterRoute(),
    home: const UserRoute(),
    dashboard: const DashboardRoute(),
    qrScan: const QrScanRoute(),
    qrScanQuantity: QrScanQuantityRoute(
      qrInfo: const QrInfoEntity(
        id: '',
        machineName: '',
        machineNumber: '',
        constructionSiteId: '',
        constructionSiteName: '',
        companyId: '',
        companyName: '',
        productName: '',
        branchId: '',
        branchName: '',
      ),
      orderLines: [],
    ),
  );

  @lazySingleton
  StackRouter stackRouter(AppRouter appRouter) => appRouter;
}
