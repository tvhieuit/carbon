import 'package:auto_route/auto_route.dart';

/// Route configuration for auth feature.
///
/// Each app provides its own route instances via DI.
///
/// ```dart
/// @module
/// abstract class AuthModule {
///   @lazySingleton
///   AppRoute get appRoute => AppRoute(
///     login: const LoginRoute(),
///     register: const RegisterRoute(),
///     home: const HomeRoute(),
///   );
/// }
/// ```
class AppRoute {
  final PageRouteInfo login;
  final PageRouteInfo register;
  final PageRouteInfo home;
  final PageRouteInfo dashboard;
  final PageRouteInfo qrScan;
  final PageRouteInfo qrScanQuantity;

  const AppRoute({
    required this.login,
    required this.register,
    required this.home,
    required this.dashboard,
    required this.qrScan,
    required this.qrScanQuantity,
  });
}
