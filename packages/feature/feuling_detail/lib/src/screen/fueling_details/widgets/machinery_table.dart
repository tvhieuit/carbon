import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

class MachineryTable extends StatelessWidget {
  final List<MachineryItemEntity> machines;

  const MachineryTable({super.key, required this.machines});

  @override
  Widget build(BuildContext context) {
    // Group machines by productId
    final grouped = <String?, List<MachineryItemEntity>>{};
    for (final machine in machines) {
      grouped.putIfAbsent(machine.productId, () => []).add(machine);
    }

    return Column(
      children: grouped.entries.expand((entry) {
        final machines = entry.value;
        final productName = machines.first.productId ?? '';
        final total =
            machines.fold(0.0, (sum, m) => sum + (m.quantity ?? 0));

        return [
          _buildProductGroup(context, productName, machines),
          _buildTotalSection(total),
          const SizedBox(height: 8),
        ];
      }).toList(),
    );
  }

  Widget _buildProductGroup(
    BuildContext context,
    String productName,
    List<MachineryItemEntity> machines,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '品名： $productName',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
                      _buildHeaderCell('No.', 3, false),
                      _buildHeaderCell('機械名', 8, false),
                      _buildHeaderCell('車体番号', 8, false),
                      _buildHeaderCell('数量(L)', 6, true),
                    ],
                  ),
                ),
                // Rows
                ...machines.asMap().entries.map((entry) {
                  final index = entry.key;
                  final machine = entry.value;
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildCell('${index + 1}', 3, false),
                        _buildCell(machine.machineryName, 8, false),
                        _buildCell(machine.vehicleNumber, 8, false),
                        _buildCell(
                          '${machine.quantity ?? 0}',
                          6,
                          true,
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

  Widget _buildTotalSection(double totalQuantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '合計',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            totalQuantity.toStringAsFixed(2),
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, int flex, bool alignRight) {
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
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildCell(String text, int flex, bool alignRight) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment:
            alignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: alignRight ? TextAlign.right : TextAlign.left,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
