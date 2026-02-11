// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'dashboard_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class DashboardLocalizationsEn extends DashboardLocalizations {
  DashboardLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'CarbonGauge';

  @override
  String get deliveryList => 'Delivery List';

  @override
  String get time => 'Time';

  @override
  String get siteName => 'Site Name';

  @override
  String get productName => 'Product Name';

  @override
  String get quantity => 'Qty';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get onSiteConfirmation => 'On-site Conf.';

  @override
  String get requiredSignature => ' (Req. Sign)';

  @override
  String get noData => 'No Data';
}
