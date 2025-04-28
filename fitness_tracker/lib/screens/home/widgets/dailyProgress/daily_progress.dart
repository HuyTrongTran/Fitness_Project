import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'dart:io';

class DailyProgress extends StatefulWidget {
  final double? distance;
  final double? distanceGoal;
  final int? calories;
  final int? caloriesGoal;
  final int? steps;
  final int? stepsGoal;

  const DailyProgress({
    Key? key,
    this.distance,
    this.distanceGoal,
    this.calories,
    this.caloriesGoal,
    this.steps,
    this.stepsGoal,
  }) : super(key: key);

  @override
  State<DailyProgress> createState() => _DailyProgressState();
}

class _DailyProgressState extends State<DailyProgress>
    with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.distance == null ||
        widget.distanceGoal == null ||
        widget.calories == null ||
        widget.caloriesGoal == null ||
        widget.steps == null ||
        widget.stepsGoal == null) {
      return const LoadingPlaceholder();
    }

    _controller.forward();

    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 20.0,
                bottom: 10.0,
              ),
              child: Text(
                'Daily progress',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableWidth = constraints.maxWidth;
                  final ringSize = availableWidth * 0.45;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: ringSize,
                        height: ringSize,
                        child: CustomPaint(
                          painter: ProgressRingsPainter(
                            distanceProgress:
                                widget.distance! / widget.distanceGoal!,
                            caloriesProgress:
                                widget.calories! / widget.caloriesGoal!,
                            stepsProgress: widget.steps! / widget.stepsGoal!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildProgressDetail(
                              color: const Color(0xFF99CCFF),
                              label: 'Distance',
                              value:
                                  '${widget.distance!.toStringAsFixed(1)} km',
                              goal:
                                  '/${widget.distanceGoal!.toStringAsFixed(1)} km',
                              context: context,
                            ),
                            const SizedBox(height: 20),
                            _buildProgressDetail(
                              color: const Color(0xFFFF9999),
                              label: 'Steps',
                              value: widget.steps!.toString(),
                              goal: '/${widget.stepsGoal}',
                              context: context,
                            ),
                            const SizedBox(height: 20),
                            _buildProgressDetail(
                              color: const Color(0xFFFFCC99),
                              label: 'Calories',
                              value: widget.calories!.toString(),
                              goal: '/${widget.caloriesGoal}',
                              context: context,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDetail({
    required Color color,
    required String label,
    required String value,
    required String goal,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Text(
                      value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      goal,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoadingPlaceholder extends StatelessWidget {
  const LoadingPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
          child: Container(
            width: 180,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9FF),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FF),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          height: 180,
          width: double.infinity,
        ),
      ],
    );
  }
}

class ProgressRingsPainter extends CustomPainter {
  final double distanceProgress;
  final double caloriesProgress;
  final double stepsProgress;

  ProgressRingsPainter({
    required this.distanceProgress,
    required this.caloriesProgress,
    required this.stepsProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.08;
    final gap = strokeWidth * 0.8;

    _drawProgressRing(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - strokeWidth / 2,
      progress: distanceProgress,
      color: const Color(0xFF99CCFF),
      strokeWidth: strokeWidth,
    );

    _drawProgressRing(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - strokeWidth - gap - strokeWidth / 2,
      progress: caloriesProgress,
      color: const Color(0xFFFF9999),
      strokeWidth: strokeWidth,
    );

    _drawProgressRing(
      canvas: canvas,
      center: center,
      radius: size.width / 2 - (strokeWidth + gap) * 2 - strokeWidth / 2,
      progress: stepsProgress,
      color: const Color(0xFFFFCC99),
      strokeWidth: strokeWidth,
    );
  }

  void _drawProgressRing({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double progress,
    required Color color,
    required double strokeWidth,
  }) {
    final paint =
        Paint()
          ..color = color.withOpacity(0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, paint);

    paint.color = color;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paint);

    if (progress > 0) {
      final endAngle = -pi / 2 + 2 * pi * progress;
      final endPoint = Offset(
        center.dx + radius * cos(endAngle),
        center.dy + radius * sin(endAngle),
      );

      canvas.drawCircle(
        endPoint,
        strokeWidth / 2.5,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(endPoint, strokeWidth / 3.5, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
