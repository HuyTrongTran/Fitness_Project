import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fitness_tracker/screens/activitiesScreen/widgets/showMonthYearPicker.dart';

class CalendarWidget extends StatefulWidget {
  final Color? color;
  final Function(DateTime)? onDateSelected;

  const CalendarWidget({Key? key, this.color, this.onDateSelected})
    : super(key: key);

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with SingleTickerProviderStateMixin {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.easeInOutCubic,
      ),
    );

    _animationController!.forward();
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController?.reset();
    _animationController?.forward();
  }

  void _onHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
      });
    } else if (details.primaryVelocity! > 0) {
      setState(() {
        _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
      });
    }
    _animationController?.reset();
    _animationController?.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_fadeAnimation != null)
          FadeTransition(
            opacity: _fadeAnimation!,
            child: GestureDetector(
              onHorizontalDragEnd: _onHorizontalSwipe,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left),
                    color: TColors.white,
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month - 1,
                        );
                      });
                      _animationController?.reset();
                      _animationController?.forward();
                    },
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  GestureDetector(
                    onTap: () async {
                      final selectedDate = await MonthYearPickerDialog.show(
                        context,
                        _focusedDay,
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _focusedDay = selectedDate;
                        });
                        _animationController?.reset();
                        _animationController?.forward();
                      }
                    },
                    child: Text(
                      '${DateFormat.MMMM().format(_focusedDay)} ${_focusedDay.day}, ${_focusedDay.year}',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: widget.color),
                    ),
                  ),
                  const SizedBox(width: TSizes.spaceBtwItems),
                  IconButton(
                    icon: const Icon(Icons.arrow_right),
                    color: TColors.white,
                    onPressed: () {
                      setState(() {
                        _focusedDay = DateTime(
                          _focusedDay.year,
                          _focusedDay.month + 1,
                        );
                      });
                      _animationController?.reset();
                      _animationController?.forward();
                    },
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: TSizes.spaceBtwItems),
        if (_animationController != null && _fadeAnimation != null)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
            child: TableCalendar(
              key: ValueKey(
                _focusedDay.month.toString() + _focusedDay.year.toString(),
              ),
              firstDay: DateTime.utc(2010, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                widget.onDateSelected?.call(selectedDay);
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
                _animationController?.reset();
                _animationController?.forward();
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: TColors.white,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: TColors.white.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
                weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
                outsideDecoration: const BoxDecoration(shape: BoxShape.circle),
                defaultTextStyle: TextStyle(color: TColors.white),
                selectedTextStyle: TextStyle(color: TColors.primary),
                todayTextStyle: TextStyle(color: TColors.primary),
                weekendTextStyle: TextStyle(color: TColors.white),
                outsideTextStyle: TextStyle(
                  color: TColors.white.withOpacity(0.8),
                ),
              ),
              headerVisible: false,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: widget.color ?? Colors.white),
                weekendStyle: TextStyle(color: widget.color ?? Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
