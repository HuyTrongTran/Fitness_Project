import 'dart:convert';

import 'package:fitness_tracker/features/models/DetailPageButton.dart';
import 'package:fitness_tracker/features/models/DetailPageTitle.dart';
import 'package:fitness_tracker/features/models/ListWheelViewScroller.dart';
import 'package:fitness_tracker/features/models/user_onboarding_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AgePage extends StatefulWidget {
  final UserOnboardingData userData;
  const AgePage({super.key, required this.userData});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  int selectedAge = 25;

  Future<void> _updateAge(int age) async {
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
        body: jsonEncode({'age': age}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Age updated successfully: $age');
      } else {
        print('Failed to update age: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update age: ${responseData['message']}'),
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

  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    for (int i = 1; i <= 100; i++) {
      items.add(i.toString());
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
                    title: "How Old Are You?",
                    text:
                        "This will help us to create a personalized fitness plan for you",
                    color: TColors.white,
                  ),
                  SizedBox(height: size.height * 0.055),
                  SizedBox(
                    height: size.height * 0.5,
                    child: Listwheelviewscroller(
                      items: items,
                      initialItem:
                          (widget.userData.age ?? 0) > 0
                              ? (widget.userData.age! - 1)
                              : 24,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedAge = int.parse(items[index]);
                        });
                      },
                    ),
                  ),
                  DetailPageButton(
                    text: "Next",
                    onTap: () async {
                      widget.userData.age = selectedAge;
                      print("Selected height: $selectedAge");
                      await _updateAge(selectedAge);
                      Navigator.pushNamed(
                        context,
                        '/height',
                        arguments: widget.userData,
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
