import 'package:app_widget/app_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

import '../../l10n/l10n.dart';
import '../../models/models.dart';
import 'delivery_creation_qr_code_bloc.dart';
import 'widgets/add_machinery_dialog.dart';

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

    final groupedMachines = state.machinesGroupedByProduct;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfo(context, state),
          const SizedBox(height: 24),
          if (groupedMachines.isEmpty)
            _buildEmptyMachinerySection(context)
          else
            ...groupedMachines.entries.map((entry) => _buildGroupedMachineryTable(context, entry.key, entry.value)),
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
    final order = state.order;
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _InfoRow(
              label: context.deliveryCreationL10n.construction_site_name_label,
              value: order?.constructionSiteName ?? '-',
            ),
            _InfoRow(
              label: context.deliveryCreationL10n.person_in_charge_label,
              value: order?.companyName ?? '-', // Assuming company name for now if person missing
            ),
            const _InfoRow(
              label: 'Phone:', // Placeholder if not in OrderEntity
              value: '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMachinerySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Machinery',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showAddMachineryDialog(context),
              icon: const Icon(Icons.add),
              label: Text(context.deliveryCreationL10n.add_machinery_button),
            ),
          ],
        ),
        const Center(
          child: Padding(padding: EdgeInsets.all(32), child: Text('No machinery items yet.')),
        ),
      ],
    );
  }

  Widget _buildGroupedMachineryTable(BuildContext context, String productName, List<MachineryItemEntity> machines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${context.deliveryCreationL10n.product_name_label}: $productName',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showAddMachineryDialog(context, productName: productName),
              icon: const Icon(Icons.add),
              label: Text(context.deliveryCreationL10n.add_machinery_button),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FixedColumnWidth(60),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(1.5),
            4: FixedColumnWidth(50),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              children: [
                _TableCell(text: context.deliveryCreationL10n.machinery_table_image, isHeader: true),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_name, isHeader: true),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_number, isHeader: true),
                _TableCell(text: context.deliveryCreationL10n.machinery_table_quantity, isHeader: true),
                const SizedBox.shrink(),
              ],
            ),
            ...machines.map(
              (machine) => TableRow(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SvgPicture.asset(
                        machine.images.isNotEmpty ? 'assets/icon/ic_album.svg' : 'assets/icon/ic_no_image.svg',
                        width: 24,
                      ),
                    ),
                  ),
                  _TableCell(text: machine.machineryName),
                  _TableCell(text: machine.vehicleNumber),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController(text: machine.quantity?.toString() ?? ''),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        final quantity = double.tryParse(value);
                        context.read<DeliveryCreationQrCodeBloc>().add(
                          DeliveryCreationQrCodeEvent.updateQuantity(machineId: machine.machineId, quantity: quantity),
                        );
                      },
                    ),
                  ),
                  Center(
                    child: IconButton(
                      icon: SvgPicture.asset('assets/icon/ic_trash.svg', width: 20),
                      onPressed: () {
                        context.read<DeliveryCreationQrCodeBloc>().add(
                          DeliveryCreationQrCodeEvent.removeMachinery(machineId: machine.machineId),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
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

  void _showAddMachineryDialog(BuildContext context, {String? productName}) {
    final state = context.read<DeliveryCreationQrCodeBloc>().state;
    if (state.orderId == null) return;

    showDialog(
      context: context,
      builder: (_) => AddMachineryDialog(
        orderId: state.orderId!,
        productName: productName,
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
  final bool isHeader;

  const _TableCell({required this.text, this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
