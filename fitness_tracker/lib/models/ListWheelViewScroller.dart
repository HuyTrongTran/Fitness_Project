import 'package:flutter/material.dart';
import '../utils/constants/colors .dart';

class Listwheelviewscroller extends StatelessWidget {
  final List<String> items;
  const Listwheelviewscroller({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      magnification: 1.3,
      useMagnifier: true,
      physics: FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(initialItem: items.length ~/ 2),
      overAndUnderCenterOpacity: 0.19,
      itemExtent: 50,
      diameterRatio: 1.5,
      children:
          items.map((level) {
            return Text(
              level,
              style: TextStyle(
                fontSize: 30, 
                color: contentColor,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
    );
  }
}
