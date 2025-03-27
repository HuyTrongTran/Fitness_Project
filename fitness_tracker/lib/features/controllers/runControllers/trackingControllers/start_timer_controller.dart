import 'dart:async';
import 'package:flutter/material.dart';

class StartTimerController {
  Timer? _timer;

  void startTimer(Function(int) onTimeUpdated) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      onTimeUpdated(timer.tick);
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}