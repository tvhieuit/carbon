import 'package:feature_feuling_detail/feuling_detail.dart';
import 'package:injectable/injectable.dart';

import '../app/feuling_detail_routes.dart';

@module
abstract class FeulingDetailRouteModule {
  @lazySingleton
  FeulingDetailAppRoute get feulingDetailAppRoute => FeulingDetailAppRoute(
        fuelingDetail: FuelingDetailsRoute(orderId: ''),
      );
}
