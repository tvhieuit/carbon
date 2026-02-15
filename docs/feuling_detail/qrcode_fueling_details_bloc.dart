import 'dart:async';
import 'dart:io';

import 'package:codebase/controller/delivery_creation_controller.dart';
import 'package:codebase/core/dependency_injection/dependency_injection.dart';
import 'package:codebase/data/local/realm/realm_service.dart';
import 'package:codebase/entities/delivery_order.dart';
import 'package:codebase/feature/app/app_bloc.dart';
import 'package:codebase/feature/app/app_event.dart';
import 'package:codebase/repository/repository.dart';
import 'package:codebase/util/file_util.dart';
import 'package:codebase/util/printer_service.dart';
import 'package:codebase/widget/loading.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../../../core/navigator/app_navigator.dart';
import '../../../core/navigator/app_router.dart';
import 'qrcode_fueling_details_event.dart';
import 'qrcode_fueling_details_state.dart';

class QrCodeFuelingDetailsBloc
    extends Bloc<QrCodeFuelingDetailsEvent, QrCodeFuelingDetailsState> {
  final DeliveryCreationController _deliveryCreationController;
  final AppBloc? _appBloc;
  late DeliveryOrder updatedDeliveryOrder;
  List<Map<String, dynamic>>? signaturePoints;
  String? _receiptId;
  String? _orderId;
  QrCodeFuelingDetailsState? _previousState;
  final _realm = LocalStorageService();

  QrCodeFuelingDetailsBloc({
    Repository? repository,
    DeliveryCreationController? deliveryCreationController,
    AppBloc? appBloc,
  })  : _deliveryCreationController =
            deliveryCreationController ?? locator<DeliveryCreationController>(),
        _appBloc = appBloc,
        super(const FuelingDetailsInitial()) {
    on(_onInitialized);
    on(_onRefreshed);
    // on<ReceiptCaptured>(_onReceiptCaptured);
    on(_onOrderSubmitted);
    // on<ReceiptCaptureCompleted>(_onReceiptCaptureCompleted);
    on(_onUpdateReceiptFileId);
    on(_onPrintReceipt);
    on(_onSetLoading);
    on(_onUpdateOrderSignature);
  }

  /// Xử lý sự kiện khởi tạo
  Future<void> _onInitialized(
    QrCodeFuelingDetailsInitialized event,
    emit,
  ) async {
    if (_appBloc?.state.deliveryOrder != null) {
      final deliveryOrder = _appBloc!.state.deliveryOrder!;
      updatedDeliveryOrder = deliveryOrder.copyWith(
        personIncharge: _appBloc!.state.user?.name,
      );
      final isDelivered = deliveryOrder.isDelivered;
      if (isDelivered) {
        _orderId = deliveryOrder.orderId;
        _receiptId = deliveryOrder.receiptId;
      }

      // Fetch the signature URL if this is a delivered order with a signature ID
      // KEY: If signature exists on server → URL will be fetched successfully
      //      If signature is NEW/LOCAL (not synced) → URL fetch will fail → signatureUrl = null
      String? signatureUrl;
      if (isDelivered && deliveryOrder.receiptSignatureId != null) {
        try {
          signatureUrl =
              await _getSignatureUrl(deliveryOrder.receiptSignatureId!);

          if (signatureUrl != null) {
            final downloadedFile =
                await FileUtil.downloadImageWithDio(signatureUrl);
            if (downloadedFile != null) {
              // Save to documents directory with signatureId as filename
              final directory = await getApplicationDocumentsDirectory();
              final targetPath = path.join(
                  directory.path, "signature_${deliveryOrder.orderId!}.png");

              // Copy file to documents with proper name
              await downloadedFile.copy(targetPath);
            }
          }
        } catch (e) {
          signatureUrl = null; // Ensure null on error
        }
      }
      final hasSignature = deliveryOrder.receiptSignatureId != null;
      final hasReceiptFile = deliveryOrder.receiptFileId != null;
      final isSignatureSynced = hasSignature &&
          signatureUrl != null; // Can fetch URL = exists on server
      final canPrint = isDelivered && isSignatureSynced && hasReceiptFile;

      final newState = FuelingDetailsLoaded(
        deliveryOrder: deliveryOrder,
        isSubmitEnabled: !isDelivered,
        isPrintEnabled: canPrint,
        signatureUrl: signatureUrl,
      );

      emit(newState);
    }
  }

  Future<String?> _getSignatureUrl(String signatureId) async {
    try {
      final fileUrlResponse = await FileUtil.generateFileUrl(signatureId);
      if (fileUrlResponse.signedUrl == null &&
          fileUrlResponse.unsignedUrl == null) {
        return null;
      }

      // Prefer signed URL if available, otherwise use unsigned URL
      return fileUrlResponse.signedUrl ?? fileUrlResponse.unsignedUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> _onRefreshed(
    FuelingDetailsRefreshed event,
    emit,
  ) async {
    if (_appBloc?.state.deliveryOrder != null &&
        state is FuelingDetailsLoaded) {
      final currentState = state as FuelingDetailsLoaded;
      final deliveryOrder = _appBloc!.state.deliveryOrder!;

      updatedDeliveryOrder = deliveryOrder.copyWith(
        personIncharge: _appBloc!.state.user?.name,
      );
      final isDelivered = deliveryOrder.isDelivered;
      if (isDelivered) {
        _orderId = deliveryOrder.orderId;
        _receiptId = deliveryOrder.receiptId;
      }
      final hasSignature = deliveryOrder.receiptSignatureId != null;
      final hasReceiptFile = deliveryOrder.receiptFileId != null;
      final isSignatureSynced =
          hasSignature && currentState.signatureUrl != null;
      final canPrint = isDelivered && isSignatureSynced && hasReceiptFile;
      emit(FuelingDetailsLoaded(
        deliveryOrder: deliveryOrder,
        isSubmitEnabled: !isDelivered,
        isPrintEnabled: canPrint,
        signatureUrl: currentState.signatureUrl, // Preserve existing URL
      ));
    }
  }

  Future<void> _onOrderSubmitted(
    OrderSubmitted event,
    emit,
  ) async {
    try {
      AppLoading.show();
      add(const SetLoadingEvent(isLoading: true));
      DeliveryOrder currentDeliveryOrder = event.deliveryOrder;
      String localId = await _realm.saveDeliveryOrder(
        currentDeliveryOrder,
        isSubmitted: false,
      );
      final connectivityResult = await Connectivity().checkConnectivity();
      final hasConnectivity = connectivityResult.isNotEmpty;
      if (!hasConnectivity) {
        await _realm.updateSubmissionStatus(
          localId,
          isSubmitted: false,
          errorMessage: 'インターネット接続なし',
        );

        add(const SetLoadingEvent(isLoading: false));
        emit(FuelingDetailsError(
          message:
              'ネットワーク接続がありません。注文はローカルに保存されています。注文リスト画面でネットワーク接続が確立されたら再送信してください。',
        ));
        return;
      }
      final directory = await getApplicationDocumentsDirectory();
      final signatureImagePath = path.join(
          directory.path, "signature_${currentDeliveryOrder.orderId!}.png");
      final file = File(signatureImagePath);
      if (await file.exists()) {
        var fileResponse = await FileUtil.uploadFile(file);
        if (fileResponse != null && fileResponse.id != null) {
          updatedDeliveryOrder = currentDeliveryOrder.copyWith(
            receiptSignatureId: fileResponse.id,
          );
        }
      }

      final response =
          await _deliveryCreationController.postOrder(updatedDeliveryOrder);
      if (response.receiptNumber != null) {
        _orderId = response.orderId;
        _receiptId = response.id;
        updatedDeliveryOrder = currentDeliveryOrder.copyWith(
          receiptNumber: response.receiptNumber,
        );

        final machineIds = updatedDeliveryOrder.constructionMachines
            .map((e) => e.id)
            .nonNulls
            .toList();
        _realm.updateSynced(
          updatedDeliveryOrder.orderId,
          machineIds,
        );

        add(const SetLoadingEvent(isLoading: false));
        emit(FuelingDetailsSubmitSuccess(
          orderNumber: response.orderId ?? '',
          receiptNumber: response.receiptNumber ?? '',
          receiptImagePath: '',
          deliveryOrder: updatedDeliveryOrder,
        ));
      } else {
        throw Exception('Failed to submit order: ${response.msg}');
      }
    } catch (e) {
      add(const SetLoadingEvent(isLoading: false));
      emit(FuelingDetailsError(
        message: 'オーダーの送信中にエラーが発生しました',
        exception: e is Exception ? e : Exception(e.toString()),
      ));
    } finally {
      AppLoading.dismiss();
    }
  }

  Future<void> _onPrintReceipt(
    PrintReceipt event,
    emit,
  ) async {
    if (state is FuelingDetailsLoaded) {
      final currentState = state as FuelingDetailsLoaded;
      try {
        double totalMachineryQuantity = updatedDeliveryOrder
            .constructionMachines
            .fold(0.0, (sum, item) => sum + item.productQuantity);
        updatedDeliveryOrder = updatedDeliveryOrder.copyWith(
            personIncharge: _appBloc!.state.user?.name,
            totalOil: double.parse(totalMachineryQuantity.toStringAsFixed(2)));

        final result =
            await PrinterService.printDeliveryOrder(updatedDeliveryOrder);
        await _handlePrintResult(result, emit);
        return;
      } catch (e) {
        emit(FuelingDetailsPrintError(
          message: 'Error printing receipt: $e',
        ));
        emit(currentState.copyWith());
      }
    }
  }

  Future<void> _handlePrintResult(dynamic result, emit) async {
    if (result is Map) {
      final success = result['success'] as bool?;
      final message = result['message'] as String?;

      if (success == true) {
        emit(FuelingDetailsPrintSuccess(
          message: message ?? 'Print success',
        ));
        await Future.delayed(const Duration(milliseconds: 500));
        _navigateToDashboard();
      } else {
        await PrinterService.openPrinterSetup();
        if (state is FuelingDetailsLoaded) {
          final currentState = state as FuelingDetailsLoaded;
          emit(FuelingDetailsPrintError(
            message: message ?? 'Print failed',
          ));

          emit(currentState.copyWith());
        } else {
          emit(FuelingDetailsPrintError(
            message: message ?? 'Print failed',
          ));
        }
      }
    } else {
      emit(FuelingDetailsPrintSuccess(
        message: 'Print success',
      ));
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    if (_appBloc != null) {
      _appBloc!.add(RefreshDashboard());
    }
    AppNavigator.goOffAllNamed(AppRoutes.dashboard);
  }

  Future<void> _onUpdateReceiptFileId(
    UpdateReceiptFileId event,
    emit,
  ) async {
    if (_orderId == null || _receiptId == null) {
      emit(FuelingDetailsError(
        message: 'Missing orderId or receiptId for update',
      ));
      return;
    }
    add(const SetLoadingEvent(isLoading: true));
    try {
      AppLoading.show();
      await _deliveryCreationController.updateReceiptFile(
        _orderId!,
        _receiptId!,
        event.receiptFileId,
      );
      String? existingSignatureUrl;
      if (state is FuelingDetailsSubmitSuccess) {
        final currentState = state as FuelingDetailsSubmitSuccess;
        updatedDeliveryOrder = currentState.deliveryOrder.copyWith(
          receiptFileId: event.receiptFileId,
        );
      } else if (state is FuelingDetailsLoaded) {
        final currentState = state as FuelingDetailsLoaded;
        existingSignatureUrl = currentState.signatureUrl; // Preserve URL
        updatedDeliveryOrder = currentState.deliveryOrder!.copyWith(
          receiptFileId: event.receiptFileId,
        );
      }
      if (_appBloc != null) {
        _appBloc!.add(UpdateDeliveryOrder(updatedDeliveryOrder));
      }
      add(const SetLoadingEvent(isLoading: false));
      emit(FuelingDetailsLoaded(
        deliveryOrder: updatedDeliveryOrder,
        isSubmitting: false,
        isSubmitEnabled: false,
        isPrintEnabled: true,
        // Now user can print
        signatureUrl: existingSignatureUrl, // Keep signature URL
      ));
    } catch (e) {
      add(const SetLoadingEvent(isLoading: false));
      emit(FuelingDetailsError(
        message: 'Failed to update receipt file: $e',
      ));
    } finally {
      AppLoading.dismiss();
    }
  }

  void _onSetLoading(SetLoadingEvent event, emit) {
    if (event.isLoading) {
      _previousState = state;
      emit(const FuelingDetailsLoadingState());
    } else if (state is FuelingDetailsLoadingState && _previousState != null) {
      emit(_previousState!);
      _previousState = null;
    }
  }

  Future<void> _onUpdateOrderSignature(
    UpdateOrderSignature event,
    emit,
  ) async {
    final savedState = state;

    try {
      add(const SetLoadingEvent(isLoading: true));
      final response = await _deliveryCreationController.updateReceiptSignature(
        event.orderId,
        event.receiptId,
        event.signatureId,
      );
      _orderId = event.orderId;
      _receiptId = event.receiptId;
      if (savedState is FuelingDetailsLoaded) {
        updatedDeliveryOrder = savedState.deliveryOrder!.copyWith(
          receiptSignatureId: event.signatureId,
          receiptNumber:
              response.receiptNumber, // CRITICAL: Save receiptNumber from API
        );
        if (_appBloc != null) {
          _appBloc!.add(UpdateDeliveryOrder(updatedDeliveryOrder));
        }
        String? newSignatureUrl;
        try {
          newSignatureUrl = await _getSignatureUrl(event.signatureId);
        } catch (e) {
          newSignatureUrl = savedState.signatureUrl;
        }
        add(const SetLoadingEvent(isLoading: false));
        emit(FuelingDetailsLoaded(
          deliveryOrder: updatedDeliveryOrder,
          isSubmitEnabled: false,
          isPrintEnabled:
              false, // Will be enabled after receipt file is updated
          signatureUrl: newSignatureUrl, // Use new or fallback signature URL
        ));
      } else {
        add(const SetLoadingEvent(isLoading: false));
      }
    } catch (e) {
      add(const SetLoadingEvent(isLoading: false));
      emit(FuelingDetailsError(
        message: 'Failed to update signature: ${e.toString()}',
        exception: e is Exception ? e : Exception(e.toString()),
      ));
    }
  }
}
