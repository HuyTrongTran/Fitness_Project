import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fitness_tracker/screens/activitiesScreen/activityList.dart';

class WorkoutPlan extends StatefulWidget {
  final DateTime selectedDate;
  final bool isInPopup;

  const WorkoutPlan({
    super.key,
    required this.selectedDate,
    this.isInPopup = false,
  });

  @override
  State<WorkoutPlan> createState() => _WorkoutPlanState();
}

class _WorkoutPlanState extends State<WorkoutPlan> {
  Map<String, dynamic> _workoutPlan = {};
  bool _isLoading = true;
  String _errorMessage = '';
  Map<String, Map<String, dynamic>> _cache = {};
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutPlan();
  }

  @override
  void didUpdateWidget(WorkoutPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _fetchWorkoutPlan();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchWorkoutPlan() async {
    final String formattedDate =
        widget.selectedDate.toIso8601String().split('T')[0];

    // Kiểm tra cache
    if (_cache.containsKey(formattedDate)) {
      setState(() {
        _workoutPlan = _cache[formattedDate]!;
        _isLoading = false;
        _errorMessage = '';
      });
      return;
    }

    // Debouncing
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        setState(() {
          _errorMessage = 'No token found. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final String apiUrl =
          '${ApiConfig.baseUrl}/activity-data?date=$formattedDate';
      print('Calling API: $apiUrl'); // Debug log

      try {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            setState(() {
              _workoutPlan = responseData['data'];
              _cache[formattedDate] = _workoutPlan;
              _isLoading = false;
            });
          } else {
            setState(() {
              _errorMessage =
                  'Failed to fetch workout plan: ${responseData['message']}';
              _isLoading = false;
            });
          }
        } else {
          setState(() {
            _errorMessage =
                'Failed to fetch workout plan: ${response.statusCode} ${response.body}';
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error occurred while fetching workout plan: $e');
        setState(() {
          _errorMessage = 'Error occurred while fetching workout plan: $e';
          _isLoading = false;
        });
      }
    });
  }

  int getTotalSetsForDay(Map<String, dynamic> workoutPlan) {
    if (workoutPlan['exercises'] == null) return 0;
    return (workoutPlan['exercises'] as List).fold(
      0,
      (sum, e) => sum + (e['set_to_do'] as int),
    );
  }

  Future<void> reloadWorkoutPlan() async {
    final formattedDate = widget.selectedDate.toIso8601String().split('T')[0];
    _cache.remove(formattedDate); // Xóa cache ngày hiện tại để luôn fetch mới
    await _fetchWorkoutPlan();
  }

  @override
  Widget build(BuildContext context) {
    final Color containerColor =
        widget.isInPopup ? TColors.primary : TColors.white.withOpacity(0.1);
    final Color textColor = widget.isInPopup ? Colors.white : Colors.white;
    final Color nextExerciseContainerColor =
        widget.isInPopup ? Colors.white : TColors.primary;
    final Color nextExerciseTextColor =
        widget.isInPopup ? TColors.primary : Colors.white;
    final Color iconColor = widget.isInPopup ? TColors.primary : Colors.white;

    final double horizontalPadding =
        widget.isInPopup ? TSizes.sm : TSizes.defaultSpace;
    final double containerWidth =
        widget.isInPopup
            ? MediaQuery.of(context).size.width * 0.95
            : double.infinity;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: TSizes.defaultSpace,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            firstChild:
                _errorMessage.isNotEmpty
                    ? Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                    : GestureDetector(
                      onTap:
                          _workoutPlan.isNotEmpty
                              ? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ActivityListScreen(
                                          workoutPlan: _workoutPlan,
                                        ),
                                  ),
                                );
                                if (result == true) {
                                  await reloadWorkoutPlan();
                                }
                              }
                              : null,
                      child: Container(
                        width: containerWidth,
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(
                            TSizes.cardRadiusLg,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(TSizes.sm),
                                  decoration: const BoxDecoration(
                                    color: TColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Iconsax.flash_1,
                                    color: TColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _workoutPlan['date'] ??
                                          widget.selectedDate.toString().split(
                                            ' ',
                                          )[0],
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.copyWith(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _workoutPlan['type'] ?? 'Rest Day',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            Container(
                              padding: const EdgeInsets.all(TSizes.sm),
                              decoration: BoxDecoration(
                                color: nextExerciseContainerColor,
                                borderRadius: BorderRadius.circular(
                                  TSizes.cardRadiusLg,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.direct_right,
                                    size: 30,
                                    color: iconColor,
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Next exercise',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: nextExerciseTextColor,
                                          ),
                                        ),
                                        if (_workoutPlan['exercises'] != null &&
                                            (_workoutPlan['exercises'] as List)
                                                .isNotEmpty) ...[
                                          Text(
                                            _workoutPlan['exercises'][0]['exercise_name'] ??
                                                'No exercises planned',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: nextExerciseTextColor,
                                            ),
                                          ),
                                          if (!widget.isInPopup) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              '${_workoutPlan['exercises'][0]['set_to_do'] ?? 0} sets • ${_workoutPlan['exercises'][0]['time_to_do'] ?? 0} mins • ${_workoutPlan['exercises'][0]['kcal_to_do'] ?? 0} kcal',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: nextExerciseTextColor,
                                              ),
                                            ),
                                          ],
                                        ] else
                                          Text(
                                            'No exercises planned',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: nextExerciseTextColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            secondChild:
                _errorMessage.isNotEmpty
                    ? Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                    : GestureDetector(
                      onTap:
                          _workoutPlan.isNotEmpty
                              ? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ActivityListScreen(
                                          workoutPlan: _workoutPlan,
                                        ),
                                  ),
                                );
                                if (result == true) {
                                  await reloadWorkoutPlan();
                                }
                              }
                              : null,
                      child: Container(
                        width: containerWidth,
                        padding: const EdgeInsets.all(TSizes.defaultSpace),
                        decoration: BoxDecoration(
                          color: containerColor,
                          borderRadius: BorderRadius.circular(
                            TSizes.cardRadiusLg,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(TSizes.sm),
                                  decoration: const BoxDecoration(
                                    color: TColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Iconsax.flash_1,
                                    color: TColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: TSizes.spaceBtwItems),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _workoutPlan['date'] ??
                                          widget.selectedDate.toString().split(
                                            ' ',
                                          )[0],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: textColor),
                                    ),
                                    Text(
                                      _workoutPlan['type'] ?? 'Rest Day',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: TSizes.spaceBtwItems),
                            Container(
                              padding: const EdgeInsets.all(TSizes.md),
                              decoration: BoxDecoration(
                                color: nextExerciseContainerColor,
                                borderRadius: BorderRadius.circular(
                                  TSizes.cardRadiusLg,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Iconsax.direct_right,
                                    size: 30,
                                    color: iconColor,
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Next exercise',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium?.copyWith(
                                            color: nextExerciseTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        if (_workoutPlan['exercises'] != null &&
                                            (_workoutPlan['exercises'] as List)
                                                .isNotEmpty) ...[
                                          Text(
                                            _workoutPlan['exercises'][0]['exercise_sub_title'] ??
                                                'No exercises planned',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: nextExerciseTextColor,
                                            ),
                                          ),
                                          if (!widget.isInPopup) ...[
                                            const SizedBox(height: 4),
                                            Text(
                                              '${_workoutPlan['exercises'][0]['set_to_do'] ?? 0} sets • ${_workoutPlan['exercises'][0]['time_to_do'] ?? 0} mins • ${_workoutPlan['exercises'][0]['kcal_to_do'] ?? 0} kcal',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium?.copyWith(
                                                color: nextExerciseTextColor,
                                              ),
                                            ),
                                          ],
                                        ] else
                                          Text(
                                            'No exercises planned',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: nextExerciseTextColor,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            crossFadeState:
                _isLoading
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
