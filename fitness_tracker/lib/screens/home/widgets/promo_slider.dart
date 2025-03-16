import 'package:carousel_slider/carousel_slider.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_container.dart';
import 'package:fitness_tracker/common/widgets/images/images_rounded.dart';
import 'package:fitness_tracker/features/controllers/home_controller.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PromoSlider extends StatelessWidget {
  const PromoSlider({super.key, required this.banner});

  final List<String> banner;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          items: banner.map((e) => Roundedimage(imageUrl: e)).toList(),
          options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
            // aspectRatio: 16/9,
            // autoPlayInterval: const Duration(seconds: 3),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < banner.length; i++)
                CircularContainer(
                  width: 20,
                  height: 4,
                  margin: EdgeInsets.only(right: 10),
                  backgroundColor:
                      controller.carouselCurrentIndex.value == i
                          ? TColors.primary
                          : TColors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
