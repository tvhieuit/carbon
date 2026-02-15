// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'feuling_detail_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class FeulingDetailLocalizationsJa extends FeulingDetailLocalizations {
  FeulingDetailLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get fueling_details_title => '給油明細';

  @override
  String get no_order_info => '注文情報がありません';

  @override
  String get loading_text => '読み込み中...';

  @override
  String get submitting_text => '送信中...';

  @override
  String get saving_receipt_text => '保存中...';

  @override
  String get person_in_charge_label => '担当者';

  @override
  String get receipt_number_label => '伝票番号';

  @override
  String get customer_name_label => 'お客様名';

  @override
  String get product_name_label => '品名';

  @override
  String get table_no_label => 'No.';

  @override
  String get table_machine_name => '機械名';

  @override
  String get table_vehicle_number => '車体番号';

  @override
  String get table_quantity_liter => '数量(L)';

  @override
  String get table_total => '合計';

  @override
  String get non_oil_products_title => '油外商品';

  @override
  String get non_oil_quantity_label => '数量';

  @override
  String get non_oil_piece_unit => '個';

  @override
  String get non_oil_empty => 'なし';

  @override
  String get signature_title => '受領サイン';

  @override
  String get signature_instruction => '現場責任者からサインを取得してください';

  @override
  String get signature_tap_to_sign => 'タップしてサインを取得';

  @override
  String get signature_not_required => 'サインは不要です';

  @override
  String get signature_load_error => '署名の読み込みに失敗しました';

  @override
  String get signature_saved => 'サインが保存されました';

  @override
  String get signature_required_error => 'サインを入力してください';

  @override
  String get signature_data_missing => '署名データが不足しています';

  @override
  String get button_back => '戻る';

  @override
  String get button_submit => '送信';

  @override
  String get button_print => '印刷';

  @override
  String get button_update_signature => '署名を更新';

  @override
  String get button_cancel => 'キャンセル';

  @override
  String get button_save => '保存';

  @override
  String submit_success_message(String receiptNumber) {
    return '注文が正常に送信されました ($receiptNumber)';
  }

  @override
  String get submit_error_default => 'オーダーの送信中にエラーが発生しました';

  @override
  String get offline_error => 'ネットワーク接続がありません。注文はローカルに保存されています。';

  @override
  String get missing_order_receipt_id => 'orderId または receiptId が見つかりません';

  @override
  String get update_receipt_file_error => 'ファイルの更新に失敗しました';

  @override
  String get update_signature_error => '署名の更新に失敗しました';

  @override
  String get print_started => '印刷を開始しました';

  @override
  String get print_success => '印刷が完了しました';

  @override
  String get print_error => '印刷に失敗しました';

  @override
  String get receipt_title => '納品伝票';

  @override
  String get receipt_company_name => '出光興産（株）販売店';

  @override
  String get receipt_store_name => '株式会社　松林';

  @override
  String get receipt_station_brand => 'apollostation';

  @override
  String get capture_error => 'ビューのキャプチャに失敗しました';

  @override
  String reiwa_date_format(int year, int month, int day, String dayOfWeek) {
    return '令和$year年$month月$day日 ($dayOfWeek)';
  }

  @override
  String get day_monday => '月';

  @override
  String get day_tuesday => '火';

  @override
  String get day_wednesday => '水';

  @override
  String get day_thursday => '木';

  @override
  String get day_friday => '金';

  @override
  String get day_saturday => '土';

  @override
  String get day_sunday => '日';
}
