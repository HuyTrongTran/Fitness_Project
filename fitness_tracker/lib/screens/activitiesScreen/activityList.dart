import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'widgets/activityItems.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityListScreen extends StatefulWidget {
  final Map<String, dynamic> workoutPlan;
  const ActivityListScreen({super.key, required this.workoutPlan});

  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  late List<Map<String, dynamic>> activities;

  @override
  void initState() {
    super.initState();
    final raw = widget.workoutPlan['exercises'];
    if (raw is List) {
      activities = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      activities = [];
    }
  }

  Future<void> _removeActivity(int index) async {
    final id = activities[index]['id'];
    if (id == null) {
      showCustomSnackbar(
        'Error',
        "Remove activity failed! Please try again!",
        type: SnackbarType.error,
      );
      return;
    }
    setState(() {
      activities.removeAt(index);
    });

    final url = Uri.parse('${ApiConfig.baseUrl}/exercise/$id');
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final isSuccess = response.statusCode == 200;
      if (isSuccess) {
        showCustomSnackbar(
          'Success',
          "Remove activity successfully!",
          type: SnackbarType.success,
        );
      } else {
        showCustomSnackbar(
          'Error',
          "Remove activity failed! Please try again!",
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        'Error',
        "Error removing activity. Please try again!",
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _fetchActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final url = Uri.parse('${ApiConfig.baseUrl}/exercise/user-plan');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final raw = responseData['data'];
        setState(() {
          activities =
              raw is List
                  ? raw.map((e) => Map<String, dynamic>.from(e)).toList()
                  : [];
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
    }
  }

  String _getIconForActivity(String name) {
    switch (name.toLowerCase()) {
      case 'bicep':
        return Images.bicep;
      case 'body-back':
        return Images.body_back;
      case 'body butt':
        return Images.body_butt;
      case 'legs and core':
        return Images.sit_leg_core;
      case 'pectoral machine':
        return Images.pectoral_machine;
      case 'weight loss':
        return Images.weight_loss;
      case 'woman up front':
        return Images.woman_up_front;
      default:
        return Images.bicep;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TAppBar(
                    title: Text(
                      'Activity List',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: TColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    showBackButton: true,
                    centerTitle: true,
                    color: TColors.white,
                    onLeadingPressed: () => Navigator.pop(context, true),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  for (int i = 0; i < activities.length; i++)
                    ActivityTodayItem(
                      title: activities[i]['exercise_name'] ?? '',
                      iconAsset: _getIconForActivity(
                        activities[i]['exercise_name'] ?? '',
                      ),
                      sets: activities[i]['set_to_do'] ?? 0,
                      kcal: activities[i]['kcal_to_do'] ?? 0,
                      minutes: activities[i]['time_to_do'] ?? 0,
                      onDelete: () => _removeActivity(i),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
