import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/features/services/workout_plan/api_workout_plan.dart';

import 'package:fitness_tracker/screens/activitiesScreen/widgets/calendar_widget.dart';
import 'package:fitness_tracker/screens/activitiesScreen/widgets/exerciseWidget.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

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
                          child: Image.asset(widget.icon, color: TColors.white),
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

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () async {
                        try {
                          await WorkoutPlan().submitWorkoutPlan(
                            widget.title,
                            widget.subTitle,
                            _selectedDate.toIso8601String(),
                            exercise.sets,
                            exercise.kcal,
                            exercise.minutes,
                          );

                          showCustomSnackbar(
                            'Success',
                            'Added ${widget.title} to your calendar on ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            type: SnackbarType.success,
                          );
                        } catch (e) {
                          showCustomSnackbar(
                            'Error',
                            'Failed to add exercise: ${e.toString()}',
                            type: SnackbarType.error,
                          );
                        }
                      },
                      child: const Text('Set to your calendar'),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
