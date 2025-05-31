import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/bottomNavi/bottomNavigationBar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/features/services/workout_plan/api_workout_plan.dart';

import 'package:fitness_tracker/screens/activitiesScreen/widgets/calendar_widget.dart';
import 'package:fitness_tracker/screens/activitiesScreen/widgets/exerciseWidget.dart';
import 'package:fitness_tracker/screens/activitiesScreen/widgets/TimerPicker.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SetCalendars extends StatefulWidget {
  const SetCalendars({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String icon;

  @override
  _SetCalendarsState createState() => _SetCalendarsState();
}

class _SetCalendarsState extends State<SetCalendars> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTimeFrom = TimeOfDay.now();
  TimeOfDay _selectedTimeTo = TimeOfDay(
    hour: TimeOfDay.now().hour + 1,
    minute: TimeOfDay.now().minute,
  );

  // Hàm reload dữ liệu (giả lập)
  Future<void> _refreshData() async {
    // Thêm logic tải lại dữ liệu ở đây, ví dụ gọi API
    await Future.delayed(const Duration(seconds: 1)); // Giả lập thời gian chờ
    setState(() {
      // Cập nhật lại giao diện nếu cần
    });
  }

  final ConfigExerciseData configExerciseData = ConfigExerciseData();
  @override
  Widget build(BuildContext context) {
    final exercise =
        configExerciseData.exerciseData[widget.title] ??
        configExerciseData.exerciseData['Bicep']!;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData, // Hàm được gọi khi kéo xuống để reload
        color: TColors.primary, // Màu của vòng tròn loading
        child: CustomScrollView(
          physics:
              const BouncingScrollPhysics(), // Cuộn mượt mà với hiệu ứng bật lại
          slivers: [
            // Fixed Header
            SliverToBoxAdapter(
              child: PrimaryHeaderContainer(
                child: Column(
                  children: [
                    TAppBar(
                      centerTitle: true,
                      color: TColors.white,
                      title: Text(
                        "Set Your Calendar",
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall!.apply(color: TColors.white),
                      ),
                      showBackButton: true,
                    ),
                    CalendarWidget(
                      color: Colors.white,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
            // Scrollable Content
            SliverPadding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SectionHeading(title: widget.title, onPressed: () {}),
                  Text(
                    widget.subTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TSizes.defaultSpace,
                      vertical: TSizes.md,
                    ),
                    decoration: BoxDecoration(
                      color: TColors.white,
                      border: Border.all(
                        color: TColors.primary.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(48),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: TColors.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Image.asset(widget.icon),
                        ),
                        const SizedBox(width: TSizes.spaceBtwItems),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Number of sets:',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${exercise.minutes} min',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: TSizes.xs),
                            Text(
                              '${exercise.sets}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: TSizes.xs),
                                Text(
                                  '${exercise.kcal} kcal',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  // Time picker UI - From and To
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time to do',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: const Color(0xFF040415),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // From Time Picker
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked =
                                    await showCustomTimePicker(
                                      context: context,
                                      initialTime: _selectedTimeFrom,
                                    );
                                if (picked != null &&
                                    picked != _selectedTimeFrom) {
                                  setState(() {
                                    _selectedTimeFrom = picked;
                                  });
                                }
                              },
                              child: Container(
                                width: 143, 
                                height: 39,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFBFBFBF),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _selectedTimeFrom.format(context),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF7F7F7F),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Iconsax.timer_1,
                                        size: 20,
                                        color: Color(0xFF7F7F7F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          // "to" text
                          Text(
                            'to',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: const Color(0xFF040415),
                            ),
                          ),
                          const SizedBox(width: 9),
                          // To Time Picker
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final TimeOfDay? picked =
                                    await showCustomTimePicker(
                                      context: context,
                                      initialTime: _selectedTimeTo,
                                    );
                                if (picked != null &&
                                    picked != _selectedTimeTo) {
                                  setState(() {
                                    _selectedTimeTo = picked;
                                  });
                                }
                              },
                              child: Container(
                                width: 143,
                                height: 39,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: const Color(0xFFBFBFBF),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(34),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _selectedTimeTo.format(context),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: const Color(0xFF7F7F7F),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Iconsax.timer_1,
                                        size: 20,
                                        color: Color(0xFF7F7F7F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TBottomNavigationBar(
        label: 'Set Calendar',
        onPressed: () async {
          try {
            // Combine selected date with selected start time
            final DateTime scheduledDateTimeFrom = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              _selectedTimeFrom.hour,
              _selectedTimeFrom.minute,
            );

            await WorkoutPlan().submitWorkoutPlan(
              widget.title,
              widget.subTitle,
              scheduledDateTimeFrom.toIso8601String(),
              exercise.sets,
              exercise.kcal,
              exercise.minutes,
            );

            showCustomSnackbar(
              'Success',
              'Added ${widget.title} to your calendar on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} from ${_selectedTimeFrom.format(context)} to ${_selectedTimeTo.format(context)}',
              type: SnackbarType.success,
            );
            Navigator.pop(context, true);
          } catch (e) {
            showCustomSnackbar(
              'Error',
              'Failed to add exercise: ${e.toString()}',
              type: SnackbarType.error,
            );
          }
        },
      ),
    );
  }
}
