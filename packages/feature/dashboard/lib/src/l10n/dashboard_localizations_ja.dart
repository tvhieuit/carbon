// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'dashboard_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class DashboardLocalizationsJa extends DashboardLocalizations {
  DashboardLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'CarbonGauge';

  @override
  String get deliveryList => '納品一覧';

  @override
  String get time => '時間';

  @override
  String get siteName => '現場名';

  @override
  String get productName => '商品名';

  @override
  String get quantity => '数量';

  @override
  String get statusDelivered => '納品済';

  @override
  String get statusCancelled => 'キャンセル';

  @override
  String get onSiteConfirmation => '現地確認';

  @override
  String get requiredSignature => ' (要サイン)';

  @override
  String get noData => 'データなし';
}
