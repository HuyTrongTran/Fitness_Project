import 'package:fitness_tracker/common/widget.login_signup/form_divider.dart';
import 'package:fitness_tracker/common/widget.login_signup/socialButton.dart';
import 'package:fitness_tracker/screens/signup.widgets/widgets/signUpForm.dart';
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
          padding: const EdgeInsets.all(TSizes.dividerHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: TSizes.md),
                child: Image(
                  height: 100,
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.contain,
                  image: AssetImage(
                    dark ? Images.darkAppLogo : Images.lightAppLogo,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: TSizes.md),
                child: Column(
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
              ),

              const SizedBox(height: TSizes.spaceBtwSections),
              //Form
              const SignUpForm(),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Divider
              FormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Social Login
              const Socialbutton(),
            ],
          ),
        ),
      ),
    );
  }
}
