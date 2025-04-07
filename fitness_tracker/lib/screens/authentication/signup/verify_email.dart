import 'package:fitness_tracker/common/widgets/success_screen/success_screen.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Get.offAll(() => const Login()),
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              //Image
              Image(
                image: const AssetImage(Images.verifyEmail),
                width: HelpersFunction.screenWidth() * 0.6,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Title & Subtitle
              Text(
                TTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'fitness.app@support.com.vn',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                TTexts.confirmEmailSubtitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      () => Get.to(
                        () => SuccessScreen(
                          image: Images.success,
                          title: TTexts.yourAccountCreatedTitle,
                          subTitle: TTexts.yourAccountCreatedSubtitle,
                          onPressed: () => Get.to(() => const Login()),
                        ),
                      ),
                  child: const Text(TTexts.iContinue),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(TTexts.resendEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
