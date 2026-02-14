import 'package:app_core/app_core.dart';
import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../l10n/l10n.dart';
import 'order_detail_bloc.dart';

@RoutePage()
class OrderDetailPage extends StatelessWidget implements AutoRouteWrapper {
  final String orderId;

  const OrderDetailPage({
    super.key,
    required this.orderId,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<OrderDetailBloc>()..add(OrderDetailEvent.started(orderId)),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.orderDetailL10n;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          l10n.orderDetailTitle,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AutoLeadingButton(color: Colors.black),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.apiError),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<OrderDetailBloc>().add(const OrderDetailEvent.refreshRequested()),
                    child: Text(l10n.tryAgain),
                  ),
                ],
              ),
            ),
            loaded: (order, me) => _OrderDetailContent(order: order, me: me),
          );
        },
      ),
      bottomNavigationBar: _BottomActions(orderId: orderId),
    );
  }
}

class _OrderDetailContent extends StatelessWidget {
  final OrderEntity order;
  final MeEntity? me;

  const _OrderDetailContent({
    required this.order,
    this.me,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.orderDetailL10n;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryHeader(l10n),
          _buildDeliveryInfoCard(l10n),
          _buildProductSection(l10n),
          _buildLocationSection(l10n),
          _buildNotesSection(l10n),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDeliveryHeader(var l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            l10n.orderDetailTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${l10n.deliveryTime} ${order.refuelingFromTime}-${order.refuelingToTime}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard(var l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          _buildInfoRow(l10n.assignedStoreName, 'Tuan Store'), // Placeholder
          _buildInfoRow(l10n.deliveryStaff, 'Diem Staff'), // Placeholder
          _buildInfoRow(l10n.companyName, order.companyName),
          _buildInfoRow(l10n.branchName, 'longdt store'), // Placeholder
          _buildInfoRow(l10n.constructionSiteName, order.constructionSiteName),
          _buildInfoRow(l10n.personInCharge, ''),
          _buildInfoRow(l10n.phoneNumber, ''),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label :',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(var l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            l10n.productInformation,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        l10n.productName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        l10n.quantity,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ...order.orderLines.map(
                (line) => Column(
                  children: [
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text(line.productName ?? '')),
                          Expanded(
                            flex: 1,
                            child: Text('${line.quantity?.toStringAsFixed(0) ?? "0"} L', textAlign: TextAlign.right),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection(var l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            l10n.constructionSiteAddress,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.noAddressInfo),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'NO_MAP_AVAILABLE',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                Text('Missing coordinates', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(var l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            l10n.remarks,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.noRemarksInfo),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            l10n.caseNotes,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(l10n.noCaseNotesInfo),
        ),
      ],
    );
  }
}

class _BottomActions extends StatelessWidget {
  final String orderId;

  const _BottomActions({required this.orderId});

  @override
  Widget build(BuildContext context) {
    final l10n = context.orderDetailL10n;

    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        return state.maybeWhen(
          loaded: (order, me) {
            final isDelivered = order.deliveryStatus == 'COMPLETED';
            final canStart = order.shippingDriverId == null || order.shippingDriverId == me?.id;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.router.pop(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(l10n.backButton, style: const TextStyle(color: Colors.blue)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canStart
                          ? () {
                              if (isDelivered) {
                                // Navigate to Receipt
                              } else {
                                // Navigate to QR Scan
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canStart ? Colors.blue : Colors.grey[300],
                        foregroundColor: canStart ? Colors.white : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: Text(isDelivered ? l10n.viewReceipt : l10n.startDelivery),
                    ),
                  ),
                ],
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
