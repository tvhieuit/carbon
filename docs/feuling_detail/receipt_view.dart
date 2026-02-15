import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:codebase/entities/delivery_order.dart';
import 'package:codebase/l10n/localizations.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/app_bloc.dart';
import '../qrcode_delivery_creation/delivery_creation_qrcode_page.dart';

class ReceiptView extends StatefulWidget {
  final DeliveryOrder deliveryOrder;
  final List<dynamic>? signaturePoints;
  final bool autoSaveToGallery;
  final Function(Uint8List)? onImageSaved;
  final bool isCapturingOnly;
  final String? receiptNumber;

  const ReceiptView({
    Key? key,
    required this.deliveryOrder,
    this.signaturePoints,
    this.autoSaveToGallery = false,
    this.onImageSaved,
    this.isCapturingOnly = false,
    this.receiptNumber,
  }) : super(key: key);

  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  final GlobalKey _receiptKey = GlobalKey();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // If autoSave is true, trigger the capture process after the widget is built
    if (widget.autoSaveToGallery) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _captureReceipt());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total quantity of machinery
    double totalMachineryQuantity = widget.deliveryOrder.constructionMachines
        .fold(0.0, (sum, item) => sum + item.productQuantity);

    // If this is for capturing only, show just the receipt content
    if (widget.isCapturingOnly) {
      return RepaintBoundary(
        key: _receiptKey,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   borderRadius: BorderRadius.circular(4),
            // ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                _buildHeader(),

                // Customer and Staff info
                _buildCustomerInfo(),

                // Separator line
                const Divider(height: 1, thickness: 1, color: Colors.grey),

                // Fuel type header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: Text(
                    widget.deliveryOrder.productName ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Machinery table
                ..._buildMachineryOrderBy(),

                // Separator line
                const Divider(height: 1, thickness: 1, color: Colors.grey),

                // Non-oil products section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: const Text(
                    '油外商品',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Non-oil products table
                _buildNonOilProductsTable(),

                // Separator line
                const Divider(height: 1, thickness: 1, color: Colors.grey),

                // Signature section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 16.0),
                  child: const Text(
                    '受領サイン',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                // Signature
                _buildSignature(),

                // Separator line
                const Divider(height: 1, thickness: 1, color: Colors.grey),

                // Footer with company info
                _buildFooter(),
              ],
            ),
          ),
        ),
      );
    }

    // Regular view with Scaffold
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('PRINT_PREVIEW'.tr),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 27,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _captureReceipt,
              tooltip: '画像として保存',
            ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Future implementation of printing functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('PRINT_STARTED'.tr),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            tooltip: '印刷',
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: RepaintBoundary(
            key: _receiptKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header section
                    _buildHeader(),

                    // Customer and Staff info
                    _buildCustomerInfo(),

                    // Separator line
                    const Divider(height: 1, thickness: 1, color: Colors.grey),

                    // Fuel type header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text(
                        widget.deliveryOrder.productName ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // Machinery table
                    ..._buildMachineryOrderBy(),

                    // Total
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '合計',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 40),
                          Text(
                            '$totalMachineryQuantity L',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ),

                    // Separator line
                    const Divider(height: 1, thickness: 1, color: Colors.grey),

                    // Non-oil products section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: const Text(
                        '油外商品',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // Non-oil products table
                    _buildNonOilProductsTable(),

                    // Separator line
                    const Divider(height: 1, thickness: 1, color: Colors.grey),

                    // Signature section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: const Text(
                        '受領サイン',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    // Signature
                    _buildSignature(),

                    // Separator line
                    const Divider(height: 1, thickness: 1, color: Colors.grey),

                    // Footer with company info
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureReceipt() async {
    try {
      setState(() {
        _isSaving = true;
      });

      // Check permissions first
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission denied');
        }
      }

      // For Android 13+, check photo permission
      if (Platform.isAndroid) {
        var photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          photosStatus = await Permission.photos.request();
          if (!photosStatus.isGranted) {
            throw Exception('Photos permission denied');
          }
        }
      }

      // Wait for the next frame to ensure all widgets are rendered
      await Future.delayed(const Duration(milliseconds: 200));

      final RenderRepaintBoundary boundary = _receiptKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        // Convert ByteData to Uint8List
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        // Call the callback if provided
        if (widget.onImageSaved != null) {
          widget.onImageSaved!(pngBytes);
        }

        // Generate a unique filename based on timestamp
        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        final String fileName = 'receipt_$timestamp.png';

        try {
          // Temporarily disabled due to compatibility issues
          /*
          // Save to gallery using image_gallery_saver package
          final result = await ImageGallerySaver.saveImage(
            pngBytes,
            name: fileName,
            quality: 100,
          );

          final bool success = result['isSuccess'] ?? false;

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('RECEIPT_SAVED_TO_ALBUM'.tr),
                duration: Duration(seconds: 2),
              ),
            );

            // If auto-save was triggered, navigate back after saving
            if (widget.autoSaveToGallery) {
              Navigator.of(context).pop();
            }
          } else {
            throw Exception('Failed to save to gallery');
          }
          */

          // Temporary implementation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image saving temporarily disabled'),
              duration: Duration(seconds: 2),
            ),
          );

          // If auto-save was triggered, navigate back
          if (widget.autoSaveToGallery) {
            Navigator.of(context).pop();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'FAILED_TO_SAVE_TO_ALBUM'.trParams({'error': e.toString()})),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR_OCCURRED'.trParams({'message': e.toString()})),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final year = now.year - 2018; // Convert to Japanese era (Reiwa)
    final japaneseDate =
        '令和${year}年${now.month}月${now.day}日 (${_getDayOfWeek(now.weekday)})';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            'RECEIPT_TITLE'.tr,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Date and time
          Text(
            japaneseDate,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: IntrinsicColumnWidth(),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        '伝票番号：',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        widget.receiptNumber ?? '',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        'CUSTOMER_NAME'.tr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        context
                                .read<AppBloc>()
                                .state
                                .deliveryOrder
                                ?.constructionSiteName ??
                            '',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        'PERSON_IN_CHARGE_LABEL'.tr,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 4.0),
                      child: Text(
                        context.read<AppBloc>().state.user?.name ?? '',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMachineryOrderBy() {
    final constructionMachines = widget.deliveryOrder.constructionMachines
        .groupListsBy((e) => GroupProductSection(
            productId: e.productId, productName: e.productName));

    return constructionMachines.entries.expand((e) {
      final key = e.key;
      final value = e.value;
      double total = value.fold(0.0, (sum, item) => sum + item.productQuantity);
      return <Widget>[
        _buildProductName(key.productName),
        const SizedBox(height: 8),
        _buildMachineryTable(value),
        const SizedBox(height: 12),
        _buildTotal(total),
        const SizedBox(height: 24),
      ];
    }).toList();
  }

  Widget _buildProductName(String? name) {
    return   Text(
      '${'PRODUCT_NAME_LABEL'.tr}： $name',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTotal(double total) {
    return // Total
        Padding(
      padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            '合計',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 40),
          Text(
            '$total L',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildMachineryTable(List<ConstructionMachine> constructionMachines) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: const {
        0: FlexColumnWidth(0.5), // No.
        1: FlexColumnWidth(1.6), // 機械名
        2: FlexColumnWidth(1.0), // 車体番号
        3: FlexColumnWidth(0.8), // 数量
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('NO_LABEL'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('MACHINE_NAME'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('VEHICLE_NUMBER'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('QUANTITY_L'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
        // Data rows
        ...constructionMachines.asMap().entries.map((entry) {
          final index = entry.key;
          final machine = entry.value;
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text('${index + 1}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(machine.name ?? '-',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(machine.machineNumber ?? '-',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '${machine.productQuantity} L',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNonOilProductsTable() {
    // チェックして、receiptLinesがある場合はそれを表示
    final nonOilProducts = widget.deliveryOrder.receiptLines;

    // if (nonOilProducts.isEmpty) {
    //   return Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Text('NO_NON_OIL_PRODUCTS'.tr,
    //         style: TextStyle(fontSize: 18, color: Colors.black),
    //         textAlign: TextAlign.left),
    //   );
    // }

    return Table(
      border: TableBorder.all(color: Colors.white),
      columnWidths: const {
        0: FlexColumnWidth(0.5), // No.
        1: FlexColumnWidth(2.0), // 商品名
        2: FlexColumnWidth(0.8), // 数量
      },
      children: [
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('NO_LABEL'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('PRODUCT_NAME_LABEL'.tr,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text('QUANTITY_LABEL'.tr,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 18, color: Colors.black)),
            ),
          ],
        ),
        // Data rows
        if (nonOilProducts.isEmpty)
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
            ),
            children: [
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(''),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(''),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(''),
              ),
            ],
          )
        else
          ...nonOilProducts.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('${index + 1}',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(item.productName,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    '${item.productQuantity} ${'PIECE'.tr}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            );
          }).toList(),
      ],
    );
  }

  Widget _buildSignature() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.grey.shade300),
      //   borderRadius: BorderRadius.circular(4),
      // ),
      child: widget.signaturePoints != null &&
              widget.signaturePoints!.isNotEmpty
          ? FittedBox(
              fit: BoxFit.contain,
              child: SizedBox(
                width: 400, // Đảm bảo kích thước phù hợp cho vùng chữ ký
                height: 180,
                child: CustomPaint(
                  painter: SignaturePainter(points: widget.signaturePoints!),
                ),
              ),
            )
          : SizedBox(),
      // : Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Text(
      //       'NO_SIGNATURE'.tr,
      //       style: const TextStyle(
      //         color: Colors.black,
      //         fontSize: 18,
      //       ),
      //     ),
      //   ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.local_gas_station,
                size: 30,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                'apollostation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '出光興産（株）販売店',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            '株式会社　松林',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildServiceStationInfo(
            '由良給油所',
            '由良給油所 宮津市由良',
            'TEL: 0772 (26) 0 5 1',
          ),
          const SizedBox(height: 4),
          _buildServiceStationInfo(
            '栗田給油所',
            '栗田給油所 宮津市字中津',
            'TEL: 0772 (25) 0 5 3 6',
          ),
          const SizedBox(height: 4),
          _buildServiceStationInfo(
            '福知山牧給油所',
            '福知山牧給油所 福知山市牧',
            'TEL: 0773 (33) 3 1 5 1',
          ),
          const SizedBox(height: 4),
          _buildServiceStationInfo(
            '京都出張所',
            '613-0036 京都府 久世郡久御山町田井荒見 79-1',
            '',
          ),
        ],
      ),
    );
  }

  Widget _buildServiceStationInfo(String title, String address, String phone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text(
            '•',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            '$title：',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                address,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Japanese style date format
    final dayOfWeek = _getDayOfWeek(date.weekday);
    return '${date.year}年${date.month}月${date.day}日（$dayOfWeek）';
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case DateTime.monday:
        return '月';
      case DateTime.tuesday:
        return '火';
      case DateTime.wednesday:
        return '水';
      case DateTime.thursday:
        return '木';
      case DateTime.friday:
        return '金';
      case DateTime.saturday:
        return '土';
      case DateTime.sunday:
        return '日';
      default:
        return '';
    }
  }
}

class SignaturePainter extends CustomPainter {
  final List<dynamic> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..strokeJoin = StrokeJoin.round;

    if (points.isEmpty) return;

    // Determine if we need to fit the points within the canvas bounds
    bool needsScaling = false;
    double minX = double.infinity;
    double maxX = 0;
    double minY = double.infinity;
    double maxY = 0;

    // Find the bounds of the points
    for (final point in points) {
      double x = point['x'].toDouble();
      double y = point['y'].toDouble();

      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;

      // Check if any point is outside the canvas
      if (x < 0 || x > size.width || y < 0 || y > size.height) {
        needsScaling = true;
      }
    }

    // Apply scaling if necessary
    if (needsScaling && maxX > minX && maxY > minY) {
      double scaleX = (size.width - 20) / (maxX - minX);
      double scaleY = (size.height - 20) / (maxY - minY);
      double scale = math.min(scaleX, scaleY);

      double offsetX =
          10 + (size.width - (maxX - minX) * scale) / 2 - minX * scale;
      double offsetY =
          10 + (size.height - (maxY - minY) * scale) / 2 - minY * scale;

      // Draw all connected lines with scaling
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i + 1]['isMoving']) {
          canvas.drawLine(
            Offset(points[i]['x'] * scale + offsetX,
                points[i]['y'] * scale + offsetY),
            Offset(points[i + 1]['x'] * scale + offsetX,
                points[i + 1]['y'] * scale + offsetY),
            paint,
          );
        }
      }
    } else {
      // Draw without scaling if all points are within bounds
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i + 1]['isMoving']) {
          canvas.drawLine(
            Offset(points[i]['x'], points[i]['y']),
            Offset(points[i + 1]['x'], points[i + 1]['y']),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return true;
  }
}
