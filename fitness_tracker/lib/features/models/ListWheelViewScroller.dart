import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

class Listwheelviewscroller extends StatelessWidget {
  final List<String> items;
  final void Function(int)? onSelectedItemChanged;
  final int? initialItem;

  const Listwheelviewscroller({
    super.key,
    required this.items,
    this.onSelectedItemChanged,
    this.initialItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      magnification: 1.3,
      useMagnifier: true,
      physics: const FixedExtentScrollPhysics(),
      controller: FixedExtentScrollController(
        initialItem: initialItem ?? items.length ~/ 2,
      ),
      overAndUnderCenterOpacity: 0.19,
      itemExtent: 50,
      diameterRatio: 1.5,
      onSelectedItemChanged: onSelectedItemChanged,
      children:
          items.map((level) {
            return Text(
              level,
              style: const TextStyle(
                fontSize: 30,
                color: TColors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          }).toList(),
    );
  }
}
