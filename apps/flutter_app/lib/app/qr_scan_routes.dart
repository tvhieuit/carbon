import 'package:feature_qr_scan/feature_qr_scan.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';

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

/// Route definition for QrScanQuantityPage from qr_scan package
class QrScanQuantityRoute extends PageRouteInfo<QrScanQuantityRouteArgs> {
  QrScanQuantityRoute({
    required QrInfoEntity qrInfo,
    required List<OrderLineEntity> orderLines,
    List<PageRouteInfo>? children,
  }) : super(
         QrScanQuantityRoute.name,
         args: QrScanQuantityRouteArgs(
           qrInfo: qrInfo,
           orderLines: orderLines,
         ),
         initialChildren: children,
       );

  static const String name = 'QrScanQuantityRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<QrScanQuantityRouteArgs>();
      return QrScanQuantityPage(
        qrInfo: args.qrInfo,
        orderLines: args.orderLines,
      );
    },
  );
}

class QrScanQuantityRouteArgs {
  const QrScanQuantityRouteArgs({
    required this.qrInfo,
    required this.orderLines,
  });

  final QrInfoEntity qrInfo;
  final List<OrderLineEntity> orderLines;

  @override
  String toString() {
    return 'QrScanQuantityRouteArgs{qrInfo: $qrInfo, orderLines: $orderLines}';
  }
}
