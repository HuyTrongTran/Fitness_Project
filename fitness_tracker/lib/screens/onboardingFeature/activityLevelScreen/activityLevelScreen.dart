import 'package:fitness_tracker/features/models/DetailPageButton.dart';
import 'package:fitness_tracker/features/models/DetailPageTitle.dart';
import 'package:fitness_tracker/features/models/ListWheelViewScroller.dart';
import 'package:fitness_tracker/features/models/user_onboarding_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  String selectedActivity = 'moderate';
  bool _isLoading = false;

  Future<void> _updateActivity(String activityLevel) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found. Please log in again.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    const String apiUrl = '${ApiConfig.baseUrl}/update-profile';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'activityLevel': activityLevel}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Activity updated successfully: $activityLevel');
      } else {
        print('Failed to update activity: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update activity: ${responseData['message']}',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error occurred while updating activity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating activity'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserOnboardingData data =
        ModalRoute.of(context)!.settings.arguments as UserOnboardingData;
    List<String> items = [
      "Rookie",
      "Beginner",
      "Intermediate",
      "Advanced",
      "Pro",
    ];
    Map<String, String> activityMapping = {
      "Rookie": "Rookie",
      "Beginner": "Beginner",
      "Intermediate": "Intermediate",
      "Advanced": "Advanced",
      "Pro": "Pro",
    };

    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Màu xanh lam nhạt
              Color(0xFF4A90E2), // Màu xanh lam đậm
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.06,
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: size.height * 0.03,
              ),
              child: Column(
                children: [
                  const Detailpagetitle(
                    text: "This helps us to create a personalized plan for you",
                    title: "What is your level?",
                    color: Colors.white, // Đổi màu thành trắng
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    height: size.height * 0.5,
                    child: Listwheelviewscroller(
                      items: items,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedActivity = activityMapping[items[index]]!;
                          print('Selected activity: $selectedActivity');
                        });
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.055),
                  DetailPageButton(
                    text: "Finish",
                    onTap: () async {
                      data.activityLevel = selectedActivity;
                      print('Selected activity: $selectedActivity');
                      Navigator.pushNamed(context, '/bmi', arguments: data);
                      await _updateActivity(selectedActivity);
                    },
                    showBackButton: true,
                    onBackTap: () => Navigator.pop(context),
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
