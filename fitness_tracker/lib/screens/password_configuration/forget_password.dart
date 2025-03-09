import 'package:fitness_tracker/screens/password_configuration/reset_password.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:iconsax/iconsax.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: TSizes.spaceBtwItems * 2),
            
            // TextField
            TextFormField(
              decoration: const InputDecoration(labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct_right)),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Button submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.off(() => const ResetPassword()),
                child: const Text(TTexts.submit),
              ),
            )
          ],
        ),
      ),
    );
  }
}
