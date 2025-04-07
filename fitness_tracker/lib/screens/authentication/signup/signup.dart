import 'package:fitness_tracker/common/widgets/login_signup/form_divider.dart';
import 'package:fitness_tracker/common/widgets/login_signup/socialButton.dart';
import 'package:fitness_tracker/screens/authentication/signup/widgets/signUpForm.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Image(
                height: 100,
                alignment: Alignment.centerLeft,
                fit: BoxFit.contain,
                image: AssetImage(
                  dark ? Images.darkAppLogo : Images.lightAppLogo,
                ),
              ),

              // Title & Subtitle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TTexts.signUp,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: TSizes.xs),
                  Text(
                    TTexts.signUpTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              const SizedBox(height: TSizes.spaceBtwItems),

              // Form
              const SignUpForm(),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Divider
              FormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwItems),

              // Social Buttons
              const Socialbutton(),
            ],
          ),
        ),
      ),
    );
  }
}