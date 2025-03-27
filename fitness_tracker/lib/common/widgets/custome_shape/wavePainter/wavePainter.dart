import 'package:flutter/material.dart';
import 'dart:math' as math;

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Tính trung tâm của màn hình
    final center = Offset(size.width / 2, size.height / 2);

    // Số lượng vòng tròn
    const int numberOfCircles = 10;
    // Bán kính tối đa (dựa trên kích thước màn hình)
    final maxRadius = math.sqrt(size.width * size.width + size.height * size.height) / 2;

    for (int i = 0; i < numberOfCircles; i++) {
      // Tính bán kính cho từng vòng tròn
      final radius = (i + 1) * (maxRadius / numberOfCircles);

      // Tạo paint với độ dày và độ trong suốt giảm dần
      final paint = Paint()
        ..color = Colors.white.withOpacity(0.3 - (i * 0.02)) // Giảm opacity dần
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 - (i * 0.2); // Giảm độ dày dần

      // Vẽ vòng tròn
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}