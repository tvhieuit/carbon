import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';

class NonOilProductsTable extends StatelessWidget {
  final List<ReceiptLineEntity> receiptLines;

  const NonOilProductsTable({super.key, required this.receiptLines});

  @override
  Widget build(BuildContext context) {
    if (receiptLines.isEmpty) return const SizedBox.shrink();

    final l10n = context.feulingDetailL10n;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.non_oil_products_title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      _HeaderCell(text: l10n.table_no_label, flex: 1),
                      _HeaderCell(text: l10n.product_name_label, flex: 4),
                      _HeaderCell(
                          text: l10n.non_oil_quantity_label,
                          flex: 2,
                          alignRight: true),
                    ],
                  ),
                ),
                // Rows
                ...receiptLines.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _DataCell(text: '${index + 1}', flex: 1),
                        _DataCell(text: item.productName, flex: 4),
                        _DataCell(
                          text:
                              '${item.quantity ?? 0}${l10n.non_oil_piece_unit}',
                          flex: 2,
                          alignRight: true,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool alignRight;

  const _HeaderCell({
    required this.text,
    required this.flex,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        alignment:
            alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool alignRight;

  const _DataCell({
    required this.text,
    required this.flex,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment:
            alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
