import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeliveryCreationNavigation {
  final AppRoute _appRoute;

  DeliveryCreationNavigation(this._appRoute);

  void goBack(BuildContext context) {
    context.maybePop();
  }
}

class AppRoute {
  final PageRouteInfo fuelDetail;

  const AppRoute({
    required this.fuelDetail,
  });
}
