import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SineWavePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  SineWavePainter({
    this.color = AppColors.primary,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height / 2;
    final amplitude = size.height / 2.5;
    const periods = 2.0;

    for (double x = 0; x <= size.width; x += 1) {
      final y = midY + amplitude * math.sin((x / size.width) * (2 * math.pi * periods));
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SineWavePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
  }
}

