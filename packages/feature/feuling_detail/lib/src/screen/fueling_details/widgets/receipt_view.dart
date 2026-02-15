import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import 'signature_painter.dart';

/// Widget for rendering the receipt, used both for print preview and
/// offscreen capture (to create the receipt image uploaded to the server).
class ReceiptView extends StatelessWidget {
  final DeliveryOrderEntity deliveryOrder;
  final List<dynamic>? signaturePoints;
  final String? receiptNumber;
  final String? constructionSiteName;
  final String? personInCharge;

  const ReceiptView({
    super.key,
    required this.deliveryOrder,
    this.signaturePoints,
    this.receiptNumber,
    this.constructionSiteName,
    this.personInCharge,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.feulingDetailL10n;

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, l10n),
          _buildCustomerInfo(l10n),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildMachinerySection(l10n),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildNonOilSection(l10n),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildSignatureSection(l10n),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildFooter(l10n),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, FeulingDetailLocalizations l10n) {
    final now = DateTime.now();
    final year = now.year - 2018;
    final dayOfWeek = _getDayOfWeekL10n(l10n, now.weekday);
    final japaneseDate =
        l10n.reiwa_date_format(year, now.month, now.day, dayOfWeek);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.receipt_title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            japaneseDate,
            style: const TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(FeulingDetailLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildInfoRow('${l10n.receipt_number_label}：', receiptNumber ?? ''),
          _buildInfoRow(
              '${l10n.customer_name_label}：', constructionSiteName ?? ''),
          _buildInfoRow(
              '${l10n.person_in_charge_label}：', personInCharge ?? ''),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
          Text(value,
              style: const TextStyle(fontSize: 18, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildMachinerySection(FeulingDetailLocalizations l10n) {
    final machines = deliveryOrder.constructionMachines;
    final total =
        machines.fold(0.0, (sum, m) => sum + (m.quantity ?? 0));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...machines.asMap().entries.map((entry) {
            final index = entry.key;
            final machine = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  SizedBox(
                      width: 30,
                      child: Text('${index + 1}',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black))),
                  Expanded(
                      child: Text(machine.machineryName,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black))),
                  SizedBox(
                      width: 80,
                      child: Text(machine.vehicleNumber,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black))),
                  SizedBox(
                      width: 80,
                      child: Text('${machine.quantity ?? 0} L',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black))),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(l10n.table_total,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const SizedBox(width: 40),
              Text('$total L',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNonOilSection(FeulingDetailLocalizations l10n) {
    final lines = deliveryOrder.receiptLines;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.non_oil_products_title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          if (lines.isEmpty)
            Text(l10n.non_oil_empty,
                style: const TextStyle(fontSize: 18, color: Colors.black))
          else
            ...lines.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    SizedBox(
                        width: 30,
                        child: Text('${index + 1}',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))),
                    Expanded(
                        child: Text(item.productName,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))),
                    SizedBox(
                        width: 80,
                        child: Text(
                            '${item.quantity ?? 0}${l10n.non_oil_piece_unit}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black))),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildSignatureSection(FeulingDetailLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.signature_title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: signaturePoints != null && signaturePoints!.isNotEmpty
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: 400,
                      height: 180,
                      child: CustomPaint(
                        painter:
                            SignaturePainter(points: signaturePoints!),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(FeulingDetailLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_gas_station,
                  size: 30, color: Colors.grey),
              const SizedBox(width: 4),
              Text(l10n.receipt_station_brand,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.receipt_company_name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text(l10n.receipt_store_name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  String _getDayOfWeekL10n(FeulingDetailLocalizations l10n, int day) {
    switch (day) {
      case DateTime.monday:
        return l10n.day_monday;
      case DateTime.tuesday:
        return l10n.day_tuesday;
      case DateTime.wednesday:
        return l10n.day_wednesday;
      case DateTime.thursday:
        return l10n.day_thursday;
      case DateTime.friday:
        return l10n.day_friday;
      case DateTime.saturday:
        return l10n.day_saturday;
      case DateTime.sunday:
        return l10n.day_sunday;
      default:
        return '';
    }
  }
}
