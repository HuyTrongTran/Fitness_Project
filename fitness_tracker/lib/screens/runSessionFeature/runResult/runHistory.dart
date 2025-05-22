import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/bottomNavi/bottomNavigationBar.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/widgets/runSumaryCard.dart';
import 'package:fitness_tracker/screens/runSessionFeature/run_screen.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/features/services/run_services/run_history_service.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/runSession.dart';

class RunHistoryScreen extends StatefulWidget {
  const RunHistoryScreen({super.key});

  @override
  _RunHistoryScreenState createState() => _RunHistoryScreenState();
}

class _RunHistoryScreenState extends State<RunHistoryScreen> {
  int selectedDayIndex = 0;
  List<DateTime> weekDates = [];
  List<RunSession> activities = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    weekDates = getWeekDates();
    // Cập nhật selectedDayIndex là index của ngày hôm nay nếu có
    final today = DateTime.now();
    final todayIndex = weekDates.indexWhere(
      (date) =>
          date.day == today.day &&
          date.month == today.month &&
          date.year == today.year,
    );
    if (todayIndex != -1) {
      selectedDayIndex = todayIndex;
    }
    _loadActivitiesForSelectedDay();
  }

  void _loadActivitiesForSelectedDay() async {
    setState(() {
      isLoading = true;
    });
    final date = weekDates[selectedDayIndex];
    final result = await RunHistoryService.getRunHistoryByDate(date);
    setState(() {
      activities = result;
      isLoading = false;
    });
  }

  // Function to generate 7 days starting from 4 days before today
  List<DateTime> getWeekDates() {
    DateTime today = DateTime.now(); // Lấy ngày hiện tại
    DateTime startDate = today.subtract(
      const Duration(days: 4),
    ); // Bắt đầu từ 4 ngày trước
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    weekDates = getWeekDates();
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
                        _loadActivitiesForSelectedDay();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: isSelected ? 16 : 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? TColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isSelected
                              ? '${date.day} ${DateFormat('MMM').format(date)}'
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
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : activities.isEmpty
                    ? const Center(child: Text('No activity for this day'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: activities.length,
                      itemBuilder: (context, idx) {
                        final session = activities[idx];
                        final selectedDate = weekDates[selectedDayIndex];
                        return Column(
                          children: [
                            RunSummaryCard(
                              session: session,
                              selectedDate: selectedDate,
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                          ],
                        );
                      },
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
