import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
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
  }

  Future<void> _startOnboarding() async {
    Navigator.pushNamed(context, '/gender');
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
                  child: Text(
                    'Skip',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Nunito',
                      color: Colors.white,
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
                      onTap: _startOnboarding,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get Started',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                // fontFamily: 'Nunito',
                                color: TColors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              color: TColors.white,
                            ),
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
        Image.asset(
          imageAsset,
          // height: size.height * 0.,
          fit: BoxFit.fill,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: size.height * 0.6,
              color: Colors.grey,
              child: const Center(child: Text('Image not found')),
            );
          },
        ),
        Positioned(
          bottom: 0,
          child: SizedBox(
            height: size.height * 0.4,
            width: size.width,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: 'Nunito',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
