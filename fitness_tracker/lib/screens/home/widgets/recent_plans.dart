import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';

class RecentPlans extends StatelessWidget {
  const RecentPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Plan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'See All',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: TColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            'July, 2021',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          // Recent plans grid
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPlanItem(
                context,
                icon: Icons.star,
                title: 'Special',
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Icons.beach_access,
                title: 'Beach Ready',
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Icons.fitness_center,
                title: 'Full-Body',
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Icons.emoji_events,
                title: 'Challenge',
                color: TColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
