import 'package:app_core/app_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:use_cases/use_cases.dart';
import 'package:intl/intl.dart';

part 'qr_scan_event.dart';
part 'qr_scan_state.dart';
part 'qr_scan_bloc.freezed.dart';

@injectable
class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  final FetchQrInfoUseCase _fetchQrInfoUseCase;
  final FetchDriverOrderLinesUseCase _fetchDriverOrderLinesUseCase;
  final GetMeUseCase _getMeUseCase;

  QrScanBloc(
    this._fetchQrInfoUseCase,
    this._fetchDriverOrderLinesUseCase,
    this._getMeUseCase,
  ) : super(const QrScanState.initial()) {

    on<_QrCodeDetected>((event, emit) async {
      final barcodes = event.barcodes;
      if (barcodes.isEmpty) return;

      final code = barcodes.first.rawValue;
      if (code == null) return;

      emit(QrScanState.detected(code));

      // 1. Fetch QR Info
      final qrInfoResult = await _fetchQrInfoUseCase(code);
      if (qrInfoResult.isFailure) {
        emit(
          QrScanState.error(
            qrInfoResult.failure?.message ?? 'Failed to fetch QR info',
            errorCode: 'API_ERROR',
          ),
        );
        return;
      }

      final qrInfo = qrInfoResult.data!;

      // 2. Get Current User (Driver)
      final meResult = await _getMeUseCase();
      if (meResult.isFailure) {
        emit(
          QrScanState.error(
            meResult.failure?.message ?? 'Failed to get user info',
            errorCode: 'AUTH_ERROR',
          ),
        );
        return;
      }

      final driverId = meResult.data!.userDetail.id;

      // 3. Fetch Driver Order Lines
      final refuelingDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final orderLinesResult = await _fetchDriverOrderLinesUseCase(
        FetchDriverOrderLinesParams(
          page: 1,
          pageSize: 100,
          refuelingDate: refuelingDate,
          constructionSiteId: qrInfo.constructionSiteId,
          shippingDriverId: driverId,
        ),
      );

      if (orderLinesResult.isFailure) {
        emit(
          QrScanState.error(
            orderLinesResult.failure?.message ?? 'Failed to fetch order lines',
            errorCode: 'API_ERROR',
          ),
        );
        return;
      }

      // TODO: Navigate to delivery screen or show success state with order lines
      // For now, we stay in detected state but could emit success
      // emit(QrScanState.success(qrInfo, orderLinesResult.data!));
    });

    on<_ErrorOccurred>((event, emit) {
      emit(
        QrScanState.error(
          event.error.errorDetails?.message ?? 'Camera error',
          errorCode: event.error.errorCode.name,
        ),
      );
    });

    on<_ResetRequested>((event, emit) {
      emit(const QrScanState.scanning());
    });
  }
}
