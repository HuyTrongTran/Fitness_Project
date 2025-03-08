import 'package:flutter/material.dart';

import '../../models/DetailPageButton.dart';
import '../../models/DetailPageTitle.dart';
import '../../models/ListWheelViewScroller.dart';
import '../../utils/constants/colors.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  bool isLoseWeight = true;
  bool isGainWeight = false;
  bool isStayFit = false;

  @override
  Widget build(BuildContext context) {
    List<String> items = [
      "Rookie",
      "Beginner",
      "InterMediate",
      "Advanced",
      "Pro",
    ];
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColors.light,
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
          top: size.height * 0.06,
          left: size.width * 0.05,
          right: size.width * 0.05,
          bottom: size.height * 0.03,
        ),
        child: Column(
          children: [
            Detailpagetitle(
              text: "This helps us to create a personlized plan for you",
              title: "What is your activity level?",
              color: TColors.textPrimary,
            ),
            SizedBox(height: size.height * 0.01),
            SizedBox(
              height: size.height * 0.5,
              child: Listwheelviewscroller(items: items),
            ),
            SizedBox(height: size.height * 0.055),
            DetailPageButton(
              text: "Next",
              onTap: () {
                Navigator.pushNamed(context, '/activity');
              },
              showBackButton: true,
              onBackTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
