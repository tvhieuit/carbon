import 'package:feature_feuling_detail/feuling_detail.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for FuelingDetailsPage from feuling_detail package
class FuelingDetailsRoute extends PageRouteInfo<FuelingDetailsRouteArgs> {
  FuelingDetailsRoute({
    required String orderId,
    String? machineId,
    DeliveryOrderEntity? deliveryOrder,
    List<PageRouteInfo>? children,
  }) : super(
         FuelingDetailsRoute.name,
         args: FuelingDetailsRouteArgs(
           orderId: orderId,
           machineId: machineId,
           deliveryOrder: deliveryOrder,
         ),
         rawPathParams: {
           'orderId': orderId,
         },
         initialChildren: children,
       );

  static const String name = 'FuelingDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FuelingDetailsRouteArgs>();
      return FuelingDetailsPage(
        orderId: args.orderId,
        machineId: args.machineId,
        deliveryOrder: args.deliveryOrder,
      );
    },
  );
}

class FuelingDetailsRouteArgs {
  const FuelingDetailsRouteArgs({
    required this.orderId,
    this.machineId,
    this.deliveryOrder,
  });

  final String orderId;
  final String? machineId;
  final DeliveryOrderEntity? deliveryOrder;

  @override
  String toString() {
    return 'FuelingDetailsRouteArgs{orderId: $orderId, machineId: $machineId, deliveryOrder: $deliveryOrder}';
  }
}
