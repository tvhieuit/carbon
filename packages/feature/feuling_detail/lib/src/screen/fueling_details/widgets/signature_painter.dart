import 'dart:math' as math;

import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {
  final List<dynamic> points;

  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0
      ..strokeJoin = StrokeJoin.round;

    if (points.isEmpty) return;

    bool needsScaling = false;
    double minX = double.infinity;
    double maxX = 0;
    double minY = double.infinity;
    double maxY = 0;

    for (final point in points) {
      final x = (point['x'] as num).toDouble();
      final y = (point['y'] as num).toDouble();

      if (x < minX) minX = x;
      if (x > maxX) maxX = x;
      if (y < minY) minY = y;
      if (y > maxY) maxY = y;

      if (x < 0 || x > size.width || y < 0 || y > size.height) {
        needsScaling = true;
      }
    }

    if (needsScaling && maxX > minX && maxY > minY) {
      final scaleX = (size.width - 20) / (maxX - minX);
      final scaleY = (size.height - 20) / (maxY - minY);
      final scale = math.min(scaleX, scaleY);

      final offsetX =
          10 + (size.width - (maxX - minX) * scale) / 2 - minX * scale;
      final offsetY =
          10 + (size.height - (maxY - minY) * scale) / 2 - minY * scale;

      _drawPoints(canvas, paint, scale: scale, offsetX: offsetX, offsetY: offsetY);
    } else {
      _drawPoints(canvas, paint);
    }
  }

  void _drawPoints(
    Canvas canvas,
    Paint paint, {
    double scale = 1.0,
    double offsetX = 0.0,
    double offsetY = 0.0,
  }) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i + 1]['isMoving'] == true) {
        canvas.drawLine(
          Offset(
            (points[i]['x'] as num).toDouble() * scale + offsetX,
            (points[i]['y'] as num).toDouble() * scale + offsetY,
          ),
          Offset(
            (points[i + 1]['x'] as num).toDouble() * scale + offsetX,
            (points[i + 1]['y'] as num).toDouble() * scale + offsetY,
          ),
          paint,
        );
      }
    }

    for (int i = 0; i < points.length; i++) {
      if (points[i]['isMoving'] != true) {
        canvas.drawCircle(
          Offset(
            (points[i]['x'] as num).toDouble() * scale + offsetX,
            (points[i]['y'] as num).toDouble() * scale + offsetY,
          ),
          2.0,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) => true;
}
