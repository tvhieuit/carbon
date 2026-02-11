import 'package:domain/domain.dart';
import 'package:feature_dashboard/src/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DeliveryTable extends StatelessWidget {
  final List<OrderEntity> orders;

  const DeliveryTable({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    final groupedOrders = _groupOrders(timeSlots, orders);
    final l10n = context.dashboardL10n;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFCECECE)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildHeader(l10n),
          Expanded(
            child: ListView.separated(
              itemCount: timeSlots.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFCECECE)),
              itemBuilder: (context, index) {
                final time = timeSlots[index];
                final slotOrders = groupedOrders[time] ?? [];
                return _buildTimeSlotRow(context, l10n, time, slotOrders);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(DashboardLocalizations l10n) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell(l10n.time, flex: 1),
          _buildHeaderCell(l10n.siteName, flex: 3),
          _buildHeaderCell(l10n.productName, flex: 2),
          _buildHeaderCell(l10n.quantity, flex: 1, isLast: true),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label, {required int flex, bool isLast = false}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildTimeSlotRow(BuildContext context, DashboardLocalizations l10n, String time, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return IntrinsicHeight(
        child: Row(
          children: [
            _buildCell(
              l10n,
              time,
              flex: 1,
              center: true,
              textStyle: const TextStyle(fontSize: 12, color: Colors.black),
            ),
            const VerticalDivider(width: 1),
            _buildCell(l10n, '', flex: 3),
            const VerticalDivider(width: 1),
            _buildCell(l10n, '', flex: 2),
            const VerticalDivider(width: 1),
            _buildCell(l10n, '', flex: 1),
          ],
        ),
      );
    }

    return Column(
      children: orders.map((order) {
        final orderLines = order.orderLines;
        final bgColor = _getBgColor(l10n, order);
        final showRequiredSign = order.signatureDate == null;

        return IntrinsicHeight(
          child: Container(
            color: bgColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCell(
                  l10n,
                  time,
                  flex: 1,
                  center: true,
                  textStyle: const TextStyle(fontSize: 12, color: Colors.black),
                ),
                const VerticalDivider(width: 1),
                _buildCell(
                  l10n,
                  order.constructionSiteName,
                  flex: 3,
                  showRequiredSign: showRequiredSign,
                  companyName: order.companyName,
                  textStyle: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                ),
                const VerticalDivider(width: 1),
                _buildProductColumn(l10n, orderLines, flex: 3),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color? _getBgColor(DashboardLocalizations l10n, OrderEntity order) {
    if (order.deliveryStatus == l10n.statusCancelled) {
      return Colors.grey.shade300;
    }
    if (order.receiptFileId != null || order.deliveryStatus == l10n.statusDelivered) {
      return Colors.green.shade50;
    }
    try {
      final now = DateTime.now();
      final toTimeParts = order.refuelingToTime.split(':');
      if (toTimeParts.length >= 2) {
        final toTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(toTimeParts[0]),
          int.parse(toTimeParts[1]),
        );
        if (now.isAfter(toTime)) {
          return Colors.orange.shade100;
        }
      }
    } catch (_) {}
    return null;
  }

  Widget _buildProductColumn(DashboardLocalizations l10n, List<OrderLineEntity> lines, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Column(
        children: lines.isEmpty
            ? [
                Row(
                  children: [
                    _buildCell(l10n, '', flex: 2),
                    const VerticalDivider(width: 1),
                    _buildCell(l10n, '', flex: 1),
                  ],
                ),
              ]
            : lines.asMap().entries.map((entry) {
                final line = entry.value;
                final isLast = entry.key == lines.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Row(
                    children: [
                      _buildCell(
                        l10n,
                        line.productName ?? '-',
                        flex: 2,
                        textStyle: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                      ),
                      const VerticalDivider(width: 1),
                      _buildCell(
                        l10n,
                        line.quantity != null ? '${line.quantity!.toInt()}' : l10n.onSiteConfirmation,
                        flex: 1,
                        alignRight: true,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildCell(
    DashboardLocalizations l10n,
    String text, {
    required int flex,
    bool center = false,
    bool alignRight = false,
    TextStyle? textStyle,
    bool showRequiredSign = false,
    String? companyName,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        alignment: alignRight ? Alignment.centerRight : (center ? Alignment.center : Alignment.centerLeft),
        child: RichText(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            style: textStyle ?? const TextStyle(color: Colors.black, fontSize: 13, height: 1.2),
            children: [
              if (companyName != null) ...[
                TextSpan(
                  text: '$companyName\n',
                  style: const TextStyle(fontSize: 11, color: Colors.black),
                ),
              ],
              TextSpan(text: text),
              if (showRequiredSign)
                TextSpan(
                  text: l10n.requiredSignature,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _generateTimeSlots() {
    return List.generate(14, (index) {
      final hour = index + 7;
      return '${hour.toString().padLeft(2, '0')}:00';
    });
  }

  Map<String, List<OrderEntity>> _groupOrders(List<String> slots, List<OrderEntity> orders) {
    final map = <String, List<OrderEntity>>{};
    for (var order in orders) {
      // Logic: map refuelingFromTime (HH:mm:ss) to nearest slot (HH:00)
      final hour = order.refuelingFromTime.split(':').first;
      final slotKey = '${hour.padLeft(2, '0')}:00';
      if (slots.contains(slotKey)) {
        map.putIfAbsent(slotKey, () => []).add(order);
      }
    }
    return map;
  }
}
