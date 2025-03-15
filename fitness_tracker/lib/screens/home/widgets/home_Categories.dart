import 'package:fitness_tracker/common/widgets/image_text/vertical_image_text.dart';
import 'package:fitness_tracker/screens/Login/widgets/login_header.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitness_tracker/screens/signup.widgets/signup.dart';


class HomeCategory extends StatelessWidget {
  const HomeCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          VerticalImageText(
            image: Images.heart,
            title: "Move your body",
            onTap: () => Get.to(() => const Signup()),
          ),
          VerticalImageText(
            image: Images.heart,
            title: "Healthy Eating",
            onTap: () => Get.to(() => const OnboardingScreen()),
          ),
        ],
      ),
    );
  }
}

