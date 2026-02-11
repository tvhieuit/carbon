import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'dashboard_localizations_en.dart';
import 'dashboard_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of DashboardLocalizations
/// returned by `DashboardLocalizations.of(context)`.
///
/// Applications need to include `DashboardLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/dashboard_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: DashboardLocalizations.localizationsDelegates,
///   supportedLocales: DashboardLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the DashboardLocalizations.supportedLocales
/// property.
abstract class DashboardLocalizations {
  DashboardLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static DashboardLocalizations of(BuildContext context) {
    return Localizations.of<DashboardLocalizations>(context, DashboardLocalizations)!;
  }

  static const LocalizationsDelegate<DashboardLocalizations> delegate = _DashboardLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ja')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CarbonGauge'**
  String get appName;

  /// No description provided for @deliveryList.
  ///
  /// In en, this message translates to:
  /// **'Delivery List'**
  String get deliveryList;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @siteName.
  ///
  /// In en, this message translates to:
  /// **'Site Name'**
  String get siteName;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantity;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @onSiteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'On-site Conf.'**
  String get onSiteConfirmation;

  /// No description provided for @requiredSignature.
  ///
  /// In en, this message translates to:
  /// **' (Req. Sign)'**
  String get requiredSignature;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;
}

class _DashboardLocalizationsDelegate extends LocalizationsDelegate<DashboardLocalizations> {
  const _DashboardLocalizationsDelegate();

  @override
  Future<DashboardLocalizations> load(Locale locale) {
    return SynchronousFuture<DashboardLocalizations>(lookupDashboardLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_DashboardLocalizationsDelegate old) => false;
}

DashboardLocalizations lookupDashboardLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return DashboardLocalizationsEn();
    case 'ja':
      return DashboardLocalizationsJa();
  }

  throw FlutterError(
    'DashboardLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
