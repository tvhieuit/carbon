import 'package:app_widget/app_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../bloc/delivery_creation_qr_code_bloc.dart';
import '../l10n/l10n.dart';
import 'add_machinery_dialog.dart';

@RoutePage()
class DeliveryCreationQrCodePage extends StatelessWidget {
  final String orderId;
  final String orderLineId;

  const DeliveryCreationQrCodePage({
    super.key,
    @pathParam required this.orderId,
    @pathParam required this.orderLineId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<DeliveryCreationQrCodeBloc>()
        ..add(
          DeliveryCreationQrCodeEvent.init(
            orderId: orderId,
            orderLineId: orderLineId,
          ),
        ),
      child: const _DeliveryCreationQrCodeView(),
    );
  }
}

class _DeliveryCreationQrCodeView extends StatelessWidget {
  const _DeliveryCreationQrCodeView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCreationQrCodeBloc, DeliveryCreationQrCodeState>(
      listener: (context, state) {
        if (state.isSuccess) {
          // TODO: Navigate to fuelingDetailQrcode
          // final appRoute = GetIt.instance<AppRoute>();
          // context.router.push(appRoute.fuelingDetailQrcode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.deliveryCreationL10n.delivery_creation_title),
            automaticallyImplyLeading: !state.isSubmitting,
          ),
          body: Stack(
            children: [
              _buildContent(context, state),
              if (state.isSubmitting) const AppLoadingView(isOverlay: true, message: '納品処理中...'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DeliveryCreationQrCodeState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(context, state),
          const SizedBox(height: 24),
          _buildMachineryTable(context, state),
          const SizedBox(height: 24),
          _buildNonOilProductsSection(context, state),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: state.isSubmitting
                  ? null
                  : () {
                      context.read<DeliveryCreationQrCodeBloc>().add(const DeliveryCreationQrCodeEvent.submit());
                    },
              child: Text(context.deliveryCreationL10n.submit_button),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context, DeliveryCreationQrCodeState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _InfoRow(label: context.deliveryCreationL10n.construction_site_name_label, value: 'Site Name Place Holder'),
            _InfoRow(label: context.deliveryCreationL10n.person_in_charge_label, value: 'Person Place Holder'),
            _InfoRow(label: context.deliveryCreationL10n.contact_phone_label, value: 'Phone Place Holder'),
          ],
        ),
      ),
    );
  }

  Widget _buildMachineryTable(BuildContext context, DeliveryCreationQrCodeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Machinery Title Place Holder', // e.g. "Dầu Diesel"
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _showAddMachineryDialog(context),
              icon: const Icon(Icons.add),
              label: Text(context.deliveryCreationL10n.add_machinery_button),
            ),
          ],
        ),
        Table(
          columnWidths: const {
            0: FixedColumnWidth(40),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FixedColumnWidth(40),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade200),
              children: [
                _TableCell(text: context.deliveryCreationL10n.machinery_table_image),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_name),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_number),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_quantity),
                const SizedBox.shrink(),
              ],
            ),
            ...state.machines.map(
              (machine) => TableRow(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      machine.images.isNotEmpty ? 'assets/icon/ic_album.svg' : 'assets/icon/ic_no_image.svg',
                      width: 24,
                    ),
                  ),
                  _TableCell(text: machine.machineryName),
                  _TableCell(text: machine.vehicleNumber),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        final quantity = double.tryParse(value);
                        context.read<DeliveryCreationQrCodeBloc>().add(
                          DeliveryCreationQrCodeEvent.updateQuantity(machineId: machine.machineId, quantity: quantity),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset('assets/icon/ic_trash.svg', width: 20),
                    onPressed: () {
                      context.read<DeliveryCreationQrCodeBloc>().add(
                        DeliveryCreationQrCodeEvent.removeMachinery(machineId: machine.machineId),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNonOilProductsSection(BuildContext context, DeliveryCreationQrCodeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ...state.receiptLines.map(
          (line) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(child: Text(line.productName)),
                SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (value) {
                      final quantity = double.tryParse(value);
                      context.read<DeliveryCreationQrCodeBloc>().add(
                        DeliveryCreationQrCodeEvent.updateProductQuantity(
                          productId: line.productId,
                          quantity: quantity,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddMachineryDialog(BuildContext context) {
    final state = context.read<DeliveryCreationQrCodeBloc>().state;
    if (state.orderId == null) return;

    showDialog(
      context: context,
      builder: (_) => AddMachineryDialog(
        orderId: state.orderId!,
        onAdd: (machinery) {
          context.read<DeliveryCreationQrCodeBloc>().add(
            DeliveryCreationQrCodeEvent.addMachinery(machinery: machinery),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;

  const _TableCell({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center),
    );
  }
}
