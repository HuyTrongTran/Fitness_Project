import 'package:flutter/material.dart';
import '../utils/constants/colors.dart';

class DetailPageButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  const DetailPageButton({
    super.key,
    required this.text,
    required this.onTap,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: [
        if (showBackButton)
          GestureDetector(
            onTap: onBackTap,
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.02),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              height: size.height * 0.07,
              child: Center(
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: TColors.buttonPrimary,
                    fontSize: size.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: TColors.buttonPrimary,
              borderRadius: BorderRadius.circular(30),
            ),
            margin: EdgeInsets.only(top: size.height * 0.02),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.07,
              vertical: size.height * 0.02,
            ),
            height: size.height * 0.07,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: TColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.05,
                  ),
                ),
                SizedBox(width: size.width * 0.02), // Add spacing between text and icon
                Icon(
                  Icons.arrow_forward, // Right arrow icon
                  color: TColors.textWhite,
                  size: size.width * 0.05,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}