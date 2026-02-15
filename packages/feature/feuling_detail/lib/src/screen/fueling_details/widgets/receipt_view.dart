import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

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
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildCustomerInfo(),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildMachinerySection(),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildNonOilSection(),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildSignatureSection(),
          const Divider(height: 1, thickness: 1, color: Colors.grey),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final year = now.year - 2018; // Reiwa era
    final japaneseDate =
        '令和${year}年${now.month}月${now.day}日 (${_getDayOfWeek(now.weekday)})';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '納品伝票',
            style: TextStyle(
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

  Widget _buildCustomerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildInfoRow('伝票番号：', receiptNumber ?? ''),
          _buildInfoRow('お客様名：', constructionSiteName ?? ''),
          _buildInfoRow('担当者：', personInCharge ?? ''),
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

  Widget _buildMachinerySection() {
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
              const Text('合計',
                  style: TextStyle(
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

  Widget _buildNonOilSection() {
    final lines = deliveryOrder.receiptLines;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('油外商品',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          if (lines.isEmpty)
            const Text('なし',
                style: TextStyle(fontSize: 18, color: Colors.black))
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
                        child: Text('${item.quantity ?? 0}個',
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

  Widget _buildSignatureSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('受領サイン',
              style: TextStyle(
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

  Widget _buildFooter() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_gas_station,
                  size: 30, color: Colors.grey),
              SizedBox(width: 4),
              Text('apollostation',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ],
          ),
          SizedBox(height: 8),
          Text('出光興産（株）販売店',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          Text('株式会社　松林',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  String _getDayOfWeek(int day) {
    const days = ['月', '火', '水', '木', '金', '土', '日'];
    return days[(day - 1) % 7];
  }
}
