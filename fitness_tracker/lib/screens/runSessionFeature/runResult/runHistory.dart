import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/bottomNavi/bottomNavigationBar.dart';
import 'package:fitness_tracker/screens/home/home.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/widgets/runSumaryCard.dart';
import 'package:fitness_tracker/screens/runSessionFeature/run_screen.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness_tracker/navigation_menu.dart';

class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key});

  @override
  _RunHistoryScreenState createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  // Function to generate 7 days starting from 4 days before today
  List<DateTime> getWeekDates() {
    DateTime today = DateTime(
      2025,
      5,
      8,
    ); // Hardcoded for example (8th May 2025)
    DateTime startDate = today.subtract(
      const Duration(days: 4),
    ); // Start from 4th May
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  int selectedDayIndex = 3; // Default to 8th May (index 3)

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDates();

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Your run history',
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        showBackButton: true,
        color: TColors.black,
        onLeadingPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const NavigationMenu()),
            (route) => false,
          );
        },
      ),
      body: Column(
        children: [
          // Date picker row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  weekDates.asMap().entries.map((entry) {
                    int index = entry.key;
                    DateTime date = entry.value;
                    bool isSelected = index == selectedDayIndex;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedDayIndex = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 300,
                        ), // Animation duration
                        curve: Curves.easeInOut, // Smooth curve for animation
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal:
                              isSelected ? 16 : 12, // Wider when selected
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? TColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isSelected
                              ? 'Today, ${date.day} ${DateFormat('MMM').format(date)}'
                              : '${date.day}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(
                            color: isSelected ? TColors.white : TColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          // Run summary cards
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                RunSummaryCard(),
                const SizedBox(height: TSizes.spaceBtwItems),
                RunSummaryCard(),
              ],
            ),
          ),
        ],
      ),
      // Sticky button at the bottom
      bottomNavigationBar: TBottomNavigationBar(
        label: 'Continue move',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RunPage()),
          );
        },
      ),
    );
  }
}
