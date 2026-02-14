part of 'qr_scan_bloc.dart';

@freezed
class QrScanEvent with _$QrScanEvent {
  const factory QrScanEvent.started() = _Started;
  const factory QrScanEvent.qrCodeDetected(Barcode barcode) = _QrCodeDetected;
  const factory QrScanEvent.errorOccurred(MobileScannerException error) = _ErrorOccurred;
  const factory QrScanEvent.resetRequested() = _ResetRequested;
}
