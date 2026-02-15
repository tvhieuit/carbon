import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import 'signature_painter.dart';

class SignatureSection extends StatelessWidget {
  final String? signatureUrl;
  final List<dynamic>? signaturePoints;
  final bool isEnabled;
  final VoidCallback? onTap;

  const SignatureSection({
    super.key,
    this.signatureUrl,
    this.signaturePoints,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSignatureUrl = signatureUrl != null;
    final hasLocalSignature =
        signaturePoints != null && signaturePoints!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '受領サイン',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '現場責任者からサインを取得してください',
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: isEnabled ? onTap : null,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: hasSignatureUrl
                    ? Image.network(
                        signatureUrl!,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Text(
                              '署名の読み込みに失敗しました',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      )
                    : hasLocalSignature
                        ? CustomPaint(
                            size: Size(
                                MediaQuery.of(context).size.width - 16, 250),
                            painter:
                                SignaturePainter(points: signaturePoints!),
                          )
                        : Center(
                            child: Text(
                              isEnabled
                                  ? 'タップしてサインを取得'
                                  : 'サインは不要です',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shows the signature pad dialog and returns the signature file path if saved.
Future<SignatureResult?> showSignaturePadDialog(
  BuildContext context, {
  required String orderId,
}) async {
  final screenSize = MediaQuery.of(context).size;
  final dialogWidth = screenSize.width - 8;
  final dialogHeight = screenSize.height * 0.7;
  final signatureWidth = dialogWidth - 4;
  final signatureHeight = dialogHeight * 0.53;

  return showDialog<SignatureResult>(
    context: context,
    builder: (dialogContext) {
      List<Map<String, dynamic>> tempPoints = [];

      return StatefulBuilder(
        builder: (dialogContext, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            insetPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: SizedBox(
              width: dialogWidth,
              height: dialogHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Text(
                          '受領サイン',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Positioned(
                          right: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Instruction
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      '現場責任者からサインを取得してください',
                      style: TextStyle(
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
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: IconButton(
                            icon: const Icon(Icons.refresh,
                                color: Colors.grey, size: 28),
                            onPressed: () {
                              setState(() => tempPoints = []);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                            child: const Text(
                              'キャンセル',
                              style: TextStyle(
                                  color: Colors.blue, fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (tempPoints.isEmpty) {
                                ScaffoldMessenger.of(dialogContext)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text('サインを入力してください'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              // Convert signature to image file
                              final filePath =
                                  await _saveSignatureToFile(
                                tempPoints,
                                signatureWidth,
                                signatureHeight,
                                orderId,
                              );

                              if (dialogContext.mounted) {
                                Navigator.pop(
                                  dialogContext,
                                  SignatureResult(
                                    points: tempPoints,
                                    filePath: filePath,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                            ),
                            child: const Text('保存',
                                style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<String> _saveSignatureToFile(
  List<Map<String, dynamic>> points,
  double width,
  double height,
  String orderId,
) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = Size(width, height);

  // Draw white background
  final bgPaint = Paint()..color = Colors.white;
  canvas.drawRect(Offset.zero & size, bgPaint);

  // Draw signature
  final signaturePainter = SignaturePainter(points: points);
  signaturePainter.paint(canvas, size);

  // Convert to image
  final picture = recorder.endRecording();
  final img = await picture.toImage(size.width.toInt(), size.height.toInt());
  final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  final pngBytes = byteData!.buffer.asUint8List();

  // Save to documents directory
  final tempDir = await getApplicationDocumentsDirectory();
  final file = File(path.join(tempDir.path, 'signature_$orderId.png'));
  await file.writeAsBytes(pngBytes);

  return file.path;
}

class SignatureResult {
  final List<Map<String, dynamic>> points;
  final String filePath;

  SignatureResult({required this.points, required this.filePath});
}
