// ignore: file_names
import 'dart:convert';

import 'package:fitness_tracker/models/DetailPageButton.dart';
import 'package:fitness_tracker/models/DetailPageTitle.dart';
import 'package:fitness_tracker/models/ListWheelViewScroller.dart';
import 'package:fitness_tracker/models/user_onboarding_data.dart';
import 'package:fitness_tracker/utils/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String selectedGoal = 'weight_loss';

  @override
  Widget build(BuildContext context) {
    final UserOnboardingData data =
        ModalRoute.of(context)!.settings.arguments as UserOnboardingData;
    List<String> items = ["Lose Weight", "Gain Weight", "Stay Fit"];
    Map<String, String> goalMapping = {
      "Lose Weight": "weight_loss",
      "Gain Weight": "muscle_gain",
      "Stay Fit": "maintenance",
    };

    Future<void> _updateGoal(String goal) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No token found. Please log in again.')),
        );
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
          body: jsonEncode({'goal': goal}),
        );

        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200 && responseData['success'] == true) {
          print('Goal updated successfully: $goal');
        } else {
          print('Failed to update Goal: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update goal: ${responseData['message']}',
              ),
            ),
          );
        }
      } catch (e) {
        print('Error occurred while updating height: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while updating height'),
          ),
        );
      }
    }

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColors.light,
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
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
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
                    title: "What is your goal?",
                    color: TColors.white,
                  ),
                  SizedBox(height: size.height * 0.01),
                  SizedBox(
                    height: size.height * 0.5,
                    child: Listwheelviewscroller(
                      items: items,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedGoal = goalMapping[items[index]]!;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.055),
                  DetailPageButton(
                    text: "Next",
                    onTap: () async {
                      data.goal = selectedGoal;
                      print("Selected height: $selectedGoal");

                      // Gọi API để cập nhật height vào database
                      await _updateGoal(selectedGoal);
                      Navigator.pushNamed(
                        context,
                        '/activity',
                        arguments: data,
                      );
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
