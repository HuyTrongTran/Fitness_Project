import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'workout_plan.dart';

class CalendarPopup extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const CalendarPopup({super.key, required this.onDaySelected});

  @override
  State<CalendarPopup> createState() => _CalendarPopupState();
}

class _CalendarPopupState extends State<CalendarPopup> {
  DateTime _focusedDay = DateTime.now();
  final ValueNotifier<DateTime?> _selectedDayNotifier =
      ValueNotifier<DateTime?>(null);

  @override
  void initState() {
    super.initState();
    _selectedDayNotifier.value = _focusedDay;
  }

  @override
  void dispose() {
    _selectedDayNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDayNotifier.value, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  _selectedDayNotifier.value = selectedDay;
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                  widget.onDaySelected(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: TColors.primary,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: const TextStyle(color: TColors.textPrimary),
                  weekendTextStyle: const TextStyle(color: TColors.textPrimary),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: TColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: TColors.textPrimary,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: TColors.textPrimary,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: TColors.textPrimary),
                  weekendStyle: TextStyle(color: TColors.textPrimary),
                ),
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<DateTime?>(
                valueListenable: _selectedDayNotifier,
                builder: (context, selectedDay, child) {
                  return WorkoutPlan(
                    selectedDate: selectedDay ?? _focusedDay,
                    isInPopup: true,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
