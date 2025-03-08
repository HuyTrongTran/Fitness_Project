import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import "package:flutter/material.dart";
import 'package:fitness_tracker/utils/constants/image_strings.dart';

import '../../../utils/constants/text_strings.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            children: [
              Column(
                children: [
                  Image(
                    width: HelpersFunction.screenWidth() * 0.8,
                    height: HelpersFunction.screenHeight() * 0.6,
                    image: AssetImage(Images.onBoardingImage1),
                  ),
                  Text(
                    TTexts.onBoardingTitle1,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems,),
                  Text(
                    TTexts.onBoardingTitle1,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
