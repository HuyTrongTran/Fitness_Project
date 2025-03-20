import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final userEmail = prefs.getString('user_email');
    if (token != null && token.isNotEmpty && userEmail != null) {
      final onboardingKey = 'has_completed_onboarding_$userEmail';
      final hasCompletedOnboarding = prefs.getBool(onboardingKey) ?? false;
      if (hasCompletedOnboarding) {
        Get.offAll(() => const NavigationMenu());
      }
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    final userEmail = prefs.getString('user_email');
    if (userEmail != null) {
      final onboardingKey = 'has_completed_onboarding_$userEmail';
      await prefs.setBool(onboardingKey, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: [
              _buildPageIndicator(
                text: 'Meet your coach, \n start your journey now!',
                imageAsset: 'assets/onboardingImages/img_background_2.png',
              ),
              _buildPageIndicator(
                text: 'Create a workout plan \n that fits your schedule',
                imageAsset: 'assets/onboardingImages/img_background_1.png',
              ),
              _buildPageIndicator(
                text: 'Action is the \nkey to all success',
                imageAsset: 'assets/onboardingImages/img_background_3.png',
              ),
            ],
          ),
          isLastPage
              ? const SizedBox.shrink()
              : Positioned(
                  top: size.height * 0.05,
                  right: size.width * 0.05,
                  child: TextButton(
                    onPressed: () {
                      controller.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          isLastPage
              ? Positioned(
                  left: size.width * 0.25,
                  right: size.width * 0.25,
                  bottom: size.height * 0.09,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () async {
                          await _completeOnboarding();
                          Navigator.pushNamed(context, '/age');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TColors.primary,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Get Started',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: TColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: TColors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Positioned(
            bottom: size.height * 0.03,
            left: size.width * 0.42,
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: const ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                dotColor: Colors.grey,
                activeDotColor: TColors.buttonPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator({
    required String imageAsset,
    required String text,
  }) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Image.asset(imageAsset, height: size.height * 0.6, fit: BoxFit.cover),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}