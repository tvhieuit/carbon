import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';
part 'qr_scan_bloc.freezed.dart';

@injectable
class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  QrScanBloc() : super(const QrScanState.initial()) {
    on<_Started>((event, emit) {
      emit(const QrScanState.scanning());
    });

    on<_QrCodeDetected>((event, emit) async {
      final barcodes = event.barcodes;
      if (barcodes.isEmpty) return;

      final code = barcodes.first.rawValue;
      if (code == null) return;

      emit(QrScanState.detected(code));

      // TODO: Implement fetching logic as per qr_scan_logic_api.md
      // 1. fetchQrInfo(machine_id)
      // 2. fetchDriverOrderLines(construction_site_id, ...)
      // For now, we just stay in detected state to show UI progress
    });

    on<_ErrorOccurred>((event, emit) {
      emit(QrScanState.error(event.error));
    });

    on<_ResetRequested>((event, emit) {
      emit(const QrScanState.scanning());
    });
  }
}
