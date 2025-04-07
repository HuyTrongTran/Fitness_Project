import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side - User info
          Row(
            children: [
              // User avatar
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              // Greeting text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello Linh!',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                  ),
                  Text(
                    'Thursday, 08 July',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Right side - Calendar icon
          Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: const Icon(Icons.calendar_today_outlined),
          ),
        ],
      ),
    );
  }
}
