import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/features/services/home_services/recent_plan/get_recent_plan.dart';

class DetailSuggest extends StatelessWidget {
  final SuggestFood suggestFood;

  const DetailSuggest({super.key, required this.suggestFood});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.4;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: PrimaryHeaderContainer(
                  child: Column(
                    children: [
                      TAppBar(
                        title: Text(
                          suggestFood.title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge!.copyWith(
                                color: TColors.white,
                                fontWeight: FontWeight.bold,
                              ),
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

              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Padding(
                      padding: const EdgeInsets.all(TSizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: TSizes.defaultSpace,
                            ),
                            child: Text(
                              suggestFood.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(height: TSizes.spaceBtwInputfields),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: suggestFood.steps.length,
                            itemBuilder: (context, index) {
                              final step = suggestFood.steps[index];
                              return _buildStep(
                                context,
                                number: "${step.stepNumber}",
                                text: step.instruction,
                                isLast: index == suggestFood.steps.length - 1,
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
                child: Image.network(
                  suggestFood.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(Images.chicken, fit: BoxFit.cover);
                  },
                ),
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
    double getLineHeight() {
      if (text.length < 50) return 30;
      if (text.length < 80) return 40;
      return 50;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Expanded(
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
      ],
    );
  }
}