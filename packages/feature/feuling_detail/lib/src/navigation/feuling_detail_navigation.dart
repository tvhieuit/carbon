import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FeulingDetailNavigation {
  final FeulingDetailAppRoute _appRoute;

  FeulingDetailNavigation(this._appRoute);

  void goBack(BuildContext context) {
    context.maybePop();
  }

  void goToDashboard(BuildContext context) {
    context.router.popUntilRoot();
  }
}

class FeulingDetailAppRoute {
  final PageRouteInfo fuelingDetail;

  const FeulingDetailAppRoute({
    required this.fuelingDetail,
  });
}
