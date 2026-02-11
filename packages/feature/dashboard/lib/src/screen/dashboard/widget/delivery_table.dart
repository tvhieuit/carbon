import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

class DeliveryTable extends StatelessWidget {
  final List<OrderEntity> orders;

  const DeliveryTable({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final timeSlots = _generateTimeSlots();
    final groupedOrders = _groupOrders(timeSlots, orders);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.separated(
              itemCount: timeSlots.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final time = timeSlots[index];
                final slotOrders = groupedOrders[time] ?? [];
                return _buildTimeSlotRow(context, time, slotOrders);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          _buildHeaderCell('時間', flex: 1),
          _buildHeaderCell('現場名', flex: 3),
          _buildHeaderCell('商品名', flex: 2),
          _buildHeaderCell('数量', flex: 1, isLast: true),
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

  Widget _buildTimeSlotRow(BuildContext context, String time, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return IntrinsicHeight(
        child: Row(
          children: [
            _buildCell(time, flex: 1, center: true, textStyle: const TextStyle(fontSize: 12)),
            const VerticalDivider(width: 1),
            _buildCell('', flex: 3),
            const VerticalDivider(width: 1),
            _buildCell('', flex: 2),
            const VerticalDivider(width: 1),
            _buildCell('', flex: 1),
          ],
        ),
      );
    }

    return Column(
      children: orders.map((order) {
        final orderLines = order.orderLines;
        final bgColor = _getBgColor(order);
        final showRequiredSign = order.signatureDate == null;

        return IntrinsicHeight(
          child: Container(
            color: bgColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCell(time, flex: 1, center: true, textStyle: const TextStyle(fontSize: 12)),
                const VerticalDivider(width: 1),
                _buildCell(
                  order.constructionSiteName,
                  flex: 3,
                  showRequiredSign: showRequiredSign,
                  companyName: order.companyName,
                ),
                const VerticalDivider(width: 1),
                _buildProductColumn(orderLines, flex: 3),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color? _getBgColor(OrderEntity order) {
    if (order.deliveryStatus == 'キャンセル') {
      return Colors.grey.shade200;
    }
    if (order.receiptFileId != null || order.deliveryStatus == '納品済') {
      return const Color(0xFFE8F5E9);
    }
    try {
      final now = DateTime.now();
      final toTimeParts = order.refuelingToTime.split(':');
      if (toTimeParts.length == 2) {
        final toTime = DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(toTimeParts[0]),
          int.parse(toTimeParts[1]),
        );
        if (now.isAfter(toTime)) {
          return const Color(0xFFFFF3E0);
        }
      }
    } catch (_) {}
    return null;
  }

  Widget _buildProductColumn(List<OrderLineEntity> lines, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Column(
        children: lines.isEmpty
            ? [
                Row(
                  children: [
                    _buildCell('', flex: 2),
                    const VerticalDivider(width: 1),
                    _buildCell('', flex: 1),
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
                      _buildCell(line.productName ?? '', flex: 2),
                      const VerticalDivider(width: 1),
                      _buildCell(
                        '${line.quantity?.toInt()}',
                        flex: 1,
                        alignRight: true,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildCell(
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
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
              TextSpan(text: text),
              if (showRequiredSign)
                const TextSpan(
                  text: '(要サイン)',
                  style: TextStyle(color: Colors.red, fontSize: 11),
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
      // Logic: map refuelingFromTime to nearest slot
      final hour = order.refuelingFromTime.split(':').first;
      final slotKey = '${hour.padLeft(2, '0')}:00';
      if (slots.contains(slotKey)) {
        map.putIfAbsent(slotKey, () => []).add(order);
      }
    }
    return map;
  }
}
