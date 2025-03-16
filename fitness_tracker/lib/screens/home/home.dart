import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/search_bar.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/screens/home/widgets/homeAppBar.dart';
import 'package:fitness_tracker/screens/home/widgets/home_Categories.dart';
import 'package:fitness_tracker/screens/home/widgets/promo_slider.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelpersFunction.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  // Header
                  const HomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  SearchContainer(
                    text: TTexts.search,
                    icon: Iconsax.search_normal,
                    showBackground: true,
                    showBorder: dark ? false : true,
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        const SectionHeading(
                          title: "Popular Categories",
                          showActionButton: false,
                          textColor: TColors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),

                        // Categories
                        const HomeCategory(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: PromoSlider(banner: [Images.slider1, Images.slider2]),
            ),
          ],
        ),
      ),
    );
  }
}
