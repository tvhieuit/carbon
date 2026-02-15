import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'delivery_creation_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of DeliveryCreationLocalizations
/// returned by `DeliveryCreationLocalizations.of(context)`.
///
/// Applications need to include `DeliveryCreationLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/delivery_creation_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: DeliveryCreationLocalizations.localizationsDelegates,
///   supportedLocales: DeliveryCreationLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the DeliveryCreationLocalizations.supportedLocales
/// property.
abstract class DeliveryCreationLocalizations {
  DeliveryCreationLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static DeliveryCreationLocalizations of(BuildContext context) {
    return Localizations.of<DeliveryCreationLocalizations>(context, DeliveryCreationLocalizations)!;
  }

  static const LocalizationsDelegate<DeliveryCreationLocalizations> delegate = _DeliveryCreationLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ja')];

  /// 納品作成画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'納品作成'**
  String get delivery_creation_title;

  /// No description provided for @loading_processing.
  ///
  /// In ja, this message translates to:
  /// **'納品処理中...'**
  String get loading_processing;

  /// No description provided for @customer_name_label.
  ///
  /// In ja, this message translates to:
  /// **'顧客名'**
  String get customer_name_label;

  /// No description provided for @construction_site_name_label.
  ///
  /// In ja, this message translates to:
  /// **'現場名'**
  String get construction_site_name_label;

  /// No description provided for @person_in_charge_label.
  ///
  /// In ja, this message translates to:
  /// **'現場担当者'**
  String get person_in_charge_label;

  /// No description provided for @contact_phone_label.
  ///
  /// In ja, this message translates to:
  /// **'連絡先'**
  String get contact_phone_label;

  /// No description provided for @machinery_table_image.
  ///
  /// In ja, this message translates to:
  /// **'画像'**
  String get machinery_table_image;

  /// No description provided for @machinery_table_name.
  ///
  /// In ja, this message translates to:
  /// **'名称'**
  String get machinery_table_name;

  /// No description provided for @machinery_table_number.
  ///
  /// In ja, this message translates to:
  /// **'車台番号'**
  String get machinery_table_number;

  /// No description provided for @machinery_table_quantity.
  ///
  /// In ja, this message translates to:
  /// **'数量'**
  String get machinery_table_quantity;

  /// No description provided for @add_machinery_button.
  ///
  /// In ja, this message translates to:
  /// **'機械追加'**
  String get add_machinery_button;

  /// No description provided for @submit_button.
  ///
  /// In ja, this message translates to:
  /// **'登録'**
  String get submit_button;

  /// No description provided for @add_machinery_dialog_title.
  ///
  /// In ja, this message translates to:
  /// **'機械を追加する'**
  String get add_machinery_dialog_title;

  /// No description provided for @from_master_label.
  ///
  /// In ja, this message translates to:
  /// **'マスターから選択'**
  String get from_master_label;

  /// No description provided for @new_registration_label.
  ///
  /// In ja, this message translates to:
  /// **'新規登録'**
  String get new_registration_label;

  /// No description provided for @select_machine_hint.
  ///
  /// In ja, this message translates to:
  /// **'機械を選択してください'**
  String get select_machine_hint;

  /// No description provided for @machine_name_input_label.
  ///
  /// In ja, this message translates to:
  /// **'名称入力'**
  String get machine_name_input_label;

  /// No description provided for @vehicle_number_input_label.
  ///
  /// In ja, this message translates to:
  /// **'車台番号入力'**
  String get vehicle_number_input_label;

  /// No description provided for @quantity_input_label.
  ///
  /// In ja, this message translates to:
  /// **'数量入力'**
  String get quantity_input_label;

  /// No description provided for @product_name_label.
  ///
  /// In ja, this message translates to:
  /// **'品名'**
  String get product_name_label;
}

class _DeliveryCreationLocalizationsDelegate extends LocalizationsDelegate<DeliveryCreationLocalizations> {
  const _DeliveryCreationLocalizationsDelegate();

  @override
  Future<DeliveryCreationLocalizations> load(Locale locale) {
    return SynchronousFuture<DeliveryCreationLocalizations>(lookupDeliveryCreationLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_DeliveryCreationLocalizationsDelegate old) => false;
}

DeliveryCreationLocalizations lookupDeliveryCreationLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja':
      return DeliveryCreationLocalizationsJa();
  }

  throw FlutterError(
    'DeliveryCreationLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
