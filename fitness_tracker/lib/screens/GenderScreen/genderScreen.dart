import 'package:fitness_tracker/models/DetailPageButton.dart';
import 'package:fitness_tracker/models/DetailPageTitle.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  bool isMale = true;
  bool isFemale = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColors.light,
      body: Container(
        padding: EdgeInsets.only(
          top: size.height * 0.06,
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.height * 0.03,
        ),
        width: size.width,
        height: size.height * 0.95,
        child: Column(
          children: [
            Detailpagetitle(
              title: "Tell Us About Yourself",
              text: "This will help us to find the best \n content for you",
              color: TColors.textPrimary,
            ),
            SizedBox(height: size.height * 0.02),
            GenderIcon(
              icon: Icons.male,
              title: 'Male',
              onTap: () {
                setState(() {
                  isMale = true;
                  isFemale = false;
                });
              },
              isSelected: isMale,
            ),
            SizedBox(height: size.height * 0.05),
            GenderIcon(
              icon: Icons.female,
              title: 'Female',
              onTap: () {
                setState(() {
                  isMale = false;
                  isFemale = true;
                });
              },
              isSelected: isFemale,
            ),
            const Spacer(),
            DetailPageButton(
              text: "Next",
              onTap: () {
                Navigator.pushNamed(context, '/age');
              },
              showBackButton: true,
              onBackTap: () {
                Navigator.pushNamed(context, '/onboarding');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GenderIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const GenderIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double circleSize =
        size.width * 0.3; // Adjust this value to make the circle smaller

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleSize, // Set fixed width
        height: circleSize, // Set fixed height
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: isSelected ? TColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size.width * 0.08, // Adjust icon size to make it smaller
              color: isSelected ? TColors.light : TColors.textPrimary,
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? TColors.light : TColors.textPrimary,
                fontSize: 16, // Adjust font size to make it smaller
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
