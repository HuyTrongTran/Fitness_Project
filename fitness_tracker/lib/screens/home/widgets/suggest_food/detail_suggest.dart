import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class DetailSuggest extends StatelessWidget {
  const DetailSuggest({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenWidth * 0.4; // 40% chiều rộng màn hình

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: PrimaryHeaderContainer(
                  child: Column(
                    children: [
                      TAppBar(
                        title: Text(
                          "Grilled chicken with vegetables",
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.apply(color: TColors.white),
                        ),
                        showBackButton: true,
                        centerTitle: true,
                        color: TColors.white,
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Description
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace,
                            ),
                            child: Text(
                              "A light salad with lean chicken breast and fresh greens, drizzled with a touch of olive oil for flavor.",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputfields),

                          // Steps
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              final steps = [
                                "Peel and chop 200g pumpkin into small pieces.",
                                "Boil pumpkin in 300ml water for 15 minutes until soft.",
                                "Blend until smooth (use a blender or mash by hand), season with a pinch of salt and pepper.",
                                "Reheat for 2 minutes, serve hot.",
                              ];
                              return _buildStep(
                                context,
                                number: "${index + 1}",
                                text: steps[index],
                                isLast: index == steps.length - 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Centered Image
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25 - (imageSize / 2),
            left: (screenWidth - imageSize) / 2,
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(Images.chicken, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String text,
    required bool isLast,
  }) {
    // Tính toán chiều dài line dựa vào độ dài của text
    double getLineHeight() {
      if (text.length < 50) return 30;
      if (text.length < 80) return 40;
      return 50;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Step Number with Circles
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: TColors.primary, width: 2),
                ),
                child: Center(
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: Theme.of(context).textTheme.bodySmall!.apply(
                          color: TColors.white,
                          fontWeightDelta: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  height: getLineHeight(),
                  width: 2,
                  color: TColors.primary,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
            ],
          ),
        ),
        const SizedBox(width: TSizes.spaceBtwItems),

        // Step Text
        Expanded(
          child: Container(
            height: 40, // Chiều cao bằng với step number
            alignment:
                Alignment
                    .centerLeft, // Căn giữa theo chiều dọc, căn trái theo chiều ngang
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}
