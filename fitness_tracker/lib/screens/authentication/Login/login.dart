import 'package:fitness_tracker/common/styles/spacing_styles.dart';
import 'package:fitness_tracker/common/widgets/login_signup/form_divider.dart';
import 'package:fitness_tracker/common/widgets/login_signup/socialButton.dart';
import 'package:fitness_tracker/screens/authentication/Login/widgets/login_form.dart';
import 'package:fitness_tracker/screens/authentication/Login/widgets/login_header.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';

import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyles.paddingWithAppBarHeght,
          child: Column(
            children: [
              // Login Header
              LoginHeader(),
              // Login Form
              LoginForm(),

              // Divider
              // FormDivider(dividerText: TTexts.orSignInWith.capitalize!),
              // const SizedBox(height: TSizes.spaceBtwItems / 2),
              // Social Button
              // const Socialbutton(),
            ],
          ),
        ),
      ),
    );
  }
}
