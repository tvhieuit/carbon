import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/l10n.dart';
import '../../l10n/qr_scan_localizations.dart';

@RoutePage()
class QrScanQuantityPage extends StatelessWidget {
  final QrInfoEntity qrInfo;
  final List<OrderLineEntity> orderLines;

  const QrScanQuantityPage({
    super.key,
    required this.qrInfo,
    required this.orderLines,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.qrScanL10n;
    final firstOrderLine = orderLines.isNotEmpty ? orderLines.first : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3CD9A0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.machine_info_title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Info rows
              _buildInfoRow(l10n.customer_name_label, qrInfo.companyName),
              const SizedBox(height: 12),
              _buildInfoRow(l10n.branch_name_label, qrInfo.branchName),
              const SizedBox(height: 12),
              _buildInfoRow(l10n.construction_site_name_label, qrInfo.constructionSiteName),
              const SizedBox(height: 12),
              _buildInfoRow(l10n.machine_name_label, qrInfo.machineName),
              const SizedBox(height: 12),
              _buildInfoRow(l10n.machine_number_label, qrInfo.machineNumber),
              const SizedBox(height: 12),
              _buildInfoRow(l10n.fuel_type_label, firstOrderLine?.productName ?? '-', valueColor: Colors.red),
              const SizedBox(height: 24),

              // Product table
              _buildProductTable(context, l10n),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.router.popUntilRoot(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        l10n.finish_button,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.router.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        l10n.next_scan_button,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductTable(BuildContext context, QrScanLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFE4C9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3),
                topRight: Radius.circular(3),
              ),
            ),
            child: Row(
              children: [
                _buildTableCell(l10n.product_name_header, isHeader: true, flex: 4),
                _buildTableCell(l10n.order_number_header, isHeader: true, flex: 4),
                _buildTableCell(l10n.quantity_header, isHeader: true, flex: 3),
              ],
            ),
          ),
          // Data rows
          ...orderLines.map(
            (line) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  _buildTableCell(line.productName ?? '-', flex: 4),
                  _buildTableCell(line.id, flex: 4), // Using ID as order number for now
                  _buildQuantityCell(
                    context,
                    line.quantity?.toString() ?? '',
                    flex: 3,
                  ),
                ],
              ),
            ),
          ),
          if (orderLines.isEmpty)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  _buildTableCell('-', flex: 4),
                  _buildTableCell('-', flex: 4),
                  _buildTableCell('-', flex: 3),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityCell(BuildContext context, String initialValue, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: TextEditingController(text: initialValue),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d*[.,]?\d*$')),
            ],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
      ),
    );
  }
}
