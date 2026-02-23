import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'feuling_detail_localizations_en.dart';
import 'feuling_detail_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FeulingDetailLocalizations
/// returned by `FeulingDetailLocalizations.of(context)`.
///
/// Applications need to include `FeulingDetailLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/feuling_detail_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FeulingDetailLocalizations.localizationsDelegates,
///   supportedLocales: FeulingDetailLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the FeulingDetailLocalizations.supportedLocales
/// property.
abstract class FeulingDetailLocalizations {
  FeulingDetailLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FeulingDetailLocalizations of(BuildContext context) {
    return Localizations.of<FeulingDetailLocalizations>(context, FeulingDetailLocalizations)!;
  }

  static const LocalizationsDelegate<FeulingDetailLocalizations> delegate = _FeulingDetailLocalizationsDelegate();

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

  /// Title for fueling details screen
  ///
  /// In en, this message translates to:
  /// **'Fueling Details'**
  String get fueling_details_title;

  /// No description provided for @no_order_info.
  ///
  /// In en, this message translates to:
  /// **'No order information available'**
  String get no_order_info;

  /// No description provided for @loading_text.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading_text;

  /// No description provided for @submitting_text.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting_text;

  /// No description provided for @saving_receipt_text.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving_receipt_text;

  /// No description provided for @person_in_charge_label.
  ///
  /// In en, this message translates to:
  /// **'Person in Charge'**
  String get person_in_charge_label;

  /// No description provided for @receipt_number_label.
  ///
  /// In en, this message translates to:
  /// **'Receipt Number'**
  String get receipt_number_label;

  /// No description provided for @customer_name_label.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customer_name_label;

  /// No description provided for @product_name_label.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get product_name_label;

  /// No description provided for @table_no_label.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get table_no_label;

  /// No description provided for @table_machine_name.
  ///
  /// In en, this message translates to:
  /// **'Machine Name'**
  String get table_machine_name;

  /// No description provided for @table_vehicle_number.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Number'**
  String get table_vehicle_number;

  /// No description provided for @table_quantity_liter.
  ///
  /// In en, this message translates to:
  /// **'Quantity (L)'**
  String get table_quantity_liter;

  /// No description provided for @table_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get table_total;

  /// No description provided for @non_oil_products_title.
  ///
  /// In en, this message translates to:
  /// **'Non-Oil Products'**
  String get non_oil_products_title;

  /// No description provided for @non_oil_quantity_label.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get non_oil_quantity_label;

  /// No description provided for @non_oil_piece_unit.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get non_oil_piece_unit;

  /// No description provided for @non_oil_empty.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get non_oil_empty;

  /// No description provided for @signature_title.
  ///
  /// In en, this message translates to:
  /// **'Receipt Signature'**
  String get signature_title;

  /// No description provided for @signature_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please obtain signature from site manager'**
  String get signature_instruction;

  /// No description provided for @signature_tap_to_sign.
  ///
  /// In en, this message translates to:
  /// **'Tap to sign'**
  String get signature_tap_to_sign;

  /// No description provided for @signature_not_required.
  ///
  /// In en, this message translates to:
  /// **'Signature not required'**
  String get signature_not_required;

  /// No description provided for @signature_load_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load signature'**
  String get signature_load_error;

  /// No description provided for @signature_saved.
  ///
  /// In en, this message translates to:
  /// **'Signature saved'**
  String get signature_saved;

  /// No description provided for @signature_required_error.
  ///
  /// In en, this message translates to:
  /// **'Please provide signature'**
  String get signature_required_error;

  /// No description provided for @signature_data_missing.
  ///
  /// In en, this message translates to:
  /// **'Signature data is missing'**
  String get signature_data_missing;

  /// No description provided for @button_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get button_back;

  /// No description provided for @button_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get button_submit;

  /// No description provided for @button_print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get button_print;

  /// No description provided for @button_update_signature.
  ///
  /// In en, this message translates to:
  /// **'Update Signature'**
  String get button_update_signature;

  /// No description provided for @button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// No description provided for @button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get button_save;

  /// No description provided for @submit_success_message.
  ///
  /// In en, this message translates to:
  /// **'Order submitted successfully ({receiptNumber})'**
  String submit_success_message(String receiptNumber);

  /// No description provided for @submit_error_default.
  ///
  /// In en, this message translates to:
  /// **'Error occurred while submitting order'**
  String get submit_error_default;

  /// No description provided for @offline_error.
  ///
  /// In en, this message translates to:
  /// **'No network connection. Order saved locally.'**
  String get offline_error;

  /// No description provided for @missing_order_receipt_id.
  ///
  /// In en, this message translates to:
  /// **'Order ID or Receipt ID not found'**
  String get missing_order_receipt_id;

  /// No description provided for @update_receipt_file_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to update file'**
  String get update_receipt_file_error;

  /// No description provided for @update_signature_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to update signature'**
  String get update_signature_error;

  /// No description provided for @print_started.
  ///
  /// In en, this message translates to:
  /// **'Print started'**
  String get print_started;

  /// No description provided for @print_success.
  ///
  /// In en, this message translates to:
  /// **'Print completed'**
  String get print_success;

  /// No description provided for @print_error.
  ///
  /// In en, this message translates to:
  /// **'Print failed'**
  String get print_error;

  /// No description provided for @receipt_title.
  ///
  /// In en, this message translates to:
  /// **'Delivery Receipt'**
  String get receipt_title;

  /// No description provided for @receipt_company_name.
  ///
  /// In en, this message translates to:
  /// **'Idemitsu Kosan Co., Ltd. Dealer'**
  String get receipt_company_name;

  /// No description provided for @receipt_store_name.
  ///
  /// In en, this message translates to:
  /// **'Matsubayashi Corporation'**
  String get receipt_store_name;

  /// No description provided for @receipt_station_brand.
  ///
  /// In en, this message translates to:
  /// **'apollostation'**
  String get receipt_station_brand;

  /// No description provided for @capture_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to capture view'**
  String get capture_error;

  /// No description provided for @reiwa_date_format.
  ///
  /// In en, this message translates to:
  /// **'Reiwa {year}/{month}/{day} ({dayOfWeek})'**
  String reiwa_date_format(int year, int month, int day, String dayOfWeek);

  /// No description provided for @day_monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get day_monday;

  /// No description provided for @day_tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get day_tuesday;

  /// No description provided for @day_wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get day_wednesday;

  /// No description provided for @day_thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get day_thursday;

  /// No description provided for @day_friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get day_friday;

  /// No description provided for @day_saturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get day_saturday;

  /// No description provided for @day_sunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get day_sunday;
}

class _FeulingDetailLocalizationsDelegate extends LocalizationsDelegate<FeulingDetailLocalizations> {
  const _FeulingDetailLocalizationsDelegate();

  @override
  Future<FeulingDetailLocalizations> load(Locale locale) {
    return SynchronousFuture<FeulingDetailLocalizations>(lookupFeulingDetailLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_FeulingDetailLocalizationsDelegate old) => false;
}

FeulingDetailLocalizations lookupFeulingDetailLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FeulingDetailLocalizationsEn();
    case 'ja':
      return FeulingDetailLocalizationsJa();
  }

  throw FlutterError(
    'FeulingDetailLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
