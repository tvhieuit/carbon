import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'order_detail_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of OrderDetailLocalizations
/// returned by `OrderDetailLocalizations.of(context)`.
///
/// Applications need to include `OrderDetailLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/order_detail_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: OrderDetailLocalizations.localizationsDelegates,
///   supportedLocales: OrderDetailLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the OrderDetailLocalizations.supportedLocales
/// property.
abstract class OrderDetailLocalizations {
  OrderDetailLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static OrderDetailLocalizations? of(BuildContext context) {
    return Localizations.of<OrderDetailLocalizations>(context, OrderDetailLocalizations);
  }

  static const LocalizationsDelegate<OrderDetailLocalizations> delegate = _OrderDetailLocalizationsDelegate();

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

  /// No description provided for @orderDetailTitle.
  ///
  /// In ja, this message translates to:
  /// **'納品詳細'**
  String get orderDetailTitle;

  /// No description provided for @deliveryTime.
  ///
  /// In ja, this message translates to:
  /// **'納品時間'**
  String get deliveryTime;

  /// No description provided for @assignedStoreName.
  ///
  /// In ja, this message translates to:
  /// **'担当店舗名'**
  String get assignedStoreName;

  /// No description provided for @deliveryStaff.
  ///
  /// In ja, this message translates to:
  /// **'配達担当者'**
  String get deliveryStaff;

  /// No description provided for @companyName.
  ///
  /// In ja, this message translates to:
  /// **'会社名'**
  String get companyName;

  /// No description provided for @branchName.
  ///
  /// In ja, this message translates to:
  /// **'支店名'**
  String get branchName;

  /// No description provided for @constructionSiteName.
  ///
  /// In ja, this message translates to:
  /// **'現場名'**
  String get constructionSiteName;

  /// No description provided for @personInCharge.
  ///
  /// In ja, this message translates to:
  /// **'担当'**
  String get personInCharge;

  /// No description provided for @phoneNumber.
  ///
  /// In ja, this message translates to:
  /// **'電話番号'**
  String get phoneNumber;

  /// No description provided for @productInformation.
  ///
  /// In ja, this message translates to:
  /// **'商品情報'**
  String get productInformation;

  /// No description provided for @productName.
  ///
  /// In ja, this message translates to:
  /// **'商品名'**
  String get productName;

  /// No description provided for @quantity.
  ///
  /// In ja, this message translates to:
  /// **'数量'**
  String get quantity;

  /// No description provided for @constructionSiteAddress.
  ///
  /// In ja, this message translates to:
  /// **'現場住所'**
  String get constructionSiteAddress;

  /// No description provided for @noAddressInfo.
  ///
  /// In ja, this message translates to:
  /// **'住所情報がありません'**
  String get noAddressInfo;

  /// No description provided for @remarks.
  ///
  /// In ja, this message translates to:
  /// **'備考'**
  String get remarks;

  /// No description provided for @noRemarksInfo.
  ///
  /// In ja, this message translates to:
  /// **'備考情報がありません'**
  String get noRemarksInfo;

  /// No description provided for @caseNotes.
  ///
  /// In ja, this message translates to:
  /// **'案件メモ'**
  String get caseNotes;

  /// No description provided for @noCaseNotesInfo.
  ///
  /// In ja, this message translates to:
  /// **'案件メモ情報がありません'**
  String get noCaseNotesInfo;

  /// No description provided for @backButton.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get backButton;

  /// No description provided for @startDelivery.
  ///
  /// In ja, this message translates to:
  /// **'納品入力へ'**
  String get startDelivery;

  /// No description provided for @viewReceipt.
  ///
  /// In ja, this message translates to:
  /// **'実績詳細へ'**
  String get viewReceipt;

  /// No description provided for @apiError.
  ///
  /// In ja, this message translates to:
  /// **'データの取得に失敗しました'**
  String get apiError;

  /// No description provided for @tryAgain.
  ///
  /// In ja, this message translates to:
  /// **'再試行'**
  String get tryAgain;
}

class _OrderDetailLocalizationsDelegate extends LocalizationsDelegate<OrderDetailLocalizations> {
  const _OrderDetailLocalizationsDelegate();

  @override
  Future<OrderDetailLocalizations> load(Locale locale) {
    return SynchronousFuture<OrderDetailLocalizations>(lookupOrderDetailLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_OrderDetailLocalizationsDelegate old) => false;
}

OrderDetailLocalizations lookupOrderDetailLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ja':
      return OrderDetailLocalizationsJa();
  }

  throw FlutterError(
    'OrderDetailLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
