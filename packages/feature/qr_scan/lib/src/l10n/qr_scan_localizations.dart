import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'qr_scan_localizations_en.dart';
import 'qr_scan_localizations_ja.dart';
import 'qr_scan_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of QrScanLocalizations
/// returned by `QrScanLocalizations.of(context)`.
///
/// Applications need to include `QrScanLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/qr_scan_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: QrScanLocalizations.localizationsDelegates,
///   supportedLocales: QrScanLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the QrScanLocalizations.supportedLocales
/// property.
abstract class QrScanLocalizations {
  QrScanLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static QrScanLocalizations of(BuildContext context) {
    return Localizations.of<QrScanLocalizations>(context, QrScanLocalizations)!;
  }

  static const LocalizationsDelegate<QrScanLocalizations> delegate = _QrScanLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('ja'), Locale('vi')];

  /// No description provided for @qr_scan_title.
  ///
  /// In en, this message translates to:
  /// **'QR Scan'**
  String get qr_scan_title;

  /// No description provided for @scan_your_qr.
  ///
  /// In en, this message translates to:
  /// **'Scan your QR Code'**
  String get scan_your_qr;

  /// No description provided for @close_button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close_button;

  /// No description provided for @camera_error.
  ///
  /// In en, this message translates to:
  /// **'Camera Error:'**
  String get camera_error;

  /// No description provided for @machine_info_title.
  ///
  /// In en, this message translates to:
  /// **'Machine Information'**
  String get machine_info_title;

  /// No description provided for @customer_name_label.
  ///
  /// In en, this message translates to:
  /// **'Customer Name:'**
  String get customer_name_label;

  /// No description provided for @branch_name_label.
  ///
  /// In en, this message translates to:
  /// **'Branch Name:'**
  String get branch_name_label;

  /// No description provided for @construction_site_name_label.
  ///
  /// In en, this message translates to:
  /// **'Construction Site:'**
  String get construction_site_name_label;

  /// No description provided for @machine_name_label.
  ///
  /// In en, this message translates to:
  /// **'Machine Name:'**
  String get machine_name_label;

  /// No description provided for @machine_number_label.
  ///
  /// In en, this message translates to:
  /// **'Machine Number:'**
  String get machine_number_label;

  /// No description provided for @fuel_type_label.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type:'**
  String get fuel_type_label;

  /// No description provided for @product_name_header.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name_header;

  /// No description provided for @order_number_header.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get order_number_header;

  /// No description provided for @quantity_header.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity_header;

  /// No description provided for @finish_button.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish_button;

  /// No description provided for @next_scan_button.
  ///
  /// In en, this message translates to:
  /// **'Next Scan'**
  String get next_scan_button;
}

class _QrScanLocalizationsDelegate extends LocalizationsDelegate<QrScanLocalizations> {
  const _QrScanLocalizationsDelegate();

  @override
  Future<QrScanLocalizations> load(Locale locale) {
    return SynchronousFuture<QrScanLocalizations>(lookupQrScanLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_QrScanLocalizationsDelegate old) => false;
}

QrScanLocalizations lookupQrScanLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return QrScanLocalizationsEn();
    case 'ja':
      return QrScanLocalizationsJa();
    case 'vi':
      return QrScanLocalizationsVi();
  }

  throw FlutterError(
    'QrScanLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
