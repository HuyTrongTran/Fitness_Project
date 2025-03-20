import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon,
    required this.showBackground,
    required this.showBorder,
  });

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Iconsax.search_normal,
            color: TColors.darkerGrey,
          ),
          hintText: TTexts.search,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          filled: showBackground,
          fillColor:
              showBackground
                  ? dark
                      ? TColors.dark
                      : TColors.light
                  : Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            borderSide:
                showBorder
                    ? const BorderSide(color: TColors.grey)
                    : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            borderSide:
                showBorder
                    ? const BorderSide(color: TColors.grey)
                    : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            borderSide: const BorderSide(color: TColors.primary),
          ),
          contentPadding: const EdgeInsets.all(TSizes.md),
        ),
      ),
    );
  }
}
