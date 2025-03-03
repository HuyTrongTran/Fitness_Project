import 'package:fitness_tracking/constants/colors%20.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  bool isLastPage = false;

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
                      duration: const Duration(microseconds: 300),
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
                    color: PrimaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          Navigator.pushNamed(context, '/gender');
                          final response = await http.get(
                            Uri.parse('http://10.0.2.2:3000/api/data'),
                          );
                          print("Response from node.js: ${response.body}");
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios, color: Colors.black),
                    ],
                  ),
                ),
              )
              : SizedBox.shrink(),

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
                activeDotColor: PrimaryColor,
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
                style: TextStyle(
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
