import 'package:fitness_tracker/screens/activitiesScreen/activitiesScreen.dart';
import 'package:fitness_tracker/screens/home/widgets/suggest_food/detail_suggest.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:intl/intl.dart';

class RecentPlans extends StatelessWidget {
  const RecentPlans({super.key});

  @override
  Widget build(BuildContext context) {
    // Variable
    final DateTime date = DateTime.now();
    final String formattedDate = DateFormat('MMMM, yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What you eat today?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Activities()),
                  );
                },
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
            formattedDate,
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
                icon: Images.chicken,
                title: 'Chicken',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailSuggest()),
                  );
                },
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Images.pumpkin,
                title: 'Pumpkin',
                onTap: () {},
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Images.fish,
                title: 'Fish',
                onTap: () {},
                color: TColors.primary,
              ),
              _buildPlanItem(
                context,
                icon: Images.egg_broccoli,
                title: 'Egg Broccoli',
                color: TColors.primary,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(
    BuildContext context, {
    required String icon,
    required String title,
    required Color color,
    required Callback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  icon,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
