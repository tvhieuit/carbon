import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '../../l10n/l10n.dart';
import 'fueling_details_bloc.dart';
import 'widgets/machinery_table.dart';
import 'widgets/non_oil_products_table.dart';
import 'widgets/receipt_view.dart';
import 'widgets/signature_section.dart';

@RoutePage()
class FuelingDetailsPage extends StatelessWidget {
  final String orderId;
  final String? machineId;
  final DeliveryOrderEntity? deliveryOrder;

  const FuelingDetailsPage({
    super.key,
    @pathParam required this.orderId,
    this.machineId,
    this.deliveryOrder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<FuelingDetailsBloc>()
        ..add(FuelingDetailsEvent.initialized(
          orderId: orderId,
          machineId: machineId,
        )),
      child: _FuelingDetailsView(deliveryOrder: deliveryOrder),
    );
  }
}

class _FuelingDetailsView extends StatefulWidget {
  final DeliveryOrderEntity? deliveryOrder;

  const _FuelingDetailsView({this.deliveryOrder});

  @override
  State<_FuelingDetailsView> createState() => _FuelingDetailsViewState();
}

class _FuelingDetailsViewState extends State<_FuelingDetailsView> {
  List<dynamic>? _signaturePoints;
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  bool _showTemporaryReceiptView = false;
  String? _tempReceiptNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = context.feulingDetailL10n;

    return BlocConsumer<FuelingDetailsBloc, FuelingDetailsState>(
      listener: (context, state) {
        if (state.isSubmitSuccess && state.receiptNumber != null) {
          setState(() {
            _tempReceiptNumber = state.receiptNumber;
          });

          if (widget.deliveryOrder != null) {
            _captureReceiptOffscreen(
              context,
              widget.deliveryOrder!,
              state.receiptNumber!,
            );
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  l10n.submit_success_message(state.receiptNumber!)),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF2F4F7),
          appBar: AppBar(
            title: Text(l10n.fueling_details_title),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (state.isPrintEnabled) {
                  context.router.popUntilRoot();
                } else {
                  context.maybePop();
                }
              },
            ),
          ),
          body: Stack(
            children: [
              _buildContent(context, state),

              if (_showTemporaryReceiptView && widget.deliveryOrder != null)
                Opacity(
                  opacity: 0.01,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: Material(
                        color: Colors.white,
                        child: ReceiptView(
                          deliveryOrder: widget.deliveryOrder!,
                          signaturePoints: _signaturePoints,
                          receiptNumber: _tempReceiptNumber ?? '',
                        ),
                      ),
                    ),
                  ),
                ),

              if (state.isLoading || state.isSubmitting)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: Center(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(state.isSubmitting
                                ? l10n.submitting_text
                                : l10n.loading_text),
                          ],
                        ),
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

  Widget _buildContent(BuildContext context, FuelingDetailsState state) {
    final l10n = context.feulingDetailL10n;
    final deliveryOrder = widget.deliveryOrder;
    if (deliveryOrder == null) {
      return Center(child: Text(l10n.no_order_info));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, deliveryOrder),
            MachineryTable(machines: deliveryOrder.constructionMachines),
            const SizedBox(height: 8),
            NonOilProductsTable(receiptLines: deliveryOrder.receiptLines),
            SignatureSection(
              signatureUrl: state.signatureUrl,
              signaturePoints: _signaturePoints,
              isEnabled: !state.isPrintEnabled && state.isSubmitEnabled,
              onTap: () => _onSignatureTap(context, deliveryOrder),
            ),
            _buildBottomButtons(context, state, deliveryOrder),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, DeliveryOrderEntity deliveryOrder) {
    final l10n = context.feulingDetailL10n;
    final now = DateTime.now();
    final year = now.year - 2018;
    final dayOfWeek = _getDayOfWeekL10n(l10n, now.weekday);
    final japaneseDate =
        l10n.reiwa_date_format(year, now.month, now.day, dayOfWeek);

    return Container(
      width: double.infinity,
      color: const Color(0xFFF2F4F7),
      padding:
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            deliveryOrder.constructionSiteId,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            japaneseDate,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    FuelingDetailsState state,
    DeliveryOrderEntity deliveryOrder,
  ) {
    final l10n = context.feulingDetailL10n;
    final hasSignature =
        _signaturePoints != null && _signaturePoints!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (state.isPrintEnabled) {
                  context.router.popUntilRoot();
                } else {
                  context.maybePop();
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
                l10n.button_back,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: state.isPrintEnabled
                  ? () => context
                      .read<FuelingDetailsBloc>()
                      .add(const FuelingDetailsEvent.printRequested())
                  : (state.isSubmitEnabled && hasSignature
                      ? () => _onSubmit(context, deliveryOrder)
                      : null),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isPrintEnabled
                    ? Colors.blue
                    : (state.isSubmitEnabled && hasSignature
                        ? Colors.blue
                        : Colors.grey.shade300),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.grey.shade100,
                disabledForegroundColor: Colors.grey.shade400,
              ),
              child: Text(
                state.isPrintEnabled
                    ? l10n.button_print
                    : l10n.button_submit,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSignatureTap(
      BuildContext context, DeliveryOrderEntity deliveryOrder) async {
    final l10n = context.feulingDetailL10n;
    final result = await showSignaturePadDialog(
      context,
      orderId: deliveryOrder.orderId,
    );

    if (result != null && mounted) {
      setState(() {
        _signaturePoints = result.points;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.signature_saved),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _onSubmit(
      BuildContext context, DeliveryOrderEntity deliveryOrder) {
    final signatureFilePath =
        _signaturePoints != null && _signaturePoints!.isNotEmpty
            ? 'signature_${deliveryOrder.orderId}.png'
            : '';

    context.read<FuelingDetailsBloc>().add(
          FuelingDetailsEvent.orderSubmitted(
            deliveryOrder: deliveryOrder,
            signatureFilePath: signatureFilePath,
          ),
        );
  }

  Future<void> _captureReceiptOffscreen(
    BuildContext context,
    DeliveryOrderEntity deliveryOrder,
    String receiptNumber,
  ) async {
    final l10n = context.feulingDetailL10n;

    setState(() {
      _showTemporaryReceiptView = true;
    });

    final completer = Completer<Uint8List?>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 3000));

      try {
        final boundary = _repaintBoundaryKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary?;

        if (boundary == null) {
          completer.complete(null);
          return;
        }

        final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        final ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        if (byteData == null) {
          completer.complete(null);
          return;
        }

        completer.complete(byteData.buffer.asUint8List());
      } catch (e) {
        completer.completeError(e);
      }
    });

    try {
      final pngBytes = await completer.future;

      setState(() {
        _showTemporaryReceiptView = false;
      });

      if (pngBytes == null) return;

      final tempDir = await getApplicationDocumentsDirectory();
      final file = File(
          '${tempDir.path}/receipt_${deliveryOrder.orderId}.png');
      await file.writeAsBytes(pngBytes);

      // TODO: Upload file and update receipt file ID via BLoC
    } catch (e) {
      setState(() {
        _showTemporaryReceiptView = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.capture_error}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
