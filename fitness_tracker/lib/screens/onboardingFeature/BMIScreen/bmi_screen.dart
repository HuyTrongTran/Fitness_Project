import 'dart:convert';
import 'package:fitness_tracker/models/user_onboarding_data.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/services/api_services.dart';
import 'package:fitness_tracker/utils/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double _bmi = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _calculateBMI();
  }

  Future<void> _completeOnboarding(UserOnboardingData data) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      Get.snackbar('Error', 'No token found. Please log in again.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final profileResponse = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/update-profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data.toJson()),
      );

      final profileData = jsonDecode(profileResponse.body);
      if (profileResponse.statusCode != 200 || !profileData['success']) {
        throw Exception(profileData['message'] ?? 'Failed to update profile');
      }

      final onboardingResponse = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/complete-onboarding'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final onboardingData = jsonDecode(onboardingResponse.body);
      if (onboardingResponse.statusCode == 200 && onboardingData['success']) {
        // Get.snackbar('Success', 'Onboarding completed successfully!');
        Get.offAll(() => const NavigationMenu());
      } else {
        throw Exception(
          onboardingData['message'] ?? 'Failed to complete onboarding',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _calculateBMI() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Lấy dữ liệu từ API
      final profileData = await ApiService.fetchProfileData();

      double? height;
      double? weight;

      if (profileData != null) {
        height = profileData.height;
        weight = profileData.weight;
      }

      // Nếu không có dữ liệu từ API, fallback về SharedPreferences
      if (height == null || weight == null) {
        final prefs = await SharedPreferences.getInstance();
        height = prefs.getDouble('height'); // Chiều cao (cm)
        weight = prefs.getDouble('weight'); // Cân nặng (kg)
      }

      if (height == null || weight == null) {
        setState(() {
          _bmi = 0.0;
          _isLoading = false;
        });
        Get.snackbar('Error', 'Height or weight not found');
        return;
      }

      // Chuyển chiều cao từ cm sang m
      final double heightInMeters = height / 100;
      // Tính BMI
      final double bmi = weight / (heightInMeters * heightInMeters);

      setState(() {
        _bmi = double.parse(
          bmi.toStringAsFixed(1),
        ); // Làm tròn 1 chữ số thập phân
        _isLoading = false;
      });
    } catch (e) {
      print('Error calculating BMI: $e');
      setState(() {
        _bmi = 0.0;
        _isLoading = false;
      });
      Get.snackbar('Error', 'An error occurred while calculating BMI: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserOnboardingData data =
        ModalRoute.of(context)!.settings.arguments as UserOnboardingData;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [TColors.primary.withOpacity(0.8), TColors.primary],
          ),
        ),
        child: Stack(
          children: [
            // Background with wave pattern
            Positioned.fill(
              child: Image.asset(Images.background, fit: BoxFit.cover),
            ),
            // Main content
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text(
                    'FIND OUT EXACTLY WHAT DIET & TRAINING\nWILL WORK SPECIFICALLY FOR YOU',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  const Text(
                    'Your BMI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: TSizes.defaultSpace * 2,
                          vertical: TSizes.defaultSpace,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            TSizes.cardRadiusLg,
                          ),
                        ),
                        child: Text(
                          _bmi.toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: TColors.primary,
                          ),
                        ),
                      ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  // BMI Range Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 10,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.green,
                                  Colors.yellow,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '18.5',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          '23',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.sm),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thin',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Normal',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        Text(
                          'Overweight',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Navigation Buttons
                  Padding(
                    padding: const EdgeInsets.all(TSizes.defaultSpace),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        TextButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    Navigator.pop(context);
                                  },
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              color: TColors.white,
                              fontSize: 20,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                        // Next Button
                        FloatingActionButton(
                          onPressed:
                              _isLoading
                                  ? null
                                  : () {
                                    data.bmi = _bmi;
                                    _completeOnboarding(data);
                                  },
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: TColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for wave background
