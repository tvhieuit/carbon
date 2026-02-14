import 'package:feature_delivery_creation/feature_delivery_creation.dart';
import 'package:auto_route/auto_route.dart';

/// Route definition for DeliveryCreationQrCodePage from delivery_creation package
class DeliveryCreationQrCodeRoute extends PageRouteInfo<DeliveryCreationQrCodeRouteArgs> {
  DeliveryCreationQrCodeRoute({
    required String orderId,
    required String orderLineId,
    List<PageRouteInfo>? children,
  }) : super(
         DeliveryCreationQrCodeRoute.name,
         args: DeliveryCreationQrCodeRouteArgs(
           orderId: orderId,
           orderLineId: orderLineId,
         ),
         rawPathParams: {
           'orderId': orderId,
           'orderLineId': orderLineId,
         },
         initialChildren: children,
       );

  static const String name = 'DeliveryCreationQrCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<DeliveryCreationQrCodeRouteArgs>();
      return DeliveryCreationQrCodePage(
        orderId: args.orderId,
        orderLineId: args.orderLineId,
      );
    },
  );
}

class DeliveryCreationQrCodeRouteArgs {
  const DeliveryCreationQrCodeRouteArgs({
    required this.orderId,
    required this.orderLineId,
  });

  final String orderId;
  final String orderLineId;

  @override
  String toString() {
    return 'DeliveryCreationQrCodeRouteArgs{orderId: $orderId, orderLineId: $orderLineId}';
  }
}
