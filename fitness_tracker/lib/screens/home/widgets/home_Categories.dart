import 'package:fitness_tracker/common/widgets/image_text/vertical_image_text.dart';
import 'package:fitness_tracker/screens/onboardingFeature/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_tracker/screens/authentication/signup/signup.dart';

class HomeCategory extends StatelessWidget {
  const HomeCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md,
          vertical: TSizes.sm,
        ),
        decoration: BoxDecoration(
          color: dark ? TColors.dark : TColors.light,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: dark ? null : Border.all(color: TColors.grey),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            VerticalImageText(
              image: Images.dumbbell,
              title: "Move y...",
              onTap: () => Get.to(() => const Signup()),
            ),
            VerticalImageText(
              image: Images.dumbbell,
              title: "Healthy...",
              onTap: () => Get.to(() => const OnboardingScreen()),
            ),
          ],
        ),
      ),
    );
  }
}
