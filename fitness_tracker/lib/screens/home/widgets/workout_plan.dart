import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class WorkoutPlan extends StatelessWidget {
  const WorkoutPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   'My Plan',
          //   style: Theme.of(
          //     context,
          //   ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: TSizes.spaceBtwItems / 2),
          // Text(
          //   'July, 2021',
          //   style: Theme.of(
          //     context,
          //   ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          // ),
          // const SizedBox(height: TSizes.spaceBtwItems),
          // Workout card
          Container(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: TColors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Week 1 header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(TSizes.sm),
                      decoration: const BoxDecoration(
                        color: TColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Iconsax.flash_1,
                        color: TColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WEEK 1',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                        Text(
                          'Body Weight',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Text(
                          'Workout 1 of 5',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                // Next exercise
                Container(
                  padding: const EdgeInsets.all(TSizes.md),
                  decoration: BoxDecoration(
                    color: TColors.primary,
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.play_arrow, size: 30, color: Colors.white),
                      const SizedBox(width: TSizes.spaceBtwItems),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next exercise',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: Colors.white),
                          ),
                          Text(
                            'Lower Strength',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
