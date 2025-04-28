import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final VoidCallback? onFinished;

  const AnimatedText({
    Key? key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 1500),
    this.onFinished,
  }) : super(key: key);

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  String _displayedText = '';
  late int _charCount;
  late Duration _stepDuration;

  @override
  void initState() {
    super.initState();
    _charCount = widget.text.length;
    _stepDuration = Duration(
      microseconds: (widget.duration.inMicroseconds / _charCount).round(),
    );
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i <= widget.text.length; i++) {
      if (mounted) {
        setState(() {
          _displayedText = widget.text.substring(0, i);
        });
        await Future.delayed(_stepDuration);
      }
    }
    widget.onFinished?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Text(_displayedText, style: widget.style);
  }
}
