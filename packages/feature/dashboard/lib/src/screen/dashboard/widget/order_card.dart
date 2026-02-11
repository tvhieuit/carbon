import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to order detail
          // context.router.push(OrderDetailRoute(order: order));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildLeading(),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTitle()),
                  _buildTrailing(),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.local_shipping,
        color: Colors.blue,
        size: 20,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          order.companyName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          order.constructionSiteName,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Refueling: ${order.refuelingDate}',
          style: const TextStyle(fontSize: 13),
        ),
        Text(
          'Time: ${order.refuelingFromTime} - ${order.refuelingToTime}',
          style: const TextStyle(fontSize: 13),
        ),
        if (order.orderLines.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          ...order.orderLines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(line.productName ?? 'Unknown Product', style: const TextStyle(fontSize: 12)),
                  Text('${line.quantity ?? 0} L', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing() {
    final statusColor = _getStatusColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        order.deliveryStatus,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (order.deliveryStatus == 'キャンセル') {
      return Colors.grey;
    }
    if (order.receiptFileId != null || order.deliveryStatus == '納品済') {
      return Colors.green;
    }

    // Check if overdue
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
        if (now.isAfter(toTime) && order.deliveryStatus != '納品済') {
          return Colors.orange;
        }
      }
    } catch (_) {
      // Ignore parsing errors
    }

    return Colors.white; // Pending or future
  }
}
