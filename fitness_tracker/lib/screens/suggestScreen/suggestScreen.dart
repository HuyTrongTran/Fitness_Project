import 'package:fitness_tracker/common/widgets/bottomNavi/bottomNavigationBar.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/screens/home/widgets/suggest_food.dart';
import 'package:fitness_tracker/screens/suggestScreen/widgets/bmiCard.dart';
import 'package:fitness_tracker/screens/suggestScreen/widgets/header.dart';
import 'package:fitness_tracker/screens/suggestScreen/widgets/suggestActivity.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:iconsax/iconsax.dart';

class SuggestScreen extends StatefulWidget {
  const SuggestScreen({super.key});

  @override
  State<SuggestScreen> createState() => _SuggestScreenState();
}

class _SuggestScreenState extends State<SuggestScreen> {
  double? _bmi;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBMIData();
  }

  Future<void> _loadBMIData() async {
    try {
      final profileData = await GetProfileService.fetchProfileData();
      if (profileData != null &&
          profileData.height != null &&
          profileData.height! > 0 &&
          profileData.weight != null &&
          profileData.weight! > 0) {
        // BMI = weight(kg) / (height(m))²
        final heightInMeters = profileData.height! / 100;
        final bmi = profileData.weight! / (heightInMeters * heightInMeters);
        setState(() {
          _bmi = bmi;
          _isLoading = false;
        });
      } else {
        setState(() {
          _bmi = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading BMI data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: TSizes.appBarHeight),
          child: Column(
            children: [
              const SuggestHeader(),
              const SizedBox(height: TSizes.spaceBtwItems),
              _isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: TColors.primary),
                  )
                  : _bmi == null
                  ? const Center(
                    child: Text(
                      'Unable to calculate BMI.\nPlease update your height and weight.',
                      textAlign: TextAlign.center,
                    ),
                  )
                  : SingleChildScrollView(
                    child: Column(
                      children: [
                        BMICard(bmi: _bmi ?? 0.0),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const SuggestActivityGrid(),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ), // Add more suggestion widgets here
                        const RecentPlans(),
                      ],
                    ),
                  ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TBottomNavigationBar(
        label: 'Go To Fitness Universe',
        icon: Iconsax.cloud_sunny,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
          );
        },
      ),
    );
  }
}
