import 'package:app_core/app_core.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../use_case/use_cases.dart';

part 'fueling_details_event.dart';
part 'fueling_details_state.dart';
part 'fueling_details_bloc.freezed.dart';

@injectable
class FuelingDetailsBloc
    extends Bloc<FuelingDetailsEvent, FuelingDetailsState> {
  final SubmitFuelingOrderUseCase _submitOrderUseCase;
  final UploadFileUseCase _uploadFileUseCase;
  final GetFileUrlUseCase _getFileUrlUseCase;
  final UpdateReceiptSignatureUseCase _updateReceiptSignatureUseCase;
  final UpdateReceiptFileUseCase _updateReceiptFileUseCase;
  final AppToast _appToast;

  FuelingDetailsBloc(
    this._submitOrderUseCase,
    this._uploadFileUseCase,
    this._getFileUrlUseCase,
    this._updateReceiptSignatureUseCase,
    this._updateReceiptFileUseCase,
    this._appToast,
  ) : super(FuelingDetailsState.initial()) {
    on<_Initialized>(_onInitialized);
    on<_Refreshed>(_onRefreshed);
    on<_OrderSubmitted>(_onOrderSubmitted);
    on<_ReceiptFileUpdated>(_onReceiptFileUpdated);
    on<_SignatureUpdated>(_onSignatureUpdated);
    on<_PrintRequested>(_onPrintRequested);
  }

  Future<void> _onInitialized(
    _Initialized event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      orderId: event.orderId,
    ));

    // TODO: Load delivery order data from repository/AppBloc
    // For now, emit loaded state
    emit(state.copyWith(
      isLoading: false,
    ));
  }

  Future<void> _onRefreshed(
    _Refreshed event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    // Refresh current state from latest data
    if (state.deliveryOrder == null) return;

    final deliveryOrder = state.deliveryOrder!;
    final isDelivered = state.receiptNumber != null;
    final hasSignature = deliveryOrder.constructionSiteId.isNotEmpty;
    final hasReceiptFile = state.isPrintEnabled;

    emit(state.copyWith(
      isSubmitEnabled: !isDelivered,
      isPrintEnabled: hasReceiptFile,
    ));
  }

  Future<void> _onOrderSubmitted(
    _OrderSubmitted event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    // Step 1: Upload signature file
    final uploadResult =
        await _uploadFileUseCase(event.signatureFilePath);

    String? signatureFileId;
    if (uploadResult.isSuccess) {
      signatureFileId = uploadResult.dataOrNull;
    }

    // Step 2: Submit the order
    final result = await _submitOrderUseCase(event.deliveryOrder);

    if (result.isSuccess && result.dataOrNull != null) {
      final submitResult = result.dataOrNull!;
      emit(state.copyWith(
        isSubmitting: false,
        isSubmitSuccess: true,
        isSubmitEnabled: false,
        orderId: submitResult.orderId,
        receiptId: submitResult.receiptId,
        receiptNumber: submitResult.receiptNumber,
        deliveryOrder: event.deliveryOrder,
        successMessage: submitResult.receiptNumber,
      ));
    } else {
      final message = result.failure?.message ?? 'Failed to submit order';
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: message,
      ));
      _appToast.error(message);
    }
  }

  Future<void> _onReceiptFileUpdated(
    _ReceiptFileUpdated event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    if (state.orderId == null || state.receiptId == null) {
      emit(state.copyWith(
        errorMessage: 'Missing orderId or receiptId',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true));

    final result = await _updateReceiptFileUseCase(
      UpdateReceiptFileParams(
        orderId: state.orderId!,
        receiptId: state.receiptId!,
        fileId: event.receiptFileId,
      ),
    );

    if (result.isSuccess) {
      emit(state.copyWith(
        isLoading: false,
        isPrintEnabled: true,
      ));
    } else {
      final message =
          result.failure?.message ?? 'Failed to update receipt file';
      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));
      _appToast.error(message);
    }
  }

  Future<void> _onSignatureUpdated(
    _SignatureUpdated event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _updateReceiptSignatureUseCase(
      UpdateReceiptSignatureParams(
        orderId: event.orderId,
        receiptId: event.receiptId,
        signatureId: event.signatureId,
      ),
    );

    if (result.isSuccess) {
      // Try to fetch the new signature URL
      String? signatureUrl;
      final urlResult = await _getFileUrlUseCase(event.signatureId);
      if (urlResult.isSuccess) {
        signatureUrl = urlResult.dataOrNull;
      }

      emit(state.copyWith(
        isLoading: false,
        orderId: event.orderId,
        receiptId: event.receiptId,
        signatureUrl: signatureUrl,
        receiptNumber: result.dataOrNull?.receiptNumber,
      ));
    } else {
      final message =
          result.failure?.message ?? 'Failed to update signature';
      emit(state.copyWith(
        isLoading: false,
        errorMessage: message,
      ));
      _appToast.error(message);
    }
  }

  Future<void> _onPrintRequested(
    _PrintRequested event,
    Emitter<FuelingDetailsState> emit,
  ) async {
    // TODO: Implement print via PrinterService
    _appToast.success('Print started');
  }
}
