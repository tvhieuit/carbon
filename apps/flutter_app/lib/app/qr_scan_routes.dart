import 'package:feature_qr_scan/feature_qr_scan.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for QrScanPage from qr_scan package
class QrScanRoute extends PageRouteInfo<void> {
  const QrScanRoute({List<PageRouteInfo>? children}) : super(QrScanRoute.name, initialChildren: children);

  static const String name = 'QrScanRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const WrappedRoute(child: QrScanPage());
    },
  );
}
