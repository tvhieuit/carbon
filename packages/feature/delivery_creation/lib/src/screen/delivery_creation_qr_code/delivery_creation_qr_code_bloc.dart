import 'package:app_core/app_core.dart';
import 'package:app_widget/app_widget.dart';
import 'package:domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:use_cases/use_cases.dart';
import '../../use_case/use_cases.dart' as feature_use_cases;

part 'delivery_creation_qr_code_event.dart';
part 'delivery_creation_qr_code_state.dart';
part 'delivery_creation_qr_code_bloc.freezed.dart';

@injectable
class DeliveryCreationQrCodeBloc extends Bloc<DeliveryCreationQrCodeEvent, DeliveryCreationQrCodeState> {
  final feature_use_cases.GetOrderMachinesUseCase _getOrderMachinesUseCase;
  final feature_use_cases.GetOrderProductsUseCase _getOrderProductsUseCase;
  final feature_use_cases.SubmitDeliveryOrderUseCase _submitDeliveryOrderUseCase;
  final GetOrderDetailUseCase _getOrderDetailUseCase;
  final AppToast _appToast;

  DeliveryCreationQrCodeBloc(
    this._getOrderMachinesUseCase,
    this._getOrderProductsUseCase,
    this._submitDeliveryOrderUseCase,
    this._getOrderDetailUseCase,
    this._appToast,
  ) : super(DeliveryCreationQrCodeState.initial()) {
    on<_Init>(_onInit);
    on<_AddMachinery>(_onAddMachinery);
    on<_UpdateQuantity>(_onUpdateQuantity);
    on<_UpdateProductQuantity>(_onUpdateProductQuantity);
    on<_RemoveMachinery>(_onRemoveMachinery);
    on<_Submit>(_onSubmit);
  }

  Future<void> _onInit(_Init event, Emitter<DeliveryCreationQrCodeState> emit) async {
    emit(state.copyWith(isLoading: true, orderId: event.orderId, orderLineId: event.orderLineId));

    try {
      // Fetch Order Details
      final orderResult = await _getOrderDetailUseCase(event.orderId);
      final order = orderResult.dataOrNull;
      if (orderResult.isFailure) {
        emit(state.copyWith(error: orderResult.failureOrNull?.message));
      }

      // Fetch Machines
      final machinesResult = await _getOrderMachinesUseCase(event.orderId);
      final machines = machinesResult.dataOrNull ?? [];
      if (machinesResult.isFailure) {
        emit(state.copyWith(error: machinesResult.failureOrNull?.message));
      }

      // Fetch Products (Receipt Lines)
      final productsResult = await _getOrderProductsUseCase(
        feature_use_cases.GetOrderProductsParams(orderId: event.orderId, orderLineId: event.orderLineId),
      );
      final receiptLines =
          productsResult.dataOrNull
              ?.map((e) => ReceiptLineEntity(productId: e.productId, productName: e.productName))
              .toList() ??
          [];
      if (productsResult.isFailure) {
        emit(state.copyWith(error: productsResult.failureOrNull?.message));
      }

      emit(
        state.copyWith(
          isLoading: false,
          order: order,
          machines: machines,
          receiptLines: receiptLines,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void _onAddMachinery(_AddMachinery event, Emitter<DeliveryCreationQrCodeState> emit) {
    emit(
      state.copyWith(
        machines: [...state.machines, event.machinery],
      ),
    );
  }

  void _onUpdateQuantity(_UpdateQuantity event, Emitter<DeliveryCreationQrCodeState> emit) {
    final updatedMachines = state.machines.map((m) {
      if (m.machineId == event.machineId) {
        return MachineryItemEntity(
          machineId: m.machineId,
          machineryName: m.machineryName,
          vehicleNumber: m.vehicleNumber,
          quantity: event.quantity,
          images: m.images,
          productId: m.productId,
        );
      }
      return m;
    }).toList();
    emit(state.copyWith(machines: updatedMachines));
  }

  void _onUpdateProductQuantity(_UpdateProductQuantity event, Emitter<DeliveryCreationQrCodeState> emit) {
    final updatedLines = state.receiptLines.map((line) {
      if (line.productId == event.productId) {
        return ReceiptLineEntity(
          productId: line.productId,
          productName: line.productName,
          quantity: event.quantity,
        );
      }
      return line;
    }).toList();
    emit(state.copyWith(receiptLines: updatedLines));
  }

  void _onRemoveMachinery(_RemoveMachinery event, Emitter<DeliveryCreationQrCodeState> emit) {
    emit(
      state.copyWith(
        machines: state.machines.where((m) => m.machineId != event.machineId).toList(),
      ),
    );
  }

  Future<void> _onSubmit(_Submit event, Emitter<DeliveryCreationQrCodeState> emit) async {
    if (state.orderId == null || state.orderLineId == null) return;

    emit(state.copyWith(isSubmitting: true));

    final deliveryOrder = DeliveryOrderEntity(
      orderId: state.orderId!,
      orderLineId: state.orderLineId!,
      constructionSiteId: state.order?.constructionSiteName ?? '',
      constructionMachines: state.machines,
      receiptLines: state.receiptLines,
    );

    final result = await _submitDeliveryOrderUseCase(deliveryOrder);

    if (result.isSuccess) {
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
      _appToast.success('納品処理が完了しました');
    } else {
      final message = result.failure?.message ?? '納品処理に失敗しました';
      emit(state.copyWith(isSubmitting: false, error: message));
      _appToast.error(message);
    }
  }
}
