import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_scan_bloc.dart';
import '../../l10n/l10n.dart';

@RoutePage()
class QrScanPage extends StatelessWidget {
  const QrScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QrScanBloc()..add(const QrScanEvent.started()),
      child: const _QrScanView(),
    );
  }
}

class _QrScanView extends StatefulWidget {
  const _QrScanView();

  @override
  State<_QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<_QrScanView> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.qrScanL10n;
    // AppBar and Button color: Mint Green (roughly #3CD9A0 or similar)
    const primaryMint = Color(0xFF3CD9A0);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: primaryMint,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.qr_scan_title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const SizedBox.shrink(), // No back button needed if Close button is present
      ),
      body: Stack(
        children: [
          // 1. Mobile Scanner
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                context.read<QrScanBloc>().add(QrScanEvent.qrCodeDetected(barcode));
              }
            },
            errorBuilder: (context, error, child) {
              context.read<QrScanBloc>().add(QrScanEvent.errorOccurred(error));
              return const SizedBox.shrink();
            },
          ),

          // 2. Overlay Background (Semi-transparent)
          const _ScannerOverlay(),

          // 3. UI Content
          Column(
            children: [
              const SizedBox(height: 80),
              // "Scan your QR Code" Text
              Center(
                child: Text(
                  l10n.scan_your_qr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              // Camera Error Text (as shown in image)
              BlocBuilder<QrScanBloc, QrScanState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    error: (error) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.camera_error,
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          Text(
                            error.errorCode.toString(),
                            style: const TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(),
                  );
                },
              ),
              const Spacer(),
              // Close Button
              Padding(
                padding: const EdgeInsets.only(left: 32, right: 32, bottom: 48),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.router.pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryMint,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.qr_code_scanner_outlined, color: Colors.white, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          l10n.close_button,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    const primaryMint = Color(0xFF3CD9A0);

    return Stack(
      children: [
        // Semi-transparent background with a hole
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 280,
                  width: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Corner borders
        Align(
          alignment: Alignment.center,
          child: Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                _buildCorner(Alignment.topLeft, primaryMint),
                _buildCorner(Alignment.topRight, primaryMint),
                _buildCorner(Alignment.bottomLeft, primaryMint),
                _buildCorner(Alignment.bottomRight, primaryMint),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    const double length = 40;
    const double thickness = 6;
    const double radius = 20;

    return Align(
      alignment: alignment,
      child: Container(
        width: length,
        height: length,
        child: CustomPaint(
          painter: _CornerPainter(alignment, color, thickness, radius),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Alignment alignment;
  final Color color;
  final double thickness;
  final double radius;

  _CornerPainter(this.alignment, this.color, this.thickness, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (alignment == Alignment.topLeft) {
      path.moveTo(0, length(size));
      path.lineTo(0, radius);
      path.quadraticBezierTo(0, 0, radius, 0);
      path.lineTo(length(size), 0);
    } else if (alignment == Alignment.topRight) {
      path.moveTo(size.width - length(size), 0);
      path.lineTo(size.width - radius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, radius);
      path.lineTo(size.width, length(size));
    } else if (alignment == Alignment.bottomLeft) {
      path.moveTo(0, size.height - length(size));
      path.lineTo(0, size.height - radius);
      path.quadraticBezierTo(0, size.height, radius, size.height);
      path.lineTo(length(size), size.height);
    } else if (alignment == Alignment.bottomRight) {
      path.moveTo(size.width - length(size), size.height);
      path.lineTo(size.width - radius, size.height);
      path.quadraticBezierTo(size.width, size.height, size.width, size.height - radius);
      path.lineTo(size.width, size.height - length(size));
    }

    canvas.drawPath(path, paint);
  }

  double length(Size size) => size.width;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
