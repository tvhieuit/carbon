import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('ja')];

  /// 給油明細画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'給油明細'**
  String get fueling_details_title;

  /// No description provided for @no_order_info.
  ///
  /// In ja, this message translates to:
  /// **'注文情報がありません'**
  String get no_order_info;

  /// No description provided for @loading_text.
  ///
  /// In ja, this message translates to:
  /// **'読み込み中...'**
  String get loading_text;

  /// No description provided for @submitting_text.
  ///
  /// In ja, this message translates to:
  /// **'送信中...'**
  String get submitting_text;

  /// No description provided for @saving_receipt_text.
  ///
  /// In ja, this message translates to:
  /// **'保存中...'**
  String get saving_receipt_text;

  /// No description provided for @person_in_charge_label.
  ///
  /// In ja, this message translates to:
  /// **'担当者'**
  String get person_in_charge_label;

  /// No description provided for @receipt_number_label.
  ///
  /// In ja, this message translates to:
  /// **'伝票番号'**
  String get receipt_number_label;

  /// No description provided for @customer_name_label.
  ///
  /// In ja, this message translates to:
  /// **'お客様名'**
  String get customer_name_label;

  /// No description provided for @product_name_label.
  ///
  /// In ja, this message translates to:
  /// **'品名'**
  String get product_name_label;

  /// No description provided for @table_no_label.
  ///
  /// In ja, this message translates to:
  /// **'No.'**
  String get table_no_label;

  /// No description provided for @table_machine_name.
  ///
  /// In ja, this message translates to:
  /// **'機械名'**
  String get table_machine_name;

  /// No description provided for @table_vehicle_number.
  ///
  /// In ja, this message translates to:
  /// **'車体番号'**
  String get table_vehicle_number;

  /// No description provided for @table_quantity_liter.
  ///
  /// In ja, this message translates to:
  /// **'数量(L)'**
  String get table_quantity_liter;

  /// No description provided for @table_total.
  ///
  /// In ja, this message translates to:
  /// **'合計'**
  String get table_total;

  /// No description provided for @non_oil_products_title.
  ///
  /// In ja, this message translates to:
  /// **'油外商品'**
  String get non_oil_products_title;

  /// No description provided for @non_oil_quantity_label.
  ///
  /// In ja, this message translates to:
  /// **'数量'**
  String get non_oil_quantity_label;

  /// No description provided for @non_oil_piece_unit.
  ///
  /// In ja, this message translates to:
  /// **'個'**
  String get non_oil_piece_unit;

  /// No description provided for @non_oil_empty.
  ///
  /// In ja, this message translates to:
  /// **'なし'**
  String get non_oil_empty;

  /// No description provided for @signature_title.
  ///
  /// In ja, this message translates to:
  /// **'受領サイン'**
  String get signature_title;

  /// No description provided for @signature_instruction.
  ///
  /// In ja, this message translates to:
  /// **'現場責任者からサインを取得してください'**
  String get signature_instruction;

  /// No description provided for @signature_tap_to_sign.
  ///
  /// In ja, this message translates to:
  /// **'タップしてサインを取得'**
  String get signature_tap_to_sign;

  /// No description provided for @signature_not_required.
  ///
  /// In ja, this message translates to:
  /// **'サインは不要です'**
  String get signature_not_required;

  /// No description provided for @signature_load_error.
  ///
  /// In ja, this message translates to:
  /// **'署名の読み込みに失敗しました'**
  String get signature_load_error;

  /// No description provided for @signature_saved.
  ///
  /// In ja, this message translates to:
  /// **'サインが保存されました'**
  String get signature_saved;

  /// No description provided for @signature_required_error.
  ///
  /// In ja, this message translates to:
  /// **'サインを入力してください'**
  String get signature_required_error;

  /// No description provided for @signature_data_missing.
  ///
  /// In ja, this message translates to:
  /// **'署名データが不足しています'**
  String get signature_data_missing;

  /// No description provided for @button_back.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get button_back;

  /// No description provided for @button_submit.
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get button_submit;

  /// No description provided for @button_print.
  ///
  /// In ja, this message translates to:
  /// **'印刷'**
  String get button_print;

  /// No description provided for @button_update_signature.
  ///
  /// In ja, this message translates to:
  /// **'署名を更新'**
  String get button_update_signature;

  /// No description provided for @button_cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get button_cancel;

  /// No description provided for @button_save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get button_save;

  /// No description provided for @submit_success_message.
  ///
  /// In ja, this message translates to:
  /// **'注文が正常に送信されました ({receiptNumber})'**
  String submit_success_message(String receiptNumber);

  /// No description provided for @submit_error_default.
  ///
  /// In ja, this message translates to:
  /// **'オーダーの送信中にエラーが発生しました'**
  String get submit_error_default;

  /// No description provided for @offline_error.
  ///
  /// In ja, this message translates to:
  /// **'ネットワーク接続がありません。注文はローカルに保存されています。'**
  String get offline_error;

  /// No description provided for @missing_order_receipt_id.
  ///
  /// In ja, this message translates to:
  /// **'orderId または receiptId が見つかりません'**
  String get missing_order_receipt_id;

  /// No description provided for @update_receipt_file_error.
  ///
  /// In ja, this message translates to:
  /// **'ファイルの更新に失敗しました'**
  String get update_receipt_file_error;

  /// No description provided for @update_signature_error.
  ///
  /// In ja, this message translates to:
  /// **'署名の更新に失敗しました'**
  String get update_signature_error;

  /// No description provided for @print_started.
  ///
  /// In ja, this message translates to:
  /// **'印刷を開始しました'**
  String get print_started;

  /// No description provided for @print_success.
  ///
  /// In ja, this message translates to:
  /// **'印刷が完了しました'**
  String get print_success;

  /// No description provided for @print_error.
  ///
  /// In ja, this message translates to:
  /// **'印刷に失敗しました'**
  String get print_error;

  /// No description provided for @receipt_title.
  ///
  /// In ja, this message translates to:
  /// **'納品伝票'**
  String get receipt_title;

  /// No description provided for @receipt_company_name.
  ///
  /// In ja, this message translates to:
  /// **'出光興産（株）販売店'**
  String get receipt_company_name;

  /// No description provided for @receipt_store_name.
  ///
  /// In ja, this message translates to:
  /// **'株式会社　松林'**
  String get receipt_store_name;

  /// No description provided for @receipt_station_brand.
  ///
  /// In ja, this message translates to:
  /// **'apollostation'**
  String get receipt_station_brand;

  /// No description provided for @capture_error.
  ///
  /// In ja, this message translates to:
  /// **'ビューのキャプチャに失敗しました'**
  String get capture_error;

  /// No description provided for @reiwa_date_format.
  ///
  /// In ja, this message translates to:
  /// **'令和{year}年{month}月{day}日 ({dayOfWeek})'**
  String reiwa_date_format(int year, int month, int day, String dayOfWeek);

  /// No description provided for @day_monday.
  ///
  /// In ja, this message translates to:
  /// **'月'**
  String get day_monday;

  /// No description provided for @day_tuesday.
  ///
  /// In ja, this message translates to:
  /// **'火'**
  String get day_tuesday;

  /// No description provided for @day_wednesday.
  ///
  /// In ja, this message translates to:
  /// **'水'**
  String get day_wednesday;

  /// No description provided for @day_thursday.
  ///
  /// In ja, this message translates to:
  /// **'木'**
  String get day_thursday;

  /// No description provided for @day_friday.
  ///
  /// In ja, this message translates to:
  /// **'金'**
  String get day_friday;

  /// No description provided for @day_saturday.
  ///
  /// In ja, this message translates to:
  /// **'土'**
  String get day_saturday;

  /// No description provided for @day_sunday.
  ///
  /// In ja, this message translates to:
  /// **'日'**
  String get day_sunday;
}

class _FeulingDetailLocalizationsDelegate extends LocalizationsDelegate<FeulingDetailLocalizations> {
  const _FeulingDetailLocalizationsDelegate();

  @override
  Future<FeulingDetailLocalizations> load(Locale locale) {
    return SynchronousFuture<FeulingDetailLocalizations>(lookupFeulingDetailLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_FeulingDetailLocalizationsDelegate old) => false;
}

FeulingDetailLocalizations lookupFeulingDetailLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
