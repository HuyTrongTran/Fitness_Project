import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';

class SuggestHeader extends StatelessWidget {
  const SuggestHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    final double headerWidth = MediaQuery.of(context).size.width * 0.9;
    return SizedBox(
      width: headerWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi! I'm FitBot",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            "Here is some suggest for today 🔥",
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: TColors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
