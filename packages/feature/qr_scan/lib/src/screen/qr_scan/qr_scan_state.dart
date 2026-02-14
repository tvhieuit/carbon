part of 'qr_scan_bloc.dart';

@freezed
class QrScanState with _$QrScanState {
  const factory QrScanState.initial() = _Initial;
  const factory QrScanState.scanning() = _Scanning;
  const factory QrScanState.detected(String code) = _Detected;
  const factory QrScanState.error(MobileScannerException error) = _Error;
  const factory QrScanState.success() = _Success;
}
