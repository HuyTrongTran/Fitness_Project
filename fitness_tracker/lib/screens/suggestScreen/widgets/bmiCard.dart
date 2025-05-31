import 'package:flutter/material.dart';
import 'dart:math' as math;

class BMICard extends StatefulWidget {
  final double bmi;
  const BMICard({super.key, required this.bmi});

  @override
  State<BMICard> createState() => _BMICardState();
}

class _BMICardState extends State<BMICard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    // Tự động chạy animation khi widget được tạo
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getBMICategory() {
    if (widget.bmi < 18.5) {
      return "Underweight";
    } else if (widget.bmi < 23) {
      return "Normal";
    } else if (widget.bmi < 25) {
      return "Overweight";
    } else {
      return "Obese";
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.9;
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: Container(
            width: cardWidth,
            height: 170,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF94A9FF), Color(0xFF8B9FFF)],
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF94A9FF).withOpacity(0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Bubble effects
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 32,
                  top: 32,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.13),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 16,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Text content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Your BMI',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(Body Mass Index)',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: Colors.white.withOpacity(0.7)),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8B7FF),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE8B7FF).withOpacity(0.7),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              getBMICategory(),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Right side - Pie chart + số BMI
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(120, 120),
                              painter: _BMIPiePainter(),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8B7FF),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE8B7FF).withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.bmi.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BMIPiePainter extends CustomPainter {
  _BMIPiePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2; // Bán kính ngoài cùng (pie chart)
    final innerRadius =
        size.width / 2 * 0.78; // Bán kính vòng tròn nền trắng nhỏ hơn

    // Vẽ pie chart (cung tròn lớn, gradient)
    final sweepAngle = 2 * math.pi; // Vẽ full vòng tròn
    final piePaint =
        Paint()
          ..shader = const LinearGradient(
            colors: [Color(0xFFE8B7FF), Color(0xFFB18AFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = outerRadius - innerRadius; // Độ dày cung tròn

    // Vẽ cung tròn (arc)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: (outerRadius + innerRadius) / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      piePaint,
    );

    // Vẽ vòng tròn nền trắng nhỏ hơn ở giữa
    final bgPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius, bgPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
