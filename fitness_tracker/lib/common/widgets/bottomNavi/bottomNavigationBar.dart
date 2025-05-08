import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class TBottomNavigationBar extends StatelessWidget {
  const TBottomNavigationBar({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });
  final String label;
  final IconData? icon;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.fontSizeSm),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
