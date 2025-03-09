import 'package:fitness_tracker/screens/signup.widgets/verify_email.dart';
import 'package:fitness_tracker/screens/signup.widgets/widgets/terms.conditions_checkbox.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                    contentPadding: EdgeInsets.all(TSizes.md),
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputfields),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                    contentPadding: EdgeInsets.all(TSizes.md),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),

          // Username
          TextFormField(
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
              contentPadding: EdgeInsets.all(TSizes.md),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),

          // Email
          TextFormField(
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.message_text),
              contentPadding: EdgeInsets.all(TSizes.md),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),

          // Password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: TTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
              contentPadding: EdgeInsets.all(TSizes.md),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Terms & Conditions
          const TermOfCondition(),

          const SizedBox(height: TSizes.spaceBtwItems),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const VerifyEmail()),
              child: const Text(TTexts.signUp),
            ),
          ),
        ],
      ),
    );
  }
}
