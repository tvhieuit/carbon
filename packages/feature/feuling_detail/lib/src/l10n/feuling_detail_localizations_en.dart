// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'feuling_detail_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FeulingDetailLocalizationsEn extends FeulingDetailLocalizations {
  FeulingDetailLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get fueling_details_title => 'Fueling Details';

  @override
  String get no_order_info => 'No order information available';

  @override
  String get loading_text => 'Loading...';

  @override
  String get submitting_text => 'Submitting...';

  @override
  String get saving_receipt_text => 'Saving...';

  @override
  String get person_in_charge_label => 'Person in Charge';

  @override
  String get receipt_number_label => 'Receipt Number';

  @override
  String get customer_name_label => 'Customer Name';

  @override
  String get product_name_label => 'Product Name';

  @override
  String get table_no_label => 'No.';

  @override
  String get table_machine_name => 'Machine Name';

  @override
  String get table_vehicle_number => 'Vehicle Number';

  @override
  String get table_quantity_liter => 'Quantity (L)';

  @override
  String get table_total => 'Total';

  @override
  String get non_oil_products_title => 'Non-Oil Products';

  @override
  String get non_oil_quantity_label => 'Quantity';

  @override
  String get non_oil_piece_unit => 'pcs';

  @override
  String get non_oil_empty => 'None';

  @override
  String get signature_title => 'Receipt Signature';

  @override
  String get signature_instruction => 'Please obtain signature from site manager';

  @override
  String get signature_tap_to_sign => 'Tap to sign';

  @override
  String get signature_not_required => 'Signature not required';

  @override
  String get signature_load_error => 'Failed to load signature';

  @override
  String get signature_saved => 'Signature saved';

  @override
  String get signature_required_error => 'Please provide signature';

  @override
  String get signature_data_missing => 'Signature data is missing';

  @override
  String get button_back => 'Back';

  @override
  String get button_submit => 'Submit';

  @override
  String get button_print => 'Print';

  @override
  String get button_update_signature => 'Update Signature';

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_save => 'Save';

  @override
  String submit_success_message(String receiptNumber) {
    return 'Order submitted successfully ($receiptNumber)';
  }

  @override
  String get submit_error_default => 'Error occurred while submitting order';

  @override
  String get offline_error => 'No network connection. Order saved locally.';

  @override
  String get missing_order_receipt_id => 'Order ID or Receipt ID not found';

  @override
  String get update_receipt_file_error => 'Failed to update file';

  @override
  String get update_signature_error => 'Failed to update signature';

  @override
  String get print_started => 'Print started';

  @override
  String get print_success => 'Print completed';

  @override
  String get print_error => 'Print failed';

  @override
  String get receipt_title => 'Delivery Receipt';

  @override
  String get receipt_company_name => 'Idemitsu Kosan Co., Ltd. Dealer';

  @override
  String get receipt_store_name => 'Matsubayashi Corporation';

  @override
  String get receipt_station_brand => 'apollostation';

  @override
  String get capture_error => 'Failed to capture view';

  @override
  String reiwa_date_format(int year, int month, int day, String dayOfWeek) {
    return 'Reiwa $year/$month/$day ($dayOfWeek)';
  }

  @override
  String get day_monday => 'Mon';

  @override
  String get day_tuesday => 'Tue';

  @override
  String get day_wednesday => 'Wed';

  @override
  String get day_thursday => 'Thu';

  @override
  String get day_friday => 'Fri';

  @override
  String get day_saturday => 'Sat';

  @override
  String get day_sunday => 'Sun';
}
