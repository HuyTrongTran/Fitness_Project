import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RunCalendar extends StatefulWidget {
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;

  const RunCalendar({
    Key? key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  State<RunCalendar> createState() => _RunCalendarState();
}

class _RunCalendarState extends State<RunCalendar> {
  List<DateTime> getWeekDates() {
    DateTime today = DateTime(
      2025,
      5,
      8,
    ); // Hardcoded for example (8th May 2025)
    DateTime startDate = today.subtract(
      Duration(days: 4),
    ); // Start from 4th May
    return List.generate(7, (index) => startDate.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getWeekDates();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            weekDates.asMap().entries.map((entry) {
              int index = entry.key;
              DateTime date = entry.value;
              bool isSelected = index == widget.selectedDayIndex;
              return InkWell(
                onTap: () {
                  widget.onDaySelected(index);
                },
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isSelected ? 16 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? TColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSelected
                        ? 'Today, ${date.day} ${DateFormat('MMM').format(date)}'
                        : '${date.day}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected ? TColors.white : TColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
