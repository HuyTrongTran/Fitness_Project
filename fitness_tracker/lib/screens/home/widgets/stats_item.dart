import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';

class Stat_Item extends StatelessWidget {
  const Stat_Item({
    super.key,
    required this.context,
    required this.value,
    required this.label,
    required this.icon,
    required this.current,
    required this.target,
  });

  final BuildContext context;
  final String value;
  final String label;
  final IconData icon;
  final double current;
  final double target;

  @override
  Widget build(BuildContext context) {
    // Tính toán phần trăm progress
    final double progress = (current / target).clamp(0.0, 1.0);
    final dark = HelpersFunction.isDarkMode(context);

    return Container(
      width: 85,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 85,
                height: 85,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey.withOpacity(0.1),
                  color: dark ? TColors.primary : TColors.primary,
                ),
              ),
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: dark ? TColors.primary : TColors.black,
                  size: 28,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: dark ? TColors.white : TColors.primary,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: dark ? TColors.white : TColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
