import 'package:fitness_tracker/common/styles/spacing_styles.dart';
import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subTitle, required this.onPressed});
  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHeght * 2,
          child: Column(
            children: [
              Image(image: AssetImage(image), width: HelpersFunction.screenWidth() * 0.6),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Title & Subtitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const Login()),
                  child: const Text(TTexts.iContinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
