import 'package:feature_delivery_creation/delivery_creation.dart' as delivery;
import 'package:injectable/injectable.dart';

import '../app/delivery_creation_routes.dart';

@module
abstract class DeliveryCreationRouteModule {
  @lazySingleton
  delivery.AppRoute get deliveryCreationAppRoute => delivery.AppRoute(
    fuelDetail: DeliveryCreationQrCodeRoute(orderId: '', orderLineId: ''),
  );
}
