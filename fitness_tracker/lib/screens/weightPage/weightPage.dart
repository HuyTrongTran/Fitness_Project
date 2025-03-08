import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../models/DetailPageButton.dart';
import '../../models/DetailPageTitle.dart';
// import '../../models/ListWheelViewScroller.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double weight = 60.0;

  @override
  Widget build(BuildContext context) {
    List<String> levels = [];

    for (var i = 30; i <= 500; i++) {
      levels.add(i.isEven ? "|" : " I ");
    }

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
              title: "What is your weight?",
              color: TColors.textPrimary,
            ),
            SizedBox(height: size.height * 0.12),
            Text(
              "$weight kg",
              style: TextStyle(
                color: TColors.primary,
                fontSize: size.height * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            // SizedBox(height: size.height * 0.012),
            SizedBox(
              height: size.height * 0.2,
              child: RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView(
                  itemExtent: size.height * 0.036,
                  magnification: 1.1,
                  useMagnifier: true,
                  overAndUnderCenterOpacity: 0.3,
                  physics: const FixedExtentScrollPhysics(),
                  controller: FixedExtentScrollController(
                    initialItem: (weight * 2).round() - 1,
                  ),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      weight = (index + 1) / 2;
                    });
                  },
                  children:
                      levels.map((level) {
                        return RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            level,
                            style: TextStyle(
                              color: TColors.buttonPrimary,
                              fontSize: size.height * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.16),
            DetailPageButton(
              text: "Next",
              onTap: () {
                Navigator.pushNamed(context, '/goal');
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
