export 'dashboard_localizations.dart';
export 'dashboard_localizations_ja.dart';
export 'dashboard_localizations_en.dart';

import 'package:flutter/widgets.dart';
import 'dashboard_localizations.dart';

extension DashboardLocalizationsX on BuildContext {
  DashboardLocalizations get dashboardL10n => DashboardLocalizations.of(this);
}
