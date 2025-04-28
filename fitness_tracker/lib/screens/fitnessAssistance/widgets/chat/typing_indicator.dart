import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final bool isTyping;
  const TypingIndicator({Key? key, required this.isTyping}) : super(key: key);

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  final int _numberOfDots = 3;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
      _numberOfDots,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400),
        vsync: this,
      ),
    );

    _animations =
        _animationControllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
        }).toList();

    _startAnimation();
  }

  void _startAnimation() {
    if (widget.isTyping) {
      for (var i = 0; i < _numberOfDots; i++) {
        Future.delayed(Duration(milliseconds: i * 200), () {
          if (mounted) {
            _animationControllers[i].repeat(reverse: true);
          }
        });
      }
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTyping != widget.isTyping) {
      if (widget.isTyping) {
        _startAnimation();
      } else {
        for (var controller in _animationControllers) {
          controller.stop();
        }
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isTyping) return SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_numberOfDots, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(
                  0.5 + _animations[index].value * 0.5,
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}
