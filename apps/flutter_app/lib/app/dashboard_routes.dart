import 'package:feature_dashboard/feature_dashboard.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for DashboardPage from dashboard package
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children}) : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrappedRoute(child: DashboardPage());
    },
  );
}
