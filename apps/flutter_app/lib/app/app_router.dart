import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'qr_scan_routes.dart';
import 'app_router.gr.dart';
import 'auth_routes.dart';
import 'settings_routes.dart';
import 'dashboard_routes.dart';
import 'delivery_creation_routes.dart';
import 'feuling_detail_routes.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(GlobalKey<NavigatorState> key) : super(navigatorKey: key);

  @override
  List<AutoRoute> get routes => [
    // Splash screen - initial route
    AutoRoute(
      page: SplashRoute.page,
      initial: true,
    ),

    // Auth routes (from auth package)
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),

    // User screen
    AutoRoute(page: UserRoute.page),

    // Dashboard screen
    AutoRoute(page: DashboardRoute.page, path: '/dashboard'),

    // QR Scan screen
    AutoRoute(page: QrScanRoute.page, path: '/qr-scan'),
    AutoRoute(page: QrScanQuantityRoute.page, path: '/qr-scan-quantity'),
    AutoRoute(page: DeliveryCreationQrCodeRoute.page, path: '/delivery-creation/:orderId/:orderLineId'),

    // Fueling Details screen
    AutoRoute(page: FuelingDetailsRoute.page, path: '/fueling-detail/:orderId'),

    // App Settings (Bottom Sheet)
    AppBottomSheetRoute(page: AppSettingsRoute.page),

    // User Dialogs
    AppDialogRoute(page: UserUpdateRoute.page),
    AppDialogRoute(page: UserDeleteConfirmationRoute.page),
    AppDialogRoute(page: UserDetailsRoute.page),

    // Dialog routes
    AppDialogRoute(
      page: PermissionDialogRoute.page,
      barrierDismissible: false,
    ),
  ];
}
