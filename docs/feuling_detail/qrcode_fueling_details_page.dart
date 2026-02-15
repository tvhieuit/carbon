import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:codebase/controller/delivery_creation_controller.dart';
import 'package:codebase/core/dependency_injection/dependency_injection.dart';
import 'package:codebase/core/navigator/app_navigator.dart';
import 'package:codebase/entities/delivery_order.dart';
import 'package:codebase/feature/app/app_bloc.dart';
import 'package:codebase/feature/app/app_event.dart';
import 'package:codebase/feature/app/app_state.dart';
import 'package:codebase/feature/top/qrcode_fueling_details/qrcode_fueling_details_bloc.dart';
import 'package:codebase/feature/top/qrcode_fueling_details/qrcode_fueling_details_event.dart';
import 'package:codebase/feature/top/qrcode_fueling_details/qrcode_fueling_details_state.dart';
import 'package:codebase/feature/top/qrcode_fueling_details/receipt_view.dart';
import 'package:codebase/l10n/localizations.dart';
import 'package:codebase/repository/repository.dart';
import 'package:codebase/util/file_util.dart';
import 'package:codebase/widget/loading.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodeFuelingDetailsPage extends StatelessWidget {
  final String? machineId;

  const QrCodeFuelingDetailsPage({super.key, this.machineId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final appBloc = context.read<AppBloc>();
        final bloc = QrCodeFuelingDetailsBloc(
          repository: locator<Repository>(),
          deliveryCreationController: locator<DeliveryCreationController>(),
          appBloc: appBloc,
        );

        // Gửi event khởi tạo ngay sau khi tạo bloc
        if (appBloc.state.deliveryOrder?.orderId != null) {
          bloc.add(QrCodeFuelingDetailsInitialized(
              orderId: appBloc.state.deliveryOrder!.orderId!,
              machineid: machineId
              //orderLineId: appBloc.state.deliveryOrder!.orderLineId!,
              ));
        }

        return bloc;
      },
      child: _FuelingDetailsContent(machineId: machineId),
    );
  }
}

class _FuelingDetailsContent extends StatefulWidget {
  final String? machineId;

  const _FuelingDetailsContent({this.machineId});

  @override
  State<_FuelingDetailsContent> createState() => _FuelingDetailsContentState();
}

class _FuelingDetailsContentState extends State<_FuelingDetailsContent> {
  File? receiptImage;
  List<dynamic>? signaturePoints;
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool _showTemporaryReceiptView = false;
  String? _tempReceiptNumber;
  bool _isCapturingAfterSignatureUpdate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrCodeFuelingDetailsBloc, QrCodeFuelingDetailsState>(
      listener: (context, state) {
        if (state is FuelingDetailsSubmitSuccess) {
          //Store receipt number temporarily for the view
          setState(() {
            _tempReceiptNumber = state.receiptNumber;
          });

          // After submit success, capture and save receipt with receipt number
          _captureAndSaveReceiptOffscreen(
            context,
            context.read<AppBloc>().state.deliveryOrder!,
            state.receiptNumber,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('ORDER_SUCCESS'
                  .trParams({'receipt_number': state.receiptNumber})),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is FuelingDetailsLoaded) {
          // Check if this is after signature update (has receiptSignatureId but isPrintEnabled is false)
          final deliveryOrder = state.deliveryOrder;

          print('anhd_UI_LISTENER: ========== AUTO-CAPTURE CHECK ==========');
          print(
              'anhd_UI_LISTENER: deliveryOrder != null: ${deliveryOrder != null}');
          print(
              'anhd_UI_LISTENER: receiptSignatureId: ${deliveryOrder?.receiptSignatureId}');
          print('anhd_UI_LISTENER: isPrintEnabled: ${state.isPrintEnabled}');
          print(
              'anhd_UI_LISTENER: receiptNumber: ${deliveryOrder?.receiptNumber}');
          print(
              'anhd_UI_LISTENER: _isCapturingAfterSignatureUpdate: $_isCapturingAfterSignatureUpdate');
          print('anhd_UI_LISTENER: ==========================================');

          if (deliveryOrder != null &&
              deliveryOrder.receiptSignatureId != null &&
              !state.isPrintEnabled &&
              deliveryOrder.receiptNumber != null &&
              !_isCapturingAfterSignatureUpdate) {
            print(
                'anhd_UI_LISTENER: ✅ ALL CONDITIONS MET - Auto-capturing receipt...');

            // Set flag to prevent multiple captures
            setState(() {
              _isCapturingAfterSignatureUpdate = true;
              _tempReceiptNumber = deliveryOrder.receiptNumber;
            });

            // Capture receipt with new signature
            Future.microtask(() {
              _captureAndSaveReceiptOffscreen(
                context,
                deliveryOrder,
                deliveryOrder.receiptNumber!,
              );
            });
          } else {
            print(
                'anhd_UI_LISTENER: ❌ Conditions NOT met - Skipping auto-capture');
          }

          // Reset flag when print is enabled (receipt file updated successfully)
          if (state.isPrintEnabled && _isCapturingAfterSignatureUpdate) {
            setState(() {
              _isCapturingAfterSignatureUpdate = false;
            });
          }
        } else if (state is FuelingDetailsError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );

          // Reset capture flag on error
          if (_isCapturingAfterSignatureUpdate) {
            setState(() {
              _isCapturingAfterSignatureUpdate = false;
            });
          }
        } else if (state is FuelingDetailsPrintSuccess) {
          // Show a success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is FuelingDetailsPrintError) {
          // Just show the error message but don't change UI state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocListener<AppBloc, AppState>(
        listenWhen: (previous, current) =>
            previous.deliveryOrder?.orderId != current.deliveryOrder?.orderId ||
            previous.deliveryOrder?.orderLineId !=
                current.deliveryOrder?.orderLineId,
        listener: (context, state) {
          if (state.deliveryOrder != null) {
            context.read<QrCodeFuelingDetailsBloc>().add(
                QrCodeFuelingDetailsInitialized(
                    orderId: state.deliveryOrder!.orderId!,
                    machineid: widget.machineId
                    //orderLineId: state.deliveryOrder!.orderLineId!,
                    ));
          }
        },
        child: Scaffold(
          backgroundColor: Color(0xFFF2F4F7),
          appBar: AppBar(
            title: Text('FUELING_DETAILS_TITLE'.tr),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black),
            // titleTextStyle: const TextStyle(
            //   color: Colors.black,
            //   fontSize: 16,
            //   fontWeight: FontWeight.bold,
            // ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                // Xử lý khi nhấn nút back
                final state = context.read<QrCodeFuelingDetailsBloc>().state;
                final isPrintEnabled = state is FuelingDetailsLoaded
                    ? state.isPrintEnabled
                    : false;

                if (isPrintEnabled) {
                  final appBloc = context.read<AppBloc>();
                  appBloc.add(RefreshDashboard());
                  AppNavigator.popToRoot();
                } else {
                  // Nếu chưa hoàn thành, back về màn hình trước
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: Stack(
            children: [
              BlocBuilder<AppBloc, AppState>(
                builder: (context, state) {
                  final deliveryOrder = state.deliveryOrder;

                  if (deliveryOrder == null) {
                    return Center(
                      child: Text('NO_ORDER_INFO'.tr),
                    );
                  }

                  // Calculate total quantity of machinery
                  // double totalMachineryQuantity = deliveryOrder
                  //     .constructionMachines
                  //     .fold(0.0, (sum, item) => sum + item.productQuantity);

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          ..._buildMachineryGroupByProduct(state),

                          const SizedBox(height: 8),
                          // Chỉ hiển thị phần sản phẩm ngoài dầu khi có dữ liệu
                          if (deliveryOrder.receiptLines.isNotEmpty)
                            _buildNonOilProductsTable(deliveryOrder),
                          _buildSignatureSection(),
                          _buildBottomButtons(context, deliveryOrder),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Temporary receipt view for capture
              if (_showTemporaryReceiptView)
                Opacity(
                  opacity: 0.01,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: RepaintBoundary(
                        key: _repaintBoundaryKey,
                        child: Material(
                          color: Colors.white,
                          elevation: 0,
                          child: ReceiptView(
                            deliveryOrder:
                                context.read<AppBloc>().state.deliveryOrder!,
                            signaturePoints: signaturePoints,
                            receiptNumber: _tempReceiptNumber ?? '',
                            isCapturingOnly: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              BlocBuilder<QrCodeFuelingDetailsBloc, QrCodeFuelingDetailsState>(
                builder: (context, state) {
                  if (state is FuelingDetailsLoadingState) {
                    return Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('SAVING_RECEIPT'.tr),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Get current date in Japanese format
    final now = DateTime.now();
    final year = now.year - 2018; // Convert to Japanese era (Reiwa)
    final japaneseDate =
        '令和${year}年${now.month}月${now.day}日 (${_getDayOfWeek(now.weekday)})';

    return Container(
      width: double.infinity,
      color: Color(0xFFF2F4F7),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.read<AppBloc>().state.deliveryOrder?.constructionSiteName ??
                'YAMAZAKI_CONSTRUCTION'.tr,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$japaneseDate • ${'PERSON_IN_CHARGE'.tr}: ${context.read<AppBloc>().state.user?.name ?? ''}',
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMachineryGroupByProduct(AppState state) {
    final machineryGroupBy = state.machineryOrderGroupByProduct();
    return machineryGroupBy.entries.expand((e) {
      final key = e.key;
      final deliveryOrder = e.value;
      final total = deliveryOrder.fold(0.0, (a, b) => a + b.productQuantity);
      return <Widget>[
        Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${'PRODUCT_NAME_LABEL'.tr}： ${key.productName ?? ''}',
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
                    // Table header
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildTableHeaderCell('NO_LABEL'.tr, 3, false),
                          _buildTableHeaderCell('MACHINE_NAME'.tr, 8, false),
                          _buildTableHeaderCell('VEHICLE_NUMBER'.tr, 8, false),
                          _buildTableHeaderCell('QUANTITY_L'.tr, 6, true),
                        ],
                      ),
                    ),
                    // Table rows
                    ...deliveryOrder.asMap().entries.map((entry) {
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
                            _buildTableCell('${index + 1}', 3, false),
                            _buildTableCell(item.name ?? '-', 8, false),
                            _buildTableCell(
                                item.machineNumber ?? '-', 8, false),
                            _buildTableCell('${item.productQuantity}', 6, true),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildTotalSection(total),
      ];
    }).toList();
  }

  Widget _buildTotalSection(double totalQuantity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TOTAL'.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            totalQuantity.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNonOilProductsTable(DeliveryOrder deliveryOrder) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NON_OIL_PRODUCTS'.tr,
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
                // Table header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTableHeaderCell('NO_LABEL'.tr, 1, false),
                      _buildTableHeaderCell('PRODUCT_NAME_LABEL'.tr, 4, false),
                      _buildTableHeaderCell('QUANTITY_LABEL'.tr, 2, true),
                    ],
                  ),
                ),
                // Table rows
                ...deliveryOrder.receiptLines.asMap().entries.map((entry) {
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
                        _buildTableCell('${index + 1}', 1, false),
                        _buildTableCell(item.productName ?? '-', 4, false),
                        _buildTableCell(
                            '${item.productQuantity}${'PIECE'.tr}', 2, true),
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

  Widget _buildSignatureSection() {
    return BlocBuilder<QrCodeFuelingDetailsBloc, QrCodeFuelingDetailsState>(
      builder: (context, state) {
        // Check if order is delivered and has a signature URL
        final deliveryOrder = context.read<AppBloc>().state.deliveryOrder;
        final bool isDelivered = deliveryOrder?.isDelivered ?? false;
        final String? signatureUrl =
            state is FuelingDetailsLoaded ? state.signatureUrl : null;
        final bool hasSignatureUrl = signatureUrl != null;
        final bool isPrintEnabled =
            state is FuelingDetailsLoaded ? state.isPrintEnabled : false;

        // DEBUG LOG for signature display
        print(
            'anhdv_SIG_DISPLAY: ========== SIGNATURE DISPLAY CHECK ==========');
        print('anhdv_SIG_DISPLAY: isDelivered: $isDelivered');
        print('anhdv_SIG_DISPLAY: isPrintEnabled: $isPrintEnabled');
        print('anhdv_SIG_DISPLAY: signatureUrl: $signatureUrl');
        print('anhdv_SIG_DISPLAY: hasSignatureUrl: $hasSignatureUrl');
        print(
            'anhdv_SIG_DISPLAY: Will show signature from network: ${isDelivered && hasSignatureUrl}');
        print('anhdv_SIG_DISPLAY: ==========================================');

        // Check if signature should be enabled:
        // CRITICAL: If isPrintEnabled=true, signature is LOCKED (order completed)
        // Otherwise:
        // 1. Order not delivered yet, OR
        // 2. Order is delivered AND isSeparate == true AND not yet printed, OR
        // 3. Order is delivered BUT doesn't have signature yet
        final bool shouldEnableSignature = !isPrintEnabled &&
            (!isDelivered ||
                (isDelivered && deliveryOrder?.isSeparate == true) ||
                (isDelivered && !hasSignatureUrl));

        return Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RECEIPT_SIGNATURE'.tr,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'GET_SIGNATURE_FROM_SITE_MANAGER'.tr,
                style: const TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                // Enable signature in two cases:
                // 1. Order not delivered yet, OR
                // 2. Order is delivered AND isSeparate == true
                onTap: shouldEnableSignature
                    ? () => _showSignaturePad(context)
                    : null,
                child: Container(
                  height: 250,
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: isDelivered && hasSignatureUrl
                        ? Image.network(
                            signatureUrl!,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print('Error rendering signature image: $error');
                              return Center(
                                child: Text(
                                  'ERROR_LOADING_SIGNATURE'.tr,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            },
                          )
                        : (signaturePoints != null &&
                                signaturePoints!.isNotEmpty
                            ? CustomPaint(
                                size: Size(
                                    MediaQuery.of(context).size.width - 16,
                                    300),
                                painter:
                                    SignaturePainter(points: signaturePoints!),
                              )
                            : Center(
                                child: Text(
                                  shouldEnableSignature
                                      ? 'TAP_TO_GET_SIGNATURE'.tr
                                      : 'SIGNATURE_NOT_REQUIRED'.tr,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSignaturePad(BuildContext context) {
    List<dynamic> tempPoints = [];

    // Get the screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final double dialogWidth =
        screenSize.width - 8; // Full width minus 4px margins on each side
    final double dialogHeight =
        screenSize.height * 0.7; // Reduced from 0.6 to 0.5

    // Calculate signature canvas size relative to dialog size
    final double signatureWidth = dialogWidth - 4; // Accounting for padding
    final double signatureHeight =
        dialogHeight * 0.53; // Increased by ~1.5x from 0.35

    // Get the size of the signature area in the main screen
    final double mainSignatureWidth =
        MediaQuery.of(context).size.width - 4; // Full width minus padding
    final double mainSignatureHeight = MediaQuery.of(context).size.width /
        2; // Fixed height from the container

    // Lưu tham chiếu đến các bloc cần thiết trước khi hiển thị dialog
    QrCodeFuelingDetailsBloc? qrCodeFuelingDetailsBloc;
    try {
      qrCodeFuelingDetailsBloc = context.read<QrCodeFuelingDetailsBloc>();
    } catch (e) {
      print('Error accessing QrCodeFuelingDetailsBloc: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR_TRY_AGAIN'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final appBloc = context.read<AppBloc>();

    // Use Future.microtask to show dialog after current frame
    Future.microtask(() {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 4.0),
              // Giảm padding ngoài cùng xuống 4px mỗi bên
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              content: Container(
                width: dialogWidth,
                height: dialogHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with centered title and close button
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Centered title
                          Text(
                            'RECEIPT_SIGNATURE'.tr,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // Close button on the right
                          Positioned(
                            right: 8,
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Instruction text
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'GET_SIGNATURE_FROM_SITE_MANAGER'.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    // Signature area
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      height: signatureHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Stack(
                        children: [
                          // Signature drawing area
                          GestureDetector(
                            onPanStart: (details) {
                              setState(() {
                                tempPoints.add({
                                  'x': details.localPosition.dx,
                                  'y': details.localPosition.dy,
                                  'isMoving': false,
                                });
                              });
                            },
                            onPanUpdate: (details) {
                              setState(() {
                                tempPoints.add({
                                  'x': details.localPosition.dx,
                                  'y': details.localPosition.dy,
                                  'isMoving': true,
                                });
                              });
                            },
                            child: CustomPaint(
                              painter: SignaturePainter(points: tempPoints),
                              size: Size(signatureWidth, signatureHeight),
                            ),
                          ),

                          // Refresh button at bottom right
                          Positioned(
                            right: 8,
                            bottom: 8,
                            child: IconButton(
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.grey,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  tempPoints = [];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Buttons row
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: Row(
                        children: [
                          // Cancel button
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'CANCEL_BUTTON'.tr,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Save button
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (tempPoints.isEmpty) {
                                  ScaffoldMessenger.of(dialogContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('PLEASE_ENTER_SIGNATURE'.tr),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                // Show loading indicator
                                Future.microtask(() {
                                  showDialog(
                                    context: dialogContext,
                                    barrierDismissible: false,
                                    builder: (BuildContext loadingContext) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                });

                                try {
                                  // 1. Convert signature to image
                                  final recorder = ui.PictureRecorder();
                                  final canvas = Canvas(recorder);
                                  final size =
                                      Size(signatureWidth, signatureHeight);

                                  // Draw white background
                                  final bgPaint = Paint()..color = Colors.white;
                                  canvas.drawRect(Offset.zero & size, bgPaint);

                                  // Draw signature
                                  final signaturePainter =
                                      SignaturePainter(points: tempPoints);
                                  signaturePainter.paint(canvas, size);

                                  // Convert to image
                                  final picture = recorder.endRecording();
                                  final img = await picture.toImage(
                                    size.width.toInt(),
                                    size.height.toInt(),
                                  );
                                  final byteData = await img.toByteData(
                                      format: ui.ImageByteFormat.png);
                                  final pngBytes =
                                      byteData!.buffer.asUint8List();

                                  // 2. Create temporary file
                                  final tempDir =
                                      await getApplicationDocumentsDirectory();
                                  var file = File(
                                      '${tempDir.path}/signature_${appBloc.state.deliveryOrder?.orderId}.png');
                                  await file.writeAsBytes(pngBytes);
                                  print(file.path);
                                  // 5. Scale points for main screen display
                                  List<dynamic> scaledPoints =
                                      tempPoints.map((point) {
                                    return {
                                      'x': point['x'] *
                                          (mainSignatureWidth / signatureWidth),
                                      'y': point['y'] *
                                          (mainSignatureHeight /
                                              signatureHeight),
                                      'isMoving': point['isMoving'],
                                    };
                                  }).toList();

                                  // Update the signature in the main screen
                                  this.setState(() {
                                    signaturePoints = scaledPoints;
                                  });

                                  // Close loading dialog and signature dialog
                                  Navigator.pop(
                                      dialogContext); // Close loading dialog
                                  Navigator.pop(
                                      dialogContext); // Close signature dialog

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('SIGNATURE_SAVED'.tr),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // 3. Upload file - just upload and save ID locally, don't call update API yet
                                  try {
                                    final fileResponse =
                                        await FileUtil.uploadFile(file);

                                    if (fileResponse != null &&
                                        fileResponse.id != null) {
                                      print(
                                          'anhd_UPLOAD: Signature uploaded successfully. ID: ${fileResponse.id}');

                                      // 4. Update local deliveryOrder with signature ID for button state
                                      final deliveryOrder =
                                          appBloc.state.deliveryOrder;
                                      if (deliveryOrder != null) {
                                        // Update local order with signature ID
                                        final updatedOrder =
                                            deliveryOrder.copyWith(
                                          receiptSignatureId: fileResponse.id,
                                        );

                                        // Update AppBloc state to trigger button state change
                                        appBloc.add(
                                            UpdateDeliveryOrder(updatedOrder));

                                        // CRITICAL: Refresh QrCodeFuelingDetailsBloc to sync with AppBloc
                                        qrCodeFuelingDetailsBloc?.add(
                                            const FuelingDetailsRefreshed());

                                        print(
                                            'anhd_UPLOAD: Signature ID saved locally. QrCodeFuelingDetailsBloc refreshed.');
                                        print(
                                            'anhd_UPLOAD: Button will show UPDATE mode.');
                                        print(
                                            'anhd_UPLOAD: User needs to press UPDATE button to call API.');
                                      }
                                    } else {
                                      print(
                                          'anhd_UPLOAD: Failed to upload signature file');
                                    }
                                  } catch (uploadError) {
                                    print(
                                        'anhd: Error uploading signature: $uploadError');
                                    // Don't show error to user as signature is already saved locally
                                  }
                                } catch (e) {
                                  // Close loading dialog
                                  Navigator.pop(dialogContext);

                                  // Show error message
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('ERROR_OCCURRED'
                                          .trParams({'message': e.toString()})),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  print('Error uploading signature: $e');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                              ),
                              child: Text(
                                'SAVE'.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  Widget _buildBottomButtons(
      BuildContext context, DeliveryOrder deliveryOrder) {
    return BlocBuilder<QrCodeFuelingDetailsBloc, QrCodeFuelingDetailsState>(
      builder: (context, state) {
        // CRITICAL FIX: Use deliveryOrder from QrCodeFuelingDetailsBloc state, not from AppBloc
        // This ensures we're working with the most up-to-date order data
        final DeliveryOrder currentOrder = state is FuelingDetailsLoaded
            ? (state.deliveryOrder ?? deliveryOrder)
            : deliveryOrder;

        final bool isSubmitEnabled =
            state is FuelingDetailsLoaded ? state.isSubmitEnabled : false;
        final bool isPrintEnabled =
            state is FuelingDetailsLoaded ? state.isPrintEnabled : false;

        // Check if in update mode (delivered order without signature or needs update)
        final bool isDelivered =
            state is FuelingDetailsLoaded && !state.isSubmitEnabled;

        // Get signature URL to determine if signature is synced with server
        final String? signatureUrl =
            state is FuelingDetailsLoaded ? state.signatureUrl : null;

        // Determine if we're in update signature mode
        final bool hasSignature = currentOrder.receiptSignatureId != null;
        final bool hasReceiptFile = currentOrder.receiptFileId != null;
        // Signature is synced if we can fetch its URL from server
        final bool isSignatureSynced = hasSignature && signatureUrl != null;

        // CRITICAL: Detect "processing" state
        // When signature synced but receipt file not yet captured (auto-capture in progress)
        final bool isProcessingReceipt = isDelivered &&
            isSignatureSynced &&
            !hasReceiptFile &&
            !isPrintEnabled;

        // UPDATE mode conditions:
        // 1. Delivered AND no signature yet, OR
        // 2. Delivered AND has signature but not synced (URL not fetchable), OR
        // 3. Delivered AND isSeparate=true AND no receipt file yet
        final bool isUpdateMode = isDelivered &&
            !isPrintEnabled &&
            (!hasSignature ||
                (hasSignature && !isSignatureSynced) ||
                (currentOrder.isSeparate == true && !hasReceiptFile));

        // DEBUG LOG
        print('anhdv_UI: ========== BUTTON UI LOGIC ==========');
        print('anhdv_UI: State type: ${state.runtimeType}');
        print('anhdv_UI: isSubmitEnabled: $isSubmitEnabled');
        print('anhdv_UI: isPrintEnabled: $isPrintEnabled');
        print('anhdv_UI: isDelivered: $isDelivered');
        print(
            'anhdv_UI: receiptSignatureId (from Bloc): ${currentOrder.receiptSignatureId}');
        print(
            'anhdv_UI: receiptFileId (from Bloc): ${currentOrder.receiptFileId}');
        print(
            'anhdv_UI: receiptNumber (from Bloc): ${currentOrder.receiptNumber}');
        print('anhdv_UI: isSeparate: ${currentOrder.isSeparate}');
        print(
            'anhdv_UI: signatureUrl (from Bloc): ${signatureUrl != null ? "EXISTS" : "NULL"}');
        print('anhdv_UI: hasSignature: $hasSignature');
        print('anhdv_UI: isSignatureSynced: $isSignatureSynced');
        print('anhdv_UI: hasReceiptFile: $hasReceiptFile');
        print('anhdv_UI: isProcessingReceipt: $isProcessingReceipt');
        print('anhdv_UI: isUpdateMode: $isUpdateMode');
        print(
            'anhdv_UI: Button will show: ${isPrintEnabled ? "PRINT" : (isProcessingReceipt ? "PROCESSING..." : (isUpdateMode ? "UPDATE" : "SUBMIT"))}');
        print('anhdv_UI: ==========================================');

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Back button - always enabled with same style
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (isPrintEnabled) {
                      final appBloc = context.read<AppBloc>();
                      appBloc.add(RefreshDashboard());
                      AppNavigator.popToRoot();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'BACK_BUTTON'.tr,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Combined Submit/Update/Print button - enabled based on state
              Expanded(
                child: ElevatedButton(
                  onPressed: isPrintEnabled
                      ? () {
                          // Print mode - use currentOrder from bloc state
                          context.read<QrCodeFuelingDetailsBloc>().add(
                                PrintReceipt(
                                    imagePath: state is FuelingDetailsLoaded
                                        ? state.capturedReceiptImage?.path ?? ''
                                        : ''),
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('PRINT_STARTED'.tr),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : (isUpdateMode
                          ? () {
                              // Update mode - call UpdateOrderSignature API
                              final deliveryOrder = currentOrder;

                              // Verify we have all required data
                              if (deliveryOrder.orderId == null ||
                                  deliveryOrder.receiptId == null ||
                                  deliveryOrder.receiptSignatureId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('署名データが不足しています'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              print(
                                  'anhd_UPDATE_BTN: Calling UpdateOrderSignature...');
                              print(
                                  'anhd_UPDATE_BTN: orderId: ${deliveryOrder.orderId}');
                              print(
                                  'anhd_UPDATE_BTN: receiptId: ${deliveryOrder.receiptId}');
                              print(
                                  'anhd_UPDATE_BTN: signatureId: ${deliveryOrder.receiptSignatureId}');

                              context.read<QrCodeFuelingDetailsBloc>().add(
                                    UpdateOrderSignature(
                                      orderId: deliveryOrder.orderId!,
                                      receiptId: deliveryOrder.receiptId!,
                                      signatureId:
                                          deliveryOrder.receiptSignatureId!,
                                    ),
                                  );

                              print(
                                  'anhd_UPDATE_BTN: UpdateOrderSignature event dispatched');
                            }
                          : (isSubmitEnabled
                              ? () {
                                  // Submit mode - use currentOrder
                                  context.read<QrCodeFuelingDetailsBloc>().add(
                                        OrderSubmitted(
                                          deliveryOrder: currentOrder,
                                          receiptImageFile: File(''),
                                        ),
                                      );
                                }
                              : null)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isPrintEnabled
                        ? Colors.blue
                        : (isUpdateMode
                            ? Colors.orange
                            : (isSubmitEnabled
                                ? Colors.blue
                                : Colors.grey.shade300)),
                    foregroundColor:
                        isPrintEnabled || isUpdateMode || isSubmitEnabled
                            ? Colors.white
                            : Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade100,
                    disabledForegroundColor: Colors.grey.shade400,
                  ),
                  child: Text(
                    isPrintEnabled
                        ? 'PRINT_BUTTON'.tr
                        : (isUpdateMode
                            ? '署名を更新'.tr // "Update Signature"
                            : 'SUBMIT_BUTTON'.tr),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableHeaderCell(String text, int flex, bool isAlignRight) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        alignment: isAlignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          textAlign: isAlignRight ? TextAlign.right : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, int flex, bool isAlignRight) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        alignment: isAlignRight ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          text,
          textAlign: isAlignRight ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
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

  Future<void> _captureAndSaveReceiptOffscreen(
    BuildContext context,
    DeliveryOrder deliveryOrder,
    String receiptNumber,
  ) async {
    try {
      AppLoading.show();
      final appBloc = context.read<AppBloc>();
      // Check permissions first
      // bool permissionsGranted = await _checkAndRequestPermissions();
      // if (!permissionsGranted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('PERMISSION_REQUIRED'.tr),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      //   return;
      // }

      // Show temporary receipt view for capture
      setState(() {
        _showTemporaryReceiptView = true;
      });

      // Use a Completer to wait for the capture process to complete
      final completer = Completer<Uint8List?>();

      // Ensure all rendering is complete by using a post-frame callback
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Add a longer delay to ensure rendering is complete
        await Future.delayed(const Duration(milliseconds: 3000));

        try {
          // Find the repaint boundary by key
          final boundary = _repaintBoundaryKey.currentContext
              ?.findRenderObject() as RenderRepaintBoundary?;

          if (boundary == null) {
            completer.complete(null);
            return;
          }

          // Capture the image
          final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
          final ByteData? byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);

          if (byteData == null) {
            completer.complete(null);
            return;
          }

          final Uint8List pngBytes = byteData.buffer.asUint8List();
          completer.complete(pngBytes);
        } catch (e) {
          print('Error during capture: $e');
          completer.completeError(e);
        }
      });

      // Wait for the capture to complete
      final Uint8List? pngBytes = await completer.future;

      // Hide the temporary view now that we've captured the image
      setState(() {
        _showTemporaryReceiptView = false;
      });

      if (pngBytes == null) {
        throw Exception('Failed to capture receipt image');
      }

      // Generate a unique filename
      final String fileName =
          'receipt_${appBloc.state.deliveryOrder?.orderId}.png';

      // Create temporary file to save image
      final tempDir = await getApplicationDocumentsDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      // // Store the captured receipt image in the state
      // context.read<QrCodeFuelingDetailsBloc>().add(
      //       ReceiptCaptureCompleted(capturedImage: file),
      //     );

      // Upload captured receipt file and get ID
      try {
        final fileResponse = await FileUtil.uploadFile(file);
        if (fileResponse != null && fileResponse.id != null) {
          print('Receipt file uploaded successfully. ID: ${fileResponse.id}');

          try {
            if (mounted) {
              context
                  .read<QrCodeFuelingDetailsBloc>()
                  .add(UpdateReceiptFileId(fileResponse.id!));
            }
          } catch (e) {
            print('Error updating receipt file ID: $e');
          }
        }
      } catch (e) {
        print('Error uploading receipt file: $e');
      }

      // Show processing message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ORDER_PROCESSING'.tr),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error capturing receipt: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR_OCCURRED'.trParams({'message': e.toString()})),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      AppLoading.dismiss();
      setState(() {
        _showTemporaryReceiptView = false;
      });
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    if (Platform.isIOS) {
      if (await Permission.photos.isGranted) {
        return true;
      }
      return await Permission.photos.request().isGranted;
    }

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      if (await Permission.photos.isGranted) {
        return true;
      }
      return await Permission.photos.request().isGranted;
    }

    if (await Permission.storage.isGranted) {
      return true;
    }
    return await Permission.storage.request().isGranted;
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

    // Only apply scaling if necessary
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

      // Draw points for single taps with scaling
      for (int i = 0; i < points.length; i++) {
        if (!points[i]['isMoving']) {
          canvas.drawCircle(
            Offset(points[i]['x'] * scale + offsetX,
                points[i]['y'] * scale + offsetY),
            2.0,
            paint,
          );
        }
      }
    } else {
      // Draw without scaling if all points are within bounds
      // Draw all connected lines
      for (int i = 0; i < points.length - 1; i++) {
        if (points[i + 1]['isMoving']) {
          canvas.drawLine(
            Offset(points[i]['x'], points[i]['y']),
            Offset(points[i + 1]['x'], points[i + 1]['y']),
            paint,
          );
        }
      }

      // Also draw points (for single taps)
      for (int i = 0; i < points.length; i++) {
        if (!points[i]['isMoving']) {
          canvas.drawCircle(
            Offset(points[i]['x'], points[i]['y']),
            2.0,
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
